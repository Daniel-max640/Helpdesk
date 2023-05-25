<?php
    class Umedida extends Conectar{
        
        public function get_umedida(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_umedida WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }        
    }
?>