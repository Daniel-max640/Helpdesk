<div id="modalmantecliente" class="modal fade bd-example-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="modal-close" data-dismiss="modal" aria-label="Close">
                    <i class="font-icon-close-2"></i>
                </button>
                <h4 class="modal-title" id="mdltitulo"></h4>
            </div>
            <form method="post" id="cliente_form">
                <div class="modal-body">
                    
                    <input type="hidden" id="id_cliente" name="id_cliente">

                    <div class="form-group">
                        <label class="form-label semibold" for="exampleInput">Tipo/Doc</label>
						    <select id="tipodoc_id" name="tipodoc_id" class="form-control" data-placeholder="Seleccionar" required>
						    	<option label="Seleccionar"></option>
                                <option value="1">RUC</option>
                                <option value="2">DNI</option>
                                <option value="3">CE</option>
                                <option value="4">PASAPORTE</option>
						    </select>                  
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="nro_doc">Nro. Documento</label>
                        <input type="text" class="form-control" id="nro_doc" name="nro_doc" placeholder="Ingrese Nro. Doc" required>
                        <p id="documento-error" style="display: none; color: red;"></p>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="nom_cli">Nombre</label>
                        <input type="text" class="form-control" id="nom_cli" name="nom_cli" placeholder="Ingrese Nombre" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="direc_cli">Direccion</label>
                        <input type="text" class="form-control" id="direc_cli" name="direc_cli" placeholder="Ingrese direccion" required>
                    </div>
                    
                    <div class="col-lg-4">
                        <fieldset class="form-group">
                            <label class="form-label semibold" for="exampleInput">Departamento</label>
						        <select id="id_departamento" name="id_departamento" class="form-control" data-placeholder="Seleccionar" required>
						    	    <option label="Seleccionar"></option>
						        </select>
                        </fieldset>    
                    </div>

                    <div class="col-lg-4">
						<fieldset class="form-group">
							<label class="form-label semibold" for="exampleInput">Provincia</label>
							<select id="id_provincia" name="id_provincia" class="form-control" data-placeholder="Seleccionar" required>
								<option label="Seleccionar"></option>
							</select>
						</fieldset>
					</div>

					<div class="col-lg-4">
						<fieldset class="form-group">
							<label class="form-label semibold" for="exampleInput">Distrito</label>
							<select id="id_distrito" name="id_distrito" class="form-control" data-placeholder="Seleccionar" required>
								<option label="Seleccionar"></option>
							</select>
						</fieldset>
					</div>

                    <!--
                    <div class="form-group">
                        <label class="form-label" for="id_provincia1">Provincia</label>
                        <input type="text" class="form-control" id="id_provincia1" name="id_provincia1" placeholder="Ingrese Provincia">
                        <p id="campo1-error" style="display: none; color: red;"></p>
                    </div>
                    -->
                       
                    
                    <div class="form-group">
                        <label class="form-label" for="tele_cli">Telefono</label>
                        <input type="text" class="form-control" id="tele_cli" name="tele_cli" placeholder="Ingrese Telefono">
                        <p id="campo1-error" style="display: none; color: red;"></p>
                    </div>
                       
                    <div class="form-group">
                        <label class="form-label" for="correo_cli">Correo</label>
                        <input type="email" class="form-control" id="correo_cli" name="correo_cli" placeholder="test@test.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="contacto_telf">Telf. Contacto</label>
                        <input type="text" class="form-control" id="contacto_telf" name="contacto_telf" placeholder="Ingrese Telf. Contacto">
                        <p id="campo1-error2" style="display: none; color: red;"></p>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="contacto_cli">Contacto</label>
                        <input type="text" class="form-control" id="contacto_cli" name="contacto_cli" placeholder="Ingrese Nombre Contacto" >
                    </div>                 

                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-rounded btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="submit" name="action" id="#" value="add" class="btn btn-rounded btn-primary">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>



