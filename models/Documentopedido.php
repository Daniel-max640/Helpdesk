<?php
    class Documentopedido extends Conectar{
        public function insert_docpedido($id_pedido,$doc_nombre){
            $conectar= parent::conexion();
            /* consulta sql */
            $sql="INSERT INTO td_documentopedido (id_documento,id_pedido,doc_nombre,fecha_crea,estado) VALUES (NULL,?,?,now(),1);";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1,$id_pedido);
            $sql->bindParam(2,$doc_nombre);
            $sql->execute();
        }

        public function get_documento_x_pedido($id_pedido){
            $conectar= parent::conexion();
            /* consulta sql */
            $sql="SELECT * FROM td_documentopedido WHERE id_pedido=?";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1,$id_pedido);
            $sql->execute();
            return $resultado = $sql->fetchAll(pdo::FETCH_ASSOC);
        }
    }
?>