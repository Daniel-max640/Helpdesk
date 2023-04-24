<?php
    class Pedido extends Conectar{

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