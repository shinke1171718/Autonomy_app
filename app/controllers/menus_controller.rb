class MenusController < ApplicationController
  before_action :delete_t_ingredients, only: [:index]
  before_action :check_menu_processing, only: [:index]
  before_action :set_menu_processing, only: [:new, :edit]


  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
    @temp_ingredients = get_t_ingredients_for_user(current_user)
    save_menu_data_to_session(menu)
  end


  def new_confirm
    @menu = session[:menu_data]['menu']
    @temp_ingredients = get_t_ingredients_for_user(current_user)

    validate_and_set_original(menu)
    render_if_flash_present('new')
  end


  def create
    menu = Menu.new(menu_params)
    menu.save

    UserMenu.create(user: current_user, menu: menu)
    assign_and_save_t_ingredients(current_user, menu)

    session.delete(:new_menu_data)
    redirect_to_confirm_user_menu(current_user, menu)
  end


  def edit
    @menu = Menu.find(params[:id])

    # 既存データをtemp_ingredientsに移行
    move_ingredients_to_temp(@menu)
    @temp_ingredients = get_t_ingredients_for_user(current_user)

    save_menu_data_to_session(menu)
  end


  def edit_confirm
    @menu = session[:menu_data]['menu']
    @temp_ingredients = get_temp_ingredients_for_user(current_user)

    validate_menu(menu)
    render_if_flash_present('edit')
  end


  def update
    menu = Menu.find(params[:id])
    validate_and_render_or_set_original(menu)
    render_or_update_menu(menu, 'edit')

    assign_and_save_temp_ingredients(current_user, menu)

    redirect_to_confirm_user_menu(current_user, menu)
  end


  def destroy_related_data
    menu = Menu.find(params[:id])
    Ingredient.where(menu_id: menu.id).destroy_all
    UserMenu.where(menu_id: menu.id).destroy_all
    menu.destroy
    reset_menu_processing
    redirect_to user_menus_path(current_user)
  end


  def reset_session
    reset_menu_processing
    redirect_to user_menus_path(current_user)
  end


  private

  def delete_t_ingredients
    TempIngredient.where(user_id: current_user.id).delete_all
  end

  #献立登録時にブラウザの戻るボタンを押された場合の処理
  def check_menu_processing
    if set_menu_processing
      set_flash_notice("予期せぬエラーが発生しました。再度献立登録をしてください。")
      reset_menu_processing
    end
  end

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :original_menu, :image, :image_meta_data)
  end

  def set_menu_processing
    session[:menu_processing] = true
  end

  def reset_menu_processing
    session[:menu_processing] = false
  end

  def save_menu_data_to_session(menu)
    session[:menu_data] = {
      menu: menu.attributes
    }
  end

  def attach_default_menu_image(menu)
    menu_image = File.open('app/assets/images/default-menu-icon.png')
    menu.image.attach(io: menu_image, filename: 'default-menu-icon.jpg')
  end

  def validate_menu(menu)
    if menu.menu_name.blank?
      flash[:notice] = "献立名を登録してください。"
    elsif menu.menu_contents.blank?
      flash[:notice] = "献立内容を登録してください。"
    elsif menu.contents.blank?
      flash[:notice] = "献立の詳細を登録してください。"
    elsif menu.image.attached? == false
      attach_default_menu_image(menu)
    end
  end

  def validate_and_set_original(menu)
    validate_menu(menu)
    menu.original_menu = true
  end

  def render_if_flash_present(view)
    if flash[:notice].present?
      render view
    end
  end

  def render_or_update_menu(menu, view)
    if flash[:notice].present?
      render view
    else
      menu.update
    end
  end

  def assign_and_save_temp_ingredients(user, menu)
    ingredients = TempIngredient.where(user_id: user.id)
    ingredients.each do |ingredient|
      ingredient.menu_id = menu.id
      ingredient.save
    end
  end

  def redirect_to_confirm_user_menu(user, menu)
    redirect_to confirm_user_menu_path(user_id: current_user.id, id: menu.id)
  end

  def move_ingredients_to_temp(menu)
    ingredients = Ingredient.where(menu_id: @menu.id)
    ingredients.each do |ingredient|
      TempIngredient.create(name: ingredient.name, quantity: ingredient.quantity, unit: ingredient.unit, user_id: current_user.id)
    end
  end

  def get_t_ingredients_for_user(user)
    TempIngredient.where(user_id: user.id)
  end

end
