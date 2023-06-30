<div id="modalagregaryeditar"  class="modal bd-example-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="modal-close" data-dismiss="modal" aria-label="Close">
                    <i class="font-icon-close-2"></i>
                </button>
                <h4 class="modal-title" id="mdltitulo"></h4>
            </div>
            <form method="post" id="servicios_form">
                <div class="modal-body">
                    <div class="container-fluid">
    
                        <input type="hidden" id="usu_id" name="usu_id">
                        
                        <div class="col-lg-8">
                            <div class="form-group">
                                <label class="form-label" for="descripcion">Producto/Servicio</label>
                                <input type="text" class="form-control" id="descripcion" name="descripcion" placeholder="Ingrese producto o servicio" required>
                                <div id="lista">
                                    <ul id="lista-resultados" class="list-group"></ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-2">
                            <div class="form-group">
                                <label class="form-label" for="total">Codigo</label>
                                <input type="text" class="form-control" id="id_producto" name="id_producto" required readonly>
                            </div>
                        </div>

                       <div class="col-lg-2">
							<fieldset class="form-group">
								<label class="form-label" for="exampleInput">Unidad Medida</label>
								<select id="id_medida" name="id_medida" class="form-control" data-placeholder="Seleccionar" required>
								<option label="Seleccionar"></option>
								</select>
							</fieldset>
						</div>
                        
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label class="form-label" for="cant_limpieza">N° Limpiezas</label>
                                <input type="text" class="form-control" id="cant_limpieza" name="cant_limpieza" required>
                            </div>
                        </div>   

                        <div class="col-lg-3">
                            <div class="form-group">
                                <label class="form-label" for="precio">Precio Unitario</label>
                                <input type="text" class="form-control" id="precio" name="precio" required></input>
                            </div>
                        </div>                        
                         
                       <div class="col-lg-3">
                            <div class="row">
                                <div class="form-group">
                                    <label class="form-label">Cantidad</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <button type="button" class="btn btn-default" data-type="minus"><i class="fa fa-minus"></i></button>
                                        </div>
                                        <input type="text" id="cantidad" name="cantidad" class="form-control input-number" value="1" min="1" max="1000">
                                        <div class="input-group-append">
                                            <button type="button" class="btn btn-default" data-type="plus"><i class="fa fa-plus"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                       </div>                 
                                              
                    
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label class="form-label" for="total">Total</label>
                                <input type="text" class="form-control" id="total" name="total" required readonly>
                            </div>
                        </div>

                        <div class="col-lg-12">
							<fieldset class="form-group">
								<label class="form-label semibold" for="descrip_producto">Descripcion de Producto o Servicio</label>
								<div class="summernote-theme-1">
									<textarea id="descrip_producto" name="descrip_producto" class="summernote"></textarea>
								</div>
							</fieldset>
						</div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-rounded btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="button" name="action" id="btn-AgregarDetalle" class="btn btn-rounded btn-primary">Agregar</button>
                </div>    
            </form>
        </div>
    </div>
</div>

