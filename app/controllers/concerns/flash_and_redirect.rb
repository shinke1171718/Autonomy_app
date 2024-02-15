module FlashAndRedirect

  # メッセージとリダイレクトパスを設定するメソッド
  def set_flash_and_redirect(flash_key, message, redirect_path)
    flash[flash_key] = message
    redirect_to redirect_path
  end
end
