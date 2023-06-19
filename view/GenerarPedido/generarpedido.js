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

    // llamar controles adicionales para contacto
    $("#info-adicional").click(function() {
      $("#campos_adicionales").toggle();
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
      // Obtener la cantidad de limpiezas de la fila correspondiente
      var cant_limpieza = $(this).data('cant_limpieza');   
      var producto = {
        id_servicio: id_servicio,
        descripcion: descripcion,
        u_medida: u_medida,
        cantidad: cantidad,
        precio_uni: precio_uni,
        total: total,
        cant_limpieza: cant_limpieza // Agregar el campo de cantidad de limpiezas
      };    
      productos.push(producto);
    });
    // Obtén el estado de los campos "acceso_portal" y "entrega_factura"

    var formData = new FormData($("#pedido_form")[0]);
    var totalfiles = $('#fileElem').val().length;
    for (var i = 0; i < totalfiles; i++) {
      formData.append("files[]", $('#fileElem')[0].files[i]);
    }
    var accesoPortal = $('#acceso_portal').is(':checked') ? 1 : 0;
    var entregaFactura = $('#entrega_factura').is(':checked') ? 1 : 0;
    formData.append('total_pagar', sub_total);
    formData.append('igv', igv);
    formData.append('total_final', total);
    formData.append('acceso_portal', accesoPortal);
    formData.append('entrega_factura', entregaFactura);
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
          //console.log(data[0].id_pedidos);
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
          //window.location.href = "../NotaPedido";
        } else {
          console.log('Respuesta vacía');
        } 
      }
    });
  }
}
init();