module CartChecker

  def ensure_cart_is_not_empty
    if current_user_cart.nil? || current_user_cart.cart_items.empty?
      flash[:error] = "レシピを選択してください。"
      redirect_to root_path
    end
  end
end

