class CreatePhoenixes < ActiveRecord::Migration
  def change
    create_table :phoenixes do |t|
      t.integer :droplet_id
      t.integer :image_id
      t.integer :floating_ip_id
      t.string :name

      t.timestamps null: false
    end
  end
end
