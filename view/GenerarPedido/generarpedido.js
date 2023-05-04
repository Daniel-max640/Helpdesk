function init(){
    
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

    $('#cantidad').on('change', function() {
      calcularTotal();
    });

    $('#precio').on('input', function() {
      calcularTotal();
    });
      
  

    $('#descripcion').on('input', function() {
      const descripcion = $(this).val();
      if (descripcion === '') {
        $('#lista-resultados').empty();
      } else {
        buscarProducto(descripcion);   
      }
    });
    
    function buscarProducto(descripcion) {
      if (descripcion.trim().length === 0) {
        $('#lista-resultados').empty();
        return;
      }
      $.ajax({
        url: '../../controller/producto.php?op=buscar',
        type: "POST",
        data: { "action": "buscar", "descripcion": descripcion },
        dataType: "json",
        success: function(response) {
          const listaResultados = $('#lista-resultados');
          listaResultados.empty();
          response.forEach(producto => {
            const li = $('<li class="list-group-item">').text(producto.descripcion);
            li.on('click', () => {
              $('#id_producto').val(producto.id_producto);
              $('#descripcion').val(producto.descripcion);
              $('#id_medida').val(producto.medida_descripcion);
              $('#precio').val(producto.precio);
              calcularTotal();
              listaResultados.empty();

                          });
            listaResultados.append(li);
          });
        },
        error: function() {
          const listaResultados = $('#lista-resultados');
          listaResultados.empty();
          listaResultados.append('<li>Error al buscar productos</li>');      
        }
      });
    }

    $('#btn-AgregarDetalle').on('click', function() {
      // Obtener valores del producto seleccionado en el modal
      var id_producto = $('#id_producto').val();
      var descripcion = $('#descripcion').val();
      var id_medida = $('#id_medida').val();
      var cantidad = $('#cantidad').val();
      var precio = $('#precio').val();
      var total = $('#total').val();
    
      console.log('Función click del botón "Agregar detalle" ejecutada');
      // Agregar nueva fila a la tabla de detalle de pedido
      if (id_producto && descripcion && id_medida && cantidad && precio && total) {
      $('#detalle_ped tbody').append('<tr>' +
        '<td>' + id_producto + '</td>' +
        '<td>' + descripcion + '</td>' +
        '<td>' + id_medida + '</td>' +
        '<td>' + cantidad + '</td>' +
        '<td class="d-none d-sm-table-cell">' + precio + '</td>' +
        '<td class="d-none d-sm-table-cell">' + total + '</td>' +
        '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-danger"><i class="fa fa-trash"></i></a></td>' +
        '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-primary"><i class="fa fa-pencil-alt"></i></a></td>' +
        '</tr>');
    
      // Limpiar campos del modal y cerrarlo
      $('#descripcion').val('');
      $('#cantidad').val('1');
      $('#precio').val('');
      $('#id_medida').val('');
      $('#id_producto').val('');
      $('#total').val('');
      
      }
      
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
function calcularTotal() {
  const cantidad = parseInt($('#cantidad').val());
  const precio = parseFloat($('#precio').val());
  const total = cantidad * precio;
  $('#total').val(total.toFixed(2));
}

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
    calcularTotal();
  }
});

btnMinus.on("click", function() {
  // obtener el valor actual y restar 1
  var currentValue = parseInt(input.val());
  var newValue = currentValue - 1;

  // asegurarse de que el nuevo valor esté dentro del rango permitido
  if (newValue >= parseInt(input.attr("min"))) {
    input.val(newValue);
    calcularTotal();
  }
});
init();