class MenusController < ApplicationController

  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where.not(id: UserMenu.pluck(:menu_id))
  end


  def new
    # 動的フォームを作成する個数
    @formCount = 5
    # ドロップダウンリストを作成に必要なデータを格納
    @materials_by_category = fetch_sorted_materials_by_category

    # 初期登録時の処理
    unless params[:menu].present?
      @menu = Menu.new
      @menu.ingredients = Ingredient.new
      return
    end

    # 確認画面一度経由した場合の処理
    if params[:menu][:encoded_image].present?
      # Base64エンコードされた画像データをデコードする
      decoded_image = Base64.decode64(params[:menu][:encoded_image])

      # 一時ファイルを作成する
      tempfile = Tempfile.new(['upload', '.jpg'])
      tempfile.binmode
      tempfile.write(decoded_image)
      tempfile.rewind

      #`ActionDispatch::Http::UploadedFile`オブジェクトを作成する
      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        filename: params[:menu][:filename],
        type: params[:menu][:image_content_type],
        tempfile: tempfile
      )

      # viewに表示する画像URL
      @image_data_url = generate_data_url(uploaded_file)
      # hiddenに設定するバイナリデーター
      @encoded_image = params[:menu][:encoded_image]
    end

    # 受け取ったmenuデータを再度インスタンス化
    @menu = Menu.new(
      menu_name: params[:menu][:menu_name],
      menu_contents: params[:menu][:menu_contents],
      contents: params[:menu][:contents],
    )

    # 受け取ったingredientデータの処理
    if params[:menu][:ingredients_attributes]
      @menu.ingredients = params[:menu][:ingredients_attributes]
    end

    render 'new', status: :unprocessable_entity
  end


  def confirm
    @menu = Menu.new(menu_params)

    # 食材データを「@menu.ingredients」に格納
    if params[:menu][:ingredients].present?
      new_ingredient_forms(@menu, params[:menu][:ingredients])
    end

    # 重複した献立を基準の単位に変換し、合算する
    @aggregated_ingredients = aggregate_ingredients(new_ingredient_forms(@menu, params[:menu][:ingredients]))

    # 画像か新規アップロードされた場合、uploaded_fileを作成
    if params[:menu][:image].present?
      uploaded_file = params[:menu][:image]
    end

    # 編集時に再登録した画像を格納 or 初回登録の内容を格納
    if uploaded_file.present?
      # viewに表示する画像URL設定
      @image_data_url = generate_data_url(uploaded_file)
      # 読み取り位置をファイルの先頭に戻す
      uploaded_file.rewind
      # データを読み取り
      image_data = uploaded_file.read
      # Base64エンコードに変換
      @encoded_image = Base64.strict_encode64(image_data)

    elsif params[:menu][:image_data_url].present?
      @image_data_url = params[:menu][:image_data_url]
      @encoded_image = params[:menu][:encoded_image]
    end

    if @menu.valid?
      render 'confirm', status: :unprocessable_entity
      return
    else
      handle_general_error
    end
  end


  # 食材登録時にajaxで該当する単位を検索するアクション
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

    # 画像データがある場合の処理
    if params[:menu].values_at(:encoded_image, :image_content_type).all?
      image_data = Base64.decode64(params[:menu][:encoded_image])
      filename = "user_#{current_user.id}の献立の画像"
      menu.image.attach(io: StringIO.new(image_data), filename: filename, content_type: params[:menu][:image_content_type])
    end

    menu.save
    UserMenu.create!(menu_id: menu.id, user_id: current_user.id)

    if menu.ingredients.present?
      begin
        ActiveRecord::Base.transaction do
          menu.ingredients.each do |ingredient|
            ingredient.save!
            MenuIngredient.create!(menu_id: menu.id, ingredient_id: ingredient.id)
          end
        end
      rescue ActiveRecord::RecordInvalid
        handle_general_error
        return
      end
    end

    flash[:notice] = "献立を登録しました。"
    redirect_to user_menus_path
  end

  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :image, :image_meta_data, ingredients: [:material_name, :material_id, :unit_id, :quantity])
  end

  # メニューに関連する新しいIngredient オブジェクトを作成するためのメソッド
  def new_ingredient_forms(menu_instance, ingredients_params)
    filtered_ingredients = ingredients_params.reject do |key, ingredient|
      ingredient['material_id'].blank? || ingredient['quantity'].blank? && ingredient['unit_id'] != '17'|| ingredient['unit_id'].blank?
    end

    menu_instance.ingredients = filtered_ingredients.values.map do |ingredient_data|
      Ingredient.new(ingredient_data)
    end
  end

  # Material オブジェクトをカテゴリー別にグループ化し、
  # それらをカテゴリーIDとひらがなでソートした結果を返すメソッド
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

  def handle_general_error
    flash[:error] = "登録中に予期せぬエラーが発生しました。"
    redirect_to user_menus_path
  end

  #食材データを受け取り、それをmaterial_idに基づいてグループ化し、各グループの食材を集約する
  def aggregate_ingredients(ingredient_list)
    min_duplicate_count = 1
    aggregated_ingredients = []

    # material_idに基づいてグループ化
    grouped_ingredients = ingredient_list.group_by(&:material_id)

    grouped_ingredients.each do |material_id, ingredients_group|
      # 重複していない食材の処理
      if ingredients_group.length <= min_duplicate_count
        aggregated_ingredients << ingredients_group.first
        next
      end

      # 重複している食材の処理
      total_quantity = aggregate_quantities(ingredients_group)
      default_unit_id = ingredients_group.first.material.default_unit_id

      aggregated_ingredient = Ingredient.new(
        material_id: material_id,
        quantity: total_quantity,
        unit_id: default_unit_id
      )

      aggregated_ingredients << aggregated_ingredient
    end

    aggregated_ingredients
  end

  # 食材が重複した場合、「MaterialUnit」にある"変換率"をかけて合算し、
  # 「Material」にある"デフォルトのunit_id"を単位に設定する
  def aggregate_quantities(grouped_ingredients)
    total_quantity = 0
    default_unit_id = grouped_ingredients.first.material.default_unit_id
    same_unit = grouped_ingredients.all? { |ingredient| ingredient.unit_id == default_unit_id }

    total_quantity = if same_unit
      grouped_ingredients.sum(&:quantity)
    else
      grouped_ingredients.reduce(0) do |sum, ingredient|
        material_unit = MaterialUnit.find_by(material_id: ingredient.material_id, unit_id: ingredient.unit_id)
        sum + ingredient.quantity * material_unit.conversion_factor
      end
    end

    total_quantity
  end

end
