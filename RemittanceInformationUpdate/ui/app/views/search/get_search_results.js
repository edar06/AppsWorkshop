$('.btn-search').removeClass('disabled');
$('.btn-environments').removeClass('disabled');
$('.work-spinner').css('visibility', 'hidden');
$('input[name="environmentTypesRadio"]:radio').attr("disabled", false);
<% if @searchResults["error"].present? %>
  console.log('there is an error');
  $('.error-message').html("<%=j render "error" %>");    
  $('.error-message-header').html("<h5>Ouch!! :O Unfortunately something went wrong.</h5>");
  $('.error-message-body').html("<%=j @searchResults["error"] %>");
<% else %>
  <% if !@searchResults["searchResults"].present? %>
    $('.error-message').html("<%=j render "error" %>");
    $('.error-message-body').html("We could not find any matches for what you were looking for. Please refine your research.");
  <% else %>
    $(".alert").alert('close')
    $('.search-results').fadeOut(function(){
      $('.search-results').html("<%=j render "search_results" %>");
      $(document).ready(loadTooltipPopover);
    });
    $('.search-results').fadeIn();
  <% end %>
<% end %>
