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
                                <a href="..\NuevoTicket\"><span class="lbl">Cotizaciones</span></a>
                            </li>
	                        <li>
                                <a href="..\NotaPedido\"><span class="lbl">Notas de Pedido</span></a>
                            </li>                  
	                    </ul>
	                </li>

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="font-icon font-icon-notebook"></i>
	                    <span class="lbl">Pedidos</span>
	                    </span>
	                    <ul>
	                        <li>
                                <a href="..\SeguimientoPedidos\"><span class="lbl">Seguimiento de Pedidos</span></a>
                            </li>	                                   
	                    </ul>
	                </li>

                    <li class="blue-dirty with-sub">
	                    <span>
	                    <i class="font-icon font-icon-user"></i>
	                    <span class="lbl">CRM</span>
	                    </span>
	                    <ul>
	                        <li>
                                <a href="..\MntCliente\"><span class="lbl">Mantenimiento de Clientes</span></a>
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
	            </li>           
            </ul>
        </nav>          
    <?php
   }
?>
            
    
       

