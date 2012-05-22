#Gossip Chat
========

"Gossip Chat is a bad-ass chat application, where you can find the hottest gossips around you. It was developed by some amazing and super talented guys at EAFIT University."

 ![PUSH](https://github.com/esbanarango/Topicos-Especiales-en-Telematica/blob/master/Reto%204/Gossip/app/assets/images/gossip.jpg?raw=true)

#Reto 4

>Diseño e implementación de un Chat con múltiples salas. Un usuario puede enviar mensajes a todos los miembros de una sala (por defecto) o a un usuario en particular en línea en el sistema. Se debe enviar mensajes sencillos de texto de máximo 160 caracteres (tipo twitter o SMS).

 **By:**
  
   * [Esteban Arango Medina](https://github.com/esbanarango)
   * [Daniel Duque Tirado](https://github.com/DanielJDuque)
   * [Sebastian Duque Jaramillo](https://github.com/sduquej)

##Description

This is _simple_ web chat application which we wanted to made as nice as we could. The basic idea behind scenes is a real-time ( publish and subscribe) application where you will be able to use from a web browser as well as from a desktop program.

##Requirements
This app was entirely made using Ruby (_1.9.>_) and Ruby on Rails, so you must have installed Ruby and Rails in your machine. Please go to these sites, there you'll find a nice guides to install both.

 [RVM](https://rvm.io//) Ruby Version Manager

 [Rails Guides](http://guides.rubyonrails.org/getting_started.html)

>We recommend to run it on Linux or Mac OS. Rails run extremely slow on Windows (Actually we should say that _Windows runs Rails extremely slow_:P).

##Setup

The app needs to run two servers. 
First, make sure you run `$ bundle install` to install all the dependencies. Then, setup the database running `$ rake db:migrate` and  fill it up running `$ rake db:seed`.

Now you'll be able to run `$ rails s`, to start the rails server, and  now you can start up that Rack server by running `$ rackup private_pub.ru -s thin -E production`.

#####Linux Note.
If you're on Linux, there is a _problem_ with the ports when you start up the Rack server, so you'll have to change the _private_pub.yml_ file. on:

```yaml
development:
  server: "http://localhost:9292/faye"
  secret_token: "secret"
```
Change the port `9292` to `8000` (or whatever you want.), and then start up the Rack server with `$ rackup private_pub.ru -s thin -p 8000 -E production`. (You'll also need to restar the Rails sever in order to get the changes made on _private_pub.yml_)

####Web
Now you can go to `http://localhost:3000` and enjoy it :).

####Desktop
Being on the _Gossip Thick_ folder (`$ cd Gossip\ Thick/`), run `$ ruby GossipServer.rb ` and you can enjoy it too from you favorite console :).

##Resources

* [Private Pub](https://github.com/ryanb/private_pub)
	* For all the real-time interactions.
* [CanCan](https://github.com/ryanb/cancan)
	* Admin permissions and users abilities
* [Bootstrap, from Twitter](http://twitter.github.com/bootstrap/) with [Twitter Bootstrap for Rails](https://github.com/seyhunak/twitter-bootstrap-rails)
	* Site style, and responsive design

##References

[RailsCasts](http://railscasts.com/) was really helpful, thanks Ryan :P.

Room chat design taken from [Liam Kaufman](http://liamkaufman.com/)