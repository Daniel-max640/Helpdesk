var sumaTotal = 0;
var cantidadesLimpieza = [];
var modoModal;

function init(){
   
}

$(document).ready(function(){  

    $('#tickd_requi').summernote({
        height: 50,
        lang: "es-ES",
        callbacks: {
            onImageUpload: function(image) {
                console.log("Image detect...");
                myimagetreat(image[0]);
            },
            onPaste: function (e) {
                console.log("Text detect...");
            }
        },
        toolbar: [
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']]
        ]
    });

    $('#tickd_requi').summernote('disable');

    $('#segui_descripcion').summernote({
        height:200,
        lang: "es-ES",
        callbacks: {
            onImageUpload: function(image) {
                console.log("Image detect...");
                myimagetreat(image[0]);
            },
            onPaste: function (e) {
                console.log("Text detect...");
            }
        },
        toolbar: [
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']]
        ]
    });

     // llamar controles adicionales para contacto
    $("#info-adicional").click(function() {
        $("#campos_adicionales").toggle();
    });

    var id_pedido = getUrlParameter('IDs');
    listardetalle(id_pedido);

      //Mostrar documentos adjutos en data table
      tabla=$('#documentos_pedido').dataTable({
        "aProcessing": true,
        "aServerSide": true,
        "searching": false,
        lengthChange: false,
        colReorder: true,
        buttons: [],
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

$(document).on("click","#btnenviar", function(){
    var id_pedido = getUrlParameter('IDs');
    var usu_id = $('#user_idx').val();
    var segui_descripcion = $('#segui_descripcion').val();

    if ($('#segui_descripcion').summernote('isEmpty')){
        swal("Advertencia!", "Falta Descripción", "warning");
        
    }else{
        var formData = new FormData();
        formData.append('id_pedido', id_pedido);
        formData.append('usu_id', usu_id);
        formData.append('segui_descripcion', segui_descripcion);
        var totalfiles = $('#fileElem').val().length;
        for (var i = 0; i < totalfiles; i++) {
            formData.append("files[]", $('#fileElem')[0].files[i]);
          }

          $.ajax({
            url: "../../controller/pedido.php?op=insert_seguidetalle",
            type: "POST",
            data: formData,
            contentType: false,
            processData: false,
            success: function(data){
                console.log(data);
                listardetalle(id_pedido);
                $('#fileElem').val('');
                $('#segui_descripcion').summernote('reset');
                swal("Correcto!", "Registrado Correctamente", "success");
            } 
            
        });  
    }
});

function listardetalle(id_pedido){  

    $.post("../../controller/pedido.php?op=listardetalle", { id_pedido : id_pedido }, function (data) {
        $('#lbldetalle').html(data);
    }); 

    $.post("../../controller/pedido.php?op=mostrar", { id_pedido : id_pedido }, function (data) {
      data = JSON.parse(data);
      console.log(data);        
       $('#lblid_pedido').html("Seguimiento  Pedido "+data.serie_pedido);
       $('#id_pedido').val(data.id_pedido); 
       $('#serie_pedido').val(data.serie_pedido);
       $('#moneda').val(data.moneda);
       $('#id_cliente').val(data.id_cliente);  
       $('#nro_doc').val(data.nro_doc);
       $('#nom_cli').val(data.nom_cli);
       $('#direc_cli').val(data.direc_cli);
       $('#fecha_emision').val(data.fecha_emision);       
       $('#contacto').val(data.contacto);
       $('#telf_contacto').val(data.telf_contacto);
       $('#dire_entrega').val(data.dire_entrega);        
       $('#id_demision').val(data.id_demision);
       $('#id_fpago').val(data.descripcion);
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
       $('#fpago').val(data.descripcion);
       $('#modalidad').val(data.modalidad);
       $('#demision').val(data.documento); 
       $('#total_pagar').text(data.sub_total);  
       $('#igv').text(data.igv);
       $('#total_final').text(data.total); 
  
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
            '<td class="text-center"><a href="#" class="btn btn-sm btn-icon btnEditar btn-warning"><i class="fa fa-pencil"></i></a></td>' +
            '</tr>';      
            $('#detalle_ped').append(fila);
  
      // Almacenar el valor de cant_limpieza en el array
      cantidadesLimpieza.push(detalle.cant_limpieza);
      });
  
     
      });
  
    });
  }
  

init();
