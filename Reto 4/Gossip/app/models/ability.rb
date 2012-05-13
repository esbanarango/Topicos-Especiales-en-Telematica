class Ability
	include CanCan::Ability
  

	def initialize(user)
		user ||= User.new
		if user.admin
			can :manage, :all
		else
			can :read, :all
			can :create, Message
			can :create, User
			can :update, User do |_user|
				_user == user
			end
		end

	end
	
	
end