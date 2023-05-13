function init(){
  $("#pedido_form").on("submit",function(e){
    guardaryeditarPedido(e);
  });
}

$(document).ready(function(){
    $("#nro_doc").on("keydown", function(event) {
       if (event.keyCode === 13) { // Si se presiona Enter
        event.preventDefault(); // Prevenir el comportamiento por defecto de la tecla Enter (enviar el formulario)
         buscarCliente(); // Llamar a la función buscarCliente()
       }
    }); 

    $.post("../../controller/tservicio.php?op=combo",function(data, status){
      $('#id_modalidad').html(data);
    });

    $.post("../../controller/fpago.php?op=combo",function(data, status){
      $('#id_fpago').html(data);
    });

    $.post("../../controller/demision.php?op=combo",function(data, status){
      $('#id_demision').html(data);
    });   
});
 
$('#tickd_requi').summernote({
  height: 100,
  lang: "es-ES",
  toolbar: [
       ['style', ['bold', 'italic', 'underline', 'clear']],
       ['font', ['strikethrough', 'superscript', 'subscript']],
       ['fontsize', ['fontsize']],
       ['color', ['color']],
       ['para', ['ul', 'ol', 'paragraph']],
       ['height', ['height']]
  ]
});  

$(function() {			
  $('.flatpickr').flatpickr();
    $("#flatpickr-disable-range").flatpickr({
    disable: [
      {
        from: "2016-08-16",
          to: "2016-08-19"
      },
      "2016-08-24",
        new Date().fp_incr(30) // 30 days from now
        ]
    });
});

// Función para buscar el cliente utilizando AJAX
function buscarCliente() {
  var nro_doc = $("#nro_doc").val(); // Obtener el número de documento ingresado
  $.ajax({
    url: "../../controller/pedido.php?op=buscarCli", // El archivo PHP que contiene la función buscarCliente()
    type: "POST",
    data: { "action": "buscarCli", "nro_doc": nro_doc},
    dataType: "json",
    success: function(data) {
      // Mostrar la información obtenida en los campos de texto correspondientes
      $("#nom_cli").val(data.nom_cli);
      $("#direc_cli").val(data.direc_cli);
      $("#contacto_cli").val(data.contacto_cli);
      $("#contacto_telf").val(data.contacto_telf);
      $("#correo_cli").val(data.correo_cli);

      // Asignar el valor del id_client a un campo oculto
      $("#id_cliente").val(data.id_cliente);
     },
     error: function() {
       alert("Error al buscar el cliente.");
    }
    });       
} 

function guardaryeditarPedido(e){
  e.preventDefault();
 
  
  if ($('#nro_doc').val()=='' || $('#id_modalidad').val() == 0 || $('#id_fpago').val() == 0 || $('#direc_ser').val() == 0){
      swal("Advertencia!", "Campos Vacios", "warning");
  }else{

    var sub_total = parseFloat($('#total_pagar').text());
    var igv = parseFloat($('#igv').text());
    var total = parseFloat($('#total_final').text());
  
    var formData = new FormData($("#pedido_form")[0]);
    formData.append('total_pagar', sub_total);
    formData.append('igv', igv);
    formData.append('total_final', total);
 
          $.ajax({
          url: "../../controller/pedido.php?op=generaryeditar",
          type: "POST",
          data: formData,
          contentType: false,
          processData: false,
          success: function(data){

            console.log(data);
            if (data.trim() !== '') {
              data = JSON.parse(data);
              console.log(data[0].id_pedido);

              
              $("#nro_doc").val("");
              $('#pedido_form')[0].reset();
              $('#tickd_requi').summernote('reset');
              swal("Correcto!", "Registrado Correctamente", "success");
            } else {
              console.log('Respuesta vacía');
            } 
          }
      });
  }
}

init();