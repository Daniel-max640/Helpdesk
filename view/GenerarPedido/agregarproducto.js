var sumaTotal = 0;
function init(){
    
}


$(document).ready(function(){

  $('#btn-AgregarDetalle').hide();

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
      $('#btn-AgregarDetalle').hide();
    } else {
      buscarProducto(descripcion);   
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
});

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
            $('#id_producto').val(producto.id_producto);
            $('#descripcion').val(producto.descripcion);
            $('#id_medida').val(producto.medida_descripcion);
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

 

  function agegardetalle() {
    // Obtener valores del producto seleccionado en el modal
    var id_producto = $('#id_producto').val();
    var descripcion = $('#descripcion').val();
    var id_medida = $('#id_medida').val();
    var cantidad = $('#cantidad').val();
    var precio = $('#precio').val();
    var total = $('#total').val();

    console.log('Función click del botón "Agregar detalle" ejecutada');
    // Agregar nueva fila a la tabla de detalle de pedido

    $('#detalle_ped tbody').append('<tr>' +
    '<td>' + id_producto + '</td>' +
    '<td>' + descripcion + '</td>' +
    '<td>' + id_medida + '</td>' +
    '<td>' + cantidad + '</td>' +
    '<td class="d-none d-sm-table-cell">' + precio + '</td>' +
    '<td class="d-none d-sm-table-cell">' + total + '</td>' +
    '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-warning btnEditar"><i class="fa fa-pencil"></i></a></td>' +
    '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-danger btnEliminar"><i class="fa fa-trash"></i></a></td>' +
    '</tr>');

    // Sumar el total de la fila actual a la variable global
    sumaTotal += parseFloat(total);

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
    $('#btn-AgregarDetalle').hide();
    return false;     
    }

    function actualizarIGVYTotal() {
      const igv = sumaTotal * 0.18; // suponiendo que el IGV es del 18%
      const total = sumaTotal + igv;
      $('#total_pagar').text(sumaTotal.toFixed(2));
      $('#igv').text(igv.toFixed(2));
      $('#total_final').text(total.toFixed(2));
    }

    function eliminarDetalle(btn) {
      var row = btn.parentNode.parentNode;
      var total = parseFloat(row.cells[5].textContent);
      row.parentNode.removeChild(row);
      sumaTotal -= total;
      // Actualizar el IGV y el total
      actualizarIGVYTotal();
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
  