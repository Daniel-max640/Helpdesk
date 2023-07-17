<?php
    class Acopio extends Conectar{
        public function get_acopio(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_acopio WHERE estado=1;";
            $sql=$conectar->prepare($sql);            
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>