=begin
	Archivo: xmlHandler.rb
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Sebastian Duque Jaramillo
			Daniel Julian Duque Tirado
=end
module XmlHandler
	def guardarInfo()
		clientesGuardar = {}
		builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
		    xml.data {
		      xml.canales {
			      @canales.each do |k,v|
			      	xml.canal k
			      end
		      }
		      xml.mensajesCanales{
			      @canales.each do |k,v|
				      xml.mensajes(:canal => k){
					      v[0].each do |mensaje|
						      xml.mensaje mensaje
						  end
						}
			        end
		      }
		      xml.clientes{
			      @canales.each do |k,v|
			      		v[1].each do |cliente|
			      			if clientesGuardar.include?(cliente)
			      				clientesGuardar[cliente].push(k)
			      			else
			      				clientesGuardar[cliente] = []
			      				clientesGuardar[cliente].push(k)
			      			end
			      		end
				    end
				   clientesGuardar.each do |k,v|
				   		xml.cliente(:nombre => k){
				   			v.each do |canal|
				   				xml.canal canal
				   			end
				      	}
					end	
		      }
		    }
		  end
		aFile = File.new("Persistence/data.xml", "w")
		aFile.write(builder.to_xml)
		aFile.close
	end

	def cargarInfoXML(op)
		case op
	   		when "canales"
		   		@doc.xpath('/data//canales/canal/text()').each do |canal|	
					@canales[canal.to_s] = [[],[]]			# Array con los dos arrays [[mensajes],[clientes]]
			  	end#do
			when "mensajes"
				@canales.each do |k,v|
				  @doc.xpath('/data//mensajesCanales/mensajes[@canal="'+k+'"]/mensaje/text()').each do |mensaje|	
						v[0].push(mensaje.to_s)
				  end#do
				end#do
			when "clientes"
				@doc.xpath('/data//clientes/cliente/@nombre').each do |nombreCliente|	
					doc.xpath('/data//clientes/cliente[@nombre="'+nombreCliente+'"]/canal/text()').each do |canal|	
						#@usuarios[data].push(canal.to_s)
						if @canales.has_key?(canal.to_s) 
							@canales[canal.to_s][1].push(nombreCliente.to_s)
						end
					end#do
				end#do
		end
	end

end