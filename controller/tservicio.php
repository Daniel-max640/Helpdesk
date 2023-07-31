<?php
    require_once("../config/conexion.php");
    require_once("../models/Tservicio.php");
    $tservicio = new Tservicio();

    switch($_GET["op"]){

        case "guardaryeditar":
            if(empty($_POST["id_modalidad"])){       
                $tservicio->insert_tservicio  ($_POST["modalidad"]);     
            }
            else {
                $tservicio->update_tservicio($_POST["id_modalidad"],$_POST["modalidad"]);
            }
        break;

        /* TODO: Listado de servicios segun formato json para el datatable */
        case "listar":
            $datos=$tservicio->get_tservicio();
            $data= Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array[] = $row["modalidad"];
                $sub_array[] = '<button type="button" onClick="editar('.$row["id_modalidad"].');"  id="'.$row["id_modalidad"].'" class="btn btn-inline btn-warning btn-sm ladda-button"><i class="fa fa-edit"></i></button>';
                $sub_array[] = '<button type="button" onClick="eliminar('.$row["id_modalidad"].');"  id="'.$row["id_modalidad"].'" class="btn btn-inline btn-danger btn-sm ladda-button"><i class="fa fa-trash"></i></button>';
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
            $tservicio->delete_tservicio($_POST["id_modalidad"]);
            break;
        
        /* TODO: Mostrar en formato JSON segun prio_id */
        case "mostrar";
            $datos=$tservicio->get_tservicio_x_id($_POST["id_modalidad"]);
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $output["id_modalidad"] = $row["id_modalidad"];
                    $output["modalidad"] = $row["modalidad"];
                }
                echo json_encode($output);
            }
        break;

        case "combo":
            $datos = $tservicio->get_tservicio();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_modalidad']."'>".$row['modalidad']."</option>";
                }
                echo $html;
            }
        break;
    }


?>