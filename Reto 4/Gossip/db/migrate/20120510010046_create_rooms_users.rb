class CreateRoomsUsers < ActiveRecord::Migration
  def change
    create_table :rooms_users, :id => false do |t|
    	t.integer :user_id
      	t.integer :room_id
      t.timestamps
    end
  end
end
