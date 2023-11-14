class MenusController < ApplicationController

  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where.not(id: UserMenu.pluck(:menu_id))
  end


  def new
    @menu = Menu.new
    @menu.ingredients = Ingredient.new
    @materials_by_category = fetch_sorted_materials_by_category
  end


  def confirm
    @user = current_user
    @menu = Menu.new(menu_params)

    if params[:menu][:ingredients].present?
      new_ingredient_forms(@menu, params[:menu][:ingredients])
    end

    uploaded_file = params[:menu][:image]

    if uploaded_file.present?
      @image_data_url = generate_data_url(uploaded_file)
      uploaded_file.rewind
      image_data = uploaded_file.read
      @encoded_image = Base64.strict_encode64(image_data)
    end

    if @menu.valid?
      render 'confirm', status: :unprocessable_entity
      return
    else
      flash[:error] = "誤った入力が検出されました。"
      redirect_to new_user_menu_path
    end

  end

  def units
    material = Material.find_by(material_name: params[:material_name])
    units = material.material_units.map do |material_unit|
      { id: material_unit.unit_id, name: material_unit.unit.unit_name }
    end
    render json: units
  end

  def create
    menu = Menu.new(menu_params.except(:image))

    if params[:menu][:ingredients].present?
      new_ingredient_forms(menu, params[:menu][:ingredients])
    end

    if params[:menu].values_at(:encoded_image, :image_content_type).all?
      image_data = Base64.decode64(params[:menu][:encoded_image])
      filename = "user_#{current_user.id}の献立の画像"
      menu.image.attach(io: StringIO.new(image_data), filename: filename, content_type: params[:menu][:image_content_type])
    end

    begin
      ActiveRecord::Base.transaction do
        menu.save!
        UserMenu.create!(menu_id: menu.id, user_id: current_user.id)
      end
    rescue ActiveRecord::RecordInvalid
      handle_transaction_error
      return
    end

    if menu.ingredients.present?
      begin
        ActiveRecord::Base.transaction do
          menu.ingredients.each do |ingredient|
            ingredient.save!
            MenuIngredient.create!(menu_id: menu.id, ingredient_id: ingredient.id)
          end
        end
      rescue ActiveRecord::RecordInvalid
        handle_transaction_error
        return
      end
    end

    flash[:notice] = "献立を登録しました。"
    redirect_to user_menus_path
  end

  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :image, :image_meta_data, ingredients: [:name, :material_id, :unit_id, :quantity])
  end

  def new_ingredient_forms(menu_instance, ingredients_params)
    filtered_ingredients = ingredients_params.reject do |key, ingredient|
      ingredient['material_id'].blank? || ingredient['quantity'].blank?
    end

    menu_instance.ingredients = filtered_ingredients.values.map do |ingredient_data|
      sanitized_ingredient_data = ingredient_data.except('name')
      Ingredient.new(sanitized_ingredient_data)
    end
  end

  def fetch_sorted_materials_by_category
    materials_by_category = {}
    sorted_materials = Material.includes(:category).order('categories.id', :hiragana)
    grouped_materials = sorted_materials.group_by { |m| m.category.category_name }

    grouped_materials.each do |category_name, materials|
      materials_by_category[category_name] = materials.sort_by(&:hiragana)
    end
    materials_by_category
  end

  # アップロードされたファイルからデータURLを生成するメソッド
  def generate_data_url(uploaded_file)
    "data:#{uploaded_file.content_type};base64,#{Base64.strict_encode64(uploaded_file.read)}"
  end

  def handle_transaction_error
    flash[:error] = "登録中に予期せぬエラーが発生しました。"
    redirect_to user_menus_path
  end

end
