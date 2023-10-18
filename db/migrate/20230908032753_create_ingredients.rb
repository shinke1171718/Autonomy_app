class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.references :material_unit,  null: false
      t.references :unit,           null: false
      t.integer :quantity
      t.timestamps
    end
  end
end
