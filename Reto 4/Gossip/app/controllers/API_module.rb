module APIModule

	def createMessage(message)
			msg ="<li><span data-id='#{message.user_id}' class='bodyMessages'>#{User.find(message.user_id).username}:</span><span class='created_at'>#{message.created_at.strftime('%H:%M')}</span><div class='content'>#{message.content}</div></li>"
  			js = "$('#chat').append(\"#{msg}\");$('#messages-inner').animate({ scrollTop: $('#chat').prop('scrollHeight')}, 1000);"
	end

	def newUserEnter(user_id)
		js="$('#liUsers').append(\"<a id='#{user_id}' class='user_#{user_id}' title='Desktop User' ><i class='icon-user'></i>#{User.find(user_id).username}<i class='desktop'>Desktop</i></a>\");$('#num-users').text($('#liUsers a').size());"    
	end

	def userLeaves(user)
		js="var elems = $('a.user_#{user.id}').nextAll(), count = elems.length;
		
		  $('a.user_#{user.id}').each(function(){
			  	$(this).slideUp('fast',function(){
			  		$(this).remove();
			  		//Decrease the number of users in the room
			  		if (count==0) $('#num-users').text($('#liUsers a').size());
			  	});
			});
			"
		
	end

end