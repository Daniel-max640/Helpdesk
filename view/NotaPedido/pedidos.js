var tabla;

function init(){
    $("#usuario_form").on("submit",function(e){
        guardaryeditar(e);	
    });
}

function guardaryeditar(e){
    e.preventDefault();
	var formData = new FormData($("#usuario_form")[0]);
    $.ajax({
        url: "../../controller/usuario.php?op=guardaryeditar",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(datos){           
            $('#usuario_form')[0].reset();
            $("#modalmantenimiento").modal('hide');
            $('#usuario_data').DataTable().ajax.reload();
            swal({
                title: "HelpDesk!",
                text: "Completado.",
                type: "success",
                confirmButtonClass: "btn-success"
            });
        }
    }); 
}

$(document).ready(function(){
    tabla=$('#pedido_data').dataTable({
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
            url: '../../controller/pedido.php?op=listar',
            type : "post",
            dataType : "json",						
            error: function(e){
                console.log(e.responseText);	
            }
        },
        "bDestroy": true,
        "responsive": true,
        "bInfo":true,
        "iDisplayLength": 10,
        //Ordenamiento mostrando los ultimos registro en el table
        "autoWidth": false,
        "order": [[0, 'desc']],
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


$(document).on("click","#btnnuevo", function(){ 
    window.open('http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/');
    //  window.open('https://sanipperuerp.000webhostapp.com//view/GenerarPedido/');
});

function opcionSeleccionada(opcion, id_pedido) {
    if (opcion === 'editar') {
        // Lógica para la opción "Editar"
        window.open('http://localhost/Tutorial_Helpdesk-main/view/DetallePedido/?IDs='+ id_pedido +'');    
    } else if (opcion === 'anular') {
        // Lógica para la opción "Anular"
        swal({
            title: "HelpDesk",
            text: "Esta seguro de Anular el Pedido?",
            type: "warning",
            showCancelButton: true,
            confirmButtonClass: "btn-warning",
            confirmButtonText: "Si",
            cancelButtonText: "No",
            closeOnConfirm: false
        },
        function(isConfirm) {
         if (isConfirm) {
            $.post("../../controller/pedido.php?op=update", {opcion : opcion,id_pedido : id_pedido}, function (data) {
       
            });
            
            $.post("../../controller/pedido.php?op=updateest", {opcion : opcion,id_pedido : id_pedido}, function (data) {
       
            })
            	

            $('#pedido_data').DataTable().ajax.reload();	

            swal({
                title: "HelpDesk!",
                text: "Pedido Anulado.",
                type: "success",
                confirmButtonClass: "btn-success"
            });
        }
    });
    } else if (opcion === 'seguimiento') {
         // Lógica para la opción "Editar"
         window.open('http://localhost/Tutorial_Helpdesk-main/view/SeguimientoPedidos/?IDs='+ id_pedido +'');    
    } else {

    }
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
init();