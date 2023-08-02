class IngredientsController < ApplicationController

  def new
    @menu = Menu.find(params[:menu_id])
    @ingredient = Ingredient.new
    @ingredients = Ingredient.where(menu_id: @menu.id)
  end

  def create
    ingredient = Ingredient.new(ingredient_params)
    redirect_path = new_user_menu_ingredient_path
    existing_ingredient = Ingredient.where(menu_id: ingredient.menu_id, name: ingredient.name).first

    if ingredient.name.blank?
      flash_message = "食材名を登録してください。"
    elsif ingredient.quantity.blank?
      flash_message = "数量を登録してください。"
    elsif !ingredient.quantity.to_i.positive?
      flash_message = "数量は数値で入力してください。"
    elsif ingredient.unit.blank?
      flash_message = "単位を登録してください。"
    end

    if existing_ingredient.present?
      flash_message = '同じ名前の食材がすでに存在します。'
    end

    if flash_message.present?
      flash[:notice] = flash_message
      redirect_to redirect_path
      return
    end

    ingredient.save
    flash[:notice] = '食材を登録しました。'
    redirect_to redirect_path
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
    flash[:notice] = "食材を削除しました。"
    respond_to do |format|
      format.html { redirect_to new_user_menu_ingredient_path }
      format.js
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :quantity, :unit, :menu_id)
  end
end
