<?php
    require_once("../config/conexion.php");
    require_once("../models/Umedida.php");
    $umedida = new Umedida();

    switch($_GET["op"]){
        case "combo":
            $datos = $umedida->get_umedida();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_medida']."'>".$row['abreviatura']."</option>";
                }
                echo $html;
            }
        break;
    }
?>