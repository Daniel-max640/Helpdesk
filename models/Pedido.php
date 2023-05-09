<?php
    class Pedido extends Conectar{

        public function insert_pedido($usu_id,$cat_id,$cats_id,$tick_titulo,$tick_descrip,$prio_id){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="INSERT INTO tm_ticket (tick_id,usu_id,cat_id,cats_id,tick_titulo,tick_descrip,tick_estado,fech_crea,usu_asig,fech_asig,prio_id,est) VALUES (NULL,?,?,?,?,?,'Abierto',now(),NULL,NULL,?,'1');";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $usu_id);
            $sql->bindValue(2, $cat_id);
            $sql->bindValue(3, $cats_id);
            $sql->bindValue(4, $tick_titulo);
            $sql->bindValue(5, $tick_descrip);
            $sql->bindValue(6, $prio_id);
            $sql->execute();

            $sql1="select last_insert_id() as 'tick_id';";
            $sql1=$conectar->prepare($sql1);
            $sql1->execute();
            return $resultado=$sql1->fetchAll(pdo::FETCH_ASSOC);
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