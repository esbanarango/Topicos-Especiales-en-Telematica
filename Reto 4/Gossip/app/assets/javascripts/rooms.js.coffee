# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	#$( document ).on( "click", "#members li a", function( e ) {} );
	$(document).on "click",".parner", (e)->
		id = $(@).attr("id")
		$("#private_message_#{id}").slideToggle()