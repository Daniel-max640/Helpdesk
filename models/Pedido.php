<?php
    class Pedido extends Conectar{

        public function insert_pedido($usu_id,$id_cliente,$nro_doc,$direc_cli,$nom_cli,$orden_compra,$serie_pedido,$moneda,$id_modalidad,$contacto,$telf_contacto,$dire_entrega,$id_demision,$asesor,$id_fpago,$fecha_entrega,$sub_total,$igv,$total,$observacion,$conta_factu,$correo_cfactu,$telf_cfactu,$conta_cobra,$correo_ccobra,$telf_ccobra){
            $conectar= parent::conexion();
            parent::set_names();            
            $sql="INSERT INTO tm_pedido (id_pedido,usu_id,id_cliente,nro_doc,direc_cli,nom_cli,orden_compra,fecha_emision,fecha_devolucion,serie_pedido,moneda,id_modalidad,contacto,telf_contacto,dire_entrega,id_demision,asesor,id_fpago,fecha_entrega,sub_total,igv,total,observacion,conta_factu,correo_cfactu,telf_cfactu,conta_cobra,correo_ccobra,telf_ccobra,est_ped) VALUES (NULL,?,?,?,?,?,?,now(), NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, '1');";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $usu_id);
            $sql->bindValue(2, $id_cliente);
            $sql->bindValue(3, $nro_doc);
            $sql->bindValue(4, $direc_cli);
            $sql->bindValue(5, $nom_cli);
            $sql->bindValue(6, $orden_compra);
            $sql->bindValue(7, $serie_pedido);
            $sql->bindValue(8, $moneda);
            $sql->bindValue(9, $id_modalidad);
            $sql->bindValue(10, $contacto);
            $sql->bindValue(11, $telf_contacto);
            $sql->bindValue(12, $dire_entrega);
            $sql->bindValue(13, $id_demision);
            $sql->bindValue(14, $asesor);
            $sql->bindValue(15, $id_fpago);
            $sql->bindValue(16, date('Y/m/d', strtotime($fecha_entrega)));
            $sql->bindValue(17, $sub_total);
            $sql->bindValue(18, $igv);
            $sql->bindValue(19, $total);
            $sql->bindValue(20, $observacion);
            $sql->bindValue(21, $conta_factu);
            $sql->bindValue(22, $correo_cfactu);
            $sql->bindValue(23, $telf_cfactu);
            $sql->bindValue(24, $conta_cobra);
            $sql->bindValue(25, $correo_ccobra);
            $sql->bindValue(26, $telf_ccobra);
            $sql->execute();
          
            $sql1="select last_insert_id() as 'id_pedido';";
            $sql1=$conectar->prepare($sql1);
            $sql1->execute();
            return $resultado=$sql1->fetchAll(pdo::FETCH_ASSOC);
        }

        public function editar_pedido($id_pedido,$usu_id,$id_cliente,$nro_doc,$direc_cli,$nom_cli,$orden_compra,$serie_pedido,$moneda,$id_modalidad,$contacto,$telf_contacto,$dire_entrega,$id_demision,$asesor,$id_fpago,$fecha_entrega,$sub_total,$igv,$total,$observacion,$conta_factu,$correo_cfactu,$telf_cfactu,$conta_cobra,$correo_ccobra,$telf_ccobra){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="UPDATE tm_pedido SET usu_id=?, id_cliente=?, nro_doc=?, direc_cli=?, nom_cli=?, orden_compra=?, fecha_emision=now(), serie_pedido=?, moneda=?, id_modalidad=?, contacto=?, telf_contacto=?, dire_entrega=?, id_demision=?, asesor=?, id_fpago=?, fecha_entrega=?, sub_total=?, igv=?, total=?, observacion=?, conta_factu=?, correo_cfactu=?, telf_cfactu=?, conta_cobra=?, correo_ccobra=?, telf_ccobra=? WHERE id_pedido=?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $usu_id);
            $sql->bindValue(2, $id_cliente);
            $sql->bindValue(3, $nro_doc);
            $sql->bindValue(4, $direc_cli);
            $sql->bindValue(5, $nom_cli);
            $sql->bindValue(6, $orden_compra);
            $sql->bindValue(7, $serie_pedido);
            $sql->bindValue(8, $moneda);
            $sql->bindValue(9, $id_modalidad);
            $sql->bindValue(10, $contacto);
            $sql->bindValue(11, $telf_contacto);
            $sql->bindValue(12, $dire_entrega);
            $sql->bindValue(13, $id_demision);
            $sql->bindValue(14, $asesor);
            $sql->bindValue(15, $id_fpago);
            $sql->bindValue(16, $fecha_entrega);
            $sql->bindValue(17, $sub_total);
            $sql->bindValue(18, $igv);
            $sql->bindValue(19, $total);
            $sql->bindValue(20, $observacion);
            $sql->bindValue(21, $conta_factu);
            $sql->bindValue(22, $correo_cfactu);
            $sql->bindValue(23, $telf_cfactu);
            $sql->bindValue(24, $conta_cobra);
            $sql->bindValue(25, $correo_ccobra);
            $sql->bindValue(26, $telf_ccobra);
            $sql->bindValue(27, $id_pedido);
            $sql->execute();

            return $resultado=$sql->fetchAll();
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
                tm_pedido.dire_entrega,
                tm_pedido.id_fpago,
                tm_pedido.total,
                forma_pago.descripcion                
                FROM 
                tm_pedido
                INNER join tm_cliente on tm_pedido.id_cliente = tm_cliente.id_cliente
                INNER join tm_usuario on tm_pedido.usu_id = tm_usuario.usu_id
                INNER join forma_pago on tm_pedido.id_fpago = forma_pago.id_fpago
                WHERE
                tm_pedido.est_ped = 1";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

      public function obtener_siguiente_numero_pedido() {
            $conectar = parent::conexion();
            $sql = "SELECT MAX(id_pedido) AS max_id FROM tm_pedido";
            $result = $conectar->query($sql);
            $row = $result->fetch(PDO::FETCH_ASSOC);
            return ($row['max_id'] + 1);
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

        
    }
?>