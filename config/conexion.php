<?php
    session_start();

    class Conectar{
        protected $dbh;

        protected function Conexion(){
            try {
                //Local
				$conectar = $this->dbh = new PDO("mysql:host=localhost;dbname=sanip_peru","root","");
                //Produccion
             
               //$conectar = $this->dbh = new PDO("mysql:host=localhost;dbname=id20721968_andercode_helpdesk1","id20721968_root","Abigail3005@");
				return $conectar;
			} catch (Exception $e) {
				print "¡Error BD!: " . $e->getMessage() . "<br/>";
				die();
			}
        }

        public function set_names(){
			return $this->dbh->query("SET NAMES 'utf8'");
        }

        public static function ruta(){
            //Local
			return "http://localhost/Helpdesk/";
            //Produccion
            //return https://sanipperuerp.000webhostapp.com/";
		}

    }
?>