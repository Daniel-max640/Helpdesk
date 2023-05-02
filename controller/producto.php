<?php
    require_once("../config/conexion.php");
    require_once("../models/Producto.php");
    $producto = new Producto();

    switch($_GET["op"]){
       
        case "guardaryeditar":        
         

        case "listar":
            $descripcion = $_POST['descripcion'];
            $resultados = $producto->productos_servicios($descripcion);
            echo json_encode($resultados);
            echo $html; 
        break;
        
        case "buscar":
            if(isset($_POST['descripcion'])) {
                $descripcion = $_POST['descripcion'];
                // llamada a la función del modelo
                $resultados = $producto->productos_servicios($descripcion);
                // retorna los resultados en formato JSON
                echo json_encode($resultados);
            }
          
          // Resto de las acciones del controlador
          

        case "mostrarcliente";
       
            
         break;

        case "eliminar":
        
        break;

      
        
    }
?>