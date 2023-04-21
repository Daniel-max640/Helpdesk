<?php
  require_once("../../config/conexion.php"); 
  if(isset($_SESSION["usu_id"])){ 
?>
<!DOCTYPE html>
<html>
    <?php require_once("../MainHead/head.php");?>
	<title>::Generar Pedidos</title>
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
							<h3>Generar Pedidos</h3>
							<ol class="breadcrumb breadcrumb-simple">
								<li><a href="#">Home</a></li>
								<li class="active">Pedidos</li>
							</ol>
						</div>
					</div>
				</div>
			</header>

			<div class="box-typical box-typical-padding">
				<p>
					Desde esta ventana podra generar Nuevos Pedidos.
				</p>

				<h5 class="m-t-lg with-border">Ingresar Información</h5>

				<div class="row">
					<form method="post" id="ticket_form">

						<input type="hidden" id="usu_id" name="usu_id" value="<?php echo $_SESSION["usu_id"] ?>">

						    <div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">RUC/DNI</label>
									<input type="text" class="form-control" id="tick_titulo" name="tick_titulo" placeholder="Ingrese RUC/DNI">
									</select>
								</fieldset>
							</div>                      

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Razon Social</label>
									<input type="text" class="form-control" id="tick_titulo" name="tick_titulo">
								</fieldset>
							</div>
						

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Direccion</label>
									<input type="text" class="form-control" id="tick_direccion" name="tick_direccion">
								</fieldset>
							</div>

							<div class="col-lg-1">
								<div class="form-group">
									<label class="form-label semibold" for="exampleInput">Serie</label>
										<select id="Serie" name="Serie" class="form-control" data-placeholder="Seleccionar" required>
											<option value="1">NP01</option>									
										</select>              
								</div>
							</div>                      

							<div class="col-lg-1">
								<div class="form-group">
									<label class="form-label semibold" for="exampleInput">Moneda</label>
										<select id="moneda" name="moneda	" class="form-control" data-placeholder="Seleccionar" required>
											<option value="1">SOLES</option>
											<option value="2">DOLARES</option>										
										</select>                  
								</div>
							</div>

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Contacto</label>
									<input type="text" class="form-control" id="tick_titulo" name="tick_titulo" placeholder="Ingrese Nombre">
  								</fieldset>
							</div>

							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Telf. Contacto</label>
									<input type="text" id="telf_contacto" name="telf_contacto" class="form-control">
								</fieldset>
							</div>

							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Modalidad</label>
									<select id="cat_id" name="cat_id" class="form-control" data-placeholder="Seleccionar">
									<option label="Seleccionar"></option>
									</select>
								</fieldset>
							</div>
							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Asesor</label>
									<input type="text" id="usu_id" name="usu_id" class="form-control">
								</fieldset>
							</div>
							
							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Forma de Pago</label>
									<select id="id_pago" name="id_pago" class="form-control" data-placeholder="Seleccionar">
									<option label="Seleccionar"></option>
									</select>
								</fieldset>
							</div>
							
							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Correo</label>
									<input type="text" class="form-control" id="correo" name="correo" placeholder="Ingrese Nombre">
  								</fieldset>
							</div>
							
							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Fecha Entrega</label>
									<div class="input-group date">
									<input id="daterange3" type="text" value="" class="form-control">
									<span class="input-group-append">
										<span class="input-group-text"><i class="font-icon font-icon-calend"></i></span>
									</span>
								</div>
								</fieldset>
							</div>

							
							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Documentos Adicionales</label>
									<input type="file" name="fileElem" id="fileElem" class="form-control" multiple>
								</fieldset>
							</div>
							
							<div class="col-lg-12">
								<button type="submit" name="action" value="add" class="btn btn-rounded btn-inline btn-primary">Guardar</button>
							</div>
					</form>
				</div>

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