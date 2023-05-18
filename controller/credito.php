<?php
    require_once("../config/conexion.php");
    require_once("../models/Credito.php");
    $credito = new Credito();

    switch($_GET["op"]){
        case "combocredito":
            $datos = $credito->get_credito();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_ccredito']."'>".$row['descripcion']."</option>";
                }
                echo $html;
            }
        break;
    }
?>