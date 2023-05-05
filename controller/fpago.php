<?php
    require_once("../config/conexion.php");
    require_once("../models/Fpago.php");
    $fpago = new Fpago();

    switch($_GET["op"]){
        case "combo":
            $datos = $fpago->get_fpago();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_fpago']."'>".$row['descripcion']."</option>";
                }
                echo $html;
            }
        break;
    }
?>