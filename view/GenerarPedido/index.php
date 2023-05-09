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
				<h5 class="m-t-lg with-border">Ingresar Información</h5>
				<div class="row">
					<form method="post" id="ticket_form">
							<input type="hidden" id="usu_id" name="usu_id" value="<?php echo $_SESSION["usu_id"] ?>">

						    <div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">RUC/DNI</label>
									<input type="text" class="form-control" id="nro_doc" name="nro_doc" placeholder="Ingrese RUC/DNI">
									</select>
								</fieldset>
							</div>                      

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Razon Social/Nombres</label>
									<input type="text" class="form-control" id="nom_cli" name="nom_cli" readonly>
								</fieldset>
							</div>						

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Direccion</label>
									<input type="text" class="form-control" id="direc_cli" name="direc_cli" readonly>
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
										<select id="moneda" name="moneda" class="form-control" data-placeholder="Seleccionar" required>
											<option value="1">SOLES</option>
											<option value="2">DOLARES</option>										
										</select>                  
								</div>
							</div>

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Contacto</label>
									<input type="text" class="form-control" id="contacto_cli" name="contacto_cli"  readonly>
  								</fieldset>
							</div>

							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Telf. Contacto</label>
									<input type="text" id="contacto_telf" name="contacto_telf" class="form-control" readonly>
								</fieldset>
							</div>

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Correo</label>
									<input type="text" class="form-control" id="correo_cli" name="correo_cli" readonly>
  								</fieldset>
							</div>

							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Tipo de Servicio</label>
									<select id="modalidad" name="modalidad" class="form-control" data-placeholder="Seleccionar">
									<option label="Seleccionar"></option>
									</select>
								</fieldset>
							</div>
				
							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Contacto de  Servico/Entrega</label>
									<input type="text" class="form-control" id="direc_ser" name="direc_ser" placeholder="Ingrese Contacto">
  								</fieldset>
  							</div>

							  <div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Telf. Contacto Servicio/Entrega</label>
									<input type="text" id="telf_contacto" name="telf_contacto" class="form-control" placeholder="Ingrese Telefono">
								</fieldset>
							</div>
							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Direccion Servico/Entrega</label>
									<input type="text" class="form-control" id="direc_ser" name="direc_ser" placeholder="Ingrese Direccion">
  								</fieldset>
							</div>						


							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Documento a Emitir</label>
									<select id="id_demision" name="id_demision" class="form-control" data-placeholder="Seleccionar">
									<option label="Seleccionar"></option>
									</select>
								</fieldset>
							</div>

							<div class="col-lg-2">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Asesor</label>
									<input type="text" id="asesor" name="asesor" class="form-control" readonly value="<?php echo $_SESSION["usu_nom"] ?> <?php echo $_SESSION["usu_ape"] ?>">
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

							<div class="col-lg-4 flatpickr" data-date-format="d-m-Y" data-wrap="true" data-click-opens="true">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Fecha Servicio/Entrega</label>
									<div id="input-group" class="input-group icon icon-lg icon-color-primary">
										<input class="form-control flatpickr-input" placeholder="Elegir fecha" data-input="" readonly="readonly">
                                		<span class="input-group-append" data-toggle="">
										<span class="input-group-text"><span class="font-icon font-icon-calend"></span></span>
                                    	</span>
									</div>
								</fieldset>
							</div>

							<div class="col-lg-4">
								<fieldset class="form-group">
									<label class="form-label semibold" for="exampleInput">Documentos Adicionales</label>
									<input type="file" name="fileElem1" id="fileElem1" class="form-control" multiple>
								</fieldset>
							</div>

							<div class="col-lg-12">
								<div class="col-lg-4">								
									<button type="button" id="btnagregar" class="btn">+ Agregar Productos/Servicios</i></button>
								</div>
								<div class="box-typical box-typical-padding">				
									<table id="detalle_ped" class="table table-bordered table-striped table-vcenter js-dataTable-full">
										<thead>
											<tr>
												<th style="width: 5%;">Id</th>
												<th style="width: 25%;">Descripción</th>
												<th style="width: 5%;">U.Medida</th>
												<th style="width: 5%;">cantidad</th>
												<th class="d-none d-sm-table-cell" style="width: 8%;">Precio Unitario</th>
												<th class="d-none d-sm-table-cell" style="width: 5%;">Total</th>
												<th class="text-center" style="width: 5%;"></th>
												<th class="text-center" style="width: 5%;"></th>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>
								</div>
							</div>
							
							<!--DETALLE DEL TOTAL-->
							<div class="col-lg-12">							 											
								<p class="text-right"><b>Sub-Total: </b>S/ <span id="total_pagar">0.00</span</p> <!----> 
								<p class="text-right"><b>IGV: </b>S/ <span id="igv">0.00</span</p> <!----> 
								<h3 class="text-right"><b>TOTAL A PAGAR: </b>S/ <span id="total_final">0.00</span></h3>
							</div>
								
							<div class="col-lg-12">
								<fieldset class="form-group">
									<label class="form-label semibold" for="tickd_requi">Observaciones/Requisitos</label>
									<div class="summernote-theme-1">
										<textarea id="tickd_requi" name="tickd_requi" class="summernote" name="name"></textarea>
									</div>
								</fieldset>
							</div>					
									
							<div class="col-lg-12">
								<h5 class="with-border"><b>Contacto de Facturacion</b></h5>
							</div>
							<div class="col-md-4">
								<label class="form-label semibold">Nombres</label>
								<input type="text" class="form-control" id="contac_fac" placeholder="Ingrese Nombre" required>										
							</div>
							<div class="col-md-4">
								<label class="form-label semibold">Correo</label>
								<input type="text" class="form-control" id="correo_fac" placeholder="Ingrese Correo" required>									
							</div>
							<div class="col-md-4">
							<fieldset class="form-group">
								<label  class="form-label semibold">Telefono</label>
								<input type="text" class="form-control" id="Telefono_fac" placeholder="Ingrese Telefono" required>	
							</fieldset>									
							</div>						
							<div class="col-lg-12">
								<h5 class="with-border"><b>Contacto de Cobranza</b></h5>
							</div>
							<div class="col-md-4">
								<label class="form-label semibold">Nombres</label>
								<input type="text" class="form-control" id="contac_fac" placeholder="Ingrese Contacto" required>										
							</div>
							<div class="col-md-4">
								<label class="form-label semibold">Correo</label>
								<input type="text" class="form-control" id="correo_fac" placeholder="Ingrese Correo" required>									
							</div>
							<div class="col-md-4">
								<fieldset class="form-group">
									<label  class="form-label semibold">Telefono</label>
									<input type="text" class="form-control" id="Telefono_fac" placeholder="Ingrese Telefono" required>	
								</fieldset>									
							</div>			
							
							<div class="col-lg-12">
								<fieldset class="form-group">
								<button type="submit" name="action" value="add" class="btn btn-rounded btn-inline btn-primary">Guardar</button>
								</fieldset>
							</div>
					</form>
				</div>
  			</div>
	</div>
	<!-- Contenido -->
	<?php require_once("modalagregarproductos.php");?>
	<?php require_once("../MainJs/js.php");?>

	<script type="text/javascript" src="generarpedido.js"></script>

</body>
</html>
<?php
  } else {
    header("Location:".Conectar::ruta()."index.php");
  }
?>