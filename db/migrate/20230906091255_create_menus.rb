class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.string :menu_name,               null: false, default: ""
      t.text :menu_contents,             null: false, default: ""
      t.string :contents,                null: false, default: ""
      t.boolean :original_menu,          null: false, default: false
      t.text :image_meta_data,           null: false, default: ""
      t.string :image,                   null: false, default: ""
      t.timestamps
    end
  end
end