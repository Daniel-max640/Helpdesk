<?php
    /* TODO:Cadena de Conexion */
    require_once("../config/conexion.php");
    require_once("../models/Usuario.php");
    $usuario = new Usuario();

    require_once("../models/Correo.php");
    $correo = new Correo();

    /*TODO: opciones del controlador Prioridad*/
    switch($_GET["op"]){
        /* TODO: Guardar y editar, guardar si el campo prio_id esta vacio */
        case "guardaryeditar":
            if(empty($_POST["id_correo"])){       
                $correo->insert_correo($_POST["correo"],$_POST["contrasena"],$_POST["usu_id"]);     
            }
            else {
                $correo->update_correo($_POST["id_correo"],$_POST["correo"],$_POST["contrasena"],$_POST["usu_id"]);
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
                $sub_array[] = $row["contrasena"];                
                if($row["usu_id"]==null){
                    $sub_array[] = '<a onClick="asignar('.$row["id_correo"].');"><span class="label label-pill label-warning">Sin Asignar</span></a>';
                }else{
                    $datos1=$usuario->get_usuario_x_id($row["usu_id"]);
                    foreach($datos1 as $row1){
                        $sub_array[] = '<span class="label label-pill label-success">'. $row1["usu_nom"].'</span>';
                    }
                }
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
                    $output["contrasena"] = $row["contrasena"];
                    $output["usu_id"] = $row["usu_id"];                    
                }
                echo json_encode($output);
            }
            break;

            case "combo";
            $datos = $usuario->get_usuario();
            $html="";
            if(is_array($datos)==true and count($datos)>0){
                $html.= "<option label='Seleccionar'></option>";
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['usu_id']."'>".$row['usu_nom']."</option>";
                }
                echo $html;
            }
            break;

    }
?>