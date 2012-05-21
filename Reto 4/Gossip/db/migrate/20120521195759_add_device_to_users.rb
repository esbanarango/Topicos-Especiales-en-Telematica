class AddDeviceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device, :string, :default => "web"
  end
end
