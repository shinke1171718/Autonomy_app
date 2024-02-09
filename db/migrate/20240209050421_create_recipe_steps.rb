class CreateRecipeSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_steps do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :recipe_step_category, null: false, foreign_key: true
      t.integer :step_order
      t.text :description

      t.timestamps
    end
  end
end
