class StaticPagesController < ApplicationController

	def home

	end

	def error
		render :layout => "error_layout"
	end

end
