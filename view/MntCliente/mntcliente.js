var tabla;

function init(){
    $("#cliente_form").on("submit",function(e){
        guardaryeditar(e);	
    });
}

function guardaryeditar(e){
    e.preventDefault();
	var formData = new FormData($("#cliente_form")[0]);
    $.ajax({
        url: "../../controller/cliente.php?op=guardaryeditar",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(datos){    
            
            $('#cliente_form')[0].reset();
            $("#modalmantecliente").modal('hide');
            $('#cliente_data').DataTable().ajax.reload();

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


    $.post("../../controller/departamento.php?op=combo",function(data, status){
        $('#id_departamento').html(data);
    });

    $("#id_departamento").change(function(){
        id_departamento = $(this).val();
        $.post("../../controller/provincia.php?op=combo",{id_departamento : id_departamento},function(data, status){
            console.log(id_departamento);
            $('#id_provincia').html(data);
        });

    });

    $("#id_provincia").change(function(){
        id_provincia = $(this).val();
        $.post("../../controller/distrito.php?op=combo",{id_provincia : id_provincia},function(data, status){
            console.log(id_provincia);
            $('#id_distrito').html(data);
            
        });

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


$(document).on("click","#btnnuevo", function(){
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
      $("#campo1-error2").text("Por favor, ingrese solo valores numéricos en el telefono del Cliente.").show();
    } else {
        // Si es un número, oculta el mensaje de error si estaba visible
        $("#campo1-error2").hide();
        
      }
    });

  


init();