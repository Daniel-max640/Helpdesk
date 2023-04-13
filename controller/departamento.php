<?php
    require_once("../config/conexion.php");
    require_once("../models/Departamento.php");
    $departamento = new Departamento();

    switch($_GET["op"]){
        case "combo":
            $datos = $departamento->get_Departamento();
            $html="";
            //$html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_departamento']."'>".$row['departamento']."</option>";
                }
                echo $html;
            }
        break;
    }
?>