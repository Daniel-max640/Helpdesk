<?php
    /* TODO:Cadena de Conexion */
    require_once("../config/conexion.php");
    /* TODO:Modelo Prioridad */
    require_once("../models/Correo.php");
    $correo = new Correo();

    /*TODO: opciones del controlador Prioridad*/
    switch($_GET["op"]){
        /* TODO: Guardar y editar, guardar si el campo prio_id esta vacio */
        case "guardaryeditar":
            if(empty($_POST["id_correo"])){       
                $correo->insert_correo($_POST["correo"],$_POST["contraseña"],$_POST["usu_id"]);     
            }
            else {
                $correo->update_prioridad($_POST["id_correo"],$_POST["contraseña"],$_POST["usu_id"]);
            }
            break;

        /* TODO: Listado de prioridad segun formato json para el datatable */
        case "listar":
            $datos=$correo->get_correo();
            $data= Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array[] = $row["id_correo"];
                $sub_array[] = $row["correo"];
                $sub_array[] = $row["contraseña"];
                $sub_array[] = $row["usu_id"];
                $sub_array[] = $row["asignado"];
                $sub_array[] = '<button type="button" onClick="editar('.$row["id_correo"].');"  id="'.$row["id_correo"].'" class="btn btn-inline btn-warning btn-sm ladda-button"><i class="fa fa-edit"></i></button>';
                $sub_array[] = '<button type="button" onClick="eliminar('.$row["id_correo"].');"  id="'.$row["id_correo"].'" class="btn btn-inline btn-danger btn-sm ladda-button"><i class="fa fa-trash"></i></button>';
                $data[] = $sub_array;
            }
            $results = array(
                "sEcho"=>1,
                "iTotalRecords"=>count($data),
                "iTotalDisplayRecords"=>count($data),
                "aaData"=>$data);
            echo json_encode($results);
        break;

        /* TODO: Actualizar estado a 0 segun id de prioridad */
        case "eliminar":
            $correo->delete_correo($_POST["id_correo"]);
        break;
        
        /* TODO: Mostrar en formato JSON segun prio_id */
        case "mostrar";
            $datos=$correo->get_correo_x_id($_POST["id_correo"]);
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $output["id_correo"] = $row["id_correo"];
                    $output["correo"] = $row["correo"];
                    $output["contraseña"] = $row["contraseña"];
                    $output["usu_id"] = $row["usu_id"];
                    $output["asignado"] = $row["asignado"];
                }
                echo json_encode($output);
            }
            break;
        /* TODO: Formato para llenar combo en formato HTML */
        case "combo":
            $datos = $id_correo->get_correo();
            $html="";
            $html.="<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_correo']."'>".$row['id_correo']."</option>";
                }
                echo $html;
            }
        break;
    }
?>