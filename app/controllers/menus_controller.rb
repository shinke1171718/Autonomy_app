class MenusController < ApplicationController

  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
    new_ingredients(@menu)
  end


  def new_confirm
    @menu = Menu.new(menu_params)
    new_ingredient_forms(@menu)

    if @menu.valid? && @menu.ingredients.all?(&:valid?) && validate_unique_name(@menu.ingredients)
      render 'confirm'
      return
    else
      flash[:error] = "誤った入力が検出されました。"
      redirect_to new_user_menu_path
    end
  end


  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :image, :image_meta_data, ingredients: [:form_number, :name, :quantity, :unit])
  end

  def new_ingredient_forms(menu)
    ingredient_forms_data = @menu.ingredients

    ingredient_forms = []
    ingredient_forms_data.each do |form_number, form_data|
      ingredient_form = Ingredient.new(form_data)
      ingredient_forms << ingredient_form
    end

    ingredient_forms.reject! do |ingredient|
      ingredient.name.blank? &&
      ingredient.quantity.blank? &&
      ingredient.unit.blank?
    end

    @menu.ingredients = ingredient_forms
  end


  def new_ingredients(menu)
    menu.ingredients = []
    setting_form_number = 10
    setting_form_number.times { menu.ingredients << Ingredient.new }
  end

  def validate_unique_name(ingredients)
    if ingredients.map(&:name).uniq.count != ingredients.count
      return false
    end
    return true
  end

end
