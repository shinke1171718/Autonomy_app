class CreateUserMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :user_menus do |t|
      t.references :user
      t.references :menu, null: false
      t.timestamps
    end
  end
end
