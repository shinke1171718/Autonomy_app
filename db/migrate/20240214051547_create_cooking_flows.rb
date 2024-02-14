class CreateCookingFlows < ActiveRecord::Migration[7.0]
  def change
    create_table :cooking_flows do |t|
      t.references :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
