<?php
    class TipoDoc extends Conectar{

        public function get_TipoDoc(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_tipodocumento WHERE est=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>