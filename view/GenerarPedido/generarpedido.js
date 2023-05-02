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

    const descripcionInput = document.querySelector('#descripcion');

    // Agregamos un evento de input para detectar cambios en el campo
    descripcionInput.addEventListener('input', () => {
      // Obtenemos el valor actual del campo
      const descripcion = descripcionInput.value;
      
      // Llamamos a la función buscarProductos con el valor actual del campo
     
    });

    

    $("#descripcion").keyup(function() {
      buscarProducto($(this).val());
    });

    function buscarProducto() {
      $('#descripcion').on('input', function() {
        var descripcion = $(this).val();
        $.ajax({
          url: '../../controller/producto.php?op=buscar',
          type: "POST",
            data: { "action": "buscar", "descripcion": descripcion },
            dataType: "json",
          success: function(response) {
            const listaResultados = document.querySelector('#lista-resultados');
            listaResultados.innerHTML = '';
            response.forEach(producto => {
              const li = document.createElement('li');
              li.textContent = producto.descripcion;
              li.addEventListener('click', () => {
                descripcionInput.value = producto.descripcion;
                document.querySelector('#id_medida').value = producto.id_medida;
                document.querySelector('#precio').value = producto.precio;
                calcularTotal();
                listaResultados.innerHTML = '';
              });
              listaResultados.appendChild(li);
            });
          },
          error: function() {
            const listaResultados = document.querySelector('#lista-resultados');
            listaResultados.innerHTML = '<li>Error al buscar productos</li>';
          }
        });
      });
    }
  

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
    $('#productos_form')[0].reset();
    $('#modalagregarproductos').modal('show');
});

function actualizarCantidad(cantidad) {
  var inputCantidad = document.getElementById("cantidad");
  var nuevaCantidad = parseInt(inputCantidad.value) + cantidad;
  if (nuevaCantidad >= 1) {
      inputCantidad.value = nuevaCantidad;
  }
}

var input = $("#cantidad");
var btnPlus = $('[data-type="plus"]');
var btnMinus = $('[data-type="minus"]');

// agregar event listeners a los botones
btnPlus.on("click", function() {
  // obtener el valor actual y agregar 1
  var currentValue = parseInt(input.val());
  var newValue = currentValue + 1;

  // asegurarse de que el nuevo valor esté dentro del rango permitido
  if (newValue <= parseInt(input.attr("max"))) {
    input.val(newValue);
  }
});

btnMinus.on("click", function() {
  // obtener el valor actual y restar 1
  var currentValue = parseInt(input.val());
  var newValue = currentValue - 1;

  // asegurarse de que el nuevo valor esté dentro del rango permitido
  if (newValue >= parseInt(input.attr("min"))) {
    input.val(newValue);
  }
});

 


init();