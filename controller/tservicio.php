<?php
    require_once("../config/conexion.php");
    require_once("../models/Tservicio.php");
    $tservicio = new Tservicio();

    switch($_GET["op"]){
        case "combo":
            $datos = $tservicio->get_tservicio();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_modalidad']."'>".$row['modalidad']."</option>";
                }
                echo $html;
            }
        break;
    }
?>