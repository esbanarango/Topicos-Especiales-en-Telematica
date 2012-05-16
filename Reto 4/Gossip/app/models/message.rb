# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  content    :string(160)     not null
#  user_id    :integer         not null
#  room_id    :integer         not null
#  to         :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Message < ActiveRecord::Base
  attr_accessible :content, :room_id, :user_id, :to
  before_save :truncated

  private
  # Longer username than 40 will be truncated
	def truncated
		if self[:content].size > 160
			self[:content] = self[:content][0..159]
		end
	end
end
