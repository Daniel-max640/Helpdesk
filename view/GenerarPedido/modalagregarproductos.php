<div id="modalagregarproductos"  class="modal bd-example-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
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
                    <div class="container-fluid">
    
                        <input type="hidden" id="usu_id" name="usu_id">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label class="form-label" for="usu_nom">Producto/Servicio</label>
                                    <input type="text" class="form-control" id="usu_nom" name="usu_nom" placeholder="Ingrese Nombre" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-4">
                            <div class="form-group">
                                <label class="control-label">Cantidad</label> 
                                <div class="el-input el-input--small el-input-group el-input-group--append el-input-group--prepend">
                                    <div class="el-input-group__prepend">
                                        <button type="button" class="el-button el-button--default el-button--small" style="padding-right: 5px; padding-left: 12px;"><!----><i class="el-icon-minus"></i><!----></button></div>
                                        <input tabindex="2" type="text" autocomplete="off" class="el-input__inner"><!----><!---->
                                        <div class="el-input-group__append">
                                        <button type="button" class="el-button el-button--default el-button--small" style="padding-right: 5px; padding-left: 12px;"><!----><i class="el-icon-plus"></i><!----></button></div><!---->
                                    </div> <!---->
                                </div>
                            </div>
                        </div>
                        
                    
                        <div class="col-lg-4">
                            <div class="form-group">
                                <label class="form-label" for="usu_correo">Precio Unitario</label>
                                <input type="email" class="form-control" id="usu_correo" name="usu_correo" required>
                            </div>
                        </div>
                        
                    
                        <div class="col-lg-4">
                            <div class="form-group">
                                <label class="form-label" for="usu_pass">Total</label>
                                <input type="text" class="form-control" id="usu_pass" name="usu_pass" required readonly>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-rounded btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="submit" name="action" id="#" value="add" class="btn btn-rounded btn-primary">Agregar</button>
                </div>
    
            </form>
        </div>
    </div>
</div>