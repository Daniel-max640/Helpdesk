<?php
    class Credito extends Conectar{
        public function get_credito(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_concredito WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>