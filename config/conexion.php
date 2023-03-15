<?php
    session_start();

    class Conectar{
        protected $dbh;

        protected function Conexion(){
            try {
                //Local
				$conectar = $this->dbh = new PDO("mysql:local=localhost;dbname=andercode_helpdesk1","root","");
                //Produccion
               // $conectar = $this->dbh = new PDO("mysql:host=localhost;dbname=id20283916_helpdesk","id20283916_userhelpdesk","sg%0}$~pU|/iF<fr");
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
			return "http://localhost/TUTORIAL_HELPDESK-main/";
            //Produccion
            //return "http://gestticket.000webhostapp.com/";
		}

    }
?>