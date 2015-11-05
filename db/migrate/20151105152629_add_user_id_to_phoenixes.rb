class AddUserIdToPhoenixes < ActiveRecord::Migration
  def change
    add_column :phoenixes, :user_id, :integer
  end
end
