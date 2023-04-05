<?php
    require_once("../config/conexion.php");
    require_once("../models/Provincia.php");
    $provincia = new Provincia();

    switch($_GET["op"]){
        case "combo":
            $datos = $provincia->get_provincia($_POST["id_departamento"]);
            $html="";
            $html.="<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_provincia']."'>".$row['nom_provincia']."</option>";
                }
                echo $html;
            }
        break;
    }
?>