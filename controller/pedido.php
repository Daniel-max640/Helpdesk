<?php
    require_once("../config/conexion.php");

    require_once("../models/Pedido.php");
    $pedido = new Pedido();

    require_once("../models/Usuario.php");
    $usuario = new Usuario();

    require_once("../models/Tservicio.php");
    $tservicio = new Tservicio();

    require_once("../models/Documentopedido.php");
    $documentopedido = new Documentopedido();

    require_once("../models/Cliente.php");
    $cliente = new Cliente();
    switch($_GET["op"]){
        case "generaryeditar":
        // Obtener los datos del formulario o de la solicitud
        $detalle_ped = json_decode($_POST["productos"], true);

        // Verificar si la forma de pago es crédito o alguna otra forma de pago que requiere estado pendiente
        if ($_POST["id_fpago"] == 2 || $_POST["id_fpago"] == 5 || $_POST["id_fpago"] == 10 || $_POST["id_fpago"] == 13) {
            $estado_pago = "Pendiente";
        } else {
            $estado_pago = "Pagado";
        }
        if(empty($_POST["id_pedido"])){       
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
        $_POST["cotizacion"],
        $_POST["link"],
        $_POST["cierre_facturacion"],
        $_POST["fecha_pago"],
        $_POST["acceso_portal"],
        $_POST["entrega_factura"],
        $estado_pago,
        $_POST["orden_compra"],
        $detalle_ped
       ); 
       //recupero el ultimo id_generado
        $last_inserted_id = $datos;
        if (!empty($_FILES['files']['name'])) {
            $ruta = "../public/pedido/" . $last_inserted_id . "/";
            if (!file_exists($ruta)) {
               mkdir($ruta, 0777, true);
            }        
            // Manejar los archivos adjuntos       
            $countfiles = count($_FILES['files']['name']);
            for ($index = 0; $index < $countfiles; $index++) {
                $doc1 = $_FILES['files']['tmp_name'][$index];
                $destino = $ruta . $_FILES['files']['name'][$index];
                move_uploaded_file($doc1, $destino);
                // Insertar información del archivo en la tabla Documentopedido
                $documentopedido->insert_docpedido($last_inserted_id, $_FILES['files']['name'][$index]);
            }
        }
        } else {
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
            $_POST["cotizacion"],
            $_POST["link"],
            $_POST["cierre_facturacion"],
            $_POST["fecha_pago"],
            $_POST["acceso_portal"],
            $_POST["entrega_factura"],
            $estado_pago,
            $_POST["orden_compra"],
            $detalle_ped
            );
        }
        echo json_encode($datos);
        break;

        case "update":
            $pedido->update_pedido($_POST["id_pedido"]);
        break;

        case "updateest":
            $pedido->update_estpedido($_POST["id_pedido"]);
        break;       

        case "listar":
            $datos=$pedido->listar_pedido();
            $data= Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array[] = $row["id_pedido"];
                $sub_array[] = $row["fecha_emision"];
                $sub_array[] = $row["fecha_entrega"];
                if ($row["estado"]=="Registrado"){
                    $sub_array[] = '<span class="label label-success">Registrado</span>';
                }else{
                    $sub_array[] = '<span class="label label-danger">Anulado</span></a>';
                }
                $sub_array[] = $row["usu_nom"];
                $sub_array[] = $row["orden_compra"];  
                $sub_array[] = $row["nom_cli"];
                $sub_array[] = $row["serie_pedido"];
                $sub_array[] = $row["descripcion"];               
                $sub_array[] = $row["total"];
                if ($row["estado_pago"]=="Pendiente"){
                    $sub_array[] = '<span class="label label-warning">Pendiente</span>';
                } elseif ($row["estado_pago"] == "Pagado") {
                    $sub_array[] = '<span class="label label-info">Pagado</span>';
                } elseif ($row["estado_pago"] == "Anulado") {
                    $sub_array[] = '<span class="label label-danger">Anulado</span>';
                }
                //$sub_array[] = '<button type="button" onClick="editapedido('.$row["id_pedido"].');"  id="'.$row["id_pedido"].'" class="btn btn-inline btn-danger btn-sm ladda-button"><i class="fa fa-pencil"></i></button>';              
                $opciones = '<div class="dropdown">';
                $opciones .= '<button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
                $opciones .= 'Acciones';
                $opciones .= '</button>';
                $opciones .= '<div class="dropdown-menu" aria-labelledby="dropdownMenu1">';
                $opciones .= '<a class="dropdown-item" href="#" onclick="opcionSeleccionada(\'editar\', '.$row["id_pedido"].')">Editar</a>';
                $opciones .= '<a class="dropdown-item" href="#" onclick="opcionSeleccionada(\'anular\', '.$row["id_pedido"].')">Anular</a>';
                $opciones .= '<a class="dropdown-item" href="#" onclick="opcionSeleccionada(\'seguimiento\', '.$row["id_pedido"].')">Seguimiento</a>';
                // Agrega más opciones según tus necesidades
                $opciones .= '</div>';
                $opciones .= '</div>';
        
                $sub_array[] = $opciones;
                $data[] = $sub_array;
            }
            $results = array(
                "sEcho"=>1,
                "iTotalRecords"=>count($data),
                "iTotalDisplayRecords"=>count($data),
                "aaData"=>$data);
            echo json_encode($results);
        break;

        case "listardetalle":
            $datos=$pedido->listar_seguimiento_x_pedido($_POST["id_pedido"]);
            ?>
                <?php
                    foreach($datos as $row){
                        ?>
                            <article class="activity-line-item box-typical">
                                <div class="activity-line-date">
                                    <?php echo date("d/m/Y", strtotime($row["fecha_crea"]));?>
                                </div>
                                <header class="activity-line-item-header">
                                    <div class="activity-line-item-user">
                                        <div class="activity-line-item-user-photo">
                                            <a href="#">
                                                <img src="../../public/<?php echo $row['rol_id'] ?>.jpg" alt="">
                                            </a>
                                        </div>
                                        <div class="activity-line-item-user-name"><?php echo $row['usu_nom'].' '.$row['usu_ape'];?></div>
                                        <div class="activity-line-item-user-status">
                                            <?php 
                                                if ($row['rol_id']==1){
                                                    echo 'Usuario';
                                                }else{
                                                    echo 'Soporte';
                                                }
                                            ?>
                                        </div>
                                    </div>
                                </header>
                                <div class="activity-line-action-list">
                                    <section class="activity-line-action">
                                        <div class="time"><?php echo date("H:i:s", strtotime($row["fecha_crea"]));?></div>
                                        <div class="cont">
                                            <div class="cont-in">
                                                <p>
                                                    <?php echo $row["segui_descripcion"];?>
                                                </p>
                                                <br>
                                                <?php
                                                    $datos_seg=$documentopedido->get_documento_x_id_seguimiento($row["id_seguimiento"]);
                                                    if(is_array($datos_seg)==true and count($datos_seg)>0){
                                                        ?>
                                                            <p><strong>Documentos Adicionales</strong></p>

                                                            <p>
                                                                <table class="table table-bordered table-striped table-vcenter js-dataTable-full">
                                                                    <thead>
                                                                        <tr>
                                                                            <th style="width: 60%;">Nombre</th>
                                                                            <th style="width: 40%;"></th>

                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <?php
                                                                            foreach ($datos_seg as $row_det){                                                                           
                                                                        ?>
                                                                        <tr>
                                                                            <td><?php echo $row_det["docsegui_nom"]; ?></td>
                                                                            <td>
                                                                                <a href="../../public/doc_seguimiento/<?php echo $row_det["id_seguimiento"]; ?>/<?php echo $row_det["docsegui_nom"]; ?>" target="_blank" class="btn btn_inline btn-primary btn-sm">Ver</a>
                                                                            </td> 
                                                                        </tr>    
                                                                        <?php
                                                                             }
                                                                        ?>                                                                    </tbody>
                                                                </table>
                                                            </p>
                                                        <?php    
                                                    }
                                                ?>
                                            </div>
                                        </div>
                                    </section>
                                </div>
                            </article>
                        <?php
                    }
                ?>
            <?php
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
                    $output["fecha_emision"] = $row["fecha_emision"];
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
                    $output["total"] = $row["total"];
                    $output["tickd_requi"] = $row["observacion"];
                    $output["conta_factu"] = $row["conta_factu"];
                    $output["correo_cfactu"] = $row["correo_cfactu"];
                    $output["telf_cfactu"] = $row["telf_cfactu"];
                    $output["conta_cobra"] = $row["conta_cobra"];
                    $output["correo_ccobra"] = $row["correo_ccobra"];
                    $output["telf_ccobra"] = $row["telf_ccobra"];                    
                    $output["cotizacion"] = $row["cotizacion"];
                    $output["link"] = $row["link"];
                    $output["cierre_facturacion"] = $row["cierre_facturacion"];
                    $output["fecha_pago"] = $row["fecha_pago"];
                    $output["acceso_portal"] = $row["acceso_portal"];
                    $output["entrega_factura"] = $row["entrega_factura"];
                    $output["orden_compra"] = $row["orden_compra"];
                    $output["descripcion"] = $row["descripcion"];
                    $output["documento"] = $row["documento"];
                    $output["modalidad"] = $row["modalidad"];
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

            case "insert_seguidetalle":
                $datos=$pedido->insert_seguimiento($_POST["id_pedido"],$_POST["usu_id"],$_POST["segui_descripcion"]);
                if (is_array($datos)==true and count($datos)>0){
                    foreach ($datos as $row){
                        //Obtener  id_seguimiento de $datos
                        $output["id_seguimiento"] = $row["id_seguimiento"];
    
                        //Consultamos si vienen archivos deede la vista
                        if (empty($_FILES['files']['name'])){
    
                        }else{
                            //Contar resgistros
                            $countfiles = count($_FILES['files']['name']);
                            //Ruta de los documentos
                            $ruta = "../public/doc_seguimiento/".$output["id_seguimiento"]."/";
                            //crear array de archivos
                            $files_arr = array();

                            //Consultar si ruta existe en caso sea no, crearla
    
                            if (!file_exists($ruta)) {
                                mkdir($ruta, 0777, true);
                            }
    
                            for ($index = 0; $index < $countfiles; $index++) {
                                $doc1 = $_FILES['files']['tmp_name'][$index];
                                $destino = $ruta.$_FILES['files']['name'][$index];
    
                                $documentopedido->insert_docseguimiento( $output["id_seguimiento"],$_FILES['files']['name'][$index]);
    
                                move_uploaded_file($doc1,$destino);
                            }
                        }
                    }
                }
                echo json_encode($datos);


            break;
            
          
        }
?>