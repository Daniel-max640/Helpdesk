<?php
    class Tservicio extends Conectar{

        public function get_tservicio(){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tipo_servicio WHERE estado=1;";
            $sql=$conectar->prepare($sql);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        /* TODO:Insert */
        public function insert_tservicio($modalidad){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="INSERT INTO tipo_servicio (id_modalidad, modalidad, estado) VALUES (NULL,?,'1');";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $modalidad);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        /* TODO:Update */
        public function update_tservicio($id_modalidad,$modalidad){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="UPDATE tipo_servicio set
                modalidad = ?
                WHERE
                id_modalidad = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $modalidad);
            $sql->bindValue(2, $id_modalidad);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

         /* TODO:Delete */
         public function delete_tservicio($id_modalidad){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="UPDATE tipo_servicio SET
                estado = 0
                WHERE 
                id_modalidad = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_modalidad);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }

        /* TODO:Registro x id */
        public function get_tservicio_x_id($id_modalidad){
            $conectar= parent::conexion();
            parent::set_names();
            $sql="SELECT * FROM tipo_servicio WHERE id_modalidad = ?";
            $sql=$conectar->prepare($sql);
            $sql->bindValue(1, $id_modalidad);
            $sql->execute();
            return $resultado=$sql->fetchAll();
        }


    }
?>