class ServiciosController < ApplicationController

	def search
		queries = params[:query]

		@info = getInfo
		puts @info.inspect
		answers = []

		strings = queries.split 

		@info["data"].each do |string|
			strings.each do |query|
				if(string["string"] == query)
					answer = {count: string["count"], url: string["archivo"].to_s}
					answers << answer
				end
			end			
		end
		response = { answers: answers }

		respond_to do |format|
	      format.json { render json: response }
	    end
	end

end