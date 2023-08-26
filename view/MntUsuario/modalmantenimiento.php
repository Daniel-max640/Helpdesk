<div id="modalmantenimiento" class="modal fade bd-example-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="modal-close" data-dismiss="modal" aria-label="Close">
                    <i class="font-icon-close-2"></i>
                </button>
                <h4 class="modal-title" id="mdltitulo"></h4>
            </div>
            <form method="post" id="usuario_form">
                <div class="modal-body">
                    <input type="hidden" id="usu_id" name="usu_id">

                    <ul class="nav nav-tabs" id="myTab" role="tablist">
                         <li class="nav-item">
                             <a class="nav-link active" id="home-tab" data-toggle="tab" href="#home" role="tab" aria-controls="home" aria-selected="true">Informacion Personal</a>
                         </li>
                         <li class="nav-item">
                             <a class="nav-link" id="profile-tab" data-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="false">Informacion Laboral</a>
                         </li>
                         <li class="nav-item">
                             <a class="nav-link" id="contact-tab" data-toggle="tab" href="#contact" role="tab" aria-controls="contact" aria-selected="false">Documentos Adjuntos</a>
                         </li>
                    </ul>

                    <div class="tab-content" id="myTabContent">
                        <div class="tab-pane show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                            <div class="row">

                                <div class="col-lg-3">
                                    <div class="form-group">
                                        <label class="form-label" for="nro_doc">Nro. Documento</label>
                                        <input type="text" class="form-control" id="nro_doc" name="nro_doc" placeholder="Ingrese Nro. Doc" required>
                                        <p id="documento-error" style="display: none; color: red;"></p>
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="form-group">
                                        <label class="form-label" for="usu_nom">Nombre</label>
                                        <input type="text" class="form-control" id="usu_nom" name="usu_nom" placeholder="Ingrese Nombre" required>
                                    </div>
                                </div>

                                <div class="col-lg-5">
                                    <div class="form-group">
                                        <label class="form-label" for="usu_ape">Apellido</label>
                                        <input type="text" class="form-control" id="usu_ape" name="usu_ape" placeholder="Ingrese Apellido" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label class="form-label" for="usu_correo">Correo Electronico</label>
                                        <input type="email" class="form-control" id="usu_correo" name="usu_correo" placeholder="test@test.com" >
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="form-group">
                                        <label class="form-label" for="usu_pass">Contraseña</label>
                                        <input type="text" class="form-control" id="usu_pass" name="usu_pass" placeholder="************" >
                                    </div>
                                </div>                                
                                
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label class="form-label" for="usu_correo">Direccion</label>
                                        <input type="email" class="form-control" id="usu_correo" name="usu_correo" placeholder="Ingrese Direccion" >
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="form-group">
                                        <label class="form-label" for="usu_pass">Telefono</label>
                                        <input type="text" class="form-control" id="usu_pass" name="usu_pass" placeholder="Ingrese Telefono" >
                                    </div>
                                </div>  
                                
                                <div class="col-lg-2">
                                    <div class="form-group">
                                        <label class="form-label" for="rol_id">Rol</label>
                                        <select class="select2" id="rol_id" name="rol_id">
                                            <option value="1">Usuario</option>
                                            <option value="2">Soporte</option>
                                        </select>
                                    </div>
                                </div>
                            </div>    
                        </div>

                        <div class="tab-pane fade" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                            <div class="row">                       
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-label" for="direc_cli">Direccion</label>
                                        <input type="text" class="form-control" id="direc_cli" name="direc_cli" placeholder="Ingrese direccion">
                                    </div>
                                </div>
                                
                                <div class="col-lg-4">
                                    <fieldset class="form-group">
                                        <label class="form-label" for="exampleInput">Departamento</label>
                                            <select id="id_departamento" name="id_departamento" class="form-control" data-placeholder="Seleccionar">
                                                <option label="Seleccionar"></option>
                                            </select>
                                    </fieldset>    
                                </div>                      
                                <div class="col-lg-4">
                                    <fieldset class="form-group">
                                        <label class="form-label" for="exampleInput">Provincia</label>
                                        <select id="id_provincia" name="id_provincia" class="form-control" data-placeholder="Seleccionar">
                                            <option label="Seleccionar"></option>
                                        </select>
                                    </fieldset>
                                </div>                      
                                <div class="col-lg-4">
                                    <fieldset class="form-group">
                                        <label class="form-label" for="exampleInput">Distrito</label>
                                        <select id="id_distrito" name="id_distrito" class="form-control" data-placeholder="Seleccionar">
                                            <option label="Seleccionar"></option>
                                        </select>
                                    </fieldset>
                                </div>                      
                            </div>    
                        </div>                      
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