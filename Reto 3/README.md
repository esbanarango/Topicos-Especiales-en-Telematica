#Servicio de presencia
========
Implementación de un servicio de presencia (estilo mensajería instantánea) con un chat sencillo. El servicio de presencia consiste en conocer el estado de mis contactos o de los miembros de la red basado en grupos. El estado se refiere a: _contectado_, _desconectado_, _ocupado_. (utiliza mecanismos similares a messager o skype). El segundo servicio consiste en un chat sencillo con los usuarios en línea.

###Reto 3

 **Por:**
  
   * [Esteban Arango Medina](https://github.com/esbanarango)
   * [Daniel Duque Tirado](https://github.com/DanielJDuque)
   * [Sebastian Duque Jaramillo](https://github.com/sduquej)

##Ejecución

En la carpeta _Reto3_ hay 2 archivos ejecuatables, _ClientChat.rb_ y _ServerChat.rb_. El primer archivo que se debe ejecutar
es _ServerChat.rb_, especificando el puerto que se desea utilizar `$ ruby ServerChat.rb 5555`.

Teniendo en ejecución el servidor podemos correr _ClientChat.rb_ el número de veces (clientes) que se desee. Para esto se debe especificar la ip del servidor al igual que el puerto. `$ ruby ClientChat.rb localhost 5555`.
