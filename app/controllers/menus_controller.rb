class MenusController < ApplicationController

  def index
    # menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    # @original_menus = Menu.where(id: menu_ids)
    # @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
  end