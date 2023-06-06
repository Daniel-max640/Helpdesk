<?php
    class Pedido extends Conectar{

        public function insert_pedido($usu_id,$id_cliente,$nro_doc,$direc_cli,$nom_cli,
        $serie_pedido,$moneda,$id_modalidad,$contacto,$telf_contacto,$dire_entrega,
        $id_demision,$asesor,$id_fpago,$fecha_entrega,$sub_total,$igv,$total,$observacion,
        $conta_factu,$correo_cfactu,$telf_cfactu,$conta_cobra,$correo_ccobra,$telf_ccobra,
        $cotizacion,$link,$cierre_facturacion,$fecha_pago,$acceso_portal,$entrega_factura,$detalles){
            $conectar= parent::conexion();
            parent::set_names();            
            $sql="INSERT INTO tm_pedido (id_pedido,usu_id,id_cliente,nro_doc,direc_cli,nom_cli,fecha_emision,serie_pedido,moneda,id_modalidad,contacto,telf_contacto,dire_entrega,id_demision,asesor,id_fpago,fecha_entrega,sub_total,igv,total,observacion,conta_factu,correo_cfactu,telf_cfactu,conta_cobra,correo_ccobra,telf_ccobra,est_ped,cotizacion,link,cierre_facturacion,fecha_pago,acceso_portal,entrega_factura) VALUES (NULL,?,?,?,?,?,now(),CONCAT(?, '-', (SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'andercode_helpdesk1' AND TABLE_NAME = 'tm_pedido')),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'1',?,?,?,?,?,?);";
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
            $sql->bindValue(15, date($fecha_entrega));
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
            $sql->bindValue(31, $entrega_factura); // Convertir a 0 si está activo, 1 si no lo está
            $sql->execute();         
            $pedido_id = $conectar->lastInsertId();
    
            // Insertar detalles del pedido
            foreach ($detalles as $detalle) {
            $id_servicio = $detalle['id_servicio'];
            $descripcion = $detalle['descripcion'];
            $u_medida = $detalle['u_medida'];
            $cant_limpieza = $detalle['cant_limpieza'];
            $cantidad = $detalle['cantidad'];
            $precio_uni = $detalle['precio_uni'];
            $total = $detalle['total'];
                
            $sql_detalle = "INSERT INTO det_pedido (id_detpedido, id_pedido, id_servicio, descripcion, u_medida, cant_limpieza, cantidad, precio_uni, total) VALUES (NULL,?,?,?,?,?,?,?,?);";
            $sql_detalle = $conectar->prepare($sql_detalle);
            $sql_detalle->bindValue(1, $pedido_id);
            $sql_detalle->bindValue(2, $id_servicio);
            $sql_detalle->bindValue(3, $descripcion);
            $sql_detalle->bindValue(4, $u_medida);
            $sql_detalle->bindValue(5, $cant_limpieza);
            $sql_detalle->bindValue(6, $cantidad);
            $sql_detalle->bindValue(7, $precio_uni);
            $sql_detalle->bindValue(8, $total);
            $sql_detalle->execute();
            }             
            return $pedido_id;
        }        

        public function editar_pedido($id_pedido, $usu_id, $id_cliente, $nro_doc, $direc_cli, $nom_cli, 
            $serie_pedido, $moneda, $id_modalidad, $contacto, $telf_contacto, $dire_entrega, $id_demision, 
            $asesor, $id_fpago, $fecha_entrega, $sub_total, $igv, $total, $observacion, $conta_factu, 
            $correo_cfactu, $telf_cfactu, $conta_cobra, $correo_ccobra, $telf_ccobra, $cotizacion, $link, 
            $cierre_facturacion, $fecha_pago, $acceso_portal, $entrega_factura, $detalles) {
            $conectar = parent::conexion();
            parent::set_names();
        
            try {
                $conectar->beginTransaction();        
                $sql = "UPDATE tm_pedido SET usu_id=?, id_cliente=?, nro_doc=?, direc_cli=?, nom_cli=?, fecha_emision=now(), serie_pedido=?, moneda=?, id_modalidad=?, contacto=?, telf_contacto=?, dire_entrega=?, id_demision=?, asesor=?, id_fpago=?, fecha_entrega=?, sub_total=?, igv=?, total=?, observacion=?, conta_factu=?, correo_cfactu=?, telf_cfactu=?, conta_cobra=?, correo_ccobra=?, telf_ccobra=?, cotizacion=?, link=?, cierre_facturacion=?, fecha_pago=?, acceso_portal=?, entrega_factura=? WHERE id_pedido=?";
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
                $sql->bindValue(31, $entrega_factura); // Convertir a 0 si está activo, 1 si no lo está
                $sql->bindValue(32, $id_pedido);
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
                    // Insertar los nuevos detalles del pedido
                    $sql_detalle = "INSERT INTO det_pedido (id_detpedido, id_pedido, id_servicio, descripcion, u_medida, cant_limpieza, cantidad, precio_uni, total) VALUES (NULL,?,?,?,?,?,?,?,?)";
                    $sql_detalle = $conectar->prepare($sql_detalle);        
                    $sql_detalle->bindValue(1, $id_pedido);
                    $sql_detalle->bindValue(2, $id_servicio);
                    $sql_detalle->bindValue(3, $descripcion);
                    $sql_detalle->bindValue(4, $u_medida);
                    $sql_detalle->bindValue(5, $cant_limpieza);
                    $sql_detalle->bindValue(6, $cantidad);
                    $sql_detalle->bindValue(7, $precio_uni);
                    $sql_detalle->bindValue(8, $total);
                    $sql_detalle->execute();
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
                tm_pedido.fecha_entrega,
                tm_pedido.usu_id,
                tm_usuario.usu_nom,
                tm_pedido.id_cliente,
                tm_cliente.nom_cli,
                tm_pedido.serie_pedido,
                tm_pedido.id_fpago,
                tm_pedido.total,
                forma_pago.descripcion                
                FROM 
                tm_pedido
                LEFT JOIN tm_cliente on tm_pedido.id_cliente = tm_cliente.id_cliente
                LEFT JOIN tm_usuario on tm_pedido.usu_id = tm_usuario.usu_id
                LEFT JOIN forma_pago on tm_pedido.id_fpago = forma_pago.id_fpago
                WHERE
                tm_pedido.est_ped = 1";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        public function buscarCliente($nro_doc) {
            $conectar= parent::conexion(); 
            parent::set_names();           
            // Consulta para buscar al cliente
            $sql = "SELECT * FROM tm_cliente WHERE nro_doc = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $nro_doc);
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
                tipo_servicio.modalidad,
                doc_emision.documento,                
                forma_pago.descripcion           
                FROM 
                tm_pedido
                INNER join tipo_servicio on tm_pedido.id_modalidad = tipo_servicio.id_modalidad
                INNER join doc_emision on tm_pedido.id_demision = doc_emision.id_demision
                INNER join forma_pago on tm_pedido.id_fpago = forma_pago.id_fpago                
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
                det_pedido.total
                FROM 
                det_pedido
                INNER join tm_pedido ON det_pedido.id_pedido = tm_pedido.id_pedido
                INNER join tm_servicio ON det_pedido.id_servicio = tm_servicio.id_servicio
                WHERE
                tm_pedido.id_pedido = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_pedido);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }        
    }
?>