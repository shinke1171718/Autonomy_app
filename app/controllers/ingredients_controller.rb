class IngredientsController < ApplicationController

  def new
    @menu = Menu.find(params[:menu_id])
    @ingredient = Ingredient.new
    @ingredients = Ingredient.where(menu_id: @menu.id)
  end

  def create
    ingredient = Ingredient.new(ingredient_params)
    redirect_path = new_user_menu_ingredient_path(current_user.id)

    if ingredient.name.blank?
      flash_message = "食材名を登録してください。"
    elsif ingredient.quantity.blank?
      flash_message = "数量を登録してください。"
    elsif !ingredient.quantity.to_i.positive?
      flash_message = "数量は数値で入力してください。"
    elsif ingredient.unit.blank?
      flash_message = "単位を登録してください。"
    end

    if flash_message.present?
      flash[:notice] = flash_message
      redirect_to redirect_path
      return
    end

    ingredient.save
    redirect_to redirect_path
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :quantity, :unit, :menu_id)
  end
end
