module MessageModule

	def createMessage(message)
			msg ="<li><span data-id='#{message.user_id}' class='bodyMessages'>#{User.find(message.user_id).username}:</span><span class='created_at'>#{message.created_at.strftime('%H:%M')}</span><div class='content'>#{message.content}</div></li>"
  			js = "$('#chat').append(\"#{msg}\");$('#messages-inner').animate({ scrollTop: $('#chat').prop('scrollHeight')}, 1000);"		  

	end

end