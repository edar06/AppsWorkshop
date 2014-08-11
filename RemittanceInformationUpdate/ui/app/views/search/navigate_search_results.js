<% if @searchResults["error"].present? %>
  console.log('there is an error');
  $('.error-message').html("<%=j render "error" %>");    
  $('.error-message-header').html("<h5>Ouch!! :O Unfortunately something went wrong.</h5>");
  $('.error-message-body').html("<%=j @searchResults["error"] %>");
<% else %>
  <% case @type %>
  <% when "1" %>
    $('.<%= @status %>').html("<%=j render partial: 'freight_bill_search_results', :locals => {:k => @status, :v => @page, :type => @type} %>");
  <% when "2" %>
    $('.<%= @status %>').html("<%=j render partial: 'invoice_bill_search_results', :locals => {:k => @status, :v => @page, :type => @type} %>");
  <% end %>
  $(document).ready(loadTooltipPopover);
<% end %>

