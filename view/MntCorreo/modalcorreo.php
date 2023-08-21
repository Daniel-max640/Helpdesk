<div id="modalcorreo" class="modal fade bd-example-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="modal-close" data-dismiss="modal" aria-label="Close">
                    <i class="font-icon-close-2"></i>
                </button>
                <h4 class="modal-title" id="mdltitulo"></h4>
            </div>
            <form method="post" id="correo_form">
                <div class="modal-body">

                    <div class="form-group">
                        <label class="form-label" for="id_correo">Codigo</label>
                        <input type="text" class="form-control" id="id_correo" name="id_correo" placeholder="Ingrese Nombre" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Correo</label>
                        <input type="text" class="form-control" id="correo" name="correo" placeholder="Ingrese Correo" >
                    </div>

                    <div class="form-group">
                        <label class="form-label">Contraseña</label>
                        <input type="text" class="form-control" id="contrasena" name="contrasena" placeholder="Ingrese Contraseña">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="usu_id">Asignado</label>
                        <select id="usu_id" name="usu_id" class="form-control">
							<option label="Seleccionar"></option>
						</select>
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