#Búsquedas en Texto Completo Distribuidas
========

**By:**
  
   * [Esteban Arango Medina](https://github.com/esbanarango)

##Estructura

Se cuenta con dos apliacaciónes de Rails `servidor_integrador` y `worker`.

	|-- Examen Final
		|-- servidor_integrador
		`-- Workers
		    `-- worker

##Requerimientos

Se debe tener instalado Ruby 1.9.> y Rails 3.2.>.

Antes de ejecutar cualquiera de los dos proyectos, se debe correr en la consola `$ bundle install` para cada uno de los dos proyectos. Con el fin de instalar las dependencias y gemas necesarias.

##Ejecución

Primero se deben generar los n Workers que se deseen, para esto se lanzan n instancias del proyecto _worker_, cada una de estas por diferente puerto. (Se debe estár ubicado en la carpeta _worker_ `$ cd Workers/worker`)

	$ rails s -p 8080
	$ rails s -p 8081
	$ rails s -p 8082


Estos puertos debe coincidir con el archivo _dsearch.xml_

    <?xml version=”1.0”> 
    	<workers>
	    	<worker>http://localhost:8080/</worker> 
	    	<worker>http://localhost:8081/</worker> 
			<worker>http://localhost:8082/</worker> 
    	</workers>

Este archivo se encuentra en:
	
	|-- servidor_integrador
		`-- config
		    `-- dsearch.xml

Al tener los workers corriendo se puede lanzar la app *servidor_integrador*, `$ rails s`

##Interacción

La aplicación web del Integrador es accedida por: 
`http://localhost:3000/WebDSearch`

El Web Service del Integrador es accedido por: 
`http://localhost:3000/WSS_DSearch.json?q=java`

Este último responde con un JSON con la siguiente estructura:
```json
{
	"question":"java",
	"answers":[
		{"count":"10","url":"http://localhost:8080/datos/doc1.html"},
		{"count":"34","url":"http://localhost:8080/datos/doc3.pdf"}
	]
}
```

####Ejemplo interacción
 ![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Examen%20Final/Screenshots/exam.png?raw=true)

