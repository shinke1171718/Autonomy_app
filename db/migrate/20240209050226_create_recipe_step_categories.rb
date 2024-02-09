class CreateRecipeStepCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_step_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
