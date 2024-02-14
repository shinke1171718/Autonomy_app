class CreateCookingSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :cooking_steps do |t|
      t.references :cooking_flow,       null: false, foreign_key: true
      t.references :recipe_step,        null: false, foreign_key: true
      t.string :menu_name,              null: false, default: ""
      t.integer :step_order
      t.boolean :is_checked

      t.timestamps
    end
  end
end
