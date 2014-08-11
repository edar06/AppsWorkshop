$(document).ready(function() {

  var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;

  if (is_chrome) {
    $('.radio-type').css( { marginBottom : "-15px" } );
  }

  $('input[name="environmentTypesRadio"]:radio').change(function(event){
    $('.work-spinner').css('visibility', 'visible');
    $('input[name="environmentTypesRadio"]:radio').attr("disabled", true);
    if (!$('.btn-search').hasClass('disabled')){
      $('.btn-search').addClass('disabled');
    };
    envTypes(event);
  });

  $('.btn-clear').click(function(event){
    $('.input-text').val('');
    $('.btn-search').addClass('disabled');
  });

  $('.btn-search').click(function(event){
    $('.work-spinner').css('visibility', 'visible');
    $('input[name="environmentTypesRadio"]:radio').attr("disabled", true);
    $('.btn-environments').addClass('disabled');
    searchResults(event);
  });

  $('.input-text').keyup(function(event) {
    if (!$('#textEnv').hasClass('default-environment')) {
      $('.btn-search').removeClass('disabled');
    }
    if ($('.input-text').val().length == 0) {
      $('.btn-search').addClass('disabled');
    }
  });

  $('.input-text').keydown(function(event) {
    if (event.keyCode == '32') {
      event.preventDefault();
    }
  });

  $('.btn-expand-search').click(function(event){
    console.log('Expand Control');
    if ($('.expand-search').hasClass('fa-chevron-down')){
      $('.expand-search').removeClass('fa-chevron-down');
      $('.expand-search').addClass('fa-chevron-right');
      $('.search-bar').slideUp("slow");
    }
    else
    {
      $('.expand-search').removeClass('fa-chevron-right');
      $('.expand-search').addClass('fa-chevron-down');
      $('.search-bar').slideDown("slow");
    }
  });
  
  loadSearchResults();

});

function envTypes(event) {
  console.log('envTypes');
  var id = $('input[name="environmentTypesRadio"]:checked').val();
  $('.btn-environments').addClass('disabled');
  $.ajax({
    type: "GET",
    url: "/search/get_environments.js",
    data: {id: id}
  });
}

function searchResults(event) {
  var environment_id = $('.environmentsList').attr('id');
  var search_type_id = $("input[name='searchTypesRadio']:checked").val();
  var search_text = $('.input-text').val();
  $('.btn-search').addClass('disabled');
  $.ajax({
    type: "GET",
    url: "/search/get_search_results.js",
    data: {
      environment_id: environment_id,
      search_type_id: search_type_id,
      search_text: search_text
    }
  });
}

function loadEnvironmentDropdown() {
  $('#environmentsDropdown li').click(function(event){
    envList(event);
  });
}

function envList(event) {
  console.log('envList');
  var $target = $(event.currentTarget);
  var text = $target.text();
  var id = $target[0].id;
  $('.environmentsList').attr('id',id);
  console.log(text.length);
  if (text.length > 40) {
    console.log('trimma');
    text = jQuery.trim(text).substring(0, 27).trim(this) + "...";
  }
  $('#textEnv').text(text);
  $('#textEnv').removeClass('default-environment');
  if ($('.input-text').val().length > 0) {
    $('.btn-search').removeClass('disabled');
  }
}

function loadTooltipPopover() {
  
  $('.tip').tooltip();

  var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
  if (is_chrome) {
    $('.amount-popover').popover({
      trigger: 'focus'
    });
    $('.date-popover').popover({
      trigger: 'focus'
    });
  }
  else {
    $('.amount-popover').popover();
    $('.date-popover').popover();
  }
}

function loadSearchResults() {

  $('.search-results').on("click", ".btn-expand-bills", function(){
    console.log('Expand Control Bills');
    var id = $(this).attr('id');
    if ($('.expand-bills-' + id).hasClass('fa-chevron-down')){
      $('.expand-bills-' + id).removeClass('fa-chevron-down');
      $('.expand-bills-' + id).addClass('fa-chevron-right');
      $('.pagination-buttons-' + id).fadeOut();
      $('.table-' + id).slideUp("slow");
    }
    else
    {
      $('.expand-bills-' + id).removeClass('fa-chevron-right');
      $('.expand-bills-' + id).addClass('fa-chevron-down');
      $('.btn-next').css('visibility', 'visible');
      $('.pagination-buttons-' + id).fadeIn();
      $('.table-' + id).slideDown("slow");
    }
  });

  $('.search-results').on("click", ".btn-previous", function(){
    var page = parseInt($(this).attr('page-number')) - 1;
    var status = $(this).attr('id');
    var type = $(this).attr('search-type');
    $('.pagination-spinner-'+ status).css('visibility', 'visible');
    $.ajax({
    type: "GET",
    url: "/search/navigate_search_results.js",
    data: {
      page: page ,
      status: status,
      type: type
      }
    });
  });

  $('.search-results').on("click", ".btn-next", function(){
    var page = parseInt($(this).attr('page-number')) + 1;
    var status = $(this).attr('id');
    var type = $(this).attr('search-type');
    $('.pagination-spinner-'+ status).css('visibility', 'visible');
    $.ajax({
    type: "GET",
    url: "/search/navigate_search_results.js",
    data: {
      page: page,
      status: status,
      type: type
      }
    });
  });

}



