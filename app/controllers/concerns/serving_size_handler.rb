module ServingSizeHandler
  extend ActiveSupport::Concern

  included do
    before_action :set_serving_sizes, only: [:show, :change_serving_size]
  end

  def change_serving_size
    # リダイレクト時に必要なためパラメータからmenu_idを取得
    menu_id = params[:menu_id]

    # パラメータから増加または減少するかのタイプを取得
    change_type = params[:change_type]
    # settings.ymlから最小の提供サイズを取得
    min_serving_size = @settings.dig('limits', 'min_serving_size')

    # change_typeが'increase'の場合、提供サイズを1増やす
    if change_type == 'increase'
      @serving_size = [@serving_size + 1, @max_serving_size].min

    # change_typeが'decrease'の場合、提供サイズを1減らす
    elsif change_type == 'decrease'
      @serving_size = [@serving_size - 1, min_serving_size].max
    end

    # @is_pre_selectionがtrue（選択前）の場合、completed_menu_pathへリダイレクト
    if @is_pre_selection
      redirect_to user_menu_path(user_id: current_user.id, id: menu_id, serving_size: @serving_size, max_count: @max_serving_size, is_pre_selection: @is_pre_selection)
      return
    # @is_pre_selectionがfalse（選択後）の場合、user_menu_pathへリダイレクト
    else
      redirect_to completed_menu_path(menu_id: menu_id, serving_size: @serving_size, max_count: @max_serving_size, is_pre_selection: @is_pre_selection)
    end
  end

  private

  def set_serving_sizes
    # 買い出し前の献立にはそれぞれデフォルト値を設定
    # 買い出し後の献立にはそれぞれ「買い出しを完了した献立数を設定」
    @serving_size = params[:serving_size].present? ? params[:serving_size].to_i : @settings.dig('limits', 'default_serving_size')
    @max_serving_size = params[:max_count].present? ? params[:max_count].to_i : @settings.dig('limits', 'default_max_serving_size')

    # 初期の場合には@is_pre_selectionに「true」か「false」を設定
    # この設定はchange_serving_sizeアクションでリダイレクト先を判断する際に使用
    if params[:is_pre_selection].blank?
      # 両方のパラメータが存在する場合に @is_pre_selection をtrueに設定
      @is_pre_selection = params[:serving_size].blank? && params[:max_count].blank?
    else
      # パラメータが存在する場合に @is_pre_selection のデータ（「true」もしくは「false」)を適切な真偽値に変換
      @is_pre_selection = ActiveModel::Type::Boolean.new.cast(params[:is_pre_selection])
    end
  end

end
