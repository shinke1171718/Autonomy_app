class CreateShoppingListMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :shopping_list_menus do |t|
      t.references :shopping_list, null: false, foreign_key: true
      t.references :menu, null: false, foreign_key: true
      t.integer :menu_count

      t.timestamps
    end
  end
end
