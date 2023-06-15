<?php
    /* llamada a las clases necesarias */
    require_once("../config/conexion.php");
    require_once("../models/Documentopedido.php");
    $documentopedido = new Documentopedido();
    /* opciones del controlador */
    switch($_GET["op"]){
        /* manejo de json para poder listar en el datatable, formato de json segun documentacion */
        case "listar":
            $datos=$documentopedido->get_documento_x_pedido($_POST["id_pedido"]);
            $data= Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array[] = '<a href="../../public/pedido/'.$_POST["id_pedido"].'/'.$row["doc_nombre"].'" target="_blank">'.$row["doc_nombre"].'</a>';
                $sub_array[] = '<a type="button" href="../../public/pedido/'.$_POST["id_pedido"].'/'.$row["doc_nombre"].'" target="_blank" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></a>';
                $data[] = $sub_array;
            }
            $results = array(
                "sEcho"=>1,
                "iTotalRecords"=>count($data),
                "iTotalDisplayRecords"=>count($data),
                "aaData"=>$data);
            echo json_encode($results);
        break;
    }
?>
