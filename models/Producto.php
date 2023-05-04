<?php
    class Producto extends Conectar{

        public function productos_servicios($descripcion){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT p.id_modelo AS id_producto, p.descripcion, m.abreviatura AS medida_descripcion, p.precio 
            FROM tm_modeloportatil p 
            INNER JOIN tm_umedida m ON p.id_medida = m.id_medida
            WHERE p.descripcion LIKE '%$descripcion%'
            UNION
            SELECT s.id_servicio AS id_producto, s.descripcion,m.abreviatura AS medida_descripcion, s.precio 
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