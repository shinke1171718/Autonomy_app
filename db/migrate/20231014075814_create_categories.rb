class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :category_name,           null: false, default: ""
      t.timestamps                       default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
