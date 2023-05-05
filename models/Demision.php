<?php
    class Demision extends Conectar{

        public function get_demision(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM doc_emision WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>