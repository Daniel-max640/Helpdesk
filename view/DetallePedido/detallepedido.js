function init(){
   
}

$(document).ready(function(){
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
        $('#nro_doc').val(data.nro_doc);
        $('#nom_cli').val(data.nom_cli);
        $('#direc_cli').val(data.direc_cli);
        $('#lblid_pedido').html("Editar Pedido "+data.serie_pedido);
        $('#contacto').val(data.contacto);
        $('#telf_contacto').val(data.telf_contacto);
        $('#dire_entrega').val(data.dire_entrega);

    });
}


init();
