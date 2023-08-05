class CreateTempIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :temp_ingredients do |t|
      t.string :name,                null: false, default: ""
      t.integer :quantity,           null: false, default: ""
      t.string :unit,                null: false, default: ""
      t.references :user, 		       null: false, foreign_key: true

      t.timestamps
    end
  end
end
