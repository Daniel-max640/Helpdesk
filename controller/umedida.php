<?php
    require_once("../config/conexion.php");
    require_once("../models/Umedida.php");
    $umedida = new Umedida();

    switch($_GET["op"]){
        case "combo":
            $valor_seleccionado = ""; 
            $datos = $umedida->get_umedida();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $selected = ($row['id_medida'] == $valor_seleccionado) ? "selected" : ""; // Agrega esta línea, reemplazando $valor_seleccionado con el valor correcto
                    $html .= "<option value='".$row['id_medida']."' data-nombre='".$row['abreviatura']."'>".$row['abreviatura']."</option>";
                }
                echo $html;
            }
        break;
    }
?>