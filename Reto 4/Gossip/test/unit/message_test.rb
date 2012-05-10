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

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
