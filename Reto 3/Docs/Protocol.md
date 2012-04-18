Una conexión TCP a través de un socket comienza la comunicación, el cliente se identifica con el exponiendo un objeto y su información, servidor envía una respuesta preguntando por el nickname del usuario, y después de que el cliente ingrese su nickname, la interacción y las peticiones se soportarán en la siguiente expresión regular:

{(?(?i)LIST USERS|CHAT|QUIT CONVERSATION|QUIT) ?(?\(.{1,}\))?}

El contenido que el cliente envía contiene un match (aceptación) de esta expresión.

Posibilidades:
a)	LIST USERS: Este mensaje indica al servidor que el cliente solicita el estado de los usuarios existentes en la aplicación.

Respuesta del servidor: El servidor despliega en el cliente todos los usuarios agrupados según su estado (online, busy, offline):


b)	CHAT (USER): Este mensaje indica al servidor que el cliente desea enviar mensajes a otro cliente especificado. El servidor envía la URI del usuario especificado,  con el fin de poder realizar la conexión peer-to-peer y comunicarse.  Todo esto es transparente para el cliente que ejecuto el comando.

Respuesta del servidor: El servidor brinda la información del cliente solicitada al cliente solicitante. 
En la lógica del cliente (sin participación del servidor) se genera la conexión a partir de esta información. Mensajes de información y confirmación son desplegados en ambos peer’s que están siendo conectados.

En el peer en el cual ha llegado la petición se despliega un mensaje que permite aceptar o rechazar la invitación:

“User [username] wants to chat with you?  Would you like too?(Y/N)”

Y en el peer que solicita la conexión se despliega:

“Waiting for [username] responses..."

Cuando la invitación es aceptada, comienza la comunicación libre entre los peer’s. El mensaje siguiente es desplegado:

"Your now connected with [username]."

Otros mensajes que pueden ser desplegados en el usuario solicitante son:

•	"User [username] does not want to chat with you."
•	"User [username] is busy at this moment, you may interrupt."
•	"User [username] is offline at this moment. Would you like to leave a message?(Y/N)" Si el usuario escoge Y, lo siguiente que escribiráw será el mensaje.
•	“User [username] does not exist!”

c)	-QUIT CONVERSATION: Este mensaje cierra la conversación entre dos ClientChat, actualizando el estado en el servidor de cada peer involucrado en disponible y terminando la conexión que existía entre estos.

Respuesta del servidor:

"You have just left your last conversation."

d)	QUIT: Este mensaje desconecta el cliente de la aplicación, detiene la ejecución. Debe hacerse por fuera de una conversación, primero se deberá cerrar la conversación activa, si esta existe.


Respuesta del servidor:

"Good Bye! ☺."
