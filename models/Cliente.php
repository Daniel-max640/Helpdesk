<?php
    class Cliente extends Conectar{
   
        public function insert_cliente($tipodoc_id,$nro_doc,$nom_cli,$direc_cli,$id_departamento,$id_provincia,$id_distrito,$tele_cli){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="INSERT INTO tm_cliente (id_cliente, tipodoc_id, nro_doc, nom_cli, direc_cli, id_departamento, id_provincia, id_distrito, tele_cli, correo_cli, contacto_telf, contacto_cli, fech_crea, fech_modi, fech_elim, est) VALUES (NULL,?,?,?,?,?,?,?,?, NULL, NULL, NULL, now(), NULL, NULL, '1');";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $tipodoc_id);
            $sql->bindValue(2, $nro_doc);
            $sql->bindValue(3, $nom_cli);
            $sql->bindValue(4, $direc_cli);
            $sql->bindValue(5, $id_departamento);
            $sql->bindValue(6, $id_provincia);
            $sql->bindValue(7, $id_distrito);
            $sql->bindValue(8, $tele_cli);
            
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }


        public function update_cliente($id_cliente,$tipodoc_id,$nro_doc,$nom_cli,$direc_cli,$ubigeo,$tele_cli,$correo_cli,$contacto_tel,$contacto_cli){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="UPDATE tm_cliente set
                tipodoc_id = ?,
                nro_doc = ?,
                nom_cli = ?,
                direc_cli = ?,
                tele_cli = ?,
                correo_cli = ?,
                contacto_tel = ?,
                contacto_cli = ?
                WHERE
                id_cliente = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $tipodoc_id);
            $sql->bindValue(2, $nro_doc);
            $sql->bindValue(3, $nom_cli);
            $sql->bindValue(4, $direc_cli);
            $sql->bindValue(6, $tele_cli);                  
            $sql->bindValue(7, $correo_cli);
            $sql->bindValue(8, $contacto_tel);
            $sql->bindValue(9, $contacto_cli);
            $sql->bindValue(10, $id_cliente);
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

    } 
?>