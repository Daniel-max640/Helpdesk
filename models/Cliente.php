<?php
    class Cliente extends Conectar{
   
        public function insert_cliente($tipodoc_id,$nro_doc,$nom_cli,$direc_cli,$id_ccredito,$id_departamento,$id_provincia,$id_distrito,$tele_cli,$correo_cli,$contacto_telf,$contacto_cli,$contacto_factu,$correo_fac,$contacto_cobra,$correo_cobra,$tele_cobra,$contacto_adi,$correo_adi,$tele_adi,$web){
            $conectar= parent::conexion();
            parent::set_names();

            // Verificar si ya existe un cliente con el mismo número de documento
        $sql_count = "SELECT COUNT(*) FROM tm_cliente WHERE nro_doc = ?";
        $stmt = $conectar->prepare($sql_count);
        $stmt->bindValue(1, $nro_doc);
        $stmt->execute();
        $count = $stmt->fetchColumn();

        if ($count > 0) {
            echo "El número de documento ya existe";
            return false;
        } else {   
                $sql="INSERT INTO tm_cliente (id_cliente, tipodoc_id, nro_doc, nom_cli, direc_cli, id_ccredito, id_departamento, id_provincia, id_distrito, tele_cli, correo_cli, contacto_telf, contacto_cli, fech_crea, fech_modi, fech_elim, est, contacto_factu, correo_fac, contacto_cobra, correo_cobra, tele_cobra, contacto_adi, correo_adi, tele_adi, web ) VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?, now(), NULL, NULL, '1',?,?,?,?,?,?,?,?,?);";
                $sql=$conectar->prepare($sql);
                $sql->bindValue(1, $tipodoc_id);
                $sql->bindValue(2, $nro_doc);
                $sql->bindValue(3, $nom_cli);
                $sql->bindValue(4, $direc_cli);
                $sql->bindValue(5, $id_ccredito);
                $sql->bindValue(6, $id_departamento);
                $sql->bindValue(7, $id_provincia);
                $sql->bindValue(8, $id_distrito);
                $sql->bindValue(9, $tele_cli);
                $sql->bindValue(10, $correo_cli);
                $sql->bindValue(11, $contacto_telf);
                $sql->bindValue(12, $contacto_cli);
                $sql->bindValue(13, $contacto_factu);
                $sql->bindValue(14, $correo_fac);
                $sql->bindValue(15, $contacto_cobra);
                $sql->bindValue(16, $correo_cobra);
                $sql->bindValue(17, $tele_cobra);
                $sql->bindValue(18, $contacto_adi);
                $sql->bindValue(19, $correo_adi);
                $sql->bindValue(20, $tele_adi);
                $sql->bindValue(21, $web);
                  
                $sql->execute();
                
                if ($sql->rowCount() > 0) {
                    return true; // El cliente se insertó correctamente
                } else {
                    return false; // Error al insertar el cliente
                }        
                
            }
        } 
        
        public function update_cliente($id_cliente,$tipodoc_id,$nro_doc,$nom_cli,$direc_cli,$id_ccredito,$id_departamento,$id_provincia,$id_distrito,$tele_cli,$correo_cli,$contacto_telf,$contacto_cli,$contacto_factu,$correo_fac,$contacto_cobra,$correo_cobra,$tele_cobra,$contacto_adi,$correo_adi,$tele_adi,$web){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="UPDATE tm_cliente set
                tipodoc_id = ?,
                nro_doc = ?,
                nom_cli = ?,
                direc_cli = ?,
                id_ccredito = ?,
                id_departamento = ?,
                id_provincia = ?,
                id_distrito = ?,
                tele_cli = ?,
                correo_cli = ?,
                contacto_telf = ?,
                contacto_cli = ?,
                contacto_factu = ?,
                correo_fac = ?,
                contacto_cobra = ?,
                correo_cobra = ?,
                tele_cobra = ?,
                contacto_adi = ?,
                correo_adi = ?,
                tele_adi = ?,
                web = ?
                WHERE
                id_cliente = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $tipodoc_id);
            $sql->bindValue(2, $nro_doc);
            $sql->bindValue(3, $nom_cli);
            $sql->bindValue(4, $direc_cli);
            $sql->bindValue(5, $id_ccredito);
            $sql->bindValue(6, $id_departamento);
            $sql->bindValue(7, $id_provincia);
            $sql->bindValue(8, $id_distrito);
            $sql->bindValue(9, $tele_cli);
            $sql->bindValue(10, $correo_cli);
            $sql->bindValue(11, $contacto_telf);
            $sql->bindValue(12, $contacto_cli);
            $sql->bindValue(13, $contacto_factu);
            $sql->bindValue(14, $correo_fac);
            $sql->bindValue(15, $contacto_cobra);
            $sql->bindValue(16, $correo_cobra);
            $sql->bindValue(17, $tele_cobra);
            $sql->bindValue(18, $contacto_adi);
            $sql->bindValue(19, $correo_adi);
            $sql->bindValue(20, $tele_adi);
            $sql->bindValue(21, $web);
            $sql->bindValue(22, $id_cliente);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }
        
        public function buscarCliente($nro_doc) {
            $conectar= parent::conexion(); 
            parent::set_names();           
            // Consulta para buscar al cliente
            $sql = "SELECT * FROM tm_cliente WHERE nro_doc = ? and est = 1";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $nro_doc);
            $sql->execute();
            return $resultado=$sql->fetchAll();
         }

         public function buscarClientes($nro_doc) {
            $conectar= parent::conexion(); 
            parent::set_names();           
            // Consulta para buscar al cliente
            $sql = "SELECT * FROM tm_cliente WHERE nro_doc = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $nro_doc);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }
         
       
        public function get_cliente(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="call sp_l_cliente_01()";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        public function get_cliente_x_id($id_cliente){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="call sp_l_cliente_02(?)";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_cliente);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        public function delete_cliente($id_cliente){
            $conectar= parent::conexion(); 
            parent::set_names();  
            $sql="call sp_d_cliente_01(?)";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_cliente);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }
    } 
?>