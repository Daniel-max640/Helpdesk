var tabla;

function init(){
    $("#usuario_form").on("submit",function(e){
        guardaryeditar(e);	
    });
}



$(document).ready(function(){
    $("#nro_doc").on("keydown", function(event) {
        if (event.keyCode === 13) { // Si se presiona Enter
          event.preventDefault(); // Prevenir el comportamiento por defecto de la tecla Enter (enviar el formulario)
          buscarCliente(); // Llamar a la función buscarCliente()
        }
      });
      
      // Función para buscar el cliente utilizando AJAX
      function buscarCliente() {
        var nro_doc = $("#nro_doc").val(); // Obtener el número de documento ingresado
        $.ajax({
          url: "../../controller/pedido.php?op=buscarCli", // El archivo PHP que contiene la función buscarCliente()
          type: "POST",
          data: { "action": "buscarCli", "nro_doc": nro_doc },
          dataType: "json",
          success: function(data) {
            // Mostrar la información obtenida en los campos de texto correspondientes
            $("#nom_cli").val(data.nom_cli);
            $("#direc_cli").val(data.direc_cli);
          },
          error: function() {
            alert("Error al buscar el cliente.");
          }
        });       
      } 
      
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

  $(document).on("click","#btnagregar", function(){
    $('#usu_id').val('');
    $('#mdltitulo').html('Agregar productos/Servicios');
    $('#usuario_form')[0].reset();
    $('#modalagregarproductos').modal('show');
});

init();