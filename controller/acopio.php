<?php
    require_once("../config/conexion.php");
    require_once("../models/Acopio.php");
    $acopio = new Acopio();

    switch($_GET["op"]){
        case "combo":
            $datos = $acopio->get_acopio();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_acopio']."'>".$row['descripcion']."</option>";
                }
                echo $html;
            }
        break;
    }
?>