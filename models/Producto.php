<?php
    class Producto extends Conectar{

        public function productos_servicios($descripcion){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT s.id_servicio, s.descripcion, s.precio 
            FROM tm_servicio s 
            INNER JOIN tm_umedida m ON s.id_medida = m.id_medida
            WHERE s.descripcion LIKE '%$descripcion%'";
            $resultado = $conectar->query($sql);
            $productos = array();
            while ($producto = $resultado->fetch(PDO::FETCH_ASSOC)) {
                $productos[] = $producto;
            }
            return $productos;
        }

    }
?>