class TempIngredientsController < ApplicationController

  def create
    temp_ingredient = TempIngredient.new(temp_ingredient_params)
    validate_temp_ingredient(temp_ingredient)
    render_or_save_temp_ingredient(temp_ingredient, new_user_menu_path(current_user))
  end

  def update
    temp_ingredient = TempIngredient.new(temp_ingredient_params)
    validate_temp_ingredient(temp_ingredient)
    render_or_save_temp_ingredient(temp_ingredient, edit_user_menu_path(current_user, menu))
  end

  def new_destroy
    temp_ingredient = TempIngredient.find(params[:id])
    destroy_and_redirect(temp_ingredient, new_user_menu_path(current_user))
  end

  def edit_destroy
    temp_ingredient = TempIngredient.find(params[:id])
    destroy_and_redirect(temp_ingredient, edit_user_menu_path(current_user, temp_ingredient.menu))
  end


  private

  def temp_ingredient_params
    params.require(:temp_ingredient).permit(:name, :quantity, :unit, :user_id)
  end

  def validate_temp_ingredient(temp_ingredient)
    existing_temp_ingredient = TempIngredient.where(user_id: current_user.id, name: temp_ingredient.name).first

    if existing_temp_ingredient.present?
      flash[:notice] = '同じ名前の食材がすでに存在します。'
    elsif temp_ingredient.name.blank?
      flash[:notice] = "食材名を登録してください。"
    elsif temp_ingredient.quantity.blank?
      flash[:notice] = "数量を登録してください。"
    elsif !temp_ingredient.quantity.to_i.positive?
      flash[:notice] = "数量は数値で入力してください。"
    elsif temp_ingredient.unit.blank?
      flash[:notice] = "単位を登録してください。"
    end
  end

  def render_or_save_temp_ingredient(temp_ingredient, path)
    if flash[:notice].present?
      redirect_to path
    else
      temp_ingredient.save
      flash[:notice] = '食材を登録しました。'
      redirect_to path
    end
  end

  def destroy_and_redirect(temp_ingredient, path)
    temp_ingredient.destroy
    flash[:notice] = "食材を削除しました。"
    respond_to do |format|
      format.html { redirect_to path }
      format.js
    end
  end

end
