<?php
  require_once("../../config/conexion.php"); 
  if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
    <?php require_once("../MainHead/head.php");?>
	<title>::Nuevo Ticket</title>
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
							<h3>Nuevo Ticket</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="#">Home</a></li>
								<li class="active">Nuevo Ticket</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="container">
				<div class="col-lg-12">
					<button type="button" id="btnver" name="action" value="add" class="btn btn-rounded btn-inline btn-primary">Imprimir</button>
				</div>				
			</div>
			
		</div>
	</div>
	<!-- Contenido -->

	<?php require_once("../MainJs/js.php");?>

	<script type="text/javascript" src="tcpdf.js"></script>

</body>
</html>
<?php
  } else {
    header("Location:".Conectar::ruta()."index.php");
  }
?>