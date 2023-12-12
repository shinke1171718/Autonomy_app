class ShoppingListsController < ApplicationController
  include IngredientsAggregator

  def index
    shopping_list_items = current_user.cart.shopping_list.shopping_list_items

    # ショッピングリストアイテムをカテゴリIDに基づいてグループ化する
    shopping_list_items_by_category = shopping_list_items.includes(:material).group_by do |item|
      item.material.category_id
    end

    # すべてのカテゴリを取得して、IDと名前のハッシュを作成
    @categories = Category.all.index_by(&:id).transform_values(&:category_name)

    # カテゴリIDでソートした結果をインスタンス変数に代入
    @shopping_lists = shopping_list_items_by_category.sort_by { |category_id, _items| category_id }.to_h
  end

  def create
    # ユーザーのカートを取得
    cart = current_user.cart
    # カートに紐づいたショッピングリストを取得
    shopping_list = current_user.cart.build_shopping_list

    # カートの中にあるmenu_idとその個数のデータを取得
    cart_items = cart.cart_items

    # menu_idとそのitem_countだけをハッシュとして取得
    menu_item_counts = cart_items.each_with_object({}) do |cart_item, counts|
      counts[cart_item.menu_id] = cart_item.item_count
    end

    # menuに関連するingredient_idを取得
    menu_ingredients = cart_items.flat_map { |cart_item| cart_item.menu.menu_ingredients }

    # 食材のレコードを複製する処理
    ingredients_duplicated = []
    menu_ingredients.each do |menu_ingredient|
      # 対応する献立の数量を取得
      menu_count = menu_item_counts[menu_ingredient.menu_id]

      # 献立の数量分だけレコードを複製
      menu_count.times do
        duplicated_ingredient = menu_ingredient.dup
        # 必要であれば他の属性もここで設定する
        ingredients_duplicated << duplicated_ingredient
      end
    end

    # ingredient_idに紐づく食材データを取得
    ingredients = ingredients_duplicated.map(&:ingredient)

    # 食材データを合算する
    aggregated_ingredients = aggregate_ingredients(ingredients)

    # カテゴリIDを格納するためのハッシュマップを初期化
    ingredients_with_categories = {}
    aggregated_ingredients.each do |ingredient|
      material = Material.find_by(id: ingredient.material_id)
      # Material に紐づくカテゴリIDをハッシュマップに追加
      ingredients_with_categories[ingredient.material_id] = material.category_id
    end

    begin
      ActiveRecord::Base.transaction do
        # ShoppingListが新規の場合は保存
        shopping_list.save! if shopping_list.new_record?

        aggregated_ingredients.each do |ingredient|
          shopping_list.shopping_list_items.create!(
            material_id: ingredient.material_id,
            quantity: ingredient.quantity,
            unit_id: ingredient.unit_id,
            category_id: ingredients_with_categories[ingredient.material_id],
            is_checked: false
          )
        end

        redirect_to shopping_lists_path
      end
    rescue ActiveRecord::RecordInvalid
      handle_general_error
      return
    end

  end
end
