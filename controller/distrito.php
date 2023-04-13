<?php
    require_once("../config/conexion.php");
    require_once("../models/Distrito.php");
    $distrito = new Distrito();

    switch($_GET["op"]){
        case "combo":
            $datos = $distrito->get_distrito($_POST["id_provincia"]);
            $html="";
            //$html.="<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_distrito']."'>".$row['nom_distrito']."</option>";
                }
                echo $html;
            }
        break;
    }
?>