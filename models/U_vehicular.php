<?php
    class U_vehicular extends Conectar{
        
        public function get_u_vehicular(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_tipo_vehiculo WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }        
    }
?>