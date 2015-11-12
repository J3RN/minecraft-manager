class ChangePhoenixFloatingIpToString < ActiveRecord::Migration
  def up
    rename_column :phoenixes, :floating_ip_id, :floating_ip
    change_column :phoenixes, :floating_ip, :string
  end

  def down
    remove_column :phoenixes, :floating_ip
    add_column :phoenixes, :floating_ip_id, :integer
  end
end
