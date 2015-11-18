class SwitchToManyToMany < ActiveRecord::Migration
  def up
    add_column :phoenixes, :owner_id, :integer

    transaction do
      Phoenix.all.each do |phoenix|
        phoenix.update(owner_id: phoenix.user_id)
      end
    end

    remove_column :phoenixes, :user_id
    create_table :phoenixes_users do |t|
      t.column :user_id, :integer
      t.column :phoenix_id, :integer
    end

    transaction do
      Phoenix.all.each do |phoenix|
        phoenix.users << phoenix.owner
      end
    end
  end

  def down
    add_column :phoenixes, :user_id, :integer

    transaction do
      Phoenix.all.each do |phoenix|
        phoenix.update(user_id: phoenix.owner_id)
      end
    end

    remove_column :phoenixes, :owner_id

    drop_table :phoenixes_users
  end
end
