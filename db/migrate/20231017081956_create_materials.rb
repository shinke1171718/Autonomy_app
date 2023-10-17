class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :material_name,               null: false, default: ""
      t.integer :conversion_factor,          null: false, default: ""
      t.references :category,                null: false
      t.references :unit,                    null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
