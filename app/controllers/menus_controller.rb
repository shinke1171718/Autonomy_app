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
    new_ingredient_forms(@menu, params[:menu][:ingredients])

    if !params[:menu][:image].nil?
      @image_data_url = generate_data_url(params[:menu][:image])
      uploaded_file = params[:menu][:image]
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

  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :image, :image_meta_data, ingredients: [:name, :material_id, :unit_id, :quantity])
  end

  def new_ingredient_forms(menu, ingredients)
    ingredient_params = ingredients

    filtered_ingredients = ingredient_params.reject do |key, ingredient|
      ingredient['material_id'].blank? || ingredient['quantity'].blank?
    end

    ingredient_array = filtered_ingredients.values

    menu.ingredients = ingredient_array.map do |ingredient_data|
      sanitized_ingredient_data = ingredient_data.except('name')
      Ingredient.new(sanitized_ingredient_data)
    end
  end

  def validate_unique_name(ingredients)
    if ingredients.map(&:name).uniq.count != ingredients.count
      return false
    end
    return true
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

end
