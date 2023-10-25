class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :material_name,               null: false, default: ""
      t.integer :conversion_factor,          null: false, default: ""
      t.references :category,                null: false
      t.references :unit,                    null: false
      t.string :default_name,                null: false, default: ""
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    # ここでのunitは変換時に利用するデータです。
    # 通常時の単位は中間モデルで設定しています。
  end
end
