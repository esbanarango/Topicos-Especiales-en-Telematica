# == Schema Information
#
# Table name: rooms
#
#  id          :integer         not null, primary key
#  name        :string(255)     not null
#  description :text            not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Room < ActiveRecord::Base
	attr_accessible :name, :description

	has_and_belongs_to_many :users
  	
  	has_many :messages, :dependent => :destroy
  	accepts_nested_attributes_for :messages, :allow_destroy => true

  	validates :name, presence: true
  	validates :description, presence: true

end
