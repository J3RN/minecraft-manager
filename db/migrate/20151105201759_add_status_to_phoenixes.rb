class AddStatusToPhoenixes < ActiveRecord::Migration
  def change
    add_column :phoenixes, :status, :string
  end
end
