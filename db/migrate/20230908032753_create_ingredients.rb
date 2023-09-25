class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.references :menu,           null: false
      t.integer :form_number,       null: false, default: ""
      t.string :name,               null: false, default: ""
      t.integer :quantity,          null: false, default: ""
      t.string :unit,               null: false, default: ""
      t.timestamps
    end
  end
end
