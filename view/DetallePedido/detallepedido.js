var sumaTotal = 0;
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

  var id_pedido = getUrlParameter('IDs');
  listardetalle(id_pedido); 
         
}); 

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
      swal("Error!", "Documento no existe", "error");
    }
  });       
}

function listardetalle(id_pedido){  
    $.post("../../controller/pedido.php?op=mostrar", { id_pedido : id_pedido }, function (data) {
        data = JSON.parse(data);
        console.log(data);        
        $('#lblid_pedido').html("Editar Pedido "+data.serie_pedido);
        $('#id_pedido').val(data.id_pedido);   
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

        // Obtener detalles de los productos
        $.post("../../controller/pedido.php?op=mostrar", { id_pedido: id_pedido }, function(detalles) {
        detalles = JSON.parse(detalles);  
        // Obtener los detalles de los servicios
        var detalles = data.detalles;      
        // Referencia a la tabla
        var tabla = $('#detalle_ped');
        // Limpiar filas anteriores de la tabla (excepto la cabecera)
        tabla.find('tr:not(:first)').remove();        
        // Recorrer los detalles y agregar filas a la tabla
        detalles.forEach(function(detalle) {
          var fila = '<tr>' +
            '<td>' + detalle.id_servicio + '</td>' +
            '<td>' + detalle.descripcion + '</td>' +
            '<td>' + detalle.U_medida + '</td>' +
            '<td>' + detalle.cantidad + '</td>' +
            '<td>' + detalle.precio_uni + '</td>' +
            '<td>' + detalle.total + '</td>' +
            '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-warning btnEditar"><i class="fa fa-pencil"></i></a></td>' +
            '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btn-danger btnEliminar"><i class="fa fa-trash"></i></a></td>' +      
            '</tr>';      
          $('#detalle_ped').append(fila);
        });

        sumaTotal = 0;
        $('#detalle_ped tbody tr').each(function() {
          var row = $(this);
          var totalRow = parseFloat(row.find('td').eq(5).text());
          sumaTotal += totalRow;
        });

        // Asignar el valor de la suma al elemento <label>
        $('#total_pagar').text(sumaTotal.toFixed(2));
        actualizarIGVYTotal();
      });

    });
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

$(document).on("click","#btnagregar", function(){    
  $('#mdltitulo').html('Agregar productos/Servicios');
  $('#servicios_form')[0].reset();
  $('#modalagregaryeditar').modal('show');
});

function guardaryeditarPedido(e){
  e.preventDefault(); 
  
  if ($('#nro_doc').val()=='' || $('#id_modalidad').val() == 0 || $('#id_fpago').val() == 0 || $('#direc_ser').val() == 0 || $('#fecha_entrega').val() == 0){
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
      var producto = {
        id_servicio: id_servicio,
        descripcion: descripcion,
        u_medida: u_medida,
        cantidad: cantidad,
        precio_uni: precio_uni,
        total: total
      };    
      productos.push(producto);
    });
    var formData = new FormData($("#pedido_form")[0]);
  
    formData.append('total_pagar', sub_total);
    formData.append('igv', igv);
    formData.append('total_final', total);
    formData.append('id_pedido', $('#id_pedido').val());
    formData.append('productos', JSON.stringify(productos)); 
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

              swal("Correcto!", "Registrado Correctamente", "success");
            } else {
              console.log('Respuesta vacía');
            } 
          }
      });
  }
}

init();
