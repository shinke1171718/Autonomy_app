class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :menu, null: false, foreign_key: true
      t.integer :item_count

      t.timestamps
    end
  end
end
