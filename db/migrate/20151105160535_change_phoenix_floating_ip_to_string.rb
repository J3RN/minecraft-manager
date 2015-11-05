class ChangePhoenixFloatingIpToString < ActiveRecord::Migration
  def change
    rename_column :phoenixes, :floating_ip_id, :floating_ip
    change_column :phoenixes, :floating_ip, :string
  end
end
