class MenusController < ApplicationController
  before_action :load_settings

  def custom_menus
    # 現在ログインしているユーザーのIDに関連付けられたすべてのメニューIDを取得
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    # menu_ids を使って Menu モデルから該当するレコードを取得
    @original_menus = paginate(Menu.where(id: menu_ids))
    # menu_ids を使って Menu モデルから該当するレコードの総数を取得
    @total_menus_count = Menu.where(id: menu_ids).count
  end


  def sample_menus
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @default_menus = paginate(Menu.where.not(id: menu_ids))
    # ユーザーに紐づいていないメニュー項目の総数を取得
    @total_menus_count = Menu.where.not(id: menu_ids).count
  end


  def new
    # ドロップダウンリストを作成に必要なデータを格納
    @materials_by_category = fetch_sorted_materials_by_category

    # 初期登録時の処理
    if params[:menu].blank?
      @menu = Menu.new
      @menu.ingredients = Ingredient.new
      return
    end

    # 確認画面一度経由した場合の処理
    if params[:menu][:encoded_image].present?
      result = decode_and_prepare_image(
        params[:menu][:encoded_image],
        params[:menu][:filename],
        params[:menu][:image_content_type]
      )

      @image_data_url = result[:image_data_url]
      @encoded_image = result[:encoded_image]
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
      # フィルタリングされた食材データを取得
      filtered_ingredients = filter_ingredients(params[:menu][:ingredients])
      # インスタンス化して@menuに関連付ける
      create_ingredient_instances(@menu, filtered_ingredients)
    end

    # 重複した献立を基準の単位に変換し、合算する
    @aggregated_ingredients = aggregate_ingredients(@menu.ingredients)

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
      # フィルタリングされた食材データを取得
      filtered_ingredients = filter_ingredients(params[:menu][:ingredients])
      # インスタンス化して@menuに関連付ける
      create_ingredient_instances(menu, filtered_ingredients)
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
    redirect_to user_custom_menus_path
  end


  def show
    @menu = Menu.find(params[:id])

    # 重複した献立を基準の単位に変換し、合算する
    menu_ingredients = MenuIngredient.where(menu_id: @menu.id)
    ingredients = menu_ingredients.includes(:ingredient).map(&:ingredient)
    @aggregated_ingredients = aggregate_ingredients(ingredients)
  end

  def edit
    @menu = Menu.find(params[:id])
    @materials_by_category = fetch_sorted_materials_by_category

    # MenuIngredient モデルを使用して ingredient_id のリストを取得
    ingredient_ids = MenuIngredient.where(menu_id: @menu.id).pluck(:ingredient_id)
    ingredients = Ingredient.where(id: ingredient_ids)

    # @menu.ingredients にデータを設定。このデータはフロントエンドの動的フォームにおいて
    # JavaScriptを介して利用される。各食材の詳細情報をインデックスに基づいたハッシュマップとして構築。
    @menu.ingredients = ingredients.each_with_index.inject({}) do |hash, (ingredient, index)|
      hash[index.to_s] = {
        'material_name' => ingredient.material_name,
        'material_id'   => ingredient.material_id.to_s,
        'quantity'      => ingredient.quantity.to_s,
        'unit_id'       => ingredient.unit_id.to_s
      }
      hash
    end

    if @menu.image.attached?
      @image_data_url = url_for(@menu.image)
    end
  end


  def update
    menu = Menu.find(params[:id])

    # 画像データがある場合の処理
    if params[:menu].values_at(:encoded_image, :image_content_type).all?
      image_data = Base64.decode64(params[:menu][:encoded_image])
      filename = "user_#{current_user.id}の献立の画像"
      menu.image.attach(io: StringIO.new(image_data), filename: filename, content_type: params[:menu][:image_content_type])
    end

    if params[:menu][:ingredients].present?
      # フィルタリングされた食材データを取得
      filtered_ingredients = filter_ingredients(params[:menu][:ingredients])
      # インスタンス化して@menuに関連付ける
      ingredient_data = create_ingredient_instances(menu, filtered_ingredients)
    end

    begin
      ActiveRecord::Base.transaction do
        # MenuIngredient モデルを使用して ingredient_id のリストを取得
        ingredient_ids = MenuIngredient.where(menu_id: menu.id).pluck(:ingredient_id)
        ingredients = Ingredient.where(id: ingredient_ids)

        # 既存の食材データを削除する
        ingredients.destroy_all
        # 関連する MenuIngredient レコードを削除
        MenuIngredient.where(menu_id: menu.id).destroy_all

        # メニューデータを更新
        menu.update!(menu_params)

        # 新しい食材データを保存
        if ingredient_data.present?
          ingredient_data.each do |ingredient|
            puts "食材を保存中: #{ingredient.inspect}"
            ingredient.save!
            MenuIngredient.create!(menu_id: menu.id, ingredient_id: ingredient.id)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      handle_general_error
      return
    end

    flash[:notice] = "献立が更新されました。"
    redirect_to user_menu_path(user_id: current_user.id, menu_id: menu.id)
  end

  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :image, :image_meta_data, ingredients: [:material_name, :material_id, :unit_id, :quantity])
  end

  def filter_ingredients(ingredients_params)
    # 設定から特定のunit_idを取得
    no_quantity_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id')

    # material_idが空である要素を排除
    ingredient_data = ingredients_params.reject { |key, ingredient| ingredient['material_id'].blank? }
    # unit_idが特定の値の要素を選択
    unit_specific_ingredients = ingredient_data.select { |key, ingredient| ingredient['unit_id'] == no_quantity_unit_id }
    # quantityが空でない要素を選択
    quantity_present_ingredients = ingredient_data.reject { |key, ingredient| ingredient['quantity'].blank? }

    # 両方の条件を満たす要素を結合
    usable_ingredients = (unit_specific_ingredients.values + quantity_present_ingredients.values)
  end

  # メニューインスタンスに関連付ける食材インスタンスを作成するメソッド
  def create_ingredient_instances(menu_instance, filtered_ingredients)
    menu_instance.ingredients = filtered_ingredients.map do |ingredient_data|
      Ingredient.new(ingredient_data)
    end
  end

  # Material オブジェクトをカテゴリー別にグループ化し、それらをカテゴリーIDとひらがなでソートした結果を返すメソッド
  def fetch_sorted_materials_by_category
    materials_by_category = {}
    # Material オブジェクトの取得とソート
    sorted_materials = Material.includes(:category).order('categories.id', :hiragana)
    # カテゴリー名でグループ化
    grouped_materials = sorted_materials.group_by { |m| m.category.category_name }

    # カテゴリー名でグループ化かつ50音順に並び替える
    grouped_materials.each do |category_name, materials|
      # カテゴリー内でさらにひらがな順にソート
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

      # 「material_id」、合算した「数量」、「デフォルト単位」を１つのインスタンスとして再構成
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

    # 複数の食材の合算数値
    total_quantity = 0
    # 合算時に使用する単位を取得
    default_unit_id = grouped_ingredients.first.material.default_unit_id
    # 取得した食材の単位が全て合算用の単位と同じならsame_unitに代入
    same_unit = grouped_ingredients.all? { |ingredient| ingredient.unit_id == default_unit_id }

    # 取得した食材の単位が全て合算用の単位と同じ場合の処理
    total_quantity = if same_unit
      grouped_ingredients.sum(&:quantity)
    else
      # 取得した食材の単位がバラバラの場合、合算されたデータがsumに蓄積され戻り値としてtotal_quantityに格納
      grouped_ingredients.reduce(0) do |sum, ingredient|
        # MaterialUnitから変換率（conversion_factor）を取得
        material_unit = MaterialUnit.find_by(material_id: ingredient.material_id, unit_id: ingredient.unit_id)
        # 登録された数値と変換率（conversion_factor）を掛け、sumに蓄積する
        sum + ingredient.quantity * material_unit.conversion_factor
      end
    end

    total_quantity
  end

  # 各アクション内で必要な設定値を @settings 変数に格納
  def load_settings
    @settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
  end

  def paginate(query)
    # 定数 FIRST_PAGE はページネーションで使用される最初のページ番号を定義します。
    # 通常、ページ番号は1から始まります。
    first_page = @settings.dig('pagination', 'first_page')

    # パラメータからページ番号を取得し、1以上の整数に変換（デフォルトは1ページ目）
    page = [params[:page].to_i, first_page].max

    items_per_page = @settings.dig('pagination', 'items_per_page')

    # どれだけのレコードをスキップしてからデータを取り出すかを指定する数値
    offset = (page - first_page) * items_per_page

    # items_per_page分のレコードをoffset分スキップしてレコードを取得する
    query.limit(items_per_page).offset(offset)
  end

  def decode_and_prepare_image(encoded_image, filename, image_content_type)
    return nil unless encoded_image.present?

    # Base64エンコードされた画像データをデコードする
    decoded_image = Base64.decode64(encoded_image)

    # 一時ファイルを作成する
    tempfile = Tempfile.new(['upload', '.jpg'])
    tempfile.binmode
    tempfile.write(decoded_image)
    tempfile.rewind

    # `ActionDispatch::Http::UploadedFile`オブジェクトを作成する
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      filename: filename,
      type: image_content_type,
      tempfile: tempfile
    )

    # 必要な情報を返す
    {
      image_data_url: generate_data_url(uploaded_file),
      encoded_image: encoded_image
    }
  end

end
