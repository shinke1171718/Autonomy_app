class MenusController < ApplicationController
  before_action :delete_menu_session, only: [:index]
  before_action :delete_flash, only: [:new_confirm]


  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
  end


  def new_confirm
    if session[:menu].nil? && session[:temp_ingredients].nil?
      session[:menu] = menu_params
      session[:temp_ingredients] = []
    end

    # renderを行なった際に「フォームの属性キー」を付与するため@menuにデータを格納
    @menu = Menu.new(menu_params)
    # menuデータを更新
    update_session_menu_data(menu_params, menu_image_params)

    # 追加ボタンを押された処理
    if params[:ingredient] == "追加"

      new_ingredient = ingredient_params
      temp_ingredients = session[:temp_ingredients]
      validate_new_ingredient(temp_ingredients, new_ingredient)

      if flash[:notice].present?
        redirect_to new_user_menu_path(current_user)
        return
      end

      if temp_ingredients.nil?
        temp_ingredients = new_ingredient
      else
        temp_ingredients << new_ingredient
      end

      flash[:notice] = '食材が追加されました'
      session[:temp_ingredients] = temp_ingredients

      redirect_to new_user_menu_path(current_user)
      return
    end


    # 削除ボタンを押された処理
    if params[:delete] == "✖️"
      ingredient_name = params[:ingredient][:name]
      session[:temp_ingredients].reject! { |ingredient| ingredient["name"] == ingredient_name }
      set_flash_notice("食材を削除しました。")
      redirect_to new_user_menu_path(current_user)
    end


    # 次へボタンを押された処理
    if params[:create] == "次へ"

      validate_menu(menu_params, menu_image_params)

      if flash[:notice].present?
        render 'new'
        return
      end

      binding.pry
      render 'confirm'
    end

  end


  def create
    # extract_image_data_from_session(session[:menu_image])
    binding.pry
    save_menu_with_image(session[:menu], session[:menu_image])
    binding.pry
    UserMenu.create(user: current_user, menu: menu)
    create_ingredients(menu, session[:temp_ingredients])
    binding.pry
    redirect_to user_menus_path(current_user)
  end


  # def edit
  #   @menu = Menu.find(params[:id])

  #   # 既存データをtemp_ingredientsに移行
  #   move_ingredients_to_temp(@menu)
  #   @temp_ingredients = get_t_ingredients_for_user(current_user)

  #   save_menu_data_to_session(menu)
  # end


  # def edit_confirm
  #   @menu = session[:menu_data]['menu']
  #   @temp_ingredients = get_temp_ingredients_for_user(current_user)

  #   validate_menu(menu)
  #   render_if_flash_present('edit')
  # end


  # def update
  #   menu = Menu.find(params[:id])
  #   validate_and_render_or_set_original(menu)
  #   render_or_update_menu(menu, 'edit')

  #   assign_and_save_temp_ingredients(current_user, menu)

  #   redirect_to_confirm_user_menu(current_user, menu)
  # end


  # def destroy_related_data
  #   menu = Menu.find(params[:id])
  #   Ingredient.where(menu_id: menu.id).destroy_all
  #   UserMenu.where(menu_id: menu.id).destroy_all
  #   menu.destroy
  #   reset_menu_processing
  #   redirect_to user_menus_path(current_user)
  # end


  def reset_session
    reset_menu_processing
    redirect_to user_menus_path(current_user)
  end


  private

  def ingredient_params
    ingredient_params = params.require(:menu).require(:ingredients).permit(:name, :quantity, :unit)
  end

  def menu_params
    # menu_params = params.require(:menu).permit(:menu_name, :menu_contents, :contents, :original_menu, :image, :image_meta_data)
    menu_params = params.require(:menu).permit(:menu_name, :menu_contents, :contents)
  end

  def menu_image_params
    menu_image_params = params.require(:menu).permit(:image, :image_meta_data)
  end


  def delete_menu_session
    session[:temp_ingredients] = nil
    session[:menu] = nil
    session[:menu_image] = nil
  end

  def delete_flash
    flash[:notice] = nil
  end

  # def save_menu_data_to_session(menu)
  #   session[:menu_data] = {
  #     menu: menu.attributes
  #   }
  # end

  def attach_default_menu_image(menu)
    menu_image = File.open('app/assets/images/default-menu-icon.png')
    # menu[:image].attach(io: menu_image, filename: 'default-menu-icon.jpg')
    session[:menu_image] = menu_image
  end

  def validate_menu(menu, menu_image)
    if menu["menu_name"].blank?
      set_flash_notice("献立名を登録してください。")
    elsif menu["menu_contents"].blank?
      set_flash_notice("献立内容を登録してください。")
    elsif menu["contents"].blank?
      set_flash_notice("献立の詳細を登録してください。")
    elsif menu_image["image"].blank?
      attach_default_menu_image(menu)
    end
  end

  # def validate_temp_ingredient(existing_date, new_date)
  #   matching_ingredient = existing_date.find { |ingredient| ingredient["name"] == new_date["name"] }

  #   unless matching_ingredient.nil?
  #     flash[:notice] = '同じ名前の食材がすでに存在します。'
  #   end
  # end

  def validate_new_ingredient(existing_date, new_date)

    unless existing_date.nil?
      matching_ingredient = existing_date.find { |ingredient| ingredient["name"] == new_date["name"] } || nil
    end

    if new_date["name"].blank?
      set_flash_notice("食材名を登録してください。")
    elsif new_date["quantity"].blank?
      set_flash_notice("数量を登録してください。")
    elsif !new_date["quantity"].to_i.positive?
      set_flash_notice("数量は数値で入力してください。")
    elsif new_date["unit"].blank?
      set_flash_notice("単位を登録してください。")
    elsif !matching_ingredient.nil?
      set_flash_notice("同じ名前の食材がすでに存在します。")
    end
  end

  # def validate_and_set_original(menu)
  #   validate_menu(menu)
  #   menu.original_menu = true
  # end

  def redirect_to_if_flash_present(path)
    if flash[:notice].present?
      redirect_to path
    end
  end

  def render_if_flash_present(view)
    if flash[:notice].present?
      render view
    end
  end

  # def render_or_update_menu(menu, view)
  #   if flash[:notice].present?
  #     render view
  #     return
  #   else
  #     menu.update
  #   end
  # end

  # def assign_and_save_temp_ingredients(user, menu)
  #   ingredients = TempIngredient.where(user_id: user.id)
  #   ingredients.each do |ingredient|
  #     ingredient.menu_id = menu.id
  #     ingredient.save
  #   end
  # end

  def redirect_to_confirm_user_menu(user, menu)
    redirect_to confirm_user_menu_path(user_id: current_user.id, id: menu.id)
  end

  # def move_ingredients_to_temp(menu)
  #   ingredients = Ingredient.where(menu_id: @menu.id)
  #   ingredients.each do |ingredient|
  #     TempIngredient.create(name: ingredient.name, quantity: ingredient.quantity, unit: ingredient.unit, user_id: current_user.id)
  #   end
  # end

  # def get_t_ingredients_for_user(user)
  #   TempIngredient.where(user_id: user.id)
  # end

  def save_menu_with_image(menu_data, menu_image)
    menu = Menu.new

    menu.menu_name = menu_data["menu_name"]
    menu.menu_contents = menu_data["menu_contents"]
    menu.contents = menu_data["contents"]
    menu.original_menu = true
    menu.image.attach(io: File.open(menu_image["tempfile"]), filename: menu_image["original_filename"], content_type: menu_image["content_type"])

    menu.save

    # 一時保存したデータを削除
    if File.exist?(temp_file_path)
      File.delete(temp_file_path)
    end
  end

  def create_ingredients(menu, ingredients_data)
    ingredients_data.each do |ingredient_data|
      ingredient = Ingredient.new(
        name: ingredient_data["name"],
        quantity: ingredient_data["quantity"],
        unit: ingredient_data["unit"],
        menu_id: menu.id
      )
      ingredient.save
    end
  end

  # def extract_image_data_from_session(menu_image)
  #   if menu_image.present?
  #     tempfile_path = menu_image["tempfile"]
  #     binding.pry
  #     @image_data_view = File.read(tempfile_path)
  #     @image_data = File.open(tempfile_path, "rb")
  #     @content_type = menu_image["content_type"]
  #     @original_filename = menu_image["original_filename"]
  #   end
  # end

  def update_session_menu_data(menu_params, menu_image_params)
    session[:menu] = menu_params
    unless menu_image_params.blank?
      # 一時ファイルを保存するディレクトリのパスを構築
      tmp_dir = Rails.root.join('tmp')

      # 指定されたディレクトリが存在しない場合にそのディレクトリを作成する
      unless File.directory?(tmp_dir)
        FileUtils.mkdir_p(tmp_dir)
      end

      # 一意のファイル名を生成
      temp_filename = "#{SecureRandom.hex}.jpg"

      # 一時ファイルのフルパスを構築
      temp_file_path = File.join(tmp_dir, temp_filename)

      # 画像データを一時ファイルに保存
      File.open(temp_file_path, 'wb') do |file|
        file.write(menu_image_params["image"].read)
      end

      session[:menu_image] = {
        "tempfile" => temp_file_path,
        "content_type" => menu_image_params["image"].content_type,
        "original_filename" => menu_image_params["image"].original_filename
      }
    end
  end

end
