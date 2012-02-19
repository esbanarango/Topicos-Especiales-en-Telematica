#Servicio de anuncios distribuido
========
Implementación de un sistema de anuncios (advertisement) que permite a un conjunto de clientes
obtener mensajes de anuncios de productos o servicios. El sistema tiene dos módulos principales:
Proveedor de anuncios (AdFuente), es decir, es desde donde se generan los mensajes y un Cliente de
anuncios (AdCliente), el cual recibe los mensajes enviados a un Canal por un AdFuente.

###Reto 1

  **Por:**
  
   * [Esteban Arango Medina](https://github.com/esbanarango)
   * [Daniel Duque Tirado](https://github.com/DanielJDuque)
   * [Sebastian Duque Jaramillo](https://github.com/sduquej)

Requisitos & Instalación
----
Se debe tener instalado Ruby 1.9. (Ruby 1.8 no soporta funciones como 'tcp_server_loop' entre otras.)

### Mac OS y Unix
 Basta con instalar '[Nokogiri](http://nokogiri.org/)' para la manipulación de archivos XML
 
    $ gem install nokogiri

### Windows
 En Windows se debe instalar 'win32Console' para poder visualizar los colores en la terminal, al igual que 'Nokogiri' para la manipulación de los archivos XML
 
    $ gem install win32console
    $ gem install nokogiri
 Si no se tiene Ruby instalado, recomendos el siguiente link [Ruby Installer for Windows](http://rubyinstaller.org/)