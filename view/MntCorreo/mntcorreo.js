var tabla;

function init(){
    $("#correo_form").on("submit",function(e){
        guardaryeditar(e);	
    });
}

function guardaryeditar(e){   
    e.preventDefault();
	var formData = new FormData($("#correo_form")[0]);
    $.ajax({
        url: "../../controller/correo.php?op=guardaryeditar",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(datos){    
            
            $('#correo_form')[0].reset();
            $("#modalcorreo").modal('hide');
            $('#correo_data').DataTable().ajax.reload();

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

    $.post("../../controller/correo.php?op=combo", function (data) {
        $('#usu_id').html(data);
    });

    tabla=$('#correo_data').dataTable({
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
            url: '../../controller/correo.php?op=listar',
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

function editar(id_correo){
    $('#mdltitulo').html('Editar Registro');

    $.post("../../controller/correo.php?op=mostrar", {id_correo : id_correo}, function (data) {
        data = JSON.parse(data);
        $('#id_correo').val(data.id_correo);
        $('#correo').val(data.correo);
        $('#contrasena').val(data.contrasena);
        $('#usu_id').val(data.usu_id);       
    }); 

    $('#modalcorreo').modal('show');
}

function eliminar(id_correo){
    swal({
        title: "HelpDesk",
        text: "Esta seguro de Eliminar el registro?",
        type: "error",
        showCancelButton: true,
        confirmButtonClass: "btn-danger",
        confirmButtonText: "Si",
        cancelButtonText: "No",
        closeOnConfirm: false
    },
    function(isConfirm) {
        if (isConfirm) {
            $.post("../../controller/correo.php?op=eliminar", {id_correo : id_correo}, function (data) {

            }); 

            $('#correo_data').DataTable().ajax.reload();	

            swal({
                title: "HelpDesk!",
                text: "Registro Eliminado.",
                type: "success",
                confirmButtonClass: "btn-success"
            });
        }
    });
}

$(document).on("click","#btnnuevo", function(){
    $('#id_correo').val('');
    $('#mdltitulo').html('Nuevo Registro');
    $('#correo_form')[0].reset();
    $('#modalcorreo').modal('show');
});

init();