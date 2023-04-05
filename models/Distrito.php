<?php
    class Distrito extends Conectar{

        public function get_distrito($id_provincia){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_distrito WHERE id_provincia=? AND estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_provincia);
            $sql->execute(); 
            return $resultado=$sql->fetchAll();
        }

    }
?>