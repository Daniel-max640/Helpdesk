<?php
    class Tservicio extends Conectar{

        public function get_tservicio(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tipo_servicio WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    }
?>