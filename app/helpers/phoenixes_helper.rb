module PhoenixesHelper
  def owned? phoenix
    phoenix.owner == current_user
  end
end
