$('.work-spinner').css('visibility', 'hidden');
 $('input[name="environmentTypesRadio"]:radio').attr("disabled", false);
<% if @environments["error"].present? %>
  console.log('there is an error');
  $('.error-message').html("<%=j render "error" %>");
  $('.error-message-header').html("<h5>Ouch!! :O Unfortunately something went wrong.</h5>");
  $('.error-message-body').html("<%=j @environments["error"] %>");
<% else %>
  $(".alert").alert('close')
  $('.environmentsList').html("<%=j render "environments_list" %>");
  $(document).ready(loadEnvironmentDropdown);
<% end %>
