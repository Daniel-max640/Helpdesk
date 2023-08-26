<div id="modalmantecliente" class="modal fade bd-example-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
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

                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="home-tab" data-toggle="tab" href="#home" role="tab" aria-controls="home" aria-selected="true">Datos de Cliente</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="profile-tab" data-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="false">Direccion</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="contact-tab" data-toggle="tab" href="#contact" role="tab" aria-controls="contact" aria-selected="false">Otros Datos</a>
                            </li>
                        </ul>

                        <div class="tab-content" id="myTabContent">
                            <div class="tab-pane show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                                <div class="row">

                                    <div class="col-lg-6">                                        
                                        <div class="form-group">
                                            <label class="form-label" for="exampleInput">Tipo Doc. Identidad</label>
                                            <select id="tipodoc_id" name="tipodoc_id" class="form-control" data-placeholder="Seleccionar" required>
                                                <option label="Seleccionar"></option>                                                
                                            </select>                  
                                        </div>
                                    </div>

                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <label class="form-label" for="nro_doc">Nro. Documento</label>
                                            <input type="text" class="form-control" id="nro_doc" name="nro_doc" placeholder="Ingrese Nro. Doc" required>
                                            <p id="documento-error" style="display: none; color: red;"></p>
                                        </div>
                                    </div>

                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <label class="form-label" for="nom_cli">Razon Social / Nombre</label>
                                            <input type="text" class="form-control" id="nom_cli" name="nom_cli" placeholder="Ingrese Nombre" required>
                                        </div>
                                    </div>

                                    <div class="col-lg-5">
                                        <div class="form-group">
                                            <label class="form-label" for="contacto_cli">Contacto</label>
                                            <input type="text" class="form-control" id="contacto_cli" name="contacto_cli" placeholder="Ingrese Nombre Contacto" >
                                        </div>
                                    </div> 

                                    <div class="col-lg-5"> 
                                        <div class="form-group">
                                            <label class="form-label" for="correo_cli">Correo</label>
                                            <input type="email" class="form-control" id="correo_cli" name="correo_cli" placeholder="test@test.com">
                                        </div>
                                    </div>
                                    <div class="col-lg-2"> 
                                        <div class="form-group">
                                            <label class="form-label" for="contacto_telf">Telefono</label>
                                            <input type="text" class="form-control" id="contacto_telf" name="contacto_telf" placeholder="Telefono">
                                            <p id="campo1-error2" style="display: none; color: red;"></p>
                                        </div>
                                    </div>

                                    <div class="col-lg-4">
                                        <fieldset class="form-group">
                                            <label class="form-label semibold" for="exampleInput">Condicion de Credito</label>
                                            <select id="id_ccredito" name="id_ccredito" class="form-control" data-placeholder="Seleccionar">
                                                <option label="Seleccionar"></option>
                                            </select>
                                        </fieldset>
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

                            <div class="tab-pane fade" id="contact" role="tabpanel" aria-labelledby="contact-tab">
                                <div class="row">                                     
                                    
                                    <div class="col-lg-5">
                                        <div class="form-group">
                                            <label class="form-label semibold" for="contacto_cli">Contacto de Facturacion</label>
                                            <input type="text" class="form-control" id="contacto_factu" name="contacto_factu" placeholder="Ingrese Nombre Contacto" >
                                        </div>
                                    </div> 

                                    <div class="col-lg-5"> 
                                        <div class="form-group">
                                            <label class="form-label semibold" for="correo_fac">Correo</label>
                                            <input type="email" class="form-control" id="correo_fac" name="correo_fac" placeholder="test@test.com">
                                        </div>
                                    </div>
                                    <div class="col-lg-2">
                                        <div class="form-group">
                                            <label class="form-label semibold" for="tele_cli">Telf. Contacto</label>
                                            <input type="text" class="form-control" id="tele_cli" name="tele_cli" placeholder="Telefono">
                                            <p id="campo1-error" style="display: none; color: red;"></p>
                                        </div>
                                    </div>                           
                                </div>
                                <div class="row">
                                   
                                    <div class="col-lg-5">
                                        <div class="form-group">
                                            <label class="form-label semibold" for="contacto_cobra">Contacto de Cobranza</label>
                                            <input type="text" class="form-control" id="contacto_cobra" name="contacto_cobra" placeholder="Ingrese Nombre Contacto" >
                                        </div>
                                    </div> 

                                    <div class="col-lg-5"> 
                                        <div class="form-group">
                                            <label class="form-label semibold" for="correo_cobra">Correo</label>
                                            <input type="email" class="form-control" id="correo_cobra" name="correo_cobra" placeholder="test@test.com">
                                        </div>
                                    </div>
                                    <div class="col-lg-2">
                                        <div class="form-group">
                                            <label class="form-label semibold" for="tele_cli">Telf. Contacto</label>
                                            <input type="text" class="form-control" id="tele_cobra" name="tele_cobra" placeholder="Telefono">
                                            <p id="campo1-error" style="display: none; color: red;"></p>
                                        </div>
                                    </div>                                
                                </div>  
                                
                                <div class="row">
                                    <div class="col-lg-12 text-center">
                                        <h6><strong id="contacto-titulo">Agregar Contacto Adicional +</strong></h5>
                                    </div> 
                                    
                                    <div id="campos-contacto-adicional" style="display: none;">                                    
                                        <div class="col-lg-5">
                                            <div class="form-group">
                                                <label class="form-label" for="contacto_cli">Nombre y Apellido</label>
                                                <input type="text" class="form-control" id="contacto_adi" name="contacto_adi" placeholder="Ingrese Nombre Contacto" >
                                            </div>
                                        </div> 

                                        <div class="col-lg-5"> 
                                            <div class="form-group">
                                                <label class="form-label" for="correo_adi">Correo</label>
                                                <input type="email" class="form-control" id="correo_adi" name="correo_adi" placeholder="test@test.com">
                                            </div>
                                        </div>
                                        <div class="col-lg-2">
                                            <div class="form-group">
                                                <label class="form-label" for="tele_cli">Telf. Contacto</label>
                                                <input type="text" class="form-control" id="tele_adi" name="tele_adi" placeholder="Telefono">
                                                <p id="campo1-error" style="display: none; color: red;"></p>
                                            </div>
                                        </div>
                                    </div>    
                                        
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <label class="form-label" for="tele_cli">Sitio Web</label>
                                            <input type="text" class="form-control" id="web" name="web" placeholder="Ingrese URL de Sitio Web">
                                            <p id="campo1-error" style="display: none; color: red;"></p>
                                        </div>
                                    </div>                                  
                                </div>
                            </div>                           
                        </div>
                    </div>                        
                        
                    <div class="modal-footer">
                        <button type="button" class="btn btn-rounded btn-default" data-dismiss="modal">Cerrar</button>
                        <button type="submit" name="action" id="guardarcli" value="add" class="btn btn-rounded btn-primary">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>







