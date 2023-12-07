module MenusHelper

  # display_quantity メソッドは、与えられた quantity（数量）が小数点以下が0である場合（つまり実質的に整数である場合）に整数として表示するためのメソッドです。
  # これにより、ユーザーインターフェイス上での数値の表示が、必要に応じて整数または小数として適切に行われます。
  # 例えば、1.0は1として、1.5は1.5のままとして表示されます。
  def display_quantity(quantity)
    quantity.to_f == quantity.to_i ? quantity.to_i : quantity
  end

end
