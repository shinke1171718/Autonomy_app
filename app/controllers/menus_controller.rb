class MenusController < ApplicationController
  include ServingSizeHandler
  include IngredientScaler
  before_action :set_and_sort_materials_by_category, only: [:new, :edit]
  before_action :check_menu_selection, only: [:edit, :destroy]

  def custom_menus
    # 現在ログインしているユーザーのIDに関連付けられたすべてのメニューIDを取得
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    # menu_ids を使って Menu モデルから該当するレコードを取得
    @original_menus = paginate(Menu.where(id: menu_ids))
    # menu_ids を使って Menu モデルから該当するレコードの総数を取得
    @total_menus_count = Menu.where(id: menu_ids).count
  end


  def sample_menus
    # UserMenuに存在する全てのmenu_idを取得
    used_menu_ids = UserMenu.pluck(:menu_id)
    # これらのmenu_idに紐づいていないMenuのデータを取得
    @default_menus = paginate(Menu.where.not(id: used_menu_ids))
    # ユーザーに紐づいていないメニュー項目の総数を取得
    @total_menus_count = Menu.where.not(id: used_menu_ids).count
  end


  def new
    # 通常の `new` リクエスト処理
    if params[:menu].blank?
      @menu = Menu.new
      @menu.ingredients = Ingredient.new
      return
    end

    # `confirm` アクションからのリダイレクト時の処理
    # 受け取ったmenuデータを再度インスタンス化
    @menu = Menu.new(
      menu_name: params[:menu][:menu_name],
      menu_contents: params[:menu][:menu_contents]
    )

    if params[:menu][:recipe_steps_attributes]
      @menu.recipe_steps = params[:menu][:recipe_steps_attributes]
    end

    # ingredientデータの処理
    # 別途子モデルであるingredientsをmenuに別途割り当てる。
    # 理由は「accepts_nested_attributes_for」を使用しないためです。
    if params[:menu][:ingredients_attributes]
      @menu.ingredients = params[:menu][:ingredients_attributes]
    end

    # `confirm`からのPOST後のリダイレクトのため `new` へレンダリング
    render 'new', status: :unprocessable_entity
  end


  def confirm
    @menu = Menu.new(menu_params)

    # 食材データを「@menu.steps」に格納
    if params[:menu][:recipe_steps].present?
      filtered_steps = filter_steps_data(params[:menu][:recipe_steps])
      @menu.recipe_steps = instantiate_steps(filtered_steps)
    end

    # 食材データを「@menu.ingredients」に格納
    if params[:menu][:ingredients].present?
      # フィルタリングされた食材データを取得
      filtered_ingredients = filter_ingredients(params[:menu][:ingredients])
      # インスタンス化して@menuに関連付ける
      @menu.ingredients = create_ingredient_instances(filtered_ingredients)
    end

    # 編集時に再登録はしなかったが、最初に登録した画像データがある場合は再格納
    if params[:menu][:image_data_url].present?
      @image_data_url = params[:menu][:image_data_url]
      @encoded_image = params[:menu][:encoded_image]
    end

    # アップロードされた画像がある場合のみバリデーションを行い、問題があれば処理を中断
    if params[:menu][:image].present? && validate_uploaded_image(params[:menu][:image])
      handle_general_error
      return
    end

    # 画像が新規アップロードされた場合、uploaded_fileを作成し既存データを上書き
    if params[:menu][:image].present?
      uploaded_file = params[:menu][:image]
    end

    # 編集時に再登録した画像を格納
    if uploaded_file.present?
      # viewに表示する画像URL設定
      @image_data_url = generate_data_url(uploaded_file)
      # 読み取り位置をファイルの先頭に戻す
      uploaded_file.rewind
      # データを読み取り
      image_data = uploaded_file.read
      # Base64エンコードに変換
      @encoded_image = Base64.strict_encode64(image_data)
    end

    if @menu.valid?
      render_confirm_page
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

    # unit_id で昇順にソート
    sorted_units = units.sort_by { |unit| unit[:id] }
    render json: sorted_units
  end


  def create
    menu = Menu.new(menu_params)

    # 食材データを「@menu.steps」に格納
    if params[:menu][:recipe_steps].present?
      filtered_steps = filter_steps_data(params[:menu][:recipe_steps])
      menu.recipe_steps = instantiate_steps(filtered_steps)
    end

    if params[:menu][:ingredients].present?
      # フィルタリングされた食材データを取得
      filtered_ingredients = filter_ingredients(params[:menu][:ingredients])
      # インスタンス化して@menuに関連付ける
      menu.ingredients = create_ingredient_instances(filtered_ingredients)
    end

    # 画像データがある場合の処理
    if params[:menu].values_at(:encoded_image, :image_content_type).all?
      image_data = Base64.decode64(params[:menu][:encoded_image])
      filename = "user_#{current_user.id}のレシピの画像"
      menu.image.attach(io: StringIO.new(image_data), filename: filename, content_type: params[:menu][:image_content_type])
    end

    begin
      ActiveRecord::Base.transaction do
        menu.save!
        UserMenu.create!(menu_id: menu.id, user_id: current_user.id)

        if menu.recipe_steps.present?
          menu.recipe_steps.each do |recipe_step|
            recipe_step.menu_id = menu.id
            recipe_step.save!
          end
        end

        if menu.ingredients.present?
          menu.ingredients.each do |ingredient|
            ingredient.save!
            MenuIngredient.create!(menu_id: menu.id, ingredient_id: ingredient.id)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid
      handle_general_error
      return
    end

    flash[:notice] = "レシピを登録しました。"
    redirect_to user_custom_menus_path
  end


  def show
    @menu = Menu.find(params[:id])

    # 重複したmenuを基準の単位に変換し、合算する
    menu_ingredients = MenuIngredient.where(menu_id: @menu.id)
    ingredients = menu_ingredients.includes(:ingredient).map(&:ingredient)
    aggregated_ingredients = aggregate_ingredients_with_special_handling(ingredients)

    # scale_ingredientsメソッドを呼び出して、quantityを更新
    @scaled_ingredients = adjust_ingredients_for_menu_count(aggregated_ingredients, @serving_size)

    # 作り方の工程データを取得
    @recipe_steps = RecipeStep.where(menu_id: @menu.id)
  end


  def edit
    # `confirm` アクションからのリダイレクト時の処理（その場合`menu_id` が `params[:menu]` の中に含まれる）
    if params[:menu].present?
      # 既存のメニューを取得
      @menu = Menu.find(params[:menu][:menu_id])
      # 取得したメニューにフォームからの新しい属性を割り当てる
      @menu.assign_attributes(menu_params_from_confirm)
      # 別途子モデルであるingredientsをmenuに別途割り当てる。
      # 理由は「accepts_nested_attributes_for」を使用しないためです。
      @menu.ingredients = params[:menu][:ingredients_attributes]

      @menu.recipe_steps = params[:menu][:recipe_steps_attributes]

      # `confirm`からのPOST後のリダイレクトのため `edit` へレンダリング
      render 'edit', status: :unprocessable_entity
    else
      # 通常の `edit` リクエスト処理
      @menu = Menu.find(params[:menu_id])
    end


    # menu_idに該当するRecipeStepのデータを取得
    recipe_steps = RecipeStep.where(menu_id: @menu.id)

    # @menu.recipe_steps にデータを設定
    @menu.recipe_steps = recipe_steps.each_with_index.inject({}) do |hash, (recipe_step, index)|
      hash[index.to_s] = {
        recipe_step_category_id: recipe_step.recipe_step_category_id.to_s,
        description:             recipe_step.description
      }
      hash
    end

    # MenuIngredient モデルを使用して ingredient_id のリストを取得
    ingredients = Ingredient.joins(:menu_ingredients).where(menu_ingredients: { menu_id: @menu.id })

    # @menu.ingredients にデータを設定。このデータはフロントエンドの動的フォームにおいて
    # JavaScriptを介して利用される。各食材の詳細情報をインデックスに基づいたハッシュマップとして構築。
    @menu.ingredients = ingredients.each_with_index.inject({}) do |hash, (ingredient, index)|
      hash[index.to_s] = {
        material_name: ingredient.material_name,
        material_id:   ingredient.material_id.to_s,
        quantity:      ingredient.quantity.to_s,
        unit_id:       ingredient.unit_id.to_s
      }
      hash
    end
  end

  def update
    menu = Menu.find(params[:menu][:menu_id])

    # 食材データを「@menu.steps」に格納
    if params[:menu][:recipe_steps].present?
      filtered_steps = filter_steps_data(params[:menu][:recipe_steps])
      menu.recipe_steps = instantiate_steps(filtered_steps)
    end

    # 食材データがある場合の処理
    if params[:menu][:ingredients].present?
      # フィルタリングされた食材データを取得
      filtered_ingredients = filter_ingredients(params[:menu][:ingredients])
      # インスタンス化してmenuに関連付ける
      menu.ingredients = create_ingredient_instances(filtered_ingredients)
    end

    # 画像データがある場合の処理
    if params[:menu].values_at(:encoded_image, :image_content_type).all?
      image_data = Base64.decode64(params[:menu][:encoded_image])
      filename = "user_#{current_user.id}のレシピの画像"
      menu.image.attach(io: StringIO.new(image_data), filename: filename, content_type: params[:menu][:image_content_type])
    end

    begin
      ActiveRecord::Base.transaction do
        # MenuIngredient モデルを使用して ingredient_id のリストを取得
        ingredients = Ingredient.joins(:menu_ingredients).where(menu_ingredients: { menu_id: menu.id })

        # 現在登録されているRecipeStepデータを取得
        recipe_steps = RecipeStep.where(menu_id: menu.id)

        # 既存の工程データを削除する
        recipe_steps.destroy_all
        # 既存の食材データを削除する
        ingredients.destroy_all

        # メニューデータを更新
        menu.update!(menu_params)

        # 新しい工程データを保存
        if menu.recipe_steps.present?
          menu.recipe_steps.each do |recipe_step|
            recipe_step.menu_id = menu.id
            recipe_step.save!
          end
        end

        # 新しい食材データを保存
        if menu.ingredients.present?
          menu.ingredients.each do |ingredient|
            ingredient.save!
            MenuIngredient.create!(menu_id: menu.id, ingredient_id: ingredient.id)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      handle_general_error
      return
    end

    flash[:notice] = "レシピが更新されました。"
    redirect_to user_menu_path(user_id: current_user.id, id: params[:menu][:menu_id])
  end


  def destroy
    # menu_idからデータを取得
    menu = Menu.find(params[:menu_id])
    # menu_idに該当するshopping_list_menusデータがあるかチェック
    if menu.shopping_list_menus.exists?
      flash[:error] = "このレシピは現在選択されています。"
      redirect_to user_menu_path(menu_id: menu.id)
    else
      # menuデータを削除
      menu.destroy
      flash[:notice] = "レシピを削除しました。"
      redirect_to user_custom_menus_path
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :encoded_image, :filename, :image_content_type, :image_data_url, ingredients_attributes: [:material_name, :material_id, :quantity, :unit_id], recipe_steps_attributes: [:recipe_step_category_id, :description])
  end

  # このメソッドでは、`confirm` アクションからのリダイレクト時に、ストロングパラメータを
  # 使用して、許可された属性（menu_name、menu_contents、contents）をモデルに一括で割り当てる
  # ために必要なパラメータをフィルタリングします。
  def menu_params_from_confirm
    params.require(:menu).permit(:menu_name, :menu_contents)
  end

  def filter_ingredients(ingredients_params)

    # 設定から特定のunit_idを取得
    no_quantity_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id')

    # material_idが空である要素を排除
    ingredient_data = ingredients_params.reject { |key, ingredient| ingredient['material_id'].blank? }
    # unit_idが特定の値の要素を選択
    unit_specific_ingredients = ingredient_data.select { |key, ingredient| ingredient['unit_id'] == no_quantity_unit_id.to_s }
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

  def create_ingredient_instances(filtered_ingredients)
    filtered_ingredients.map do |ingredient_data|
      Ingredient.new(ingredient_data)
    end
  end

  # Material オブジェクトをカテゴリー別にグループ化し、それらをカテゴリーIDとひらがなでソートした結果を返すメソッド
  def set_and_sort_materials_by_category
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

    @materials_by_category = materials_by_category
  end

  # アップロードされたファイルからデータURLを生成するメソッド
  def generate_data_url(uploaded_file)
    "data:#{uploaded_file.content_type};base64,#{Base64.strict_encode64(uploaded_file.read)}"
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

  def render_confirm_page
    if params[:menu][:menu_id].present?
      render 'edit_confirm', status: :unprocessable_entity
    else
      render 'new_confirm', status: :unprocessable_entity
    end
  end

  def check_menu_selection
    # current_userに紐づくカートがない場合、新しいカートを作成
    if current_user.cart.nil?
      current_user.create_cart
    end

    if current_user_cart.cart_items.exists?(menu_id: params[:menu_id])
      flash[:error] = "このレシピは現在選択されているため、編集（削除）はできません。"
      redirect_to user_menu_path(menu_id: params[:menu_id])
    end
  end

  # 受け取ったstepsデータを使用するデータだけ取得
  def filter_steps_data(steps_params)

    steps_params.select do |_, value|
      value[:recipe_step_category_id].present? && value[:description].present?
    end
  end

  # メニューインスタンスに関連付けるstepsインスタンスを作成するメソッド
  def instantiate_steps(filtered_steps)
    # ActionController::Parameters オブジェクトをハッシュに変換し、その値の配列を取得
    steps_array = filtered_steps.to_unsafe_h.values
    steps_array.map do |value|
      RecipeStep.new(recipe_step_category_id: value[:recipe_step_category_id], description: value[:description])
    end
  end

  # アップロードされた画像のバリデーションを行うメソッド
  def validate_uploaded_image(uploaded_file)
    valid_content_types = %w[image/jpeg image/png]
    max_size_in_megabytes = @settings.dig('limits', 'max_image_size_in_megabytes')

    if !valid_content_types.include?(uploaded_file.content_type)
      return true
    end

    if uploaded_file.size > max_size_in_megabytes.megabytes
      return true
    end

    return false
  end

  def adjust_ingredients_for_menu_count(ingredients, menu_count)
    menu_count = menu_count.to_i
    # ingredient_settings = @settings['ingredient']
    no_quantity_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id')

    # unit_id == 17のingredientsをフィルタリングし、最初のものを選択
    unique_no_quantity_ingredient = ingredients.find { |ingredient| ingredient.unit_id == no_quantity_unit_id }

    # unit_id != 17の残りのingredients
    other_ingredients = ingredients.reject { |ingredient| ingredient.unit_id == no_quantity_unit_id }

    scaled_ingredients = other_ingredients.map do |ingredient|
      adjust_ingredient_quantity(ingredient, menu_count)
    end

    # unit_id: 17のingredientがある場合、それを結果に追加
    scaled_ingredients.unshift(unique_no_quantity_ingredient) if unique_no_quantity_ingredient

    scaled_ingredients.compact
  end

  def adjust_ingredient_quantity(ingredient, menu_count)
    min_items_to_scale = @settings.dig('limits', 'min_items_to_scale')
    new_ingredient = ingredient.dup
    new_ingredient_quantity = new_ingredient.quantity
    new_ingredient.quantity= new_ingredient_quantity *= menu_count

    new_ingredient
  end

  #食材データを受け取り、それをmaterial_idに基づいてグループ化し、各グループの食材を集約する
  # 特殊な単位「少々（unit_id: 17）」には例外処理を行う
  def aggregate_ingredients_with_special_handling(ingredient_list)
    min_duplicate_count = 1
    no_quantity_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id')
    aggregated_ingredients = []

    # material_idに基づいてグループ化
    grouped_ingredients = ingredient_list.group_by(&:material_id)

    grouped_ingredients.each do |material_id, ingredients_group|
      # 重複していない食材の処理
      if ingredients_group.length <= min_duplicate_count
        aggregated_ingredients << ingredients_group.first
        next
      end

      no_quantity_ingredient = ingredients_group.find { |ingredient| ingredient.unit_id == no_quantity_unit_id }

      aggregated_ingredients << no_quantity_ingredient if no_quantity_ingredient

      # unit_idがno_quantity_unit_idのingredientを除外したingredients_groupを作成
      filtered_ingredients_group = ingredients_group.reject { |ingredient| ingredient.unit_id == no_quantity_unit_id }

      next if filtered_ingredients_group.empty?

      material = Material.find_by(id: material_id)
      material_name = material.material_name
      # 重複している食材の処理
      total_quantity, unit_id_to_use = aggregate_quantities_with_special_handling(filtered_ingredients_group)

      # 「material_id」、合算した「数量」、「デフォルト単位」を１つのインスタンスとして再構成
      aggregated_ingredient = Ingredient.new(
        material_name: material_name,
        material_id: material_id,
        quantity: total_quantity,
        unit_id: unit_id_to_use
      )

      aggregated_ingredients << aggregated_ingredient
    end

    aggregated_ingredients
  end

    # 食材が重複した場合、「MaterialUnit」にある"変換率"をかけて合算し、
  # 「Material」にある"デフォルトのunit_id"を単位に設定する
  def aggregate_quantities_with_special_handling(grouped_ingredients)

    # 複数の食材の合算数値
    total_quantity = 0
    exception_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id').to_i
    exception_ingredient_quantity = @settings.dig('ingredient', 'exception_ingredient_quantity')

    # グループ内で使用されている全てのunit_idを取得
    filtered_unit_ids = grouped_ingredients.reject { |ingredient| ingredient.unit_id == exception_unit_id }.map(&:unit_id).uniq
    unique_unit_id_threshold = @settings.dig('limits', 'unique_unit_id_threshold')

    # グループ内で使用されている全てのunit_idが同じかどうかを確認
    is_same_unit_id = filtered_unit_ids.length == unique_unit_id_threshold

    # 使用するunit_idを決定
    unit_id_to_use = if is_same_unit_id
      grouped_ingredients.first.unit_id
    else
      grouped_ingredients.first.material.default_unit_id
    end

    # 同じunit_idである場合と異なる場合で合算ロジックを分ける
    if is_same_unit_id
      # グループ内のunit_idが全て同じでその単位で合算
      total_quantity = grouped_ingredients.sum(&:quantity)
    else
      # 異なるunit_idが存在する場合、materialのdefault_unit_idを使用して合算
      total_quantity = grouped_ingredients.reduce(0) do |sum, ingredient|
        material_unit = MaterialUnit.find_by(material_id: ingredient.material_id, unit_id: ingredient.unit_id)
        conversion_factor = material_unit.conversion_factor
        quantity = ingredient.quantity || exception_ingredient_quantity
        sum + quantity * conversion_factor
      end
    end

    [total_quantity, unit_id_to_use]
  end

end