<?php
    require_once("../config/conexion.php");
    require_once("../models/Entrega_documento.php");
    $entrega_documento = new Entrega_documento();

    switch($_GET["op"]){
        case "combo":
            $datos = $entrega_documento->get_entrega_documento();
            $html="";
            $html.= "<option label='Seleccionar'></option>";
            if(is_array($datos)==true and count($datos)>0){
                foreach($datos as $row)
                {
                    $html.= "<option value='".$row['id_docs_cli']."'>".$row['descripcion']."</option>";
                }
                echo $html;
            }
        break;
    }
?>