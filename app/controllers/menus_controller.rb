class MenusController < ApplicationController

  def index
    menu_ids = UserMenu.where(user_id: current_user.id).pluck(:menu_id)
    @original_menus = Menu.where(id: menu_ids)
    @default_menus = Menu.where(original_menu: false)
  end


  def new
    @menu = Menu.new
  end


  def new_confirm
    flash[:notice] = nil

    validate_menu_params(menu_params)
    menu = Menu.new(menu_params)

    binding.pry
    # ingredients_params = params[:ingredient]
    # unless ingredients_params.nil?
    #   ingredients_params = params.require(:ingredient)
    #   # あとで修正が必要
    #   # ingredients = build_ingredients_from_params(ingredients_params)
    #   validate_ingredients_params(ingredients)
    # end

    if flash[:notice].present?
      # redirect_to new_user_menu_path
      render 'new', status: :unprocessable_entity
      return
    end

    render 'confirm', status: :unprocessable_entity
  end





  private

  def menu_params
    menu_params = params.require(:menu).permit(:menu_name, :menu_contents, :contents, :image, :image_meta_data)
  end

  def build_ingredients_from_params(ingredients_params)
    ingredients = []

    ingredients_params.each do |ingredient_param|
      ingredient = Ingredient.new(
        name: ingredient_param[:name],
        quantity: ingredient_param[:quantity],
        unit: ingredient_param[:unit]
      )
      ingredients << ingredient
    end

  end

  def validate_ingredients_params(ingredients)
    ingredients.each_with_index do |ingredient|

      if ingredient[:name].blank? || ingredient[:quantity].blank? ||
        (ingredient[:quantity].blank?) ||
        (ingredient[:name].length > 15) ||
        (ingredient[:unit].blank?)
        set_flash_notice("入力内容に不具合があります。")
      end

    end
  end

  def validate_menu_params(menu_params)
    if menu_params[:image].blank?
      default_image = Rails.root.join("app/assets/images/default-menu-icon.png")
      menu_params[:image] = { io: File.open(default_image), filename: "default-menu-icon.png" }
    end

    if menu_params["menu_name"].blank? || menu_params["menu_contents"].blank? || menu_params["contents"].blank?
      set_flash_notice("入力内容に不具合があります。")
    end

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
