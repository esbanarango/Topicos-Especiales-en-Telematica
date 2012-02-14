require 'nokogiri'
doc = Nokogiri::XML File.open 'data.xml'
puts doc.xpath('/data//mensajesCanales/mensajes/mensaje/text()')