<?php
//CADENA DE CONEXION
require_once("../config/conexion.php");
//RUTA LOGIN
header("Location:".Conectar::ruta()."index.php");

?>