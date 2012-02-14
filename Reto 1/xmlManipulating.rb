require 'nokogiri'
doc = Nokogiri::XML File.open 'data.xml'

canales =  Array::new

doc.xpath('//canales/canal/text()').each do |canal|
	canales.push(canal)
end

puts canales.inspect
