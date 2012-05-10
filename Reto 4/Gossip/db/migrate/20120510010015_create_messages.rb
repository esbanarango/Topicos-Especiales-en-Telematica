class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.string :content, :null => false, :limit => 160
    	t.integer :user_id, :null => false
      t.integer :room_id, :null => false 
    	# Private attributes
    	t.integer :to
      

      t.timestamps
    end
  end
end
