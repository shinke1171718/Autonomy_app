class CreateShoppingListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :shopping_list_items do |t|
      t.references :shopping_list, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true
      t.decimal :quantity
      t.references :unit, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.boolean :is_checked

      t.timestamps
    end
  end
end
