<?php
    class Disposicion extends Conectar{
        public function get_disposicion(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_disposicion_final WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>