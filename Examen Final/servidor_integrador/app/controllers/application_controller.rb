class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :getWorkers
  helper_method :getData
  helper_method :postData

  require 'net/http'

  private

  def getWorkers
  	@workers = []
  	@doc = Nokogiri::XML File.open File.expand_path("../../../config/dsearch.xml"	, __FILE__)
  	@doc.xpath('/workers/worker/text()').each do |worker|	
		  @workers << worker.to_s			# Array con los workers
  	end#do
  	return @workers
  end

  def initServer(uri)
    @serverUri = URI(uri)
    @http = Net::HTTP.new(@serverUri.host, @serverUri.port)
  end

  def getData(path,data,json)
    request = Net::HTTP::Get.new(path+((json) ? ".json" : ""))
    if !data.empty?
      request.set_form_data(data)
    end
    response = @http.request(request)
    JSON.parse(response.body)
  end

  def postData(path,data,json)
    request = Net::HTTP::Post.new(path+((json) ? ".json" : ""))
    request.set_form_data(data)
    response = @http.request(request)
    #puts "Si sera el post:"+JSON.parse(response.body).inspect
    JSON.parse(response.body)
  end


end
