<?php
    require_once("../config/conexion.php");
    require_once("../models/Disposicion.php");
    $disposicion = new Disposicion();

    switch($_GET["op"]){
        case "combo":
            $datos = $disposicion->get_disposicion();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_disposicion']."'>".$row['descripcion']."</option>";
                }
                echo $html;
            }
        break;
    }
?>