# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$(document).on "click",".parner", (e)->
		id = $(@).attr("id")
		$(@).find(".newMessages").hide().text(0)

		if $("#liUsers ##{id}").prev().is("#private_message_#{id}")
            element = $("#liUsers ##{id}").prev()
            $("#liUsers ##{id}").after(element)
   
		$("#private_message_#{id}").slideToggle()
		$("#private_message_#{id} .content").animate({ scrollTop: $("#private_message_#{id} .content").prop('scrollHeight')}, 1000)