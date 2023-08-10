var sumaTotal = 0;
var cantidadesLimpieza = [];
var descripcion_producto = [];
var id_acopios = [];
var cants = [];
var id_unidad_vehiculars = [];
var id_disposicions = [];
var personal_solicitados = [];
var id_docs_clis = [];
var modoModal;

function init(){ 
  $("#pedido_form").on("submit",function(e){
    guardaryeditarPed(e);
  });
}

$(document).ready(function(){

  $("#nro_doc").on("keydown", function(event) {
    if (event.keyCode === 13) { // Si se presiona Enter
      event.preventDefault(); // Prevenir el comportamiento por defecto de la tecla Enter (enviar el formulario)
      buscarCliente(); // Llamar a la función buscarCliente()
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

  $.post("../../controller/tservicio.php?op=combo",function(data, status){
    $('#id_modalidad').html(data);
  });

  $.post("../../controller/fpago.php?op=combo",function(data, status){
    $('#id_fpago').html(data);
  });

  $.post("../../controller/demision.php?op=combo",function(data, status){
    $('#id_demision').html(data);
  });

  $.post("../../controller/umedida.php?op=combo",function(data, status){
    console.log(data); // Verificar los datos recibidos en la consola
    $('#id_medida').html(data);
  });

  $.post("../../controller/acopio.php?op=combo",function(data, status){
    $('#id_acopio').html(data);
  });  

  $.post("../../controller/u_vehicular.php?op=combo",function(data, status){
    $('#id_unidad_vehicular').html(data);
  });  

  $.post("../../controller/disposicion.php?op=combo",function(data, status){
    $('#id_disposicion').html(data);
  });
  
  $.post("../../controller/entrega_documento.php?op=combo",function(data, status){
    $('#id_docs_cli').html(data);
  });  
  //Ocultar el boton de agregar Detalle al llamar al modal
  $('#btn-AgregarDetalle').hide();

  $("#campos_adicionales").hide();

  // llamar controles adicionales para contacto
  $("#info-adicional").click(function() {
     $("#campos_adicionales").toggle();
  });


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
   
  var id_pedido = getUrlParameter('IDs');
  listardetalle(id_pedido);
  
  $('#btn-AgregarDetalle').on('click', function() {    
    agegardetalle();         
  });  
  
 
  $('#modalagregaryeditar').on('hide.bs.modal', function() {
    if (modoModal === 'editar') {
      // Cambiar el modo del modal a "agregar"
      modoModal = 'agregar';    
      // Cambiar el texto del botón en el modal a "Agregar Detalle"
      $('#btn-AgregarDetalle').text('Agregar');
    }

  });  
  
  $("#id_modalidad").on("change", function() {
    mostrarOcultarManifiesto();
  });

  //Mostrar documentos adjutos en data table
  tabla=$('#documentos_pedido').dataTable({
    "aProcessing": true,
    "aServerSide": true,
    dom: 'Bfrtip',
    "searching": true,
    lengthChange: false,
    colReorder: true,
    buttons: [
            'copyHtml5',
            'excelHtml5',
            'csvHtml5',
            'pdfHtml5'
            ],
    "ajax":{
        url: '../../controller/documentopedido.php?op=listar',
        type : "post",
        data : {id_pedido:id_pedido},
        dataType : "json",
        error: function(e){
            console.log(e.responseText);

        }
    },
    "bDestroy": true,
    "responsive": true,
    "bInfo":true,
    "iDisplayLength": 10,
    "autoWidth": false,
    "language": {
        "sProcessing":     "Procesando...",
        "sLengthMenu":     "Mostrar _MENU_ registros",
        "sZeroRecords":    "No se encontraron resultados",
        "sEmptyTable":     "Ningún dato disponible en esta tabla",
        "sInfo":           "Mostrando un total de _TOTAL_ registros",
        "sInfoEmpty":      "Mostrando un total de 0 registros",
        "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
        "sInfoPostFix":    "",
        "sSearch":         "Buscar:",
        "sUrl":            "",
        "sInfoThousands":  ",",
        "sLoadingRecords": "Cargando...",
        "oPaginate": {
            "sFirst":    "Primero",
            "sLast":     "Último",
            "sNext":     "Siguiente",
            "sPrevious": "Anterior"
        },
        "oAria": {
            "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
            "sSortDescending": ": Activar para ordenar la columna de manera descendente"
        }

    }
  }).DataTable();
  mostrarOcultarCantidadLimpieza();
});


$(document).on('click', '#detalle_ped tbody .btnEditar', function() {
  $('#mdltitulo').html('Editar Servicio');   
    // Obtener la fila actual
  var row = $(this).closest('tr');
   // Remover la clase "editando" de cualquier otra fila que la tenga
  $('.editando').removeClass('editando');
  // Agregar la clase "editando" a la fila actual
  row.addClass('editando');
    // Obtener los valores actuales del detalle de producto
  var id_producto = row.find('td:nth-child(1)').text();
  var descripcion = row.find('td:nth-child(2)').text();
  var id_medida = row.find('td:nth-child(3)').text();
  var cantidad = row.find('td:nth-child(4)').text();
  var precio = row.find('td:nth-child(5)').text();
  var cant_limpieza = $('#cant_limpieza').val();
  var descrip_producto = row.data('descrip_producto');
  var id_acopio = row.data('id_acopio');
  var cant = row.data('cant');
  var id_unidad_vehicular = row.data('id_unidad_vehicular');
  var id_disposicion = row.data('id_disposicion');
  var personal_solicitado = row.data('personal_solicitado');
  var id_docs_cli = row.data('id_docs_cli');
  // Obtén el índice de la fila editada
  var rowIndex = $('.editando').index();
  // Actualiza la cantidad de limpieza en el arreglo correspondiente
  var cant_limpieza = cantidadesLimpieza[rowIndex];
  var descrip_producto = descripcion_producto[rowIndex];
  var id_acopio = id_acopios[rowIndex];
  var cant = cants[rowIndex];
  var id_unidad_vehicular = id_unidad_vehiculars[rowIndex];
  var id_disposicion = id_disposicions[rowIndex];
  var personal_solicitado = personal_solicitados[rowIndex];
  var id_docs_cli = id_docs_clis[rowIndex];
  // Asignar los valores a los campos del formulario de edición
  $('#id_producto').val(id_producto);
  $('#descripcion').val(descripcion);   
  $('#cantidad').val(cantidad);
  $('#precio').val(precio); // Asignar el valor de cant_limpieza al campo de texto
  //$('#cant_limpieza').get(0).value = cant_limpieza;
  $('#cant_limpieza').val(cant_limpieza);
  //$('#descrip_producto').get(0).value = descrip_producto;
  $('#descrip_producto').summernote('code', descrip_producto);
  $('#id_medida option').each(function() {
    if ($(this).text() === id_medida) {
      $('#id_medida').val($(this).val()).trigger('change');
      return false; // Salir del bucle each
    }
  });
  $('#id_acopio').val(id_acopio);
  $('#cant').val(cant);   
  $('#id_unidad_vehicular').val(id_unidad_vehicular);
  $('#id_disposicion').val(id_disposicion);
  $('#personal_solicitado').val(personal_solicitado);
  $('#id_docs_cli').val(id_docs_cli);
  calcularTotal();
  // Cambiar el modo del modal a "editar"
  modoModal = 'editar';
  $('#btn-AgregarDetalle').show();
  // Cambiar el texto del botón en el modal a "Guardar Edición"
  $('#btn-AgregarDetalle').text('Guardar Edición');
  // Mostrar el modal de agregar/editar detalle
  $('#modalagregaryeditar').modal('show');   
  // Agregar la clase "editando" a la fila actual
  row.addClass('editando');
  /// Llamada adicional para mostrar u ocultar el campo de cantidad de limpieza en el modal de edición
  mostrarOcultarCantidadLimpieza();
  mostrarOcultarManifiesto();
 
});

$(document).on("click","#btnagregar", function(){  
  $('#mdltitulo').html('Agregar productos/Servicios');
  $('#servicios_form')[0].reset();
  $('#modalagregaryeditar').modal('show');
  mostrarOcultarCantidadLimpieza();
});

function mostrarOcultarCantidadLimpieza() {
  var valorServicio = $("#id_modalidad").val();
  if (valorServicio === "5" ) { // Compara con el valor correspondiente a "Portatiles"
    $("#campo_cantidad").show(); // Mostrar el campo de cantidad de limpieza
    $("#contenedorServicio").hide();
  
  } else if (valorServicio === "1" || valorServicio === "2") {
    $("#campo_cantidad").hide(); // Ocultar el campo de cantidad de limpieza
    $("#contenedorServicio").hide();
    
  } else {
    $("#campo_cantidad_limpieza").hide(); // Ocultar el campo de cantidad de limpieza
    $("#contenedorServicio").show();
  }
}

function mostrarOcultarManifiesto() {
  var valorModalidad = $("#id_modalidad").val();
  if (valorModalidad === "3" || valorModalidad === "4" || valorModalidad === "2") {
    $("#manifiesto").show();
  } else {
    $("#manifiesto").hide();
  }
}
  

var getUrlParameter = function getUrlParameter(sParam) {
  var sPageURL = decodeURIComponent(window.location.search.substring(1)),
    sURLVariables = sPageURL.split('&'),
    sParameterName,
    i;
   for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=');
      if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : sParameterName[1];
      }
   }
};
// Función para buscar el cliente utilizando AJAX
function buscarCliente() {
  var nro_doc = $("#nro_doc").val(); // Obtener el número de documento ingresado
  $.ajax({
    url: "../../controller/cliente.php?op=buscarCli", // El archivo PHP que contiene la función buscarCliente()
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
      // Asignar el valor del id_cliente a un campo oculto
      $("#id_cliente").val(data.id_cliente);
     },
    error: function() {
    swal("Error!", "Documento no existe", "error");
    }
  });       
}

function listardetalle(id_pedido){  
  $.post("../../controller/pedido.php?op=mostrar", { id_pedido : id_pedido }, function (data) {
    data = JSON.parse(data);
    console.log(data);        
    $('#lblid_pedido').html("Editar Pedido "+data.serie_pedido);
    $('#lblestado').html(data.estado);
    $('#id_pedido').val(data.id_pedido); 
    $('#serie_pedido').val(data.serie_pedido);
    $('#moneda').val(data.moneda);
    $('#id_cliente').val(data.id_cliente);  
    $('#nro_doc').val(data.nro_doc);
    $('#nom_cli').val(data.nom_cli);
    $('#direc_cli').val(data.direc_cli);
    $('#id_modalidad').val(data.id_modalidad);
    $('#contacto').val(data.contacto);
    $('#telf_contacto').val(data.telf_contacto);
    $('#dire_entrega').val(data.dire_entrega);        
    $('#id_demision').val(data.id_demision);
    $('#id_fpago').val(data.id_fpago);
    $('#fecha_entrega').val(data.fecha_entrega);
    $('#tickd_requi').summernote ('code',data.tickd_requi);
    $('#conta_factu').val(data.conta_factu);
    $('#correo_cfactu').val(data.correo_cfactu);
    $('#telf_cfactu').val(data.telf_cfactu);
    $('#conta_cobra').val(data.conta_cobra);
    $('#correo_ccobra').val(data.correo_ccobra);
    $('#telf_ccobra').val(data.telf_ccobra);
    $('#cotizacion').val(data.cotizacion);
    $('#link').val(data.link);
    $('#cierre_facturacion').val(data.cierre_facturacion);
    $('#fecha_pago').val(data.fecha_pago);
    $('#acceso_portal').prop('checked', data.acceso_portal);
    $('#entrega_factura').prop('checked', data.entrega_factura);
    $('#orden_compra').val(data.orden_compra);

    //* Obtener detalles de los productos
    $.post("../../controller/pedido.php?op=mostrar", { id_pedido: id_pedido }, function(detalles) {
      detalles = JSON.parse(detalles);  
      //* Obtener los detalles de los servicios
      var detalles = data.detalles; 
      //* Referencia a la tabla
      var tabla = $('#detalle_ped');
      //* Limpiar filas anteriores de la tabla (excepto la cabecera)
      tabla.find('tr:not(:first)').remove();        
      //* Recorrer los detalles y agregar filas a la tabla
      detalles.forEach(function(detalle) {
        var fila = '<tr>' +
            '<td>' + detalle.id_servicio + '</td>' +
            '<td>' + detalle.descripcion + '</td>' +
            '<td>' + detalle.U_medida + '</td>' +
            '<td>' + detalle.cantidad + '</td>' +
            '<td>' + detalle.precio_uni + '</td>' +
            '<td>' + detalle.total + '</td>' +
            '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btnEditar btn-warning"><i class="fa fa-pencil"></i></a></td>' +
            '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-danger btnEliminar"><i class="fa fa-trash"></i></a></td>' +      
            '</tr>';      
            $('#detalle_ped').append(fila);

      // Almacenar el valor de cant_limpieza en el array
      cantidadesLimpieza.push(detalle.cant_limpieza);
      descripcion_producto.push(detalle.descrip_producto);
      id_acopios.push(detalle.id_acopio);
      cants.push(detalle.cant);
      id_unidad_vehiculars.push(detalle.id_unidad_vehicular);
      id_disposicions.push(detalle.id_disposicion);
      personal_solicitados.push(detalle.personal_solicitado);
      id_docs_clis.push(detalle.id_docs_cli);
    });
    

    var manifiesto = data.manifiestos[0]; //! Intenta obtener el primer elemento del array
    if (manifiesto) {
      //! Si se encuentra un manifiesto, mostrar los detalles
      $('#representante_legal').val(manifiesto.representante_legal);
      $('#dni_repre').val(manifiesto.dni_repre);
      $('#ing_responsable').val(manifiesto.ing_responsable);
      $('#cip_ing').val(manifiesto.cip_ing);
      $('#nom_residuos').val(manifiesto.nom_residuos);
    } else {
      //! Si no se encuentra un manifiesto, limpiar los campos o mostrar algún mensaje de aviso
      $('#representante_legal').val('');
      $('#dni_repre').val('');
      $('#ing_responsable').val('');
      $('#cip_ing').val('');
      $('#nom_residuos').val('');
    }

    sumaTotal = 0;
    $('#detalle_ped tbody tr').each(function() {
     var row = $(this);
    var totalRow = parseFloat(row.find('td').eq(5).text());
    sumaTotal += totalRow;
    });
    // Asignar el valor de la suma al elemento <label>
    $('#total_pagar').text(sumaTotal.toFixed(2));
    actualizarIGVYTotal();
    mostrarOcultarManifiesto();
    });  

  });
  //*Mostrar los campos de manifiesto en caso de que id_madilidad sea "3 o 4"
  mostrarOcultarCantidadLimpieza();
}

$(document).on('click', '#detalle_ped tbody .btn-danger', function() {
  var row = $(this).closest('tr');
  var totalRow = parseFloat(row.find('td').eq(5).text());
  sumaTotal -= totalRow;
  actualizarIGVYTotal();
  row.remove();
});

function actualizarIGVYTotal() {
  const igv = sumaTotal * 0.18; // suponiendo que el IGV es del 18%
  const total = sumaTotal + igv;
  $('#total_pagar').text(sumaTotal.toFixed(2));
  $('#igv').text(igv.toFixed(2));
  $('#total_final').text(total.toFixed(2));
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

function mostrarOcultarFormulario() {
  var valorServicio = $("#id_modalidad").val();
  if (valorServicio === "3" || valorServicio === "4") {
    $("#manifiesto").show();
  } else {
    $("#manifiesto").hide();
  }
}

function guardaryeditarPed(e){
  e.preventDefault(); 
  var estadoPedido =$('#lblestado').text();
  // Verificar si el pedido está anulado
  if (estadoPedido.toLowerCase() === 'anulado') {
    // Deshabilitar el botón de guardar cambios
    $('#btnGuardarCambios').prop('disabled', true);

    // Mostrar mensaje al usuario
    swal("Advertencia!", "No se pueden guardar cambios en pedidos anulados.", "warning");
    return;
  }

  if ($('#nro_doc').val()=='' || $('#id_modalidad').val() == 0 || $('#id_demision').val() == 0 || $('#id_fpago').val() == 0 || $('#direc_ser').val() == 0 || $('#fecha_entrega').val() == 0){
      swal("Advertencia!", "Campos Vacios", "warning");
  }else{    
    var sub_total = parseFloat($('#total_pagar').text());
    var igv = parseFloat($('#igv').text());
    var total = parseFloat($('#total_final').text());
    // Capturar los productos
    var productos = [];
    $('#detalle_ped tbody tr').each(function() {
      var id_servicio = $(this).find('td:nth-child(1)').text();
      var descripcion = $(this).find('td:nth-child(2)').text();
      var u_medida = $(this).find('td:nth-child(3)').text();
      var cantidad = $(this).find('td:nth-child(4)').text();
      var precio_uni = $(this).find('td:nth-child(5)').text();
      var total = $(this).find('td:nth-child(6)').text();
      //cant_limpieza se obtendrá directamente del arreglo cantidadesLimpieza en lugar de buscarlo en el campo del modal.
      var cant_limpieza = cantidadesLimpieza[$(this).index()];
      var descrip_producto = descripcion_producto[$(this).index()];
      var id_acopio = id_acopios[$(this).index()];
      var cant = cants[$(this).index()];
      var id_unidad_vehicular = id_unidad_vehiculars[$(this).index()];
      var id_disposicion = id_disposicions[$(this).index()];
      var personal_solicitado = personal_solicitados[$(this).index()];
      var id_docs_cli = id_docs_clis[$(this).index()];
      var producto = {
        id_servicio: id_servicio,
        descripcion: descripcion,
        u_medida: u_medida,
        cantidad: cantidad,
        precio_uni: precio_uni,
        total: total,
        cant_limpieza: cant_limpieza,
        descrip_producto: descrip_producto,
        id_acopio: id_acopio,
        cant: cant,
        id_unidad_vehicular: id_unidad_vehicular,
        id_disposicion: id_disposicion,
        personal_solicitado: personal_solicitado,
        id_docs_cli: id_docs_cli
      };    
      productos.push(producto);
    });

    var id_cliente = $('#id_cliente').val();
    var representante_legal = $('#representante_legal').val();
    var dni_repre = $('#dni_repre').val();
    var ing_responsable = $('#ing_responsable').val();
    var cip_ing = $('#cip_ing').val();
    var nom_residuos = $('#nom_residuos').val();

    var manifiestos = [{
      id_cliente: id_cliente,
      representante_legal: representante_legal,
      dni_repre: dni_repre,
      ing_responsable: ing_responsable,
      cip_ing: cip_ing,
      nom_residuos: nom_residuos
    }];


    // Obtén el estado de los campos "acceso_portal" y "entrega_factura"
    var accesoPortal = $('#acceso_portal').is(':checked') ? 1 : 0;
    var entregaFactura = $('#entrega_factura').is(':checked') ? 1 : 0;
    var formData = new FormData($("#pedido_form")[0]);  
    formData.append('total_pagar', sub_total);
    formData.append('igv', igv);
    formData.append('total_final', total);
    formData.append('acceso_portal', accesoPortal);
    formData.append('entrega_factura', entregaFactura);
    formData.append('id_pedido', $('#id_pedido').val());
    formData.append('productos', JSON.stringify(productos));
    formData.append('manifiestos', JSON.stringify(manifiestos)); 
      $.ajax({
      url: "../../controller/pedido.php?op=generaryeditar",
      type: "POST",
      data: formData,
      contentType: false,
      processData: false,
      success: function(data){
        console.log("Respuesta del servidor:", data);
        console.log(data);
        if (data.trim() !== '') {
          data = JSON.parse(data);
          // Limpiar la tabla
            $('#detalle_ped tbody').empty();
          //Restablecer valores de campos y editor de texto             
          $("#nro_doc").val("");
          $('#pedido_form')[0].reset();
          $('#tickd_requi').summernote('reset');              
          // Restablecer valores de subtotal, IGV y total a pagar
          $('#total_pagar').text('0.00');
          $('#igv').text('0.00');
          $('#total_final').text('0.00');
          console.log("Mensaje de éxito"); // Agrega esta línea
          swal({
            title: "Correcto!",
            text: "Los cambios se han guardado correctamente.",
            icon: "success",
            buttons: ["Cancelar", "Aceptar"],
          }, function (willRedirect) {
            if (willRedirect) {
              window.location.href = "../NotaPedido";
            }
          });
        }       
      }
    });
  }
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
  var id_acopio = $('#id_acopio').val();
  var cant = $('#cant').val();
  var id_unidad_vehicular = $('#id_unidad_vehicular').val();
  var id_disposicion = $('#id_disposicion').val();
  var personal_solicitado = $('#personal_solicitado').val();
  var id_docs_cli = $('#id_docs_cli').val();
 
 
  // Verificar si todos los campos requeridos tienen valores
  if (id_producto === '' || descripcion === '' || id_medida === '' || cantidad === '' || precio === '' || total === '') {
    swal("Advertencia!", "Por favor, completa todos los campos antes de agregar el detalle.", "warning");
    return;
  }


  // Obtener el valor seleccionado del campo id_modalidad
  var id_modalidad = $('#id_modalidad').val();

  // Verificar si se ha seleccionado "Portatiles" como servicio
  if (id_modalidad === '5' && cant_limpieza === '') {
    swal("Advertencia!", "Por favor, ingresa la cantidad de limpiezas.", "warning");
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
    var rowIndex = filaEditando.index();
    filaEditando.data('cant_limpieza', cant_limpieza);
    filaEditando.data('descrip_producto', descrip_producto);
    filaEditando.data('id_acopio', id_acopio);
    filaEditando.data('cant', cant);
    filaEditando.data('id_unidad_vehicular', id_unidad_vehicular);
    filaEditando.data('id_disposicion', id_disposicion);
    filaEditando.data('personal_solicitado', personal_solicitado);
    filaEditando.data('id_docs_cli', id_docs_cli);
    
    cantidadesLimpieza[rowIndex] = cant_limpieza;
    descripcion_producto[rowIndex] = descrip_producto;

    id_acopios[rowIndex] = id_acopio;
    cants[rowIndex] = cant;
    id_unidad_vehiculars[rowIndex] = id_unidad_vehicular;
    id_disposicions[rowIndex] = id_disposicion;
    personal_solicitados[rowIndex] = personal_solicitado;
    id_docs_clis[rowIndex] = id_docs_cli;

    filaEditando.removeClass('editando');  

    // Cambiar el modo del modal a "agregar"
    modoModal = 'agregar';
    // Mostrar alerta de éxito al editar    
    $('#modalagregaryeditar').modal('hide');     
          
  } else {
    // Agregar nueva fila a la tabla de detalle de pedido
    $('#detalle_ped tbody').append('<tr>' +
      '<td>' + id_producto + '</td>' +
      '<td>' + descripcion + '</td>' +
      '<td>' + nombre_medida + '</td>' +
      '<td>' + cantidad + '</td>' +
      '<td class="d-none d-sm-table-cell">' + precio + '</td>' +
      '<td class="d-none d-sm-table-cell">' + total + '</td>' +
      '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btnEditar btn-warning"><i class="fa fa-pencil"></i></a></td>' +
      '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-danger btnEliminar"><i class="fa fa-trash"></i></a></td>' +
      '</tr>');

      var nuevaFila = $('#detalle_ped tbody tr:last-child');

      // Guardar el valor de cantidad de limpiezas como un atributo de datos en la fila
      nuevaFila.data('cant_limpieza', cant_limpieza);
      nuevaFila.data('descrip_producto', descrip_producto);

      nuevaFila.data('id_acopio', id_acopio);
      nuevaFila.data('cant', cant);
      nuevaFila.data('id_unidad_vehicular', id_unidad_vehicular);
      nuevaFila.data('id_disposicion', id_disposicion);
      nuevaFila.data('personal_solicitado', personal_solicitado);
      nuevaFila.data('id_docs_cli', id_docs_cli);

      // Agregar la nueva fila al final de la tabla
      $('#detalle_ped tbody').append(nuevaFila);

      cantidadesLimpieza.push(cant_limpieza);
      descripcion_producto.push(descrip_producto);
      id_acopios.push(id_acopio);
      cants.push(cant);
      id_unidad_vehiculars.push(id_unidad_vehicular);
      id_disposicions.push(id_disposicion);
      personal_solicitados.push(personal_solicitado);
      id_docs_clis.push(id_docs_cli);
      // Mostrar alerta de éxito al agregar
      swal("Éxito!", "El servicio se agrego corectamente.", "success");

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
  $('#cant_limpieza').val('');
  $('#id_acopio').val('');
  $('#cant').val('');
  $('#id_unidad_vehicular').val('');
  $('#id_disposicion').val('');
  $('#personal_solicitado').val('');
  $('#id_producto').val('');
  $('#descrip_producto').summernote('reset');
  $('#total').val('');
  $('#btn-AgregarDetalle').hide();
}

init();