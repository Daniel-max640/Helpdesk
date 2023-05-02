<?php
    class Producto extends Conectar{

        public function productos_servicios($descripcion){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_modeloportatil WHERE descripcion LIKE '%$descripcion%'";
            $resultado = $conectar->query($sql);
            $productos = array();
            while ($producto = $resultado->fetch(PDO::FETCH_ASSOC)) {
                $productos[] = $producto;
            }
            return $productos;
        }

    }
?>