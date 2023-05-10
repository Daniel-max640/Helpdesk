<?php
    require_once("../config/conexion.php");
    require_once("../models/Pedido.php");
    $pedido = new Pedido();

    require_once("../models/Usuario.php");
    $usuario = new Usuario();

    require_once("../models/Cliente.php");
    $cliente = new Cliente();


    switch($_GET["op"]){

        case "generaryeditar":
             // Obtener los datos del formulario o de la solicitud
        if(empty($_POST["id_pedido"])){
        $pedido->insert_pedido(
        $_POST["usu_id"],
        $_POST["id_cliente"],
        $_POST["nro_doc"],
        $_POST["direc_cli"],
        $_POST["nom_cli"],
        $_POST["orden_compra"],
        $_POST["serie_pedido"],
        $_POST["moneda"],
        $_POST["id_modalidad"],
        $_POST["contacto"],
        $_POST["telf_contacto"],
        $_POST["dire_entrega"],
        $_POST["id_emision"],
        $_POST["asesor"],
        $_POST["id_fpago"],
        $_POST["fecha_entrega"],
        $_POST["sub_total"],
        $_POST["igv"],
        $_POST["total"],
        $_POST["observacion"],
        $_POST["conta_factu"],
        $_POST["correo_cfactu"],
        $_POST["telf_cfactu"],
        $_POST["conta_cobra"],
        $_POST["correo_ccobra"],
        $_POST["telf_ccobra"]);
        }
        else {
        $pedido->editar_pedido(
            $_POST["id_pedido"],
            $_POST["usu_id"],
            $_POST["id_cliente"],
            $_POST["nro_doc"],
            $_POST["direc_cli"],
            $_POST["nom_cli"],
            $_POST["orden_compra"],
            $_POST["serie_pedido"],
            $_POST["moneda"],
            $_POST["id_modalidad"],
            $_POST["contacto"],
            $_POST["telf_contacto"],
            $_POST["dire_entrega"],
            $_POST["id_emision"],
            $_POST["asesor"],
            $_POST["id_fpago"],
            $_POST["fecha_entrega"],
            $_POST["sub_total"],
            $_POST["igv"],
            $_POST["total"],
            $_POST["observacion"],
            $_POST["conta_factu"],
            $_POST["correo_cfactu"],
            $_POST["telf_cfactu"],
            $_POST["conta_cobra"],
            $_POST["correo_ccobra"],
            $_POST["telf_ccobra"]);
        }     

        break;
        
        case "buscarCli":           
        $datos=$cliente->buscarCliente($_POST["nro_doc"]);  
        if(is_array($datos)==true and count($datos)>0){
             foreach($datos as $row)
             {
                  $output["id_cliente"] = $row["id_cliente"];
                  $output["nom_cli"] = $row["nom_cli"];
                  $output["direc_cli"] = $row["direc_cli"];                  
                  $output["contacto_cli"] = $row["contacto_cli"];
                  $output["contacto_telf"] = $row["contacto_telf"];
                  $output["correo_cli"] = $row["correo_cli"];
                
               }                
              echo json_encode($output);             
         }   
        break;       

        case "listar":
            $datos=$pedido->listar_pedido();
            $data= Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array[] = $row["id_pedido"];
                $sub_array[] = $row["fecha_emision"];
                $sub_array[] = $row["fecha_entrega"];
                $sub_array[] = $row["usu_nom"];
                $sub_array[] = $row["nom_cli"];
                $sub_array[] = $row["dire_entrega"];
                $sub_array[] = $row["descripcion"];
                $sub_array[] = $row["total"];
                
                
                /*if ($row["tick_estado"]=="Abierto"){
                    $sub_array[] = '<span class="label label-pill label-success">Abierto</span>';
                }else{
                    $sub_array[] = '<a onClick="CambiarEstado('.$row["tick_id"].')"><span class="label label-pill label-danger">Cerrado</span><a>';
                }

                $sub_array[] = date("d/m/Y H:i:s", strtotime($row["fech_crea"]));

                if($row["fech_asig"]==null){
                    $sub_array[] = '<span class="label label-pill label-default">Sin Asignar</span>';
                }else{
                    $sub_array[] = date("d/m/Y H:i:s", strtotime($row["fech_asig"]));
                }

                if($row["fech_cierre"]==null){
                    $sub_array[] = '<span class="label label-pill label-default">Sin Cerrar</span>';
                }else{
                    $sub_array[] = date("d/m/Y H:i:s", strtotime($row["fech_cierre"]));
                }

                if($row["usu_asig"]==null){
                    $sub_array[] = '<a onClick="asignar('.$row["tick_id"].');"><span class="label label-pill label-warning">Sin Asignar</span></a>';
                }else{
                    $datos1=$usuario->get_usuario_x_id($row["usu_asig"]);
                    foreach($datos1 as $row1){
                        $sub_array[] = '<span class="label label-pill label-success">'. $row1["usu_nom"].'</span>';
                    }
                }
                */
                $sub_array[] = '<button type="button" onClick="ver('.$row["id_pedido"].');"  id="'.$row["id_pedido"].'" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>';
                $sub_array[] = '<button type="button" onClick="facturar('.$row["id_pedido"].');"  id="'.$row["id_pedido"].'" class="btn btn-inline btn-primary btn-sm ladda-button"><i class="fa fa-eye"></i></button>';
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