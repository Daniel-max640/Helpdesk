<?php
  require_once("../../config/conexion.php"); 
  if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
    <?php require_once("../MainHead/head.php");?>
	<title>Mantenimiento Clientes</title>
</head>
<body class="with-side-menu">

    <?php require_once("../MainHeader/header.php");?>

    <div class="mobile-menu-left-overlay"></div>
    
    <?php require_once("../MainNav/nav.php");?>

	<!-- Contenido -->
	<div class="page-content">
		<div class="container-fluid">
			<header class="section-header">
				<div class="tbl">
					<div class="tbl-row">
						<div class="tbl-cell">
							<h3>Mantenimiento Clientes</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="#">Home</a></li>
								<li class="active">Mantenimiento Clientes</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="box-typical box-typical-padding">
				<button type="button" id="btnnuevo" class="btn btn-inline btn-primary">Nuevo Registro</button>
				<table id="cliente_data" class="table table-bordered table-striped table-vcenter js-dataTable-full">
					<thead>
						<tr>
                            <th style="width: 8%;">Id</th>
							<th style="width: 8%;">Tipo Doc</th>
							<th style="width: 5%;">Numero</th>
							<th class="d-none d-sm-table-cell" style="width: 15%;">Nombre</th>
							<th class="d-none d-sm-table-cell" style="width: 45%;">Direccion</th>
							<th class="d-none d-sm-table-cell" style="width: 30%;">Departamento</th>
							<th class="d-none d-sm-table-cell" style="width: 30%;">Provincia</th>
							<th class="d-none d-sm-table-cell" style="width: 30%;">Distrito</th>
							<th class="d-none d-sm-table-cell" style="width: 30%;">Telefono</th>
							<th class="text-center" style="width: 3%;"></th>
							<th class="text-center" style="width: 3%;"></th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>

		</div>
	</div>
	<!-- Contenido -->

	<?php require_once("modalmantecliente.php");?>

	<?php require_once("../MainJs/js.php");?>
	
	<script type="text/javascript" src="mntcliente.js"></script>

</body>
</html>
<?php
  } else {
    header("Location:".Conectar::ruta()."index.php");
  }
?>