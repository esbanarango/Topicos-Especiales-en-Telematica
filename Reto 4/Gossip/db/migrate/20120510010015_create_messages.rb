class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.string :content, :null => false, :limit => 160
    	t.integer :user_id, :null => false

    	# Single Table Inheritance Attributes
    	t.string :type, :null => false

    	# Private attributes
    	t.integer :to, :unique => true

      t.timestamps
    end
  end
end
