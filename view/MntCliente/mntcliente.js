var tabla;
var modo;
function init(){
    $("#cliente_form").on("submit",function(e){
        guardaryeditar(e);	
    });
}

function guardaryeditar(e){
    e.preventDefault();
	var formData = new FormData($("#cliente_form")[0]);
    var tipo_doc = $("#tipodoc_id").val();
    //var tipo_doc = formData.get('tipo_doc');
    var longitud_requerida = 0; // Inicializar con longitud requerida en 0
    if (tipo_doc === '1') {
        longitud_requerida = 11; // Establecer longitud requerida para tipo1
    } else if (tipo_doc === '2') {
        longitud_requerida = 8; // Establecer longitud requerida para tipo2
    } 
    
    var nro_doc = formData.get('nro_doc');
    if (!/^\d+$/.test(nro_doc)) {
        swal("Advertencia!","El número de documento debe ser numérico.","warning");
        return; // Salir de la función si hay un error de validación
    }

    // Verificar la longitud requerida solo si el tipo de documento es 1 o 2
    if ((tipo_doc === '1' || tipo_doc === '2') && nro_doc.length !== longitud_requerida) {
        swal("Advertencia!","El número de documento debe tener " + longitud_requerida + " dígitos para el tipo de documento seleccionado.","warning");
        return; // Salir de la función si hay un error de validación
    }

    $.ajax({
        url: "../../controller/cliente.php?op=guardaryeditar",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        // parte de este codigo me recupera los mensajes del servidor 
        //y lo imprime en la interfaz
        success: function (datos) {
            if (datos.includes("Error al insertar el cliente")) {
                swal({
                    title: "Error!",
                    text: datos,
                    type: "error",
                    confirmButtonClass: "btn-danger"
                });
            } else {
                $('#nro_doc').val('');
                $('#cliente_form')[0].reset();
                $("#modalmantecliente").modal('hide');
                $('#cliente_data').DataTable().ajax.reload();
        
                swal({
                    title: "HelpDesk!",
                    text: "Cliente Insertado Correctamente.",
                    type: "success",
                    confirmButtonClass: "btn-success"
                });
            }
        },
        error: function (xhr, ajaxOptions, thrownError) {
            swal({
                title: "Error!",
                text: "Ha ocurrido un error al procesar la solicitud.",
                type: "error",
                confirmButtonClass: "btn-danger"
            });
        }
     
    });
}

$(document).ready(function(){
    tabla=$('#cliente_data').dataTable({
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
            url: '../../controller/cliente.php?op=listar',
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

    $.post("../../controller/tipodoc.php?op=combo",function(data, status){
        $('#tipodoc_id').html(data);
    });

 
    $.post("../../controller/provincia.php?op=combo2", function(data, status) {
        $('#id_provincia').html(data);
     // Limpiar el combo de distrito
    });

    $.post("../../controller/distrito.php?op=combo3", function(data, status) {
        $('#id_distrito').html(data);
     // Limpiar el combo de distrito
    });    

    $("#tipodoc_id").on("change", function() {
        var tipoDocumento = $("#tipodoc_id").val();
        var numeroDocumento = document.getElementById("nro_doc");
        if (tipoDocumento === "1") {
            numeroDocumento.setAttribute("maxlength", "11");
          } else if (tipoDocumento === "2") {
            numeroDocumento.setAttribute("maxlength", "8");
          } else if (tipoDocumento === "3") {
            numeroDocumento.setAttribute("maxlength", "20");
          } else if (tipoDocumento === "4") {
            numeroDocumento.setAttribute("maxlength", "20");  
          }
          numeroDocumento.value = "";  
    });    
});

function cargarProvinciasYDistritos() {

    $.post("../../controller/departamento.php?op=combo",function(data, status){
        $('#id_departamento').html(data);
    });
    // Cargar provincias según el departamento seleccionado
    $("#id_departamento").on("change", function() {
        var id_departamento = $(this).val();
        $.post("../../controller/provincia.php?op=combo", {id_departamento: id_departamento}, function(data, status) {
            $('#id_provincia').html(data);
           // Limpiar el combo de distrito
        });
    });

    //  $('#id_distrito').html('<option value=""></option>');
    // Cargar distritos según la provincia seleccionada
    $("#id_provincia").on("change", function() {
        var id_provincia = $(this).val();
        $.post("../../controller/distrito.php?op=combo", {id_provincia: id_provincia}, function(data, status) {
            $('#id_distrito').html(data);            
        });
    });
}

function editar(id_cliente){     
    cargarProvinciasYDistritos();
    $('#mdltitulo').html('Editar Cliente');        
    $('#modalmantecliente').modal('show');
        $.post("../../controller/cliente.php?op=mostrarcliente", {id_cliente : id_cliente}, function (data) {
            data = JSON.parse(data);
            $('#id_cliente').val(data.id_cliente);
            $('#tipodoc_id').val(data.tipodoc_id);
            $('#nro_doc').val(data.nro_doc);
            $('#nom_cli').val(data.nom_cli);
            $('#direc_cli').val(data.direc_cli);
            $('#id_departamento').val(data.id_departamento);
            $('#id_provincia').val(data.id_provincia);
            $('#id_distrito').val(data.id_distrito);
            $('#tele_cli').val(data.tele_cli);
            $('#correo_cli').val(data.correo_cli);
            $('#contacto_telf').val(data.contacto_telf);
            $('#contacto_cli').val(data.contacto_cli);     
            console.log(data);         
                
         })         
}

$(document).on("click","#btnnuevo", function(){
    cargarProvinciasYDistritos();
    $('#id_cliente').val('');
    $('#mdltitulo').html('Nuevo Registro');
    $('#cliente_form')[0].reset();
    $('#modalmantecliente').modal('show');
  
});

// Validación numérica para el campo1
$("#tele_cli").on("input", function() {
    var valor = $(this).val();
    if (isNaN(valor)) {
      // Si no es un número, puedes hacer algo, como mostrar un mensaje de error
      $("#campo1-error").text("Por favor, ingrese solo valores numéricos en el telefono del Cliente.").show();
    } else {
      // Si es un número, oculta el mensaje de error si estaba visible
      $("#campo1-error").hide();      
    }
});
  
  // Validación numérica para el campo2
$("#contacto_telf").on("input", function() {
    var valor = $(this).val();
    if (isNaN(valor)) {
     // Si no es un número, puedes hacer algo, como mostrar un mensaje de error
     $("#campo1-error2").text("Por favor, ingrese solo valores numéricos en el telefono del Contacto.").show();
    } else {
     // Si es un número, oculta el mensaje de error si estaba visible
     $("#campo1-error2").hide();        
    }
});

function eliminar(id_cliente){
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
            $.post("../../controller/cliente.php?op=eliminar", {id_cliente : id_cliente}, function (data) {

            }); 

            $('#cliente_data').DataTable().ajax.reload();	

            swal({
                title: "HelpDesk!",
                text: "Registro Eliminado.",
                type: "success",
                confirmButtonClass: "btn-success"
            });
        }
    });
}


init();