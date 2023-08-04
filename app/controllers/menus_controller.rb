class MenusController < ApplicationController

  def index
    #献立登録時にブラウザの戻るボタンを押された場合の処理
    if session[:menu_id].present?
      flash[:notice] = "予期せぬエラーで登録中のデータが誤って登録されました。修正/削除お願いします。"
      session[:menu_id] = nil
    end

    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
  end


  def create
    menu = Menu.new(menu_params)
    validate_menu_data(menu)
    render_if_flash_present('new')

    menu.original_menu = true
    menu.save
    UserMenu.create(user_id: current_user.id, menu_id: menu.id)

    # 新規登録時にmenuの編集を行う場合にviewを変更するために必要
    session[:menu_id] = menu.id
    redirect_to_new_ingredient(menu)
  end


  def edit
    @menu = Menu.find(params[:id])
    # 新規登録時の編集かどうかを判定するために設置しています。
    @new_menu = Menu.find_by(id: session[:menu_id])
  end


  def update
    menu = Menu.find(params[:id])
    validate_menu_data(menu)
    render_if_flash_present('edit')

    menu.update(menu_params)
    redirect_to_new_ingredient(menu)
  end


  def destroy_related_data
    menu = Menu.find(params[:id])
    Ingredient.where(menu_id: menu.id).destroy_all
    UserMenu.where(menu_id: menu.id).destroy_all
    menu.destroy
    session[:menu_id] = nil
    redirect_to user_menus_path(current_user)
  end


  def confirm
    @menu = Menu.find(params[:id])
    @ingredients = Ingredient.where(menu_id: @menu.id)
  end

  def reset_session
    session[:menu_id] = nil
    redirect_to user_menus_path(current_user)
  end


  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :original_menu, :image, :image_meta_data)
  end

  def validate_menu_data(menu)
    if menu.menu_name.blank?
      flash[:notice] = "献立名を登録してください。"
    elsif menu.menu_contents.blank?
      flash[:notice] = "献立内容を登録してください。"
    elsif menu.contents.blank?
      flash[:notice] = "献立の詳細を登録してください。"
    elsif menu.image.attached? == false
      menu_image = File.open('app/assets/images/default-menu-icon.png')
      menu.image.attach(io: menu_image, filename: 'default-menu-icon.jpg')
    end
  end

  def render_if_flash_present(view)
    if flash[:notice].present?
      render view
      return
    end
  end

  def redirect_to_new_ingredient(menu)
    redirect_to new_user_menu_ingredient_path(menu_id: menu.id)
  end

end
