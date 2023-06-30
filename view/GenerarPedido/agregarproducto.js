var sumaTotal = 0;
var modoModal;
function init(){    
}

$(document).ready(function(){
  //cargado de informacion en el combo de Unidad de MEDIDA
  $.post("../../controller/umedida.php?op=combo",function(data, status){
    console.log(data); // Verificar los datos recibidos en la consola
    $('#id_medida').html(data);
  });

  //Ocultar el boton de agregar Detalle al llamar al modal
  $('#btn-AgregarDetalle').hide();
  
  //Calcula los valores automaticamente del total cuando se genera un cambio en la cantidad
  $('#cantidad').on('change', function() {
    calcularTotal();
  });
  //Calcula los valores automaticamente del total cuando se genera un cambio en el precio
  $('#precio').on('input', function() {
    calcularTotal();
  });

  $('#descripcion').on('input', function() {
    const descripcion = $(this).val();
    if (descripcion === '') {
      $('#lista-resultados').empty();
      $('#btn-AgregarDetalle').hide();
    } else {
      buscarProducto(descripcion);   
    }
  }); 

  $('#descrip_producto').summernote({
    height: 50,
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


  $('#descripcion, #precio').on('keydown', function(event) {
    if (event.keyCode === 13) { // Código de la tecla Enter
      const descripcion = $('#descripcion').val();
      const precio = $('#precio').val();
  
      if (descripcion === '' || precio === '') {
        event.preventDefault(); // Cancelar la acción predeterminada del formulario
        return false;
      }
    }
  });

  $('#btn-AgregarDetalle').on('click', function() {    
     agegardetalle();         
  });  

  $(document).on('click', '#detalle_ped tbody .btn-danger', function() {
    var row = $(this).closest('tr');
    var totalRow = parseFloat(row.find('td').eq(5).text());
    sumaTotal -= totalRow;
    actualizarIGVYTotal();
    row.remove();
  });

  $(document).on('click', '#detalle_ped tbody .btnEditar', function() {
    $('#mdltitulo').html('Editar Servicio'); 

    // Obtener la fila actual
    var row = $(this).closest('tr');
    // Remover la clase "editando" de cualquier otra fila que la tenga para que guarde solo para la fila editada
    $('.editando').removeClass('editando');
     
    // Obtener los valores actuales del detalle de producto
    var id_producto = row.find('td:nth-child(1)').text();
    var descripcion = row.find('td:nth-child(2)').text();
    var id_medida = row.find('td:nth-child(3)').text();
    var cantidad = row.find('td:nth-child(4)').text();
    var precio = row.find('td:nth-child(5)').text();
    var cant_limpieza = row.data('cant_limpieza');
    var descrip_producto = row.data('descrip_producto');
   
    //console.log("id_medida:", id_medida);

    // Asignar los valores a los campos del formulario de edición
    $('#id_producto').val(id_producto);
    $('#descripcion').val(descripcion);   
    $('#cantidad').val(cantidad);
    $('#precio').val(precio);
    $('#cant_limpieza').val(cant_limpieza);
    // Establecer el contenido del Summernote
    $('#descrip_producto').summernote('code', descrip_producto);

    $('#id_medida option').each(function() {
      if ($(this).text() === id_medida) {
        $('#id_medida').val($(this).val()).trigger('change');
        return false; // Salir del bucle each
      }
    });
  

    calcularTotal();  

    // Cambiar el modo del modal a "editar"
    modoModal = 'editar';
    $('#btn-AgregarDetalle').show();

    // Cambiar el texto del botón en el modal a "Guardar Edición"
    $('#btn-AgregarDetalle').text('Guardar Edición');

    // Mostrar el modal de agregar/editar detalle
    $('#modalagregarproductos').modal('show');

    // Agregar la clase "editando" a la fila actual
    row.addClass('editando');
    });  

  // solucion a incidencia (cuando se edita y no se guardaba, al momento de queere agregar un nuevo servicio se quedaba en modo edicion)
  $('#modalagregarproductos').on('hidden.bs.modal', function () {
    // Restablecer el modo del modal a "agregar"
    modoModal = 'agregar';
  
    // Restablecer el texto del botón en el modal a "Agregar Detalle"
    $('#btn-AgregarDetalle').text('Agregar');
      // Limpiar los campos del formulario
    $('#descripcion').val('');
    $('#cantidad').val('1');
    $('#precio').val('');
    $('#id_medida').val('');
    $('#id_producto').val('');
    $('#total').val('');
    $('#cant_limpieza').val('');
    $('#descrip_producto').summernote('reset');
    // Ocultar el botón de agregar detalle
    $('#btn-AgregarDetalle').hide();
    

  });
  
});

function agegardetalle() {
  // Obtener valores del producto seleccionado en el modal
  var id_producto = $('#id_producto').val();
  var descripcion = $('#descripcion').val();
  var id_medida = $('#id_medida option:selected').val();
  var cantidad = $('#cantidad').val();
  var precio = $('#precio').val();
  var total = $('#total').val();
  var cant_limpieza = $('#cant_limpieza').val();
  var descrip_producto = $('#descrip_producto').val();
 
  // Verificar si todos los campos requeridos tienen valores
  if (id_producto === '' || descripcion === '' || id_medida === '' || cantidad === '' || precio === '' || total === '' || cant_limpieza === '') {
    swal("Advertencia!", "Por favor, completa todos los campos antes de agregar el detalle.", "warning");
    return;
  }

   // Obtener el nombre de la medida seleccionada
   var nombre_medida = $('#id_medida option:selected').data('nombre');


  // Verificar si el modal está en modo de edición
  if (modoModal === 'editar') {
    // Obtener la fila actual en modo de edición
    var filaEditando = $('.editando');

    // Actualizar los valores de la fila con los nuevos datos
    filaEditando.find('td:nth-child(1)').text(id_producto);
    filaEditando.find('td:nth-child(2)').text(descripcion);
    filaEditando.find('td:nth-child(3)').text(nombre_medida);
    filaEditando.find('td:nth-child(4)').text(cantidad);
    filaEditando.find('td:nth-child(5)').text(precio);
    filaEditando.find('td:nth-child(6)').text(total);

    filaEditando.data('cant_limpieza', cant_limpieza);
    filaEditando.data('descrip_producto', descrip_producto);

    filaEditando.removeClass('editando');

      // Cambiar el modo del modal a "agregar"
      modoModal = 'agregar';
 
      // Cambiar el texto del botón en el modal a "Agregar Detalle"
      $('#btn-AgregarDetalle').text('Agregar');
      // Cerrar el modal
      $('#modalagregarproductos').modal('hide');
  } else {
    // Agregar nueva fila a la tabla de detalle de pedido
    $('#detalle_ped tbody').append('<tr>' +
      '<td>' + id_producto + '</td>' +
      '<td>' + descripcion + '</td>' +
      '<td>' + nombre_medida + '</td>' +
      '<td>' + cantidad + '</td>' +
      '<td class="d-none d-sm-table-cell">' + precio + '</td>' +
      '<td class="d-none d-sm-table-cell">' + total + '</td>' +
      '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btnEditar btn-warning "><i class="fa fa-pencil"></i></a></td>' +
      '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-danger btnEliminar"><i class="fa fa-trash"></i></a></td>' +
      '</tr>');

       // Obtener la última fila agregada
      var nuevaFila = $('#detalle_ped tbody tr:last-child');

    // Guardar el valor de cantidad de limpiezas como un atributo de datos en la fila
    nuevaFila.data('cant_limpieza', cant_limpieza);
    nuevaFila.data('descrip_producto', descrip_producto);
  }

  // Recalcular el total
  sumaTotal = 0;
  $('#detalle_ped tbody tr').each(function() {
    var row = $(this);
    var totalRow = parseFloat(row.find('td').eq(5).text());
    sumaTotal += totalRow;
  });

  // Asignar el valor de la suma al elemento <label>
  $('#total_pagar').text(sumaTotal.toFixed(2));

  // Actualizar el IGV y el total
  actualizarIGVYTotal();

  // Limpiar campos del modal y cerrarlo
  $('#descripcion').val('');
  $('#cantidad').val('1');
  $('#precio').val('');
  $('#id_medida').val('');
  $('#id_producto').val('');
  $('#total').val('');
  $('#cant_limpieza').val('');
  $('#descrip_producto').summernote('reset');  
  $('#btn-AgregarDetalle').hide();
}

function buscarProducto(descripcion) {
  if (descripcion.trim().length === 0) {
    $('#lista-resultados').empty();
    $('#btn-AgregarDetalle').hide();
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
          $('#id_producto').val(producto.id_servicio);
          $('#descripcion').val(producto.descripcion);
          $('#precio').val(producto.precio);
          calcularTotal();
          listaResultados.empty();
           $('#btn-AgregarDetalle').show();
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

function actualizarIGVYTotal() {
  const igv = sumaTotal * 0.18; // suponiendo que el IGV es del 18%
  const total = sumaTotal + igv;
  $('#total_pagar').text(sumaTotal.toFixed(2));
  $('#igv').text(igv.toFixed(2));
  $('#total_final').text(total.toFixed(2));
}

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

function calcularTotal() {
  const cantidad = parseInt($('#cantidad').val());
  const precio = parseFloat($('#precio').val());
  const total = cantidad * precio;
  $('#total').val(total.toFixed(2));
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
  