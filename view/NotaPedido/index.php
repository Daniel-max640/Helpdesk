<?php
  require_once("../../config/conexion.php"); 
  if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
    <?php require_once("../MainHead/head.php");?>
	<title>::Lista de Pedidos</title>
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
							<h3>Lista de Pedidos</h3>							
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="#">Home</a></li>
							</ol>
						</div>						
						<div class="tbl-cell">
						<button type="button" id="btnnuevo" class="btn btn-inline btn-primary">Generar Nota de Pedido<i class="fa fa-edit"></i></button>					
					
						</div>
					</div>					
				</div>
			</header>

			<div class="box-typical box-typical-padding">
				
				<table id="pedido_data" class="table table-bordered table-striped table-vcenter js-dataTable-full">
					<thead>
						<tr>
                            <th style="width: 5%;">Id</th>
							<th style="width: 10%;">Fecha-Emision</th>
							<th style="width: 10%;">Fecha-Entrega</th>
							<th class="d-none d-sm-table-cell" style="width: 6%;">Asesor</th>
							<th class="d-none d-sm-table-cell" style="width: 15%;">Cliente</th>
							<th class="d-none d-sm-table-cell" style="width: 15%;">Direccion</th>
							<th class="d-none d-sm-table-cell" style="width: 10%;">F. Pago</th>
							<th class="d-none d-sm-table-cell" style="width: 8%;">Total</th>
							<th class="text-center" style="width: 5%;"></th>
							<th class="text-center" style="width: 5%;"></th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- Contenido -->	

	<?php require_once("../MainJs/js.php");?>
	
	<script type="text/javascript" src="pedidos.js"></script>

</body>
</html>
<?php
  } else {
    header("Location:".Conectar::ruta()."index.php");
  }
?>