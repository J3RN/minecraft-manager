class AddSshKeyIdToPhoenixes < ActiveRecord::Migration
  def change
    add_column :phoenixes, :ssh_key_id, :integer
  end
end
