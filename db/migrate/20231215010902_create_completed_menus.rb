class CreateCompletedMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_menus do |t|
      t.references :user,             null: false, foreign_key: true
      t.references :menu,             null: false, foreign_key: true
      t.integer :menu_count,          null: false
      t.boolean :is_completed,        null: false, default: false
      t.date :date_completed

      t.timestamps
    end
  end
end
