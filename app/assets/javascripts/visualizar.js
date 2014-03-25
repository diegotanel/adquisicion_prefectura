$(document).ready(function(){


  $("#eliminar_filtro").hide();

  $("#buques").change(function() {
   var nombre = $("#buques option:selected").text()
   var id = $("#posiciones_id").val()
   $.ajax({
    url: "http://localhost:3000/posiciones/" + id + "/filtrar_por_buque.js",
    dataType: "json",
    type: "GET",
    data: { id: id, buque: nombre },
    contentType: "application/json",
    success:function(result){
      $("#tabla").html(result)
      $("div.pagination").hide();
      $("a.buscar_buque").hide();
      $("#eliminar_filtro").show();
    }
  });
 });
});