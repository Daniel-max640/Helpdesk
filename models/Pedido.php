<?php
    class Pedido extends Conectar{

        public function insert_pedido($usu_id,$id_cliente,$nro_doc,$direc_cli,$nom_cli,
        $serie_pedido,$moneda,$id_modalidad,$contacto,$telf_contacto,$dire_entrega,
        $id_demision,$asesor,$id_fpago,$fecha_entrega,$sub_total,$igv,$total,$observacion,
        $conta_factu,$correo_cfactu,$telf_cfactu,$conta_cobra,$correo_ccobra,$telf_ccobra,
        $cotizacion,$link,$cierre_facturacion,$fecha_pago,$acceso_portal,$entrega_factura,
        $estado_pago,$orden_compra,$detalles,$manifiestos){
            $conectar= parent::conexion();
            parent::set_names();            
            $sql="INSERT INTO tm_pedido (id_pedido,usu_id,id_cliente,nro_doc,direc_cli,nom_cli,fecha_emision,serie_pedido,moneda,id_modalidad,contacto,telf_contacto,dire_entrega,id_demision,asesor,id_fpago,fecha_entrega,sub_total,igv,total,estado,observacion,conta_factu,correo_cfactu,telf_cfactu,conta_cobra,correo_ccobra,telf_ccobra,est_ped,cotizacion,link,cierre_facturacion,fecha_pago,acceso_portal,entrega_factura,estado_pago,orden_compra) VALUES (NULL,?,?,?,?,?,now(),CONCAT(?, '-', (SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sanip_peru' AND TABLE_NAME = 'tm_pedido')),?,?,?,?,?,?,?,?,?,?,?,?,'Registrado',?,?,?,?,?,?,?,'1',?,?,?,?,?,?,?,?);";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $usu_id);
            $sql->bindValue(2, $id_cliente);
            $sql->bindValue(3, $nro_doc);
            $sql->bindValue(4, $direc_cli);
            $sql->bindValue(5, $nom_cli);
            $sql->bindValue(6, $serie_pedido);
            $sql->bindValue(7, $moneda);
            $sql->bindValue(8, $id_modalidad);
            $sql->bindValue(9, $contacto);
            $sql->bindValue(10, $telf_contacto);
            $sql->bindValue(11, $dire_entrega);
            $sql->bindValue(12, $id_demision);
            $sql->bindValue(13, $asesor);
            $sql->bindValue(14, $id_fpago);
            $sql->bindValue(15, $fecha_entrega);
            $sql->bindValue(16, $sub_total);
            $sql->bindValue(17, $igv);
            $sql->bindValue(18, $total);
            $sql->bindValue(19, $observacion);
            $sql->bindValue(20, $conta_factu);
            $sql->bindValue(21, $correo_cfactu);
            $sql->bindValue(22, $telf_cfactu);
            $sql->bindValue(23, $conta_cobra);
            $sql->bindValue(24, $correo_ccobra);
            $sql->bindValue(25, $telf_ccobra);
            $sql->bindValue(26, $cotizacion);
            $sql->bindValue(27, $link);
            $sql->bindValue(28, $cierre_facturacion);
            $sql->bindValue(29, $fecha_pago);
            $sql->bindValue(30, $acceso_portal);
            $sql->bindValue(31, $entrega_factura); 
            $sql->bindValue(32, $estado_pago);
            $sql->bindValue(33, $orden_compra);
            $sql->execute();      

            //*obtener el ultimo id_pedido generado
            $id_pedido = $conectar->lastInsertId();

            //* Insertar detalles del pedido        
            foreach ($detalles as $detalle) {
                $id_servicio = $detalle['id_servicio'];
                $descripcion = $detalle['descripcion'];
                $u_medida = $detalle['u_medida'];
                $cant_limpieza = $detalle['cant_limpieza'];
                $cantidad = $detalle['cantidad'];
                $precio_uni = $detalle['precio_uni'];
                $total = $detalle['total'];
                $descrip_producto = $detalle['descrip_producto'];
                $id_acopio = $detalle['id_acopio'];
                $cant = $detalle['cant'];
                $id_unidad_vehicular = $detalle['id_unidad_vehicular'];
                $id_disposicion = $detalle['id_disposicion'];
                $personal_solicitado = $detalle['personal_solicitado'];
                $id_docs_cli = $detalle['id_docs_cli'];
                    
                $sql_detalle = "INSERT INTO det_pedido (id_detpedido, id_pedido, id_servicio, descripcion, u_medida, cant_limpieza, cantidad, precio_uni, total, descrip_producto, id_acopio, cant, id_unidad_vehicular, id_disposicion, personal_solicitado, id_docs_cli) VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
                $sql_detalle = $conectar->prepare($sql_detalle);
                $sql_detalle->bindValue(1, $id_pedido);
                $sql_detalle->bindValue(2, $id_servicio);
                $sql_detalle->bindValue(3, $descripcion);
                $sql_detalle->bindValue(4, $u_medida);
                $sql_detalle->bindValue(5, $cant_limpieza);
                $sql_detalle->bindValue(6, $cantidad);
                $sql_detalle->bindValue(7, $precio_uni);
                $sql_detalle->bindValue(8, $total);
                $sql_detalle->bindValue(9, $descrip_producto);
                $sql_detalle->bindValue(10, $id_acopio);
                $sql_detalle->bindValue(11, $cant);
                $sql_detalle->bindValue(12, $id_unidad_vehicular);
                $sql_detalle->bindValue(13, $id_disposicion);
                $sql_detalle->bindValue(14, $personal_solicitado);
                $sql_detalle->bindValue(15, $id_docs_cli);
                $sql_detalle->execute();
            } 
            
            //*Insertar los datos del manifiesto en la bd alguardar el pedido
            foreach ($manifiestos as $manifiesto){
                $id_cliente = $manifiesto['id_cliente'];
                $representante_legal = $manifiesto['representante_legal'];
                $dni_repre = $manifiesto['dni_repre'];
                $ing_responsable = $manifiesto['ing_responsable'];
                $cip_ing = $manifiesto['cip_ing'];
                $nom_residuos = $manifiesto['nom_residuos'];

                $sql_manifiesto = "INSERT INTO tm_manifiestos (id_manifiesto, id_pedido, fecha, id_cliente, representante_legal, dni_repre, ing_responsable, cip_ing, nom_residuos) VALUES (NULL,?,now(),?,?,?,?,?,?);";
                $sql_manifiesto = $conectar->prepare($sql_manifiesto);
                $sql_manifiesto->bindValue(1, $id_pedido);
                $sql_manifiesto->bindValue(2, $id_cliente);
                $sql_manifiesto->bindValue(3, $representante_legal);
                $sql_manifiesto->bindValue(4, $dni_repre);
                $sql_manifiesto->bindValue(5, $ing_responsable);
                $sql_manifiesto->bindValue(6, $cip_ing);
                $sql_manifiesto->bindValue(7, $nom_residuos);
                $sql_manifiesto->execute();              
            }
            return $id_pedido;       
        }       

        public function editar_pedido($id_pedido, $usu_id, $id_cliente, $nro_doc, $direc_cli, $nom_cli, 
            $serie_pedido, $moneda, $id_modalidad, $contacto, $telf_contacto, $dire_entrega, $id_demision, 
            $asesor, $id_fpago, $fecha_entrega, $sub_total, $igv, $total, $observacion, $conta_factu, 
            $correo_cfactu, $telf_cfactu, $conta_cobra, $correo_ccobra, $telf_ccobra, $cotizacion, $link, 
            $cierre_facturacion, $fecha_pago, $acceso_portal, $entrega_factura, $estado_pago, $orden_compra, $detalles, $manifiestos) {
            $conectar = parent::conexion();
            parent::set_names();
        
            try {
                $conectar->beginTransaction();        
                $sql = "UPDATE tm_pedido SET usu_id=?, id_cliente=?, nro_doc=?, direc_cli=?, nom_cli=?, fecha_emision=now(), serie_pedido=?, moneda=?, id_modalidad=?, contacto=?, telf_contacto=?, dire_entrega=?, id_demision=?, asesor=?, id_fpago=?, fecha_entrega=?, sub_total=?, igv=?, total=?, observacion=?, conta_factu=?, correo_cfactu=?, telf_cfactu=?, conta_cobra=?, correo_ccobra=?, telf_ccobra=?, cotizacion=?, link=?, cierre_facturacion=?, fecha_pago=?, acceso_portal=?, entrega_factura=?, estado_pago=?, orden_compra=? WHERE id_pedido=?";
                $sql = $conectar->prepare($sql);
                $sql->bindValue(1, $usu_id);
                $sql->bindValue(2, $id_cliente);
                $sql->bindValue(3, $nro_doc);
                $sql->bindValue(4, $direc_cli);
                $sql->bindValue(5, $nom_cli);
                $sql->bindValue(6, $serie_pedido);
                $sql->bindValue(7, $moneda);
                $sql->bindValue(8, $id_modalidad);
                $sql->bindValue(9, $contacto);
                $sql->bindValue(10, $telf_contacto);
                $sql->bindValue(11, $dire_entrega);
                $sql->bindValue(12, $id_demision);
                $sql->bindValue(13, $asesor);
                $sql->bindValue(14, $id_fpago);
                $sql->bindValue(15, $fecha_entrega);
                $sql->bindValue(16, $sub_total);
                $sql->bindValue(17, $igv);
                $sql->bindValue(18, $total);
                $sql->bindValue(19, $observacion);
                $sql->bindValue(20, $conta_factu);
                $sql->bindValue(21, $correo_cfactu);
                $sql->bindValue(22, $telf_cfactu);
                $sql->bindValue(23, $conta_cobra);
                $sql->bindValue(24, $correo_ccobra);
                $sql->bindValue(25, $telf_ccobra);
                $sql->bindValue(26, $cotizacion);
                $sql->bindValue(27, $link);
                $sql->bindValue(28, $cierre_facturacion);
                $sql->bindValue(29, $fecha_pago);
                $sql->bindValue(30, $acceso_portal); // Convertir a 0 si está activo, 1 si no lo está
                $sql->bindValue(31, $entrega_factura);
                $sql->bindValue(32, $estado_pago);
                $sql->bindValue(33, $orden_compra);
                $sql->bindValue(34, $id_pedido);
                $sql->execute();
        
                // Eliminar los detalles anteriores del pedido
                $sql_delete = "DELETE FROM det_pedido WHERE id_pedido = ?";
                $sql_delete = $conectar->prepare($sql_delete);
                $sql_delete->bindValue(1, $id_pedido);
                $sql_delete->execute();       
                            
                foreach ($detalles as $detalle) {
                    $id_servicio = $detalle['id_servicio'];
                    $descripcion = $detalle['descripcion'];
                    $u_medida = $detalle['u_medida'];
                    $cant_limpieza = isset($detalle['cant_limpieza']) ? $detalle['cant_limpieza'] : null;
                    $cantidad = $detalle['cantidad'];
                    $precio_uni = $detalle['precio_uni'];
                    $total = $detalle['total'];
                    $descrip_producto = $detalle['descrip_producto'];
                    $id_acopio = $detalle['id_acopio'];
                    $cant = $detalle['cant'];
                    $id_unidad_vehicular = $detalle['id_unidad_vehicular'];
                    $id_disposicion = $detalle['id_disposicion'];
                    $personal_solicitado = $detalle['personal_solicitado'];
                    $id_docs_cli = $detalle['id_docs_cli'];
                
                    // Insertar los nuevos detalles del pedido
                    $sql_detalle = "INSERT INTO det_pedido (id_detpedido, id_pedido, id_servicio, descripcion, u_medida, cant_limpieza, cantidad, precio_uni, total, descrip_producto, id_acopio, cant, id_unidad_vehicular, id_disposicion, personal_solicitado, id_docs_cli) VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    $sql_detalle = $conectar->prepare($sql_detalle);        
                    $sql_detalle->bindValue(1, $id_pedido);
                    $sql_detalle->bindValue(2, $id_servicio);
                    $sql_detalle->bindValue(3, $descripcion);
                    $sql_detalle->bindValue(4, $u_medida);
                    $sql_detalle->bindValue(5, $cant_limpieza);
                    $sql_detalle->bindValue(6, $cantidad);
                    $sql_detalle->bindValue(7, $precio_uni);
                    $sql_detalle->bindValue(8, $total);
                    $sql_detalle->bindValue(9, $descrip_producto);
                    $sql_detalle->bindValue(10, $id_acopio);
                    $sql_detalle->bindValue(11, $cant);
                    $sql_detalle->bindValue(12, $id_unidad_vehicular);
                    $sql_detalle->bindValue(13, $id_disposicion);
                    $sql_detalle->bindValue(14, $personal_solicitado);
                    $sql_detalle->bindValue(15, $id_docs_cli);
                    $sql_detalle->execute();
                }  
                
                 // Eliminar los manifiestos anteriores del pedido
                 $sql_delete_manifiestos = "DELETE FROM tm_manifiestos WHERE id_pedido = ?";
                 $sql_delete_manifiestos = $conectar->prepare($sql_delete_manifiestos);
                 $sql_delete_manifiestos->bindValue(1, $id_pedido);
                 $sql_delete_manifiestos->execute();
                     
         
                //*Insertar los datos del manifiesto en la bd alguardar el pedido
                foreach ($manifiestos as $manifiesto){
                    $id_cliente = $manifiesto['id_cliente'];
                    $representante_legal = $manifiesto['representante_legal'];
                    $dni_repre = $manifiesto['dni_repre'];
                    $ing_responsable = $manifiesto['ing_responsable'];
                    $cip_ing = $manifiesto['cip_ing'];
                    $nom_residuos = $manifiesto['nom_residuos'];

                    $sql_manifiesto = "INSERT INTO tm_manifiestos (id_manifiesto, id_pedido, fecha, id_cliente, representante_legal, dni_repre, ing_responsable, cip_ing, nom_residuos) VALUES (NULL,?,now(),?,?,?,?,?,?);";
                    $sql_manifiesto = $conectar->prepare($sql_manifiesto);
                    $sql_manifiesto->bindValue(1, $id_pedido);
                    $sql_manifiesto->bindValue(2, $id_cliente);
                    $sql_manifiesto->bindValue(3, $representante_legal);
                    $sql_manifiesto->bindValue(4, $dni_repre);
                    $sql_manifiesto->bindValue(5, $ing_responsable);
                    $sql_manifiesto->bindValue(6, $cip_ing);
                    $sql_manifiesto->bindValue(7, $nom_residuos);
                    $sql_manifiesto->execute();     
                }
                $conectar->commit();

                return true;
            } catch (PDOException $e) {
                $conectar->rollback();
                return false;
            }
        }

        public function listar_pedido(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT
                tm_pedido.id_pedido,
                tm_pedido.fecha_emision,
                DATE(tm_pedido.fecha_entrega) AS fecha_entrega,
                tm_pedido.usu_id,
                /*tm_usuario.usu_nom,*/
                tm_pedido.id_cliente,
                tm_pedido.asesor,
                tm_pedido.id_modalidad,
                tm_cliente.nom_cli,
                tm_pedido.serie_pedido,
                tm_pedido.id_fpago,
                tm_pedido.estado,
                tm_pedido.total,
                forma_pago.descripcion,
                tm_pedido.estado_pago,
                tm_pedido.orden_compra,
                tipo_servicio.modalidad                   
                FROM 
                tm_pedido
                LEFT JOIN tm_cliente on tm_pedido.id_cliente = tm_cliente.id_cliente
                LEFT JOIN tm_usuario on tm_pedido.usu_id = tm_usuario.usu_id
                LEFT JOIN forma_pago on tm_pedido.id_fpago = forma_pago.id_fpago
                LEFT JOIN tipo_servicio on tm_pedido.id_modalidad = tipo_servicio.id_modalidad
                WHERE
                tm_pedido.est_ped = 1";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }    

        public function listar_pedido_x_id($id_pedido){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT 
                tm_pedido.id_pedido,
                tm_pedido.usu_id,
                tm_pedido.id_cliente,
                tm_pedido.nro_doc,
                tm_pedido.direc_cli,
                tm_pedido.nom_cli,
                tm_pedido.fecha_emision,
                tm_pedido.serie_pedido,
                tm_pedido.moneda,
                tm_pedido.id_modalidad,
                tm_pedido.contacto,
                tm_pedido.telf_contacto,
                tm_pedido.dire_entrega,
                tm_pedido.id_demision,
                tm_pedido.asesor,
                tm_pedido.id_fpago,
                tm_pedido.fecha_entrega,
                tm_pedido.sub_total,
                tm_pedido.igv,
                tm_pedido.total,
                tm_pedido.estado,
                tm_pedido.observacion,
                tm_pedido.conta_factu,
                tm_pedido.correo_cfactu,
                tm_pedido.telf_cfactu,
                tm_pedido.conta_cobra,
                tm_pedido.correo_ccobra,
                tm_pedido.telf_ccobra,
                tm_pedido.cotizacion,
                tm_pedido.link,
                tm_pedido.cierre_facturacion,
                tm_pedido.fecha_pago,
                tm_pedido.acceso_portal,
                tm_pedido.entrega_factura,
                tm_pedido.orden_compra,
                tipo_servicio.modalidad,
                doc_emision.documento,                
                forma_pago.descripcion           
                FROM 
                tm_pedido
                LEFT join tipo_servicio on tm_pedido.id_modalidad = tipo_servicio.id_modalidad
                LEFT join doc_emision on tm_pedido.id_demision = doc_emision.id_demision
                LEFT join forma_pago on tm_pedido.id_fpago = forma_pago.id_fpago                
                WHERE
                tm_pedido.est_ped = 1
                AND tm_pedido.id_pedido = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        } 

        public function listar_detalle_pedido($id_pedido){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT 
                tm_pedido.id_pedido,
                tm_servicio.id_servicio,
                tm_servicio.descripcion,
                det_pedido.U_medida,
                det_pedido.cant_limpieza,
                det_pedido.cantidad,
                det_pedido.precio_uni,
                det_pedido.total,
                det_pedido.descrip_producto,
                det_pedido.id_acopio,
                det_pedido.cant,
                det_pedido.id_unidad_vehicular,
                det_pedido.id_disposicion,
                det_pedido.personal_solicitado,
                det_pedido.id_docs_cli
                FROM 
                det_pedido
                LEFT JOIN tm_pedido ON det_pedido.id_pedido = tm_pedido.id_pedido
                LEFT JOIN tm_servicio ON det_pedido.id_servicio = tm_servicio.id_servicio
                LEFT JOIN tm_tipo_vehiculo ON det_pedido.id_unidad_vehicular = tm_tipo_vehiculo.id_unidad_vehicular
                LEFT JOIN tm_acopio ON det_pedido.id_acopio = tm_acopio.id_acopio
                LEFT JOIN tm_disposicion_final ON det_pedido.id_disposicion = tm_disposicion_final.id_disposicion
                LEFT JOIN entrega_documento ON det_pedido.id_docs_cli = entrega_documento.id_docs_cli                
                WHERE
                tm_pedido.id_pedido = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        } 

        public function listar_manifiestos($id_pedido){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT 
                tm_manifiestos.id_pedido,
                tm_manifiestos.fecha,
                tm_manifiestos.id_cliente,
                tm_manifiestos.representante_legal,
                tm_manifiestos.dni_repre,
                tm_manifiestos.ing_responsable,
                tm_manifiestos.cip_ing,
                tm_manifiestos.nom_residuos,
                tm_cliente.nom_cli             
                FROM 
                tm_manifiestos
                INNER JOIN tm_pedido ON tm_manifiestos.id_pedido = tm_pedido.id_pedido
                LEFT JOIN tm_cliente ON tm_manifiestos.id_cliente = tm_cliente.id_cliente               
                WHERE
                tm_pedido.id_pedido = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }         
        
        public function update_pedido($id_pedido){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="update tm_pedido 
                set	
                    estado = 'Anulado'
                where
                    id_pedido = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        public function update_estpedido($id_pedido){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="update tm_pedido 
                set	
                    estado_pago = 'Anulado'
                where
                    id_pedido = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        public function insert_seguimiento($id_pedido,$usu_id,$segui_descripcion){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="INSERT INTO td_pedidoseguimiento (id_Seguimiento,id_pedido,usu_id,segui_descripcion,fecha_crea,estado) VALUES (NULL,?,?,?,now(),'1');";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->bindValue(2, $usu_id);
            $sql->bindValue(3, $segui_descripcion);
            $sql->execute();

            //Devuelve el ultimo comentario ingresado
            $sql1="select last_insert_id() as 'id_seguimiento';";
            $sql1=$conectar->prepare($sql1);
            $sql1->execute();
            return $resultado=$sql1->fetchAll(pdo::FETCH_ASSOC);
        }

        public function listar_seguimiento_x_pedido($id_pedido){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT
                td_pedidoseguimiento.id_seguimiento,
                td_pedidoseguimiento.segui_descripcion,
                td_pedidoseguimiento.fecha_crea,
                tm_usuario.usu_nom,
                tm_usuario.usu_ape,
                tm_usuario.rol_id
                FROM 
                td_pedidoseguimiento
                INNER join tm_usuario on td_pedidoseguimiento.usu_id = tm_usuario.usu_id
                WHERE 
                id_pedido =?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }       
    }
?>