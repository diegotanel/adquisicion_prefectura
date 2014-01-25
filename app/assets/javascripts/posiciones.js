$(document).ready(function(){

  $("#seleccionar_todos").click(function() {
    $('input[type=checkbox]').each( function() {
      $(this).prop("checked", true);
    });
  });

  $("#deseleccionar_todos").click(function() {
    $('input[type=checkbox]').each( function() {
      $(this).prop("checked", false);
    });
  });

});