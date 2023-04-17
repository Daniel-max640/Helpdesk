<?php
    class Provincia extends Conectar{

        public function get_provincia($id_departamento){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_provincia WHERE id_departamento=? AND est=1;";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_departamento);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        public function get_provi(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_provincia WHERE est=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }
    
    

    }
?>