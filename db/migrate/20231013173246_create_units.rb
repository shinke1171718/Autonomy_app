class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :unit_name,               null: false, default: ""
      t.timestamps                       default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
