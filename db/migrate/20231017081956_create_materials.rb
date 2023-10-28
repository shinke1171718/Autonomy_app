class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :material_name,               null: false
      t.references :category,                null: false
      t.integer :default_unit_id,            null: false
      t.string :hiragana,                    null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    # ここでのunitは変換時に利用するデータです。
    # 通常時の単位は中間モデルで設定しています。
  end
end
