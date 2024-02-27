module MenuItemCounts
  # カートアイテムからmenu_idとitem_countのハッシュを生成する
  def calculate_menu_item_counts(cart_items)
    cart_items.map { |item| [item.menu_id, item.item_count] }.to_h
  end
end
