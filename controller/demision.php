<?php
    require_once("../config/conexion.php");
    require_once("../models/Demision.php");
    $demision = new Demision();

    switch($_GET["op"]){
        case "combo":
            $datos = $demision->get_demision();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_demision']."'>".$row['documento']."</option>";
                }
                echo $html;
            }
        break;
    }
?>