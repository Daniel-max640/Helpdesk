<?php
    require_once("../config/conexion.php");
    require_once("../models/U_vehicular.php");
    $u_vehicular = new U_vehicular();

    switch($_GET["op"]){
        case "combo":
            $datos = $u_vehicular->get_u_vehicular();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_unidad_vehicular']."'>".$row['descripcion']."</option>";
                }
                echo $html;
            }
        break;
    }
?>