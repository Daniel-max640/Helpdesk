<?php
    class Correo extends Conectar{

  
        /* TODO:Insert */
        public function insert_correo($correo, $contrasena, $usu_id){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="INSERT INTO tm_correo (id_correo, correo, contrasena, usu_id, estado) VALUES (NULL,?,?,?,'1');";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $correo);
            $sql->bindValue(2, $contrasena);            
            $sql->bindValue(3, $usu_id);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        /* TODO:Update */
        public function update_correo($id_correo, $correo, $contrasena, $usu_id){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="UPDATE tm_correo set
                correo = ?,
                contrasena = ?,
                usu_id = ?
                WHERE
                id_correo = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $correo);
            $sql->bindValue(2, $contrasena);
            $sql->bindValue(3, $usu_id);
            $sql->bindValue(4, $id_correo);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        /* TODO:Delete */
        public function delete_correo($id_correo){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="UPDATE tm_correo SET
                estado = 0
                WHERE 
                id_correo = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_correo);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        /* TODO:Registro x id */
        public function get_correo_x_id($id_correo){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tm_correo WHERE id_correo = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_correo);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

       /* TODO:Todos los registros */
       public function get_correo(){
         $conectar= parent::conexion();
         parent::set_names();
         $sql="SELECT
         tm_correo.id_correo,
         tm_correo.correo,
         tm_correo.contrasena,
         tm_correo.usu_id,
         tm_usuario.usu_nom         
         FROM tm_correo  
         LEFT JOIN tm_usuario on tm_correo.usu_id = tm_usuario.usu_id       
         WHERE estado=1;";
         $sql=$conectar->prepare($sql);
         $sql->execute();
         return $resultado=$sql->fetchAll();
         }
    

    }
?>