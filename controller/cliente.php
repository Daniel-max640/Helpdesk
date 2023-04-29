<?php
    require_once("../config/conexion.php");
    require_once("../models/Cliente.php");
    $cliente = new Cliente();

    switch($_GET["op"]){
       
        case "guardaryeditar":
            if(empty($_POST["id_cliente"])){              
                $resultado = $cliente->insert_cliente($_POST["tipodoc_id"],$_POST["nro_doc"],$_POST["nom_cli"],$_POST["direc_cli"],$_POST["id_departamento"],$_POST["id_provincia"],$_POST["id_distrito"],$_POST["tele_cli"],$_POST["correo_cli"],$_POST["contacto_telf"],$_POST["contacto_cli"]);     
                if ($resultado) {
                    // El cliente se insertó correctamente
                    echo "Cliente insertado correctamente.";
                } else {
                    // Error al insertar el cliente
                    echo "Error al insertar el cliente.";
                }
            }
            else {
                $cliente->update_cliente($_POST["id_cliente"],$_POST["tipodoc_id"],$_POST["nro_doc"],$_POST["nom_cli"],$_POST["direc_cli"],$_POST["id_departamento"],$_POST["id_provincia"],$_POST["id_distrito"],$_POST["tele_cli"],$_POST["correo_cli"],$_POST["contacto_telf"],$_POST["contacto_cli"]);
            }
        break;
         

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

        case "mostrarcliente";
        $datos=$cliente->get_cliente_x_id($_POST["id_cliente"]);  
        if(is_array($datos)==true and count($datos)>0){
             foreach($datos as $row)
             {
                  $output["id_cliente"] = $row["id_cliente"];
                  $output["tipodoc_id"] = $row["tipodoc_id"];
                  $output["nro_doc"] = $row["nro_doc"];
                  $output["nom_cli"] = $row["nom_cli"];
                  $output["direc_cli"] = $row["direc_cli"];
                  $output["id_departamento"] = $row["id_departamento"];
                  $output["id_provincia"] = $row["id_provincia"];
                  $output["id_distrito"] = $row["id_distrito"];
                  $output["tele_cli"] = $row["tele_cli"];
                  $output["correo_cli"] = $row["correo_cli"];
                  $output["contacto_telf"] = $row["contacto_telf"];
                  $output["contacto_cli"] = $row["contacto_cli"];
               }
                
              echo json_encode($output);
             
         }   
         break;

        case "eliminar":
            $cliente->delete_cliente($_POST["id_cliente"]);
        break;

      
        
    }
?>