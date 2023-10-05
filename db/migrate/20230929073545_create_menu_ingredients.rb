class CreateMenuIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_ingredients do |t|
      t.references :menu,                null: false
      t.references :ingredient,          null: false
      t.timestamps
    end
  end
end
