class CreateCompletedMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_menu_items do |t|
      t.references :completed_menu, null: false, foreign_key: true
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
