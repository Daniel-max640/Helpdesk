<?php
    class Departamento extends Conectar{

        public function get_Departamento(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_departamento WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>