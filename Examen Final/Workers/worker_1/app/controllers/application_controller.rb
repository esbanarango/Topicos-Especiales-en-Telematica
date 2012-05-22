class ApplicationController < ActionController::Base
  protect_from_forgery


  helper_method :getInfo

  private

  def getInfo
  	info = {}
  	@doc = Nokogiri::XML File.open File.expand_path("../../../config/Worker1.xml", __FILE__)
  	info["url"]=@doc.xpath('/worker/url/text()').to_s
  	data = []
  	@doc.xpath('/worker/data/string').each do |string|	
  		s = {}
  		s["string"]=string.xpath('text()').to_s
  		s["count"]=string['count']
  		s["archivo"]=string['archivo']
  		data << s
  	end#do
  	info["data"] = data
  	
  	return info
  end

end
