<?php
    require_once("../config/conexion.php");
    require_once("../models/Pedido.php");
    $pedido = new Pedido();

    require_once("../models/Usuario.php");
    $usuario = new Usuario();
    require_once("../models/Tservicio.php");
    $tservicio = new Tservicio();

    require_once("../models/Cliente.php");
    $cliente = new Cliente();
    switch($_GET["op"]){
        case "generaryeditar":
        // Obtener los datos del formulario o de la solicitud
        if(empty($_POST["id_pedido"])){
        $detalle_ped = json_decode($_POST["productos"], true);
        $datos=$pedido->insert_pedido(
        $_POST["usu_id"],
        $_POST["id_cliente"],
        $_POST["nro_doc"],
        $_POST["direc_cli"],
        $_POST["nom_cli"],
        $_POST["serie_pedido"],
        $_POST["moneda"],
        $_POST["id_modalidad"],
        $_POST["contacto"],
        $_POST["telf_contacto"],
        $_POST["dire_entrega"],
        $_POST["id_demision"],
        $_POST["asesor"],
        $_POST["id_fpago"],
        $_POST["fecha_entrega"],
        $_POST["total_pagar"],
        $_POST["igv"],
        $_POST["total_final"],
        $_POST["tickd_requi"],
        $_POST["conta_factu"],
        $_POST["correo_cfactu"],
        $_POST["telf_cfactu"],
        $_POST["conta_cobra"],
        $_POST["correo_ccobra"],
        $_POST["telf_ccobra"],
        $detalle_ped);        
        }
        else {
        $detalle_ped = json_decode($_POST["productos"], true);
        $datos = $pedido->editar_pedido(
            $_POST["id_pedido"],
            $_POST["usu_id"],
            $_POST["id_cliente"],
            $_POST["nro_doc"],
            $_POST["direc_cli"],
            $_POST["nom_cli"],
            $_POST["serie_pedido"],
            $_POST["moneda"],
            $_POST["id_modalidad"],
            $_POST["contacto"],
            $_POST["telf_contacto"],
            $_POST["dire_entrega"],
            $_POST["id_demision"],
            $_POST["asesor"],
            $_POST["id_fpago"],
            $_POST["fecha_entrega"],
            $_POST["total_pagar"],
            $_POST["igv"],
            $_POST["total_final"],
            $_POST["tickd_requi"],
            $_POST["conta_factu"],
            $_POST["correo_cfactu"],
            $_POST["telf_cfactu"],
            $_POST["conta_cobra"],
            $_POST["correo_ccobra"],
            $_POST["telf_ccobra"],
            $detalle_ped
            );
        }
        echo json_encode($datos);

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
                $sub_array[] = $row["serie_pedido"];
                $sub_array[] = $row["descripcion"];
                $sub_array[] = $row["total"];              
                $sub_array[] = '<button type="button" onClick="editapedido('.$row["id_pedido"].');"  id="'.$row["id_pedido"].'" class="btn btn-inline btn-danger btn-sm ladda-button"><i class="fa fa-pencil"></i></button>';              
                $data[] = $sub_array;
            }
            $results = array(
                "sEcho"=>1,
                "iTotalRecords"=>count($data),
                "iTotalDisplayRecords"=>count($data),
                "aaData"=>$data);
            echo json_encode($results);
        break;

        case "mostrar":
            $datos=$pedido->listar_pedido_x_id ($_POST["id_pedido"]); 
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $output["id_pedido"] = $row["id_pedido"];
                    $output["id_cliente"] = $row["id_cliente"];
                    $output["nro_doc"] = $row["nro_doc"];
                    $output["direc_cli"] = $row["direc_cli"];
                    $output["nom_cli"] = $row["nom_cli"];
                    $output["serie_pedido"] = $row["serie_pedido"];
                    $output["moneda"] = $row["moneda"];
                    $output["id_modalidad"] = $row["id_modalidad"];
                    $output["contacto"] = $row["contacto"];
                    $output["telf_contacto"] = $row["telf_contacto"];
                    $output["dire_entrega"] = $row["dire_entrega"];
                    $output["id_demision"] = $row["id_demision"];
                    $output["asesor"] = $row["asesor"];
                    $output["id_fpago"] = $row["id_fpago"];
                    $output["fecha_entrega"] = $row["fecha_entrega"];
                    $output["sub_total"] = $row["sub_total"];
                    $output["igv"] = $row["igv"];
                    $output["total_final"] = $row["total"];
                    $output["tickd_requi"] = $row["observacion"];
                    $output["conta_factu"] = $row["conta_factu"];
                    $output["correo_cfactu"] = $row["correo_cfactu"];
                    $output["telf_cfactu"] = $row["telf_cfactu"];
                    $output["conta_cobra"] = $row["conta_cobra"];
                    $output["correo_ccobra"] = $row["correo_ccobra"];
                    $output["telf_ccobra"] = $row["telf_ccobra"];                    
                    $output["detalles"] = [];

                    $detalles = $pedido->listar_detalle_pedido($_POST["id_pedido"]);
                    if (is_array($detalles) && count($detalles) > 0) {
                        foreach ($detalles as $detalle) {
                            $detalles_pedido = [
                                "id_servicio" => $detalle["id_servicio"],
                                "descripcion" => $detalle["descripcion"],
                                "U_medida" => $detalle["U_medida"],
                                "cantidad" => $detalle["cantidad"],
                                "precio_uni" => $detalle["precio_uni"],
                                "total" => $detalle["total"],
                                "cant_limpieza" => $detalle["cant_limpieza"]
                            ];

                            $output["detalles"][] = $detalles_pedido;
                        }
                    }
                }                
                    echo json_encode($output);
            }
            break;

                            
        }
?>