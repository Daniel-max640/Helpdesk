function init(){   
}

$(document).ready(function(){
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

function listardetalle(id_pedido){  
    $.post("../../controller/pedido.php?op=mostrar", { id_pedido : id_pedido }, function (data) {
        data = JSON.parse(data);
        console.log(data);
        $('#lblid_pedido').html("Editar Pedido "+data.serie_pedido);   
        $('#nro_doc').val(data.nro_doc);
        $('#nom_cli').val(data.nom_cli);
        $('#direc_cli').val(data.direc_cli);
        $('#id_modalidad').val(data.id_modalidad);
        $('#contacto').val(data.contacto);
        $('#telf_contacto').val(data.telf_contacto);
        $('#dire_entrega').val(data.dire_entrega);        
        $('#id_demision').val(data.id_demision);
        $('#total_pagar').html(data.sub_total);
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
      });

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

init();
