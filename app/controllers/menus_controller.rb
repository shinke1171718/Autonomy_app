class MenusController < ApplicationController

  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
    @menu.ingredients = Ingredient.new
    @materials_by_category = fetch_materials_grouped_by_category
  end


  def new_confirm
    @menu = Menu.new(menu_params)

    #フォーム改装のためコメントアウトしています。
    # new_ingredient_forms(@menu)

    #不フォーム改装のため修正が必要
    # if @menu.valid? && @menu.ingredients.all?(&:valid?) && validate_unique_name(@menu.ingredients)
    #   render 'confirm'
    #   return
    # else
    #   flash[:error] = "誤った入力が検出されました。"
    #   redirect_to new_user_menu_path
    # end
  end

  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :image, :image_meta_data, ingredients: [:name, :material_unit_id, :quantity])
  end

  def new_ingredient_forms(menu)
    ingredient_forms_data = @menu.ingredients

    ingredient_forms = []
    ingredient_forms_data.each do |name, form_data|
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

  def validate_unique_name(ingredients)
    if ingredients.map(&:name).uniq.count != ingredients.count
      return false
    end
    return true
  end

  def fetch_materials_grouped_by_category
    all_materials = Material.includes(:category).order(:hiragana)
    materials_grouped_by_category = all_materials.group_by(&:category)
    sorted_by_category = materials_grouped_by_category.sort_by { |category, _| category.id }.to_h
    sorted_materials_within_categories = sorted_by_category.transform_values { |materials| materials.sort_by(&:hiragana) }
  end

end
