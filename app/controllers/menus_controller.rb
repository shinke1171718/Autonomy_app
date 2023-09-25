class MenusController < ApplicationController

  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
    new_ingredients(@menu)
    Rails.logger.info '通ったよ'
  end


  def new_confirm
    @menu = Menu.new(menu_params)
    new_ingredient_forms(@menu)

    flash.now[:error] = "入力内容に不備があります。"
    render 'new', status: :unprocessable_entity
    return

    # if @menu.valid? && @ingredients.all?(&:valid?)
    #   render 'confirm'
    #   return
    # else
    #   flash.now[:error] = "入力内容に不備があります。"
    #   render 'new', status: :unprocessable_entity
    #   return
    # end
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

    @menu.ingredients = ingredient_forms
  end


  def new_ingredients(menu)
    menu.ingredients = []
    10.times { menu.ingredients << Ingredient.new }
  end

end
