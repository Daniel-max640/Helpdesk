<?php
    require_once("../config/conexion.php");
    require_once("../models/Cliente.php");
    $cliente = new Cliente();

    switch($_GET["op"]){
       
        case "listar":
            $datos=$cliente->get_cliente();
            $data= Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array[] = $row["id_cliente"];
                $sub_array[] = $row["nom_tipdoc"];
                $sub_array[] = $row["nro_doc"];
                $sub_array[] = $row["nom_cli"];
                $sub_array[] = $row["direc_cli"];
                $sub_array[] = $row["ubigeo"];

                $sub_array[] = '<button type="button" onClick="editar('.$row["id_cliente"].');"  id="'.$row["id_cliente"].'" class="btn btn-inline btn-warning btn-sm ladda-button"><i class="fa fa-edit"></i></button>';
                $sub_array[] = '<button type="button" onClick="eliminar('.$row["id_cliente"].');"  id="'.$row["id_cliente"].'" class="btn btn-inline btn-danger btn-sm ladda-button"><i class="fa fa-trash"></i></button>';
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