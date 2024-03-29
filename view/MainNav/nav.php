<?php
   if ($_SESSION["rol_id"]==1){
    ?>
         <nav class="side-menu">
                <ul class="side-menu-list">
                    <li class="blue-dirty">
                        <a href="..\Home\">
                            <span class="glyphicon glyphicon-th"></span>
                            <span class="lbl">Inicio</span>
                        </a>
                    </li>

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="font-icon font-icon-comments active"></i>
	                    <span class="lbl">Gestion de Tickets</span>
	                    </span>
	                    <ul>
	                        <li>
                                <a href="..\NuevoTicket\"><span class="lbl">NuevoTicket</span></a>
                            </li>
	                        <li>
                                <a href="..\ConsultarTicket\"><span class="lbl">ConsultarTicket</span></a>
                            </li>                  
	                    </ul>
	                </li>

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="glyphicon glyphicon-list-alt"></i>
	                    <span class="lbl">Ventas</span>
	                    </span>
	                    <ul>
                            <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Comprobante Electronico</span></a>
                            </li>
                            <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Listado Comprobantes</span></a>
                            </li>
                            <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Notas de Venta</span></a>
                            </li>
	                        <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Cotizaciones</span></a>
                            </li>
	                        <li>
                                <a href="..\NotaPedido\"><span class="lbl">Notas de Pedido</span></a>
                            </li>                  
	                    </ul>
	                </li>

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="font-icon font-icon-widget"></i>
	                    <span class="lbl">Productos/Servicios</span>
	                    </span>
	                    <ul>
                            <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Modalidad</span></a>
                            </li>
                            <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Equipos Portatiles</span></a>
                            </li>
                          
                            <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Modelos de Portatiles</span></a>
                            </li>

                            <li>
                                <a href="..\NuevoTicket\"><span class="lbl">Servicios</span></a>
                            </li>
	                    </ul>
	                </li>                   

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="font-icon font-icon-user"></i>
	                    <span class="lbl">Clientes</span>
	                    </span>
	                    <ul>
	                        <li>
                                <a href="..\MntCliente\"><span class="lbl">Mantenimiento de Clientes</span></a>
                            </li>	                                   
	                    </ul>
	                </li>

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="font-icon font-icon-user"></i>
	                    <span class="lbl">PDF</span>
	                    </span>
	                    <ul>
	                        <li>
                                <a href="..\TCPDF\"><span class="lbl">IMPRESIONES</span></a>
                            </li>	                                   
	                    </ul>
	                </li>

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="font-icon font-icon-cogwheel"></i>
	                    <span class="lbl">Configuracion</span>
	                    </span>
	                    <ul>
	                        <li>
                                <a href="..\TCPDF\"><span class="lbl">Configuracion</span></a>
                            </li>	                                   
	                    </ul>
	                </li>

                </ul>
            </nav>            
        <?php 
    }else{
    ?>
        <nav class="side-menu">
            <ul class="side-menu-list">
                <li class="blue-dirty">
                    <a href="..\Home\">
                        <span class="glyphicon glyphicon-th"></span>
                        <span class="lbl">Inicio</span>
                    </a>
                </li>

                <li class="blue-dirty with-sub">
	                <span>
	                <i class="font-icon font-icon-comments active"></i>
	                <span class="lbl">Gestion de Tickets</span>
	                </span>
	                <ul>
	                    <li>
                            <a href="..\NuevoTicket\"><span class="lbl">NuevoTicket</span></a>
                        </li>
	                    <li>
                            <a href="..\ConsultarTicket\"><span class="lbl">ConsultarTicket</span></a>
                        </li>                  
	                </ul>
	            </li>

                <li class="blue-dirty with-sub">
	                <span>
	                <i class="font-icon font-icon-user"></i>
	                <span class="lbl">Mantenimiento</span>
	                </span>
                    <ul>
                        <li>
                            <a href="..\MntUsuario\"><span class="lbl">Mantenimiento de Usuarios</span></a>
                        </li>
                                    
                    </ul>
                    <ul>
                        <li>
                            <a href="..\MntCorreo\"><span class="lbl">Mantenimiento de Correos</span></a>
                        </li>                                    
                    </ul>
	            </li> 

            </ul>
        </nav>          
    <?php
   }
?>
            
    
       

