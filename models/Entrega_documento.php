<?php

    class Entrega_documento extends Conectar{

        public function get_entrega_documento(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM entrega_documento WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();    
        }
    }  
    
?>