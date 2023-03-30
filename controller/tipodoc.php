<?php
    require_once("../config/conexion.php");
    require_once("../models/TipoDoc.php");
    $tipodoc = new TipoDoc();

    switch($_GET["op"]){
        case "combo":
            $datos = $tipodoc->get_TipoDoc();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['tipodoc_id']."'>".$row['nom_tipdoc']."</option>";
                }
                echo $html;
            }
        break;
    }
?>