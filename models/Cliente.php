<?php
    class Cliente extends Conectar{
   

       
        public function get_cliente(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="call sp_l_cliente_01()";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

    } 
?>