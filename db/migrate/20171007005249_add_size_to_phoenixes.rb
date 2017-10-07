class AddSizeToPhoenixes < ActiveRecord::Migration
  def up
    add_column :phoenixes, :size, :string
    Phoenix.update_all(size: '2gb')
    change_column_null :phoenixes, :size, false
  end

  def down
    remove_column :phoenixes, :size
  end
end
