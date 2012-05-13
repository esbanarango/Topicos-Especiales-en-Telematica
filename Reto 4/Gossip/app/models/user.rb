# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  username        :string(25)      not null
#  password_digest :string(255)     not null
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation
  attr_protected :user_id
  
  has_and_belongs_to_many :rooms

  has_many :messages, :dependent => :destroy

  has_secure_password

  validates :username, presence: true, length: { maximum: 25 },
  				uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save :truncated

  private

  # Longer username than 40 will be truncated
  def truncated
  	if self[:username].size > 25
  		self[:username] = self[:username][0..24]
	end
  end

end
