class CreateMaterialUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :material_units do |t|
      t.references :material,                null: false
      t.references :unit,                    null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
