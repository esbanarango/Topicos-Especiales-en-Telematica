#Servicio de presencia
========
Implementación de un servicio de presencia (estilo mensajería instantánea) con un chat sencillo. El servicio de presencia consiste en conocer el estado de mis contactos o de los miembros de la red basado en grupos. El estado se refiere a: _contectado_, _desconectado_, _ocupado_. (utiliza mecanismos similares a messager o skype). El segundo servicio consiste en un chat sencillo con los usuarios en línea.

###Reto 3
Para la implementación de este reto utilizamos Drb ([Distributed object system for Ruby](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/drb/rdoc/DRb.html)) en todo el manejo de Invocación remota de métodos; Drb facilita muchisimo la codificación de programas distribuidos al igual que se cuenta con muy buen material de apoyo ([tutoriales](http://segment7.net/projects/ruby/drb/introduction.html) y api's).

#####Ejemplo.
```ruby
	#Creo la uri Drb (ej. druby://localhost:8787) y me expongo
	DRb.start_service nil, self 

	#Obtengo un objeto que está expuesto en la uri especificada
	DRbObject.new nil, uri 
```


 **Por:**
  
   * [Esteban Arango Medina](https://github.com/esbanarango)
   * [Daniel Duque Tirado](https://github.com/DanielJDuque)
   * [Sebastian Duque Jaramillo](https://github.com/sduquej)

##Requisitos & Instalación

Se debe tener instalado Ruby 1.9. (Ruby 1.8 no soporta funciones como 'tcp_server_loop' entre otras.)

#### Windows
 En Windows se debe instalar la gema _win32Console_ para poder visualizar los colores en la terminal.
 
    $ gem install win32console

 Si no se tiene Ruby instalado, recomendos el siguiente link [Ruby Installer for Windows](http://rubyinstaller.org/)

##Ejecución

En la carpeta _Reto3_ hay 2 archivos ejecuatables, _ClientChat.rb_ y _ServerChat.rb_. El primer archivo que se debe ejecutar
es _ServerChat.rb_, especificando el puerto que se desea utilizar `$ ruby ServerChat.rb 5555`.

Teniendo en ejecución el servidor podemos correr _ClientChat.rb_ el número de veces (clientes) que se desee. Para esto se debe especificar la ip del servidor al igual que el puerto. `$ ruby ClientChat.rb localhost 5555`.

######Server Running:
Durante toda la ejecución de la aplicación, en el servidor se podrá ver la actividad de los usuarios.

	![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%203/Docs/Screenshots/servidorRunning.png?raw=true)

######Users interactions:

	![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%203/Docs/Screenshots/userHelp.jpg?raw=true)
	![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%203/Docs/Screenshots/listUsers.jpg?raw=true)
	![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%203/Docs/Screenshots/chatting.jpg?raw=true)

######Offline messages, *Plus*:

>"Plus1: si los usuarios NO están conectados, puede implementar una entrega de mensajes offline, es decir, almacenará los mensajes, hasta >que el usuario se conecte de nuevo."

	![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%203/Docs/Screenshots/offlineMessages.jpg?raw=true)
	![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%203/Docs/Screenshots/offlineMessages-2.jpg?raw=true)

Recepción de los mensajes offline cuando el usuario vuelve a estado _Online_

	![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%203/Docs/Screenshots/offlinemessagesShow.jpg?raw=true)

