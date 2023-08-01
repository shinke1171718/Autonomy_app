class MenusController < ApplicationController

  def index
    @original_menus = Menu.where(original_menu: true)
    @default_menus = Menu.where(original_menu: false)
  end

  def new
    @menu = Menu.new
  end

  def create
    menu = Menu.new(menu_params)

    if menu.menu_name.blank?
      flash[:notice] = "献立名を登録してください。"
      render 'new'
      return
    end

    if menu.menu_contents.blank?
      flash[:notice] = "献立内容を登録してください。"
      render 'new'
      return
    end

    if menu.contents.blank?
      flash[:notice] = "献立の詳細を登録してください。"
      render 'new'
      return
    end

    if menu.image.attached? == false
      menu_image = File.open('app/assets/images/default-menu-icon.png')
      menu.image.attach(io: menu_image, filename: 'default-menu-icon.jpg')
    end

    menu.original_menu = true

    menu.save

    redirect_to new_user_menu_ingredient_path(menu_id: menu.id)
  end


  private

  def menu_params
    params.require(:menu).permit(:menu_name, :menu_contents, :contents, :original_menu, :image, :image_meta_data)
  end
end
