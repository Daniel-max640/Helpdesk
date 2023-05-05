<?php
    class Fpago extends Conectar{

        public function get_fpago(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM forma_pago WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>