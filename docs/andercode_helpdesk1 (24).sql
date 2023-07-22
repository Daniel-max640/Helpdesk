-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-07-2023 a las 19:41:38
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `andercode_helpdesk1`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_ticket` (IN `tick_descrip` VARCHAR(500), IN `tipo_id` INT, IN `cat_id` INT)   BEGIN

IF tick_descrip = '' THEN
SET tick_descrip = NULL;
END IF;

IF tipo_id = '' THEN
SET tipo_id = NULL;
END IF;

IF cat_id = '' THEN
SET cat_id = NULL;
END IF;

SELECT
                tm_ticket.tick_id,
                tm_categoria.cat_nom,
                tm_tipologia.tipo_nom,
                tm_operador.opera_apenom,
                tm_via.via_nom,
                tm_ticket.tick_direccion,
                tm_urbanizacion.urba_nom,
                tm_sector.sector_nom,
                tm_ticket.tick_descrip,
                tm_ticket.tick_estado,
                tm_ticket.tick_coord,
                tm_ticket.tick_horini,
                tm_ticket.fech_crea,
                tm_ticket.agen_id,
                tm_ticket.fech_asig,
                tm_usuario.usu_nom,
                tm_usuario.usu_ape
                FROM
                tm_ticket
                INNER JOIN tm_categoria ON tm_ticket.cat_id = tm_categoria.cat_id
                INNER JOIN tm_tipologia ON tm_ticket.tipo_id = tm_tipologia.tipo_id
                INNER JOIN tm_operador ON tm_ticket.opera_id = tm_operador.opera_id
                INNER JOIN tm_via ON tm_ticket.via_id = tm_via.via_id
                INNER JOIN tm_urbanizacion ON tm_ticket.urba_id = tm_urbanizacion.urba_id
                INNER JOIN tm_sector ON tm_ticket.sector_id = tm_sector.sector_id
                INNER JOIN tm_usuario ON tm_ticket.usu_id = tm_usuario.usu_id
                WHERE
                tm_ticket.est = 1 AND tm_ticket.tick_descrip LIKE IFNULL(tick_descrip,tm_ticket.tick_descrip)
                AND tm_ticket.tipo_id LIKE IFNULL(tipo_id,tm_ticket.tipo_id)
                AND tm_ticket.cat_id LIKE IFNULL(cat_id,tm_ticket.cat_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_d_cliente_01` (IN `xid_cliente` INT)   BEGIN
	UPDATE tm_cliente 
	SET 
		est='0',
		fech_elim = now() 
	where id_cliente=xid_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_d_usuario_01` (IN `xusu_id` INT)   BEGIN
	UPDATE tm_usuario 
	SET 
		est='0',
		fech_elim = now() 
	where usu_id=xusu_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_i_ticketdetalle_01` (IN `xtick_id` INT, IN `xusu_id` INT)   BEGIN
	INSERT INTO td_ticketdetalle 
    (tickd_id,tick_id,usu_id,tickd_descrip,fech_crea,est) 
    VALUES 
    (NULL,xtick_id,xusu_id,'Ticket Cerrado...',now(),'1');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_cliente_01` ()   BEGIN
SELECT 
                tm_cliente.id_cliente,
                tm_cliente.tipodoc_id,
                tm_cliente.nro_doc,
                tm_cliente.nom_cli,
                tm_cliente.direc_cli,
                tm_cliente.id_ccredito,
                tm_cliente.id_departamento,
                tm_cliente.id_provincia,
                tm_cliente.id_distrito,
                tm_cliente.correo_cli,
                tm_cliente.tele_cli, 
                tm_cliente.contacto_telf, 
                tm_cliente.contacto_cli,
                tm_cliente.fech_crea,
                tm_cliente.fech_elim,
                tm_cliente.fech_modi, 
                tm_cliente.est,
                tm_tipodocumento.nom_tipdoc,
                tm_departamento.departamento,
                tm_provincia.nom_provincia,
                tm_distrito.nom_distrito, 
                tm_concredito.descripcion
                FROM tm_cliente 
                LEFT JOIN tm_tipodocumento on tm_cliente.tipodoc_id = tm_tipodocumento.tipodoc_id 
                LEFT JOIN tm_departamento on tm_cliente.id_departamento = tm_departamento.id_departamento 
                LEFT JOIN tm_provincia on tm_cliente.id_provincia = tm_provincia.id_provincia 
                LEFT JOIN tm_distrito on tm_cliente.id_distrito = tm_distrito.id_distrito 
                LEFT JOIN tm_concredito on tm_cliente.id_ccredito = tm_concredito.id_ccredito 
                where tm_cliente.est= '1';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_cliente_02` (IN `xid_cliente` INT)   BEGIN
	SELECT * FROM tm_cliente where id_cliente=xid_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_usuario_01` ()   BEGIN
	SELECT * FROM tm_usuario where est='1';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_usuario_02` (IN `xusu_id` INT)   BEGIN
	SELECT * FROM tm_usuario where usu_id=xusu_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `det_pedido`
--

CREATE TABLE `det_pedido` (
  `id_detpedido` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_servicio` int(11) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `u_medida` varchar(11) DEFAULT NULL,
  `cant_limpieza` int(12) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_uni` decimal(8,2) NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `descrip_producto` varchar(300) DEFAULT NULL,
  `id_acopio` int(11) DEFAULT NULL,
  `cant` int(11) DEFAULT NULL,
  `id_unidad_vehicular` int(11) DEFAULT NULL,
  `id_disposicion` int(11) DEFAULT NULL,
  `personal_solicitado` varchar(400) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `det_pedido`
--

INSERT INTO `det_pedido` (`id_detpedido`, `id_pedido`, `id_servicio`, `descripcion`, `u_medida`, `cant_limpieza`, `cantidad`, `precio_uni`, `total`, `descrip_producto`, `id_acopio`, `cant`, `id_unidad_vehicular`, `id_disposicion`, `personal_solicitado`) VALUES
(861, 351, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M3', 1, 4, '250.00', '1000.00', NULL, NULL, NULL, NULL, NULL, NULL),
(862, 351, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 2, 4, '250.00', '1000.00', NULL, NULL, NULL, NULL, NULL, NULL),
(863, 351, 4, 'DESATORO DE RED DE DESAGÜE', 'M3', 5, 4, '250.00', '1000.00', NULL, NULL, NULL, NULL, NULL, NULL),
(864, 352, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M2', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(865, 352, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M2', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(866, 353, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M2', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(867, 353, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M2', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(868, 354, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M2', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(869, 354, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M2', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(870, 355, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(871, 356, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(872, 356, 4, 'DESATORO DE RED DE DESAGÜE', 'M3', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(873, 357, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(874, 358, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(875, 359, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M2', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(876, 360, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(877, 361, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(878, 362, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(879, 362, 4, 'DESATORO DE RED DE DESAGÜE', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(880, 363, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(881, 364, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(882, 365, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(884, 370, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(885, 371, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M2', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(886, 372, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(887, 373, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(888, 374, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(889, 375, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(890, 376, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(891, 377, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M2', 1, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(900, 163, 13, 'BAÑO STANDAR / LVM', 'UN', 5, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(908, 157, 13, 'BAÑO STANDAR / LVM', 'UN', 1, 2, '350.00', '700.00', NULL, NULL, NULL, NULL, NULL, NULL),
(909, 157, 14, 'BAÑO STANDAR', 'UN', 2, 2, '350.00', '700.00', NULL, NULL, NULL, NULL, NULL, NULL),
(913, 392, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(914, 392, 18, 'BAÑO EJECUTIVO', 'UN', 1, 2, '350.00', '700.00', NULL, NULL, NULL, NULL, NULL, NULL),
(919, 395, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(920, 395, 18, 'BAÑO EJECUTIVO', 'UN', 2, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(924, 394, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(925, 394, 18, 'BAÑO EJECUTIVO', 'M3', 4, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(933, 379, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(934, 379, 4, 'DESATORO DE RED DE DESAGÜE\n', 'M3', 1, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(935, 382, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(936, 382, 18, 'BAÑO EJECUTIVO', 'M3', 4, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(941, 380, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(951, 393, 18, 'BAÑO EJECUTIVO', 'M3', 1, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(952, 393, 15, 'DUCHA', 'UN', 1, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(969, 378, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M2', 4, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(970, 378, 4, 'DESATORO DE RED DE DESAGÜE\n', 'M3', 4, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(971, 378, 18, 'BAÑO EJECUTIVO', 'UN', 5, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(972, 378, 14, 'BAÑO STANDAR', 'UN', 2, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(978, 381, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(979, 381, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(980, 381, 4, 'DESATORO DE RED DE DESAGÜE\n', 'M3', 1, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(981, 396, 18, 'BAÑO EJECUTIVO', 'M3', 10, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(982, 396, 7, 'DESINFECCIÓN', 'M3', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(983, 397, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(984, 397, 18, 'BAÑO EJECUTIVO', 'M3', 2, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(989, 398, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 2, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(990, 398, 18, 'BAÑO EJECUTIVO', 'ML', 5, 1, '350.00', '350.00', NULL, NULL, NULL, NULL, NULL, NULL),
(1003, 403, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', '<p>ssssss</p>', NULL, NULL, NULL, NULL, NULL),
(1004, 403, 7, 'DESINFECCIÓN', 'M2', 2, 3, '250.00', '750.00', '<p>ssss</p>', NULL, NULL, NULL, NULL, NULL),
(1005, 403, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'ML', 5, 1, '250.00', '250.00', '<p>sdfsdfs</p>', NULL, NULL, NULL, NULL, NULL),
(1006, 403, 3, 'LIMPIEZA DE POZO SÉPTICO', 'M2', 2, 1, '250.00', '250.00', '<p>sdfdfsdf</p>', NULL, NULL, NULL, NULL, NULL),
(1045, 407, 13, 'BAÑO STANDAR / LVM', 'M2', 10, 2, '350.00', '700.00', '', NULL, NULL, NULL, NULL, NULL),
(1046, 407, 13, 'BAÑO STANDAR / LVM', 'M3', 10, 3, '350.00', '1050.00', '', NULL, NULL, NULL, NULL, NULL),
(1049, 408, 7, 'DESINFECCIÓN', 'M3', 5, 1, '250.00', '250.00', '<p>Desinfeccion&nbsp;</p>', NULL, NULL, NULL, NULL, NULL),
(1050, 408, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 4, 1, '250.00', '250.00', '<p>Limpieza de trampa de grasa</p>', NULL, NULL, NULL, NULL, NULL),
(1061, 405, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 4, '250.00', '1000.00', '<p>ghjghj</p>', NULL, NULL, NULL, NULL, NULL),
(1062, 405, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 2, 3, '250.00', '750.00', '<p>ghghjghj</p>', NULL, NULL, NULL, NULL, NULL),
(1063, 405, 18, 'BAÑO EJECUTIVO', 'ML', 2, 4, '350.00', '1400.00', '<p>ghjghj</p>', NULL, NULL, NULL, NULL, NULL),
(1064, 405, 27, 'RECOJO DE RESIDUOS SOLIDOS NO PELIGROSOS', 'KG', 5, 4, '350.00', '1400.00', '<p>hjhjkhjk</p>', NULL, NULL, NULL, NULL, NULL),
(1070, 406, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M2', 5, 1, '250.00', '250.00', '<p>limpieza m</p>', NULL, NULL, NULL, NULL, NULL),
(1071, 406, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 5, 1, '250.00', '250.00', 'trampa', NULL, NULL, NULL, NULL, NULL),
(1072, 406, 18, 'BAÑO EJECUTIVO', 'M3', 5, 1, '350.00', '350.00', 'BAÑO', NULL, NULL, NULL, NULL, NULL),
(1073, 406, 7, 'DESINFECCIÓN', 'UN', 5, 2, '250.00', '500.00', '<p>DESINFECCION</p>', NULL, NULL, NULL, NULL, NULL),
(1080, 401, 18, 'BAÑO EJECUTIVO', 'KG', 8, 5, '350.00', '1750.00', NULL, NULL, NULL, NULL, NULL, NULL),
(1081, 401, 15, 'DUCHA', 'UN', 8, 3, '350.00', '1050.00', NULL, NULL, NULL, NULL, NULL, NULL),
(1082, 404, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 5, 1, '250.00', '250.00', '<p>sssss</p>', NULL, NULL, NULL, NULL, NULL),
(1083, 404, 4, 'DESATORO DE RED DE DESAGÜE\n', 'M3', 5, 4, '250.00', '1000.00', '<p>sdfsdfdsf</p>', NULL, NULL, NULL, NULL, NULL),
(1084, 404, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'ML', 1, 3, '250.00', '750.00', '<p>daniel</p><p><br></p><p><br></p>', NULL, NULL, NULL, NULL, NULL),
(1085, 404, 16, 'LAVAMANOS GRANDE', 'M2', 2, 4, '350.00', '1400.00', '<p>lñklñkl</p>', NULL, NULL, NULL, NULL, NULL),
(1086, 399, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(1087, 402, 28, 'RECOJO DE RESIDUOS SOLIDOS PELIGROSOS', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(1088, 402, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M3', 5, 1, '250.00', '250.00', '', NULL, NULL, NULL, NULL, NULL),
(1090, 410, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M2', 0, 1, '250.00', '250.00', '', NULL, NULL, NULL, NULL, NULL),
(1092, 411, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'UN', 0, 1, '250.00', '250.00', '<p>hjkhjkhjk</p>', NULL, NULL, NULL, NULL, NULL),
(1095, 413, 18, 'BAÑO EJECUTIVO', 'UN', 8, 1, '350.00', '350.00', '', NULL, NULL, NULL, NULL, NULL),
(1096, 413, 14, 'BAÑO STANDAR', 'UN', 5, 1, '350.00', '350.00', '', NULL, NULL, NULL, NULL, NULL),
(1097, 414, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 0, 1, '250.00', '250.00', '', 1, 10, 1, 2, NULL),
(1123, 415, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'ML', 0, 1, '250.00', '250.00', '', 1, 10, 2, 1, NULL),
(1124, 415, 3, 'LIMPIEZA DE POZO SÉPTICO\n', 'KG', 0, 1, '250.00', '250.00', '', 3, 10, 3, 2, NULL),
(1125, 415, 4, 'DESATORO DE RED DE DESAGÜE\n', 'M2', 0, 1, '250.00', '250.00', '', 5, 10, 4, 2, NULL),
(1126, 417, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'M2', 0, 1, '250.00', '250.00', '', 2, 10, 1, 2, 'conductor, ayudantes, preventor'),
(1133, 416, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 0, 1, '250.00', '250.00', '', 4, 10, 1, 2, 'ayudantes, operarios'),
(1134, 416, 3, 'LIMPIEZA DE POZO SÉPTICO', 'M3', 0, 1, '250.00', '250.00', '<p><br></p>', 4, 10, 1, 1, 'ayudantes'),
(1135, 418, 7, 'DESINFECCIÓN', 'M2', 0, 1, '250.00', '250.00', '', 2, 10, 2, 1, ''),
(1136, 419, 7, 'DESINFECCIÓN', 'UN', 0, 1, '250.00', '250.00', '', 2, 10, 1, 1, ''),
(1137, 420, 25, 'SERVICIO DE SUCCION DE RESIDUOS NO PELIGROSOS', 'M3', 0, 1, '350.00', '350.00', '', 2, 10, 3, 1, ''),
(1138, 421, 7, 'DESINFECCIÓN', 'M2', 0, 1, '250.00', '250.00', '', 2, 10, 3, 1, ''),
(1139, 422, 25, 'SERVICIO DE SUCCION DE RESIDUOS NO PELIGROSOS', 'M2', 0, 1, '350.00', '350.00', '', 2, 10, 3, 2, ''),
(1140, 423, 2, 'LIMPIEZA DE TRAMPA DE GRASA', 'L', 0, 1, '250.00', '250.00', '', 1, 10, 2, 3, ''),
(1158, 412, 13, 'BAÑO STANDAR / LVM', 'UN', 5, 1, '350.00', '350.00', '', NULL, NULL, NULL, NULL, NULL),
(1159, 424, 25, 'SERVICIO DE SUCCION DE RESIDUOS NO PELIGROSOS', 'M3', 0, 1, '350.00', '350.00', '', 3, 10, 2, 1, ''),
(1162, 426, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 0, 1, '250.00', '250.00', '', 0, 0, 0, 0, ''),
(1163, 427, 7, 'DESINFECCIÓN', 'M3', 0, 2, '250.00', '500.00', '', NULL, 0, NULL, NULL, ''),
(1164, 427, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'KG', 0, 1, '250.00', '250.00', '', 0, 0, 0, 0, ''),
(1165, 427, 4, 'DESATORO DE RED DE DESAGÜE', 'KG', 0, 1, '250.00', '250.00', '<p><br></p>', 0, 0, 0, 0, ''),
(1166, 409, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'ML', 5, 2, '250.00', '500.00', '', 0, 0, 0, 0, ''),
(1167, 425, 2, 'LIMPIEZA DE TRAMPA DE GRASA\n', 'M3', 0, 1, '250.00', '250.00', '', 3, 10, 2, 2, ''),
(1168, 425, 18, 'BAÑO EJECUTIVO', 'M2', 0, 1, '350.00', '350.00', '<p><br></p>', 4, 10, 4, 2, ''),
(1172, 428, 18, 'BAÑO EJECUTIVO', 'UN', 10, 6, '350.00', '2100.00', '', 0, 0, 0, 0, 'Conductor - Ayudante'),
(1173, 428, 14, 'BAÑO STANDAR', 'M3', 10, 1, '350.00', '350.00', '', 0, 0, 0, 0, ''),
(1180, 429, 18, 'BAÑO EJECUTIVO', 'M3', 10, 4, '350.00', '1400.00', '', NULL, 0, NULL, NULL, 'Conductor, ayudante'),
(1181, 429, 13, 'BAÑO STANDAR / LVM', 'M2', 10, 1, '350.00', '350.00', '', NULL, 0, NULL, NULL, ''),
(1182, 400, 1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', 'M3', 5, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(1183, 400, 4, 'DESATORO DE RED DE DESAGÜE\n', 'KG', 1, 1, '250.00', '250.00', NULL, NULL, NULL, NULL, NULL, NULL),
(1184, 430, 28, 'RECOJO DE RESIDUOS SOLIDOS PELIGROSOS', 'M3', 0, 1, '250.00', '250.00', '', 6, 10, 1, 2, 'Ayudantes,  Operarios, SSoma');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `doc_emision`
--

CREATE TABLE `doc_emision` (
  `id_demision` int(11) NOT NULL,
  `documento` varchar(50) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `doc_emision`
--

INSERT INTO `doc_emision` (`id_demision`, `documento`, `estado`) VALUES
(1, 'Factura', 1),
(2, 'Boleta', 1),
(3, 'Nota de Venta', 1),
(4, 'Nota de Credito', 1),
(5, 'Nota de Debito', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `forma_pago`
--

CREATE TABLE `forma_pago` (
  `id_fpago` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `forma_pago`
--

INSERT INTO `forma_pago` (`id_fpago`, `descripcion`, `estado`) VALUES
(1, 'Contado', 1),
(2, 'Crédito', 1),
(3, 'Anticipado', 1),
(4, 'Pago Parcial', 1),
(5, 'Crédito en Cuotas', 1),
(6, 'Efectivo', 1),
(7, 'Tarjeta de Crédito', 1),
(8, 'Tarjeta de Debito', 1),
(9, 'Transferencia', 1),
(10, 'Factura a 30 días ', 1),
(11, 'Tarjeta Crédito Visa', 1),
(12, 'Contado Contraentrega', 1),
(13, 'A 30 dias', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tdoc_emision`
--

CREATE TABLE `tdoc_emision` (
  `id_tdocemi` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documento`
--

CREATE TABLE `td_documento` (
  `doc_id` int(11) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `doc_nom` varchar(400) NOT NULL,
  `fech_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `td_documento`
--

INSERT INTO `td_documento` (`doc_id`, `tick_id`, `doc_nom`, `fech_crea`, `est`) VALUES
(1, 283, 'Imagen de WhatsApp 2023-02-14 a las 08.06.52.jpg', '2023-02-21 16:46:59', 1),
(2, 284, 'Imagen de WhatsApp 2023-02-14 a las 08.00.16 - copia.jpg', '2023-02-21 17:04:20', 1),
(3, 284, 'Imagen de WhatsApp 2023-02-14 a las 08.00.16.jpg', '2023-02-21 17:04:20', 1),
(4, 284, 'Imagen de WhatsApp 2023-02-14 a las 08.00.25 - copia.jpg', '2023-02-21 17:04:20', 1),
(5, 285, 'Imagen de WhatsApp 2023-02-14 a las 08.00.16 - copia.jpg', '2023-02-21 17:34:49', 1),
(6, 285, 'Imagen de WhatsApp 2023-02-14 a las 08.00.16.jpg', '2023-02-21 17:34:49', 1),
(7, 285, 'Imagen de WhatsApp 2023-02-14 a las 08.00.25 - copia.jpg', '2023-02-21 17:34:49', 1),
(8, 285, 'Imagen de WhatsApp 2023-02-14 a las 08.00.25.jpg', '2023-02-21 17:34:49', 1),
(9, 285, 'Imagen de WhatsApp 2023-02-14 a las 08.04.16 - copia.jpg', '2023-02-21 17:34:49', 1),
(10, 285, 'Imagen de WhatsApp 2023-02-14 a las 08.04.16.jpg', '2023-02-21 17:34:49', 1),
(11, 286, 'Imagen de WhatsApp 2023-02-14 a las 08.00.25 - copia.jpg', '2023-02-22 08:59:19', 1),
(12, 287, 'id20275467.docx', '2023-02-22 15:41:52', 1),
(13, 287, 'COTIZACION DE MODULARES.pdf', '2023-02-22 15:41:52', 1),
(14, 287, 'correos y contraseñas.docx', '2023-02-22 15:41:52', 1),
(15, 288, 'Captura de pantalla (1).png', '2023-02-22 15:44:47', 1),
(16, 289, 'FIRMAS PERSONAL DANIEL SANIP_Mesa de trabajo 1 copia 31.png', '2023-02-23 08:46:42', 1),
(17, 292, 'FIRMAS PERSONAL DANIEL SANIP_Mesa de trabajo 1 copia 31.png', '2023-02-23 16:36:03', 1),
(18, 293, 'sika_-3.pdf', '2023-02-23 16:41:18', 1),
(19, 294, 'FIRMAS PERSONAL DANIEL SANIP_Mesa de trabajo 1 copia 31.png', '2023-02-24 17:23:31', 1),
(20, 300, 'FIRMAS PERSONAL DANIEL SANIP_Mesa de trabajo 1 copia 31.png', '2023-02-27 14:14:57', 1),
(21, 312, 'FIRMAS PERSONAL DANIEL SANIP_Mesa de trabajo 1 copia 31.png', '2023-02-28 08:30:45', 1),
(22, 313, 'FIRMAS PERSONAL DANIEL SANIP_Mesa de trabajo 1 copia 31.png', '2023-03-01 09:48:59', 1),
(23, 317, 'Imagen de WhatsApp 2023-02-14 a las 08.00.16.jpg', '2023-03-03 08:39:00', 1),
(24, 325, 'Captura de pantalla (1).png', '2023-04-17 12:42:51', 1),
(25, 326, 'bases-dia-del-trabajo-1-320 (1).JPG', '2023-05-05 16:55:03', 1),
(26, 327, 'NV01-8-20230505.pdf', '2023-05-06 10:37:36', 1),
(27, 328, 'recibo-5998838178-2023-04-12.pdf', '2023-05-08 12:47:35', 1),
(28, 329, 'bases-dia-del-trabajo-1-320.webp', '2023-05-08 12:48:09', 1),
(29, 330, 'recibo-5998838178-2023-04-12.pdf', '2023-05-09 17:30:27', 1),
(30, 338, 'andercode_helpdesk1 (14).sql', '2023-05-12 10:35:44', 1),
(31, 345, 'recibo-5998838178-2023-04-12.pdf', '2023-05-12 10:45:31', 1),
(32, 346, 'recibo-5998838178-2023-04-12.pdf', '2023-05-12 10:45:48', 1),
(33, 350, 'andercode_helpdesk1 (14).sql', '2023-05-12 10:54:24', 1),
(34, 351, 'andercode_helpdesk1 (14).sql', '2023-05-12 10:54:50', 1),
(35, 352, 'NV01-8-20230505.pdf', '2023-05-12 10:55:53', 1),
(36, 359, 'andercode_helpdesk1 (15).sql', '2023-05-13 08:43:39', 1),
(37, 367, 'Captura de pantalla 2023-05-19 101206.png', '2023-05-26 12:54:26', 1),
(38, 368, 'Captura de pantalla (1).png', '2023-06-07 15:07:03', 1),
(39, 368, 'Captura de pantalla 2023-04-15 092610.png', '2023-06-07 15:07:03', 1),
(40, 368, 'Captura de pantalla 2023-04-15 092730.png', '2023-06-07 15:07:03', 1),
(41, 368, 'Captura de pantalla 2023-04-15 095044.png', '2023-06-07 15:07:03', 1),
(42, 368, 'Captura de pantalla 2023-05-19 095227.png', '2023-06-07 15:07:03', 1),
(43, 368, 'Captura de pantalla 2023-05-19 101206.png', '2023-06-07 15:07:03', 1),
(44, 368, 'Captura de pantalla 2023-05-19 142459.png', '2023-06-07 15:07:03', 1),
(45, 369, 'Imagen de WhatsApp 7.jpg', '2023-06-07 17:47:25', 1),
(46, 370, 'Imagen de WhatsApp 2023-05-19 a las 15.24.51.jpg', '2023-06-08 08:11:38', 1),
(47, 371, '20230610092522.pdf', '2023-06-15 12:25:04', 1),
(48, 371, '20230610092600.pdf', '2023-06-15 12:25:04', 1),
(49, 371, '20230610092949.pdf', '2023-06-15 12:25:04', 1),
(50, 371, '20230610093030.pdf', '2023-06-15 12:25:04', 1),
(51, 374, '20230610092522.pdf', '2023-06-21 11:51:00', 1),
(52, 375, '20230610120203.pdf', '2023-06-23 11:18:46', 1),
(53, 376, 'Recibo de Servicio.pdf', '2023-06-26 17:41:46', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documentopedido`
--

CREATE TABLE `td_documentopedido` (
  `id_documento` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `doc_nombre` varchar(400) NOT NULL,
  `fecha_crea` datetime NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `td_documentopedido`
--

INSERT INTO `td_documentopedido` (`id_documento`, `id_pedido`, `doc_nombre`, `fecha_crea`, `estado`) VALUES
(1, 247, 'Imagen de WhatsApp 6.jpg', '2023-06-08 10:01:11', 1),
(2, 248, 'Imagen de WhatsApp 6.jpg', '2023-06-08 10:02:14', 1),
(3, 248, 'Imagen de WhatsApp 7.jpg', '2023-06-08 10:02:14', 1),
(4, 248, 'Imagen de WhatsApp 2023-05-19 a las 15.24.51.jpg', '2023-06-08 10:02:14', 1),
(5, 249, 'Imagen de WhatsApp 2.jpg', '2023-06-08 10:04:06', 1),
(6, 249, 'Imagen de WhatsApp 3.jpg', '2023-06-08 10:04:06', 1),
(7, 249, 'Imagen de WhatsApp 4.jpg', '2023-06-08 10:04:06', 1),
(8, 249, 'Imagen de WhatsApp 5.jpg', '2023-06-08 10:04:06', 1),
(9, 251, 'Imagen de WhatsApp 4.jpg', '2023-06-08 10:20:08', 1),
(10, 763, 'Imagen de WhatsApp 7.jpg', '2023-06-08 10:52:41', 1),
(11, 763, 'Imagen de WhatsApp 2023-05-19 a las 15.24.51.jpg', '2023-06-08 10:52:41', 1),
(12, 765, 'Imagen de WhatsApp 5.jpg', '2023-06-08 11:12:56', 1),
(13, 766, 'Imagen de WhatsApp 5.jpg', '2023-06-08 14:34:12', 1),
(14, 265, 'Imagen de WhatsApp 2023-05-19 a las 15.24.51.jpg', '2023-06-08 14:46:20', 1),
(15, 267, 'Imagen de WhatsApp 5.jpg', '2023-06-08 14:48:36', 1),
(16, 776, 'Imagen de WhatsApp 7.jpg', '2023-06-08 15:51:47', 1),
(17, 777, 'Imagen de WhatsApp 4.jpg', '2023-06-08 15:53:35', 1),
(18, 779, 'Imagen de WhatsApp 7.jpg', '2023-06-08 19:39:00', 1),
(19, 300, 'Imagen de WhatsApp 7.jpg', '2023-06-09 09:22:24', 1),
(20, 301, 'Imagen de WhatsApp 7.jpg', '2023-06-09 09:34:09', 1),
(21, 304, '20230610092600.pdf', '2023-06-10 10:53:23', 1),
(22, 307, '20230610093144.pdf', '2023-06-10 11:10:23', 1),
(23, 311, '20230610093225.pdf', '2023-06-10 11:31:17', 1),
(24, 809, '20230610093030.pdf', '2023-06-10 12:03:42', 1),
(25, 812, '20230610093030.pdf', '2023-06-10 12:12:39', 1),
(26, 813, '20230610093030.pdf', '2023-06-12 09:17:08', 1),
(27, 816, '20230610093413.pdf', '2023-06-12 16:38:07', 1),
(28, 829, '20230610092949.pdf', '2023-06-12 18:12:22', 1),
(29, 830, '20230610092600.pdf', '2023-06-15 08:42:11', 1),
(30, 831, '20230610093225.pdf', '2023-06-15 09:01:45', 1),
(31, 342, '20230610092949.pdf', '2023-06-15 11:05:11', 1),
(32, 342, '20230610092949.pdf', '2023-06-15 11:05:11', 1),
(33, 342, '20230610093030.pdf', '2023-06-15 11:05:11', 1),
(34, 342, '20230610093030.pdf', '2023-06-15 11:05:11', 1),
(35, 342, '20230610093144.pdf', '2023-06-15 11:05:11', 1),
(36, 342, '20230610093144.pdf', '2023-06-15 11:05:11', 1),
(37, 344, '20230610092600.pdf', '2023-06-15 11:11:21', 1),
(38, 344, '20230610092600.pdf', '2023-06-15 11:11:21', 1),
(39, 344, '20230610092949.pdf', '2023-06-15 11:11:21', 1),
(40, 344, '20230610092949.pdf', '2023-06-15 11:11:21', 1),
(41, 345, '20230610093030.pdf', '2023-06-15 11:20:30', 1),
(42, 345, '20230610093144.pdf', '2023-06-15 11:20:30', 1),
(43, 345, '20230610093225.pdf', '2023-06-15 11:20:30', 1),
(44, 345, '20230610093302.pdf', '2023-06-15 11:20:30', 1),
(45, 345, '20230610093413.pdf', '2023-06-15 11:20:30', 1),
(46, 347, '20230610093302.pdf', '2023-06-15 15:25:11', 1),
(47, 347, '20230610093413.pdf', '2023-06-15 15:25:11', 1),
(48, 347, '20230610093450.pdf', '2023-06-15 15:25:11', 1),
(49, 348, '20230610093225.pdf', '2023-06-15 15:26:08', 1),
(50, 349, '20230607130524.pdf', '2023-06-15 15:27:18', 1),
(51, 349, '20230610083759.pdf', '2023-06-15 15:27:18', 1),
(52, 349, '20230610092522.pdf', '2023-06-15 15:27:18', 1),
(53, 349, '20230610092600.pdf', '2023-06-15 15:27:18', 1),
(54, 349, '20230610092949.pdf', '2023-06-15 15:27:18', 1),
(55, 350, '20230610093030.pdf', '2023-06-15 15:28:06', 1),
(56, 351, '20230607130524.pdf', '2023-06-15 16:57:32', 1),
(57, 351, '20230610083759.pdf', '2023-06-15 16:57:32', 1),
(58, 351, '20230610092522.pdf', '2023-06-15 16:57:32', 1),
(59, 351, '20230610092600.pdf', '2023-06-15 16:57:32', 1),
(60, 352, '20230607130524.pdf', '2023-06-15 17:03:00', 1),
(61, 352, '20230610083759.pdf', '2023-06-15 17:03:00', 1),
(62, 352, '20230610092522.pdf', '2023-06-15 17:03:00', 1),
(63, 352, '20230610092600.pdf', '2023-06-15 17:03:00', 1),
(64, 352, '20230610092949.pdf', '2023-06-15 17:03:00', 1),
(65, 352, '20230610093030.pdf', '2023-06-15 17:03:00', 1),
(66, 352, '20230610093144.pdf', '2023-06-15 17:03:00', 1),
(67, 352, '20230610093225.pdf', '2023-06-15 17:03:00', 1),
(68, 352, '20230610093302.pdf', '2023-06-15 17:03:00', 1),
(69, 353, '20230607130524.pdf', '2023-06-15 17:03:01', 1),
(70, 353, '20230610083759.pdf', '2023-06-15 17:03:01', 1),
(71, 353, '20230610092522.pdf', '2023-06-15 17:03:01', 1),
(72, 353, '20230610092600.pdf', '2023-06-15 17:03:01', 1),
(73, 353, '20230610092949.pdf', '2023-06-15 17:03:01', 1),
(74, 353, '20230610093030.pdf', '2023-06-15 17:03:01', 1),
(75, 353, '20230610093144.pdf', '2023-06-15 17:03:01', 1),
(76, 353, '20230610093225.pdf', '2023-06-15 17:03:01', 1),
(77, 353, '20230610093302.pdf', '2023-06-15 17:03:01', 1),
(78, 354, '20230607130524.pdf', '2023-06-15 17:03:17', 1),
(79, 354, '20230610083759.pdf', '2023-06-15 17:03:17', 1),
(80, 354, '20230610092522.pdf', '2023-06-15 17:03:17', 1),
(81, 354, '20230610092600.pdf', '2023-06-15 17:03:17', 1),
(82, 354, '20230610092949.pdf', '2023-06-15 17:03:17', 1),
(83, 354, '20230610093030.pdf', '2023-06-15 17:03:17', 1),
(84, 354, '20230610093144.pdf', '2023-06-15 17:03:17', 1),
(85, 354, '20230610093225.pdf', '2023-06-15 17:03:17', 1),
(86, 354, '20230610093302.pdf', '2023-06-15 17:03:17', 1),
(87, 355, '20230607130524.pdf', '2023-06-15 17:05:16', 1),
(88, 355, '20230610083759.pdf', '2023-06-15 17:05:16', 1),
(89, 355, '20230610092522.pdf', '2023-06-15 17:05:16', 1),
(90, 355, '20230610092600.pdf', '2023-06-15 17:05:16', 1),
(91, 355, '20230610092949.pdf', '2023-06-15 17:05:16', 1),
(92, 355, '20230610093030.pdf', '2023-06-15 17:05:16', 1),
(93, 355, '20230610093144.pdf', '2023-06-15 17:05:16', 1),
(94, 356, '20230607130524.pdf', '2023-06-16 09:12:28', 1),
(95, 356, '20230610083759.pdf', '2023-06-16 09:12:28', 1),
(96, 356, '20230610092522.pdf', '2023-06-16 09:12:28', 1),
(97, 356, '20230610092600.pdf', '2023-06-16 09:12:28', 1),
(98, 358, '20230607130524.pdf', '2023-06-16 09:31:39', 1),
(99, 358, '20230610083759.pdf', '2023-06-16 09:31:39', 1),
(100, 358, '20230610092522.pdf', '2023-06-16 09:31:39', 1),
(101, 358, '20230610092600.pdf', '2023-06-16 09:31:39', 1),
(102, 358, '20230610092949.pdf', '2023-06-16 09:31:39', 1),
(103, 359, '20230607130524.pdf', '2023-06-16 09:34:41', 1),
(104, 359, '20230610083759.pdf', '2023-06-16 09:34:41', 1),
(105, 359, '20230610092522.pdf', '2023-06-16 09:34:41', 1),
(106, 359, '20230610092600.pdf', '2023-06-16 09:34:41', 1),
(107, 359, '20230610092949.pdf', '2023-06-16 09:34:41', 1),
(108, 360, '20230610083759.pdf', '2023-06-16 09:35:48', 1),
(109, 360, '20230610092522.pdf', '2023-06-16 09:35:48', 1),
(110, 360, '20230610092600.pdf', '2023-06-16 09:35:48', 1),
(111, 360, '20230610092949.pdf', '2023-06-16 09:35:48', 1),
(112, 361, '20230610093144.pdf', '2023-06-16 09:38:24', 1),
(113, 361, '20230610093225.pdf', '2023-06-16 09:38:24', 1),
(114, 361, '20230610093302.pdf', '2023-06-16 09:38:24', 1),
(115, 362, 'reporte-cierre-caja-17-06-2023-085007.xls', '2023-06-17 10:02:40', 1),
(116, 362, 'reporte-ventas-locales20230617083708.xls', '2023-06-17 10:02:40', 1),
(117, 362, '10444444444-01-F001-15.xml', '2023-06-17 10:02:40', 1),
(118, 362, 'andercode_helpdesk1 (22).sql', '2023-06-17 10:02:40', 1),
(119, 367, 'reporte-cierre-caja-17-06-2023-085007.xls', '2023-06-19 09:22:49', 1),
(120, 367, 'reporte-cierre-caja-17-06-2023-084958.xls', '2023-06-19 09:22:49', 1),
(121, 368, 'reporte-cierre-caja-17-06-2023-085007.xls', '2023-06-19 09:34:11', 1),
(122, 369, 'reporte-cierre-caja-17-06-2023-085007.xls', '2023-06-19 09:39:04', 1),
(123, 369, 'reporte-cierre-caja-17-06-2023-084958.xls', '2023-06-19 09:39:04', 1),
(124, 369, 'reporte-ventas-locales20230617083708.xls', '2023-06-19 09:39:04', 1),
(125, 369, 'Reporte_C_Cobrar_F_Pago2023-06-14 12_33_51.xlsx', '2023-06-19 09:39:04', 1),
(126, 369, 'R-10444444444-01-F001-15.zip', '2023-06-19 09:39:04', 1),
(127, 369, '10444444444-01-F001-15.xml', '2023-06-19 09:39:04', 1),
(128, 370, 'reporte-cierre-caja-17-06-2023-085007.xls', '2023-06-19 09:47:06', 1),
(129, 370, 'reporte-cierre-caja-17-06-2023-084958.xls', '2023-06-19 09:47:06', 1),
(130, 370, 'reporte-ventas-locales20230617083708.xls', '2023-06-19 09:47:06', 1),
(131, 370, 'Reporte_C_Cobrar_F_Pago2023-06-14 12_33_51.xlsx', '2023-06-19 09:47:06', 1),
(132, 373, 'reporte-cierre-caja-17-06-2023-084958.xls', '2023-06-19 12:37:34', 1),
(133, 374, 'reporte-cierre-caja-17-06-2023-085007.xls', '2023-06-19 12:42:14', 1),
(134, 374, 'reporte-cierre-caja-17-06-2023-084958.xls', '2023-06-19 12:42:14', 1),
(135, 374, 'reporte-ventas-locales20230617083708.xls', '2023-06-19 12:42:14', 1),
(136, 376, 'reporte-cierre-caja-17-06-2023-084958.xls', '2023-06-19 12:44:09', 1),
(137, 376, 'reporte-ventas-locales20230617083708.xls', '2023-06-19 12:44:09', 1),
(138, 376, 'Reporte_C_Cobrar_F_Pago2023-06-14 12_33_51.xlsx', '2023-06-19 12:44:09', 1),
(139, 376, 'R-10444444444-01-F001-15.zip', '2023-06-19 12:44:09', 1),
(140, 376, '10444444444-01-F001-15.xml', '2023-06-19 12:44:09', 1),
(141, 378, 'Captura de pantalla 2023-04-15 092610.png', '2023-06-19 16:11:51', 1),
(142, 378, 'Captura de pantalla 2023-04-15 092730.png', '2023-06-19 16:11:51', 1),
(143, 378, 'Captura de pantalla 2023-04-15 095044.png', '2023-06-19 16:11:51', 1),
(144, 378, 'Captura de pantalla 2023-05-19 095227.png', '2023-06-19 16:11:51', 1),
(145, 379, 'Captura de pantalla (1).png', '2023-06-20 08:56:21', 1),
(146, 379, 'Captura de pantalla 2023-04-15 092610.png', '2023-06-20 08:56:21', 1),
(147, 379, 'Captura de pantalla 2023-04-15 092730.png', '2023-06-20 08:56:21', 1),
(148, 379, 'Captura de pantalla 2023-04-15 095044.png', '2023-06-20 08:56:21', 1),
(149, 379, 'Captura de pantalla 2023-05-19 095227.png', '2023-06-20 08:56:21', 1),
(150, 379, 'Captura de pantalla 2023-05-19 101206.png', '2023-06-20 08:56:21', 1),
(151, 379, 'Captura de pantalla 2023-05-19 142459.png', '2023-06-20 08:56:21', 1),
(152, 380, 'Imagen de WhatsApp 2023-06-20 a las 16.03.44.jpg', '2023-06-20 17:38:22', 1),
(153, 381, '20230607130524.pdf', '2023-06-20 18:03:29', 1),
(154, 381, '20230610083759.pdf', '2023-06-20 18:03:29', 1),
(155, 381, '20230610092522.pdf', '2023-06-20 18:03:29', 1),
(156, 381, '20230610092600.pdf', '2023-06-20 18:03:29', 1),
(157, 381, '20230610092949.pdf', '2023-06-20 18:03:29', 1),
(158, 382, '20230607130524.pdf', '2023-06-20 18:04:31', 1),
(159, 382, '20230610083759.pdf', '2023-06-20 18:04:31', 1),
(160, 382, '20230610092522.pdf', '2023-06-20 18:04:31', 1),
(161, 382, '20230610092600.pdf', '2023-06-20 18:04:31', 1),
(162, 392, '20230607130524.pdf', '2023-06-22 08:32:11', 1),
(163, 392, '20230610083759.pdf', '2023-06-22 08:32:11', 1),
(164, 392, '20230610092522.pdf', '2023-06-22 08:32:11', 1),
(165, 393, '20230610083759.pdf', '2023-06-22 09:13:40', 1),
(166, 393, '20230610092522.pdf', '2023-06-22 09:13:40', 1),
(167, 393, '20230610092600.pdf', '2023-06-22 09:13:40', 1),
(168, 393, '20230610092949.pdf', '2023-06-22 09:13:40', 1),
(169, 393, '20230610093030.pdf', '2023-06-22 09:13:40', 1),
(170, 394, '20230607130524.pdf', '2023-06-22 10:11:11', 1),
(171, 394, '20230610083759.pdf', '2023-06-22 10:11:11', 1),
(172, 394, '20230610092522.pdf', '2023-06-22 10:11:11', 1),
(173, 395, '20230607130524.pdf', '2023-06-22 10:22:04', 1),
(174, 395, '20230610083759.pdf', '2023-06-22 10:22:04', 1),
(175, 395, '20230610092522.pdf', '2023-06-22 10:22:04', 1),
(176, 396, '20230607130524.pdf', '2023-06-22 15:36:05', 1),
(177, 397, 'Documento de Identiddad(DNI).pdf', '2023-06-24 13:24:17', 1),
(178, 397, 'Recibo de Servicio.pdf', '2023-06-24 13:24:17', 1),
(179, 398, 'Documento de Identiddad(DNI).pdf', '2023-06-26 16:12:14', 1),
(180, 398, 'Recibo de Servicio.pdf', '2023-06-26 16:12:14', 1),
(181, 399, 'Documento de Identiddad(DNI).pdf', '2023-06-28 08:55:52', 1),
(182, 399, 'Recibo de Servicio.pdf', '2023-06-28 08:55:52', 1),
(183, 400, 'Documento de Identiddad(DNI).pdf', '2023-06-30 08:45:00', 1),
(184, 400, 'Recibo de Servicio.pdf', '2023-06-30 08:45:00', 1),
(185, 401, 'Recibo de Servicio.pdf', '2023-06-30 13:01:35', 1),
(186, 405, 'Documento de Identiddad(DNI).pdf', '2023-06-30 18:13:01', 1),
(187, 405, 'Recibo de Servicio.pdf', '2023-06-30 18:13:01', 1),
(188, 406, 'Documento de Identiddad(DNI).pdf', '2023-06-30 18:40:27', 1),
(189, 406, 'Recibo de Servicio.pdf', '2023-06-30 18:40:27', 1),
(190, 407, '20230703192716.pdf', '2023-07-04 08:05:16', 1),
(191, 408, '20230703200000.pdf', '2023-07-10 08:21:49', 1),
(192, 408, '20230703192840.pdf', '2023-07-10 08:21:49', 1),
(193, 411, '20230712163318.pdf', '2023-07-17 08:37:05', 1),
(194, 411, '20230711121716.pdf', '2023-07-17 08:37:05', 1),
(195, 412, '20230710123356.pdf', '2023-07-17 08:41:15', 1),
(196, 413, '20230711121716.pdf', '2023-07-17 10:53:34', 1),
(197, 414, '20230710123356.pdf', '2023-07-17 13:13:58', 1),
(198, 415, '20230703192840.pdf', '2023-07-17 15:11:31', 1),
(199, 416, '20230710113713.pdf', '2023-07-17 16:42:55', 1),
(200, 417, '20230712163318.pdf', '2023-07-18 10:41:21', 1),
(201, 417, '20230711121716.pdf', '2023-07-18 10:41:21', 1),
(202, 418, '20230718172952.pdf', '2023-07-19 09:21:58', 1),
(203, 419, '20230718172952.pdf', '2023-07-19 09:31:42', 1),
(204, 421, '20230712163318.pdf', '2023-07-19 09:54:16', 1),
(205, 421, '20230711121716.pdf', '2023-07-19 09:54:16', 1),
(206, 422, '20230718174822.pdf', '2023-07-19 10:04:03', 1),
(207, 422, '20230718174736.pdf', '2023-07-19 10:04:03', 1),
(208, 422, '20230718173324.pdf', '2023-07-19 10:04:03', 1),
(209, 424, '20230711121633.pdf', '2023-07-19 10:25:04', 1),
(210, 426, '20230718174822.pdf', '2023-07-20 09:51:10', 1),
(211, 426, '20230718174736.pdf', '2023-07-20 09:51:10', 1),
(212, 427, '20230718173150.pdf', '2023-07-21 10:26:22', 1),
(213, 428, '20230721172528.pdf', '2023-07-22 09:24:52', 1),
(214, 429, '20230720103825.pdf', '2023-07-22 09:57:02', 1),
(215, 430, '20230721172251.pdf', '2023-07-22 10:08:43', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documentoseguimiento`
--

CREATE TABLE `td_documentoseguimiento` (
  `id_docseguimiento` int(11) NOT NULL,
  `id_seguimiento` int(11) NOT NULL,
  `docsegui_nom` varchar(300) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `td_documentoseguimiento`
--

INSERT INTO `td_documentoseguimiento` (`id_docseguimiento`, `id_seguimiento`, `docsegui_nom`, `estado`) VALUES
(1, 17, 'Documento de Identiddad(DNI).pdf', 1),
(2, 17, 'Recibo de Servicio.pdf', 1),
(3, 19, 'Documento de Identiddad(DNI).pdf', 1),
(4, 20, 'Recibo de Servicio.pdf', 1),
(5, 23, 'Documento de Identiddad(DNI).pdf', 1),
(6, 23, 'Recibo de Servicio.pdf', 1),
(7, 26, 'Recibo de Servicio.pdf', 1),
(8, 27, 'Documento de Identiddad(DNI).pdf', 1),
(9, 27, 'Recibo de Servicio.pdf', 1),
(10, 29, '20230630182640.pdf', 1),
(11, 29, '20230630180858.pdf', 1),
(12, 29, '20230630180835.pdf', 1),
(13, 31, 'firma.png', 1),
(14, 33, '20230703200000.pdf', 1),
(15, 33, '20230703192840.pdf', 1),
(16, 34, '20230703191416.pdf', 1),
(17, 37, '20230710113713.pdf', 1),
(18, 39, '20230712163318.pdf', 1),
(19, 41, '20230720181910.pdf', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_pedidoseguimiento`
--

CREATE TABLE `td_pedidoseguimiento` (
  `id_seguimiento` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `segui_descripcion` varchar(400) DEFAULT NULL,
  `fecha_crea` datetime NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `td_pedidoseguimiento`
--

INSERT INTO `td_pedidoseguimiento` (`id_seguimiento`, `id_pedido`, `usu_id`, `segui_descripcion`, `fecha_crea`, `estado`) VALUES
(1, 399, 6, '<p>dfgdgdfg</p>', '2023-06-28 11:48:24', 1),
(2, 399, 15, '<p>se adjunto OC</p>', '2023-06-28 11:49:22', 1),
(3, 399, 15, '<p>fddfdsfsdf</p>', '2023-06-28 12:15:12', 1),
(4, 399, 15, '<p>sdfsdfsd</p>', '2023-06-28 12:15:16', 1),
(5, 396, 15, '<p>fsfsdfsdf</p>', '2023-06-28 12:43:10', 1),
(6, 396, 6, '<p>fdfgdfgfg</p>', '2023-06-28 12:45:18', 1),
(7, 396, 15, '<p>dfgdfgdfg</p>', '2023-06-28 12:45:30', 1),
(8, 396, 6, '<p>afafaf</p><p><br></p>', '2023-06-28 12:45:51', 1),
(9, 396, 15, '<p>asdfasdfas</p>', '2023-06-28 12:45:58', 1),
(10, 396, 15, '<p>asdadsad</p>', '2023-06-28 13:05:35', 1),
(11, 396, 15, '<p>fghfg</p>', '2023-06-28 14:28:10', 1),
(12, 396, 6, '<p>aaaaaaaaaaaaaaa</p>', '2023-06-28 14:55:45', 1),
(13, 393, 15, '<p>dfdfsd</p>', '2023-06-28 16:58:40', 1),
(14, 393, 15, '<p>ggggggggggggg</p>', '2023-06-28 17:01:59', 1),
(15, 393, 15, '<p>sdfsdf</p>', '2023-06-28 17:09:51', 1),
(16, 393, 15, '<p>ya etsa</p>', '2023-06-28 17:13:14', 1),
(17, 393, 15, '<p>valida</p>', '2023-06-28 17:13:41', 1),
(18, 400, 15, '<p>dfgfgdg</p>', '2023-06-30 08:45:58', 1),
(19, 400, 15, '<p>dfgdfg</p>', '2023-06-30 08:46:10', 1),
(20, 400, 15, '<p>fdgfdg</p>', '2023-06-30 11:33:29', 1),
(21, 400, 15, '<p>dfsfs</p>', '2023-06-30 11:33:39', 1),
(22, 400, 15, '<p>fgdfgdfg</p>', '2023-06-30 11:36:35', 1),
(23, 400, 15, '<p>dfgdfg</p>', '2023-06-30 11:36:45', 1),
(24, 401, 15, 'por favor llamar aal client para coordinar la entrega y solicitar informacion de la direccion de despacho', '2023-06-30 13:05:11', 1),
(25, 401, 6, '<p>ya se corrdino con cliente</p><p><br></p>', '2023-06-30 13:06:12', 1),
(26, 401, 15, '<p>sea adjunta oc para facturacion al cliente</p>', '2023-06-30 13:08:17', 1),
(27, 401, 15, 'se adjunta facturas del pedido', '2023-06-30 13:09:07', 1),
(28, 406, 15, '<p>adjnuntar oc carta de aceptacion</p>', '2023-07-01 10:01:40', 1),
(29, 406, 15, '<p>docuemntos adjuntos</p>', '2023-07-01 10:01:54', 1),
(30, 406, 15, '<p>sdsdcds</p>', '2023-07-03 08:26:38', 1),
(31, 406, 15, '<p>sdcsdc</p>', '2023-07-03 08:26:47', 1),
(32, 407, 15, '<p>dsdfsd</p>', '2023-07-04 08:25:40', 1),
(33, 407, 15, '<p>asdasd</p>', '2023-07-04 08:25:50', 1),
(34, 408, 15, '<p>Adjunto oc</p>', '2023-07-10 08:24:46', 1),
(35, 408, 15, '<p>fijate bien esa oc no perteneces al cliente</p>', '2023-07-10 08:25:12', 1),
(36, 408, 15, 'adjuntar comprobante&nbsp;', '2023-07-15 09:42:45', 1),
(37, 408, 15, '<p>documento adjunto</p>', '2023-07-15 09:43:08', 1),
(38, 413, 15, 'adjuntar oc del cliente', '2023-07-17 10:56:50', 1),
(39, 413, 15, '<p>oc adjuntada</p>', '2023-07-17 10:57:08', 1),
(40, 429, 15, '<p>ytjjghjghj</p>', '2023-07-22 10:03:36', 1),
(41, 429, 15, '<p>ghjghj</p>', '2023-07-22 10:03:42', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_ticketdetalle`
--

CREATE TABLE `td_ticketdetalle` (
  `tickd_id` int(11) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `tickd_descrip` mediumtext NOT NULL,
  `fech_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `td_ticketdetalle`
--

INSERT INTO `td_ticketdetalle` (`tickd_id`, `tick_id`, `usu_id`, `tickd_descrip`, `fech_crea`, `est`) VALUES
(1, 1, 2, 'resuelto', '2023-02-07 11:48:23', 1),
(2, 1, 1, 'usuario respondiendo', '2023-02-07 17:51:37', 1),
(3, 1, 2, 'paar resolver tu  problema reinicia tu equipo', '2023-02-07 17:52:52', 1),
(4, 1, 1, 'si con eso se resolvio', '2023-02-07 17:53:30', 1),
(5, 1, 2, 'muchas gracias por su confirmacion, por favor cerrar el ticket', '2023-02-07 17:54:28', 1),
(6, 2, 2, 'tengo un inconveniente', '2023-02-07 21:22:00', 1),
(7, 2, 1, 'ssadxasxa', '2023-02-07 21:23:09', 1),
(8, 27, 2, '<p>dsdscs</p>', '2023-02-08 09:42:00', 1),
(9, 27, 2, '<p>sxdsxs</p>', '2023-02-08 09:42:28', 1),
(10, 27, 2, '<p>dfdfdfd</p>', '2023-02-08 09:42:39', 1),
(11, 27, 2, '<p>dfdfdfd</p>', '2023-02-08 09:42:42', 1),
(12, 27, 2, '<p>ytrygtrg</p>', '2023-02-08 09:42:49', 1),
(13, 27, 2, '<p>ytrygtrg</p>', '2023-02-08 09:42:55', 1),
(14, 27, 2, '<p>dfdfc</p>', '2023-02-08 09:44:00', 1),
(15, 27, 2, '<p>dfdfc</p><p><img src=\"data:image/png;base64,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\" alt=\"\"></p><p><br></p><p>el proble sigue</p><p>ahora me aparecxe esto</p><p><img src=\"data:image/png;base64,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\" alt=\"\"><br></p>', '2023-02-08 09:47:22', 1),
(16, 27, 2, '<p>ghdgdf</p>', '2023-02-08 09:48:03', 1);
INSERT INTO `td_ticketdetalle` (`tickd_id`, `tick_id`, `usu_id`, `tickd_descrip`, `fech_crea`, `est`) VALUES
(17, 25, 2, '<p>Me sigue apareciendo el mismo problema</p><p><img src=\"data:image/png;base64,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\" alt=\"\"></p><p>aca tambien</p><p><img src=\"data:image/png;base64,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\" alt=\"\"><br></p>', '2023-02-08 09:49:19', 1),
(18, 23, 2, '<p>ccascdasc</p>', '2023-02-08 09:56:35', 1),
(19, 23, 2, '<p>sxasxas</p>', '2023-02-08 09:56:44', 1),
(20, 27, 1, '<p>sdcscdscsdc</p>', '2023-02-08 09:58:31', 1),
(21, 27, 1, '<p>prueba con reinciar el equipo</p>', '2023-02-08 09:58:55', 1),
(22, 34, 1, '<p>dfdsfsd</p>', '2023-02-08 11:02:25', 1),
(23, 34, 1, '<p>sdfsdf</p>', '2023-02-08 11:02:29', 1),
(24, 1, 1, 'Ticket Cerrado...', '2023-02-08 12:27:30', 1),
(25, 2, 1, 'Ticket Cerrado...', '2023-02-08 12:27:48', 1),
(26, 11, 1, 'Ticket Cerrado...', '2023-02-08 12:29:57', 1),
(27, 35, 7, '<p>nada aun el problema persiste</p>', '2023-02-08 12:33:57', 1),
(28, 35, 1, '<p>ya me acerco para revisrala</p>', '2023-02-08 12:34:45', 1),
(29, 35, 1, '<p>encienda enmedia hora</p><p><br></p>', '2023-02-08 12:35:01', 1),
(30, 35, 1, '<p>y aesta listo</p>', '2023-02-08 12:35:22', 1),
(31, 35, 1, 'Ticket Cerrado...', '2023-02-08 12:35:26', 1),
(32, 36, 11, '<p>CSCSDCSDC</p>', '2023-02-08 12:55:33', 1),
(33, 1, 1, '<p>DFDSFSDFSDFSDF</p>', '2023-02-08 14:21:27', 1),
(34, 2, 1, '<p>defdsfsdf</p>', '2023-02-08 14:48:41', 1),
(35, 7, 1, '<p>fdfsdfsdf</p>', '2023-02-08 14:48:58', 1),
(36, 7, 1, 'Ticket Cerrado...', '2023-02-08 14:49:07', 1),
(37, 7, 1, 'Ticket Cerrado...', '2023-02-08 14:49:12', 1),
(38, 1, 1, '<p>efefef</p>', '2023-02-08 14:56:11', 1),
(39, 1, 1, '<p>efefefef</p>', '2023-02-08 14:56:32', 1),
(40, 2, 1, 'Ticket Cerrado...', '2023-02-08 14:56:51', 1),
(41, 8, 1, '<p>sdsdsd</p>', '2023-02-08 15:08:14', 1),
(42, 8, 1, 'Ticket Cerrado...', '2023-02-08 15:08:18', 1),
(43, 53, 1, '<p>wddw</p>', '2023-02-08 15:16:08', 1),
(44, 65, 1, '<p>dfsdfsd</p>', '2023-02-08 15:29:54', 1),
(45, 9, 1, '<p>rtertre</p>', '2023-02-08 15:30:56', 1),
(46, 27, 2, 'Ticket Cerrado...', '2023-02-08 15:36:34', 1),
(47, 95, 1, '<p>fdsfsdf</p>', '2023-02-08 16:48:20', 1),
(48, 95, 1, 'Ticket Cerrado...', '2023-02-08 16:49:12', 1),
(49, 96, 2, 'en que presentacion', '2023-02-08 17:09:28', 1),
(50, 96, 1, '<p>ok estamos coordinado&nbsp;</p>', '2023-02-08 17:11:09', 1),
(51, 9, 1, 'Ticket Cerrado...', '2023-02-09 11:03:00', 1),
(52, 10, 1, 'Ticket Cerrado...', '2023-02-09 17:34:40', 1),
(53, 12, 1, '<p>cerra el ticket</p>', '2023-02-13 08:16:03', 1),
(54, 12, 1, 'Ticket Cerrado...', '2023-02-13 08:16:06', 1),
(55, 96, 1, 'listo para la fecha 12/05/2023, est acoordinado', '2023-02-13 08:17:19', 1),
(56, 96, 1, 'Ticket Cerrado...', '2023-02-13 08:17:23', 1),
(57, 13, 1, '<p>dfedfsdfsdf</p>', '2023-02-14 11:42:51', 1),
(58, 13, 1, '<p>sadfasdasd</p>', '2023-02-14 11:42:58', 1),
(59, 13, 1, '<p>fsdgrsdfgsdg</p>', '2023-02-16 08:11:08', 1),
(60, 13, 1, '<p>sdgsdgsdgsd</p>', '2023-02-16 08:11:14', 1),
(61, 13, 1, 'Ticket Cerrado...', '2023-02-16 08:11:20', 1),
(62, 14, 1, '<p>SDFSDF</p>', '2023-02-16 10:47:56', 1),
(63, 14, 1, 'Ticket Cerrado...', '2023-02-16 10:47:59', 1),
(64, 103, 8, '<p>alguna novedad referente a este ticket</p>', '2023-02-16 12:31:20', 1),
(65, 229, 17, '<p>sdsdsd</p>', '2023-02-17 14:55:40', 1),
(66, 15, 1, 'Ticket Cerrado...', '2023-02-20 09:31:47', 1),
(67, 21, 1, 'Ticket Cerrado...', '2023-02-20 09:36:05', 1),
(68, 278, 1, '<p>dcsaasda</p>', '2023-02-20 09:38:37', 1),
(69, 278, 1, 'Ticket Cerrado...', '2023-02-20 09:38:47', 1),
(70, 16, 1, 'Ticket Cerrado...', '2023-02-20 09:46:20', 1),
(71, 17, 1, 'Ticket Cerrado...', '2023-02-20 09:50:07', 1),
(72, 20, 1, 'Ticket Cerrado...', '2023-02-20 09:59:05', 1),
(73, 277, 1, 'Ticket Cerrado...', '2023-02-20 10:01:46', 1),
(74, 59, 1, 'Ticket Cerrado...', '2023-02-20 10:04:01', 1),
(75, 56, 1, 'Ticket Cerrado...', '2023-02-20 10:07:58', 1),
(76, 61, 1, 'Ticket Cerrado...', '2023-02-20 10:12:15', 1),
(77, 30, 1, '<p>gfgfhgfh</p>', '2023-02-20 10:15:29', 1),
(78, 30, 1, 'Ticket Cerrado...', '2023-02-20 10:15:34', 1),
(79, 272, 3, 'Ticket Cerrado...', '2023-02-21 17:34:24', 1),
(80, 286, 1, '<p>dsfsfsdffsdf</p>', '2023-02-22 14:22:27', 1),
(81, 286, 1, '<p>sfrsdsffdsdf</p>', '2023-02-22 14:23:15', 1),
(82, 287, 1, '<p>dasdas</p>', '2023-02-22 15:43:20', 1),
(83, 289, 1, 'Ticket Cerrado...', '2023-02-23 08:48:32', 1),
(84, 1, 1, 'Ticket Re-Abierto...', '2023-02-23 12:03:00', 1),
(85, 7, 1, 'Ticket Re-Abierto...', '2023-02-23 12:03:14', 1),
(86, 7, 1, '<p>dfvdv</p>', '2023-02-23 12:04:09', 1),
(87, 8, 1, 'Ticket Re-Abierto...', '2023-02-23 16:19:48', 1),
(88, 1, 1, '<p>ascasc</p>', '2023-02-23 16:49:14', 1),
(89, 1, 1, '<p>dddd</p>', '2023-02-23 16:49:18', 1),
(90, 259, 15, 'Ticket Cerrado...', '2023-02-24 15:58:55', 1),
(91, 259, 15, 'Ticket Re-Abierto...', '2023-02-24 15:59:13', 1),
(92, 294, 9, '<p>dsfdsfsd</p>', '2023-02-24 17:23:51', 1),
(93, 294, 9, '<p>sdfsdf</p>', '2023-02-24 17:23:54', 1),
(94, 295, 9, '<p>asdasd</p>', '2023-02-24 17:24:56', 1),
(95, 295, 9, '<p>asdasd</p>', '2023-02-24 17:24:59', 1),
(96, 295, 9, 'Ticket Cerrado...', '2023-02-25 12:03:45', 1),
(97, 8, 51, 'Ticket Cerrado...', '2023-02-27 10:42:32', 1),
(98, 300, 1, '<p>que cantidad y marca</p><p><br></p>', '2023-02-27 14:15:37', 1),
(99, 303, 1, '<p>dfsdf</p>', '2023-02-27 15:53:14', 1),
(100, 303, 1, '<p>sdfsdf</p>', '2023-02-27 15:53:16', 1),
(101, 309, 1, 'Ticket Cerrado...', '2023-02-27 16:17:52', 1),
(102, 297, 1, 'Ticket Cerrado...', '2023-02-27 16:18:25', 1),
(103, 298, 1, 'Ticket Cerrado...', '2023-02-27 16:19:02', 1),
(104, 303, 1, 'Ticket Cerrado...', '2023-02-27 16:20:43', 1),
(105, 313, 1, '<p>se corrdinara con compras</p>', '2023-03-01 09:49:42', 1),
(106, 313, 1, '<p>se asigno al area.</p>', '2023-03-01 09:50:09', 1),
(107, 313, 1, '<p>se precedió con la instalación, favor de cerrar el ticket</p>', '2023-03-01 09:51:38', 1),
(108, 313, 1, 'Ticket Cerrado...', '2023-03-01 09:51:42', 1),
(109, 313, 1, 'Ticket Re-Abierto...', '2023-03-01 09:52:08', 1),
(110, 313, 1, '<p>se reabre ticket por falla del nuevo equipó</p><p><br></p>', '2023-03-01 09:53:10', 1);
INSERT INTO `td_ticketdetalle` (`tickd_id`, `tick_id`, `usu_id`, `tickd_descrip`, `fech_crea`, `est`) VALUES
(111, 313, 1, '<p><img src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAdoAAAB8CAYAAADO1nHoAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAE0nSURBVHhe7Z0H3GRFlbeLIRhWkiBmJChhSAOIJInKSpbggsoSFQMuoCtixEBSgq4kCYqAICIoSFRQskTJQUBFRKIgKyIima+euv10n7m+Y4L2c3+/85fyVJ1cdcO5dbvfnumeqSiJRCKRSPyL4pY77i1zzjzzYPTPxYyTnmr0mmuuafTvwZQpUxqd1P4/kUgkEonEWJCFNpFIJBKJMSILbSKRSCQSY0QW2kQikUgkxogstIlEIpFIjBFZaBOJRCKRGCOy0CYSiUQiMUZkoU0kEolEYozIQptIJBKJxBiRhTaRSCQSiTEiC20ikUgkEmNEFtpEIpFIJMaILLSJRCKRSIwRWWgTiUQikRgjstAmEolEIjFGZKFNJBKJRGKMyEKbSCQSicQYkYU2kUgkEokxIgttIpFIJBJjRBbaRCKRSCTGiCy0iUQikUiMEVloE4lEIpEYI7LQJhKJRCIxRmShTSQSiURijMhCm0gkEonEGJGFNpFIJBKJMSILbSKRSCQSY0QW2kQikUgkxogstIlEIpFIjBFZaBOJRCKRGCOy0CYSiUQiMUZkoU0kEolEYozIQptIJBKJxBiRhTaRSCQSiTEiC20ikUgkEmNEFtpEIpFIJMaILLSJRCKRSIwRWWgTiUQikRgjstAmEolEIjFGZKFNJBKJRGKMyEKbSCQSicQYkYU2kUgkEokxIgttIpFIJBJjRBbaRCKRSCTGiCy0iUQikUiMEVloE4lEIpEYI7LQJhKJRCIxRmShTSQSiURijMhCm0gkEonEGJGFNpFIJBL/snj6mWfKdNNNNxj930QW2kQikUj8y+KhP/6pzDTDDIPR/01koU0kEonEvxzYyT748CPlvgf/UF4w44wD7v9NTHfzr+95ZtBPJBKJROJfArwuZidLkZ1h+ukH3H8+Zpz0VKPXXHNNo38PpkyZ0uh0v/3dw1loE4lEIpGYAM9Foc1Xx4lEIpFIjBFZaBOJRCKRGCOy0CYSiUQiMUZkoU0kEolEYozIQptIJBKJxBiRhTaRSCQSiTEiC20ikUgkEmNEFtpEIpFIJMaILLSJRCKRSIwRWWgTiUQikRgjstAmEolEIjFGZKFNJBKJRGKMyH9UIJFIJBKJacB/VODZIHe0iUQikUiMEVloE4lEIpEYI7LQJhKJRCIxRmShTSQSiURijMhCm0gkEonEGJHfOk4kEolEYhqY6FvHp5xyyqD351h//fUHvRFyR5tIJBKJxN+BiYopmBY/C20ikUgkEn8n+kV1WkUWZKFNJBKJROIfgMX1LxVZkJ/RJhKJRCIxDeQvQyUSiUQi8S+OLLSJRCKRSIwRWWgTiUQikRgjstAmEolEIjFGZKFNJBKJRGKMyEKbSCQSicQYMd31t/32maeffrpMN9105ZlnnimTJk1qFEDh0ybV9lTQA/AEsjjWD/pPPvVUkz1dx9NXPrKnKk895DNMP30hD3nIp688oB+gDoh8qPPoQ5l9Grb4h2qnnnIaucBDt/moU4evL6m2jqXaxvnquw/tAPLoh7G5yY95qf/MM+YwaWgXodw8gD4Z6wf0bV0L5VDGfUQfUnO137dl7HFvsqfq+TR9Nwf6gPEzT3frgK4w3nSTaqyasv7FUD7gOQ/gHJGpJw+g++STT04VL+qC6L8fG8ijocuYtVAf9OXmGPnSmH/fzrEyeNo4Vq5PeepBo9wW9QB9Ef0C/cDzmOqfFq8Hr3V89HlAP0AdEPlQzhPHEU02sKNPwxb/UHNXTzmNXODF/EbX2Ci2to6lne0MdT5PNh7+9N2HdgB59MPY3OTHvNTXr3r9OI7NA0RdGn3Qt3UtlEMZ9xF9SM3Vft+WscddGeOoZ87KhPFoQP+iL6cGUa+Ac0SmnjyA7hN/4/VvjbzpxuvK5EWXaDLQ8qWjAYgOPBEBRRIwJjgN4DgWWWxp6NEssoBiCo/EBUngK+bgQkJp8rB18Wn01WNMvvpRrq7AB0CXg6r/lmvIC2AvRa6f6WfoTpjo1xyAMfBvfgA5MudCM0ehH1rUY6wuYxDtQKfDGnTrIo8bg42LHh3Q6U4dy/hSYDzmA8wJHcddnFFeyLywgDxtGJOjc4Ias/Fq0aSPT9a72dcbKf3h3NCpjQLcxlWnjZUzHvgT+IvziHL68MwDmK+68kGU6Vd7oS99Q40XZQB7+jPMMEPTRU8ZVJ5jr8/YlAn6/Xgg8qM+PhzH6z9S7KLPvl8aejTnBPQXrzNs8aUOkKdvecY2hnlYYNt5wsNWhXJ1BT7AxNf/E60vsJci1w/XEOA6E/hRbgz8t/ye7s435MicC80chX5oUY+xuoxBtANRBypPHzTmrUxdmrGMLwXGYz5AX+g4Ng7QnlhCnjaMiR/zNWbMC5/4oY+cGoJcH+oD6kxr05AD/FGT7CO3ltGHZx4gFmT9CeeCTL+dfbcOYDgnFo/kdaIjktN5ZzwKDkzAoos+xRhdILXIAv0RT7gIyiKMrS8Bn3yUeQH3daMOIJbxmDd8fNn6JwbAhw1gE5+ctY2IORAn+qJPDtrp27y8ydI8wdQDMQ/AmD72ymJ/9CSNr/gUO1p3QAz6M844YxsTWx/IpkVp5u68oNFeyEcnxqXFdUIWj0Vb70FBffKJqR+G2OHSkD/15FNNru8+zJM45oau+nH9oi6NfGLO9NHBRt1o43xs6sUxiLnKx9Z1is01QYf2xBNPNJ/4UG5OAD/2+zDuRLFA9AvFjzKgX/Rs6OlXGm305zwAdkBZhLH1JeATXxkF1j7ngog6wDwB84aPL5sFFDAG+LABHlbpK+/eHHU+hfGA5wHQjhygNH2b13N//XdFxZja0QdxTH/c17+1JsalxXVCFs8R/Og3btIAujTkFDrk+u4jFlRzQ9dNpLyWf9CluUkE1DT66GEDbfyhTbfu6GlfZd2rW6AhiIkMFIeL4Q7WCm6z4NIHTgBYhGnY4QcMdatP+iamHIpPgI4Nvvr6gPb9mY8NfWTAfvQfD7BQrr19mr6MozzGAMp4mrevD2zRZ31p8IB99dHRH1DP/LhIgXwoN494I3BnC3yCxy+6+OnHpOnfsX3tABRboQ+g3UQ6UmLom3H07S7VHa1oNlWGXiu4Az8RQx8D3zGONM4fHi0eB8b2hXGiP3Q8f+DjF+ALHcYxFtC3PqDqulba9HMiVlxPoByKXL+Rb170yUMfMeeogw/1zA1qPjZ0aPS1FVFPP/KBc4RvA1B8AnRs8NXXB7Tvz3xs6CMD9qP/v379j/pd0R2tnf5BjAGU/fOv/9E5APQHfLOAX3j46cek6d+xfe0AFFuhD6AdY2sNiLbE0Dfj6Bs+tQVePD7w9GszVxF9gFajBn15cf7waNY2wDjWMmAcqP7QdxMJ380o61J1RosHUCAwPIPriH7jDcbRDiDTNu5ugYtCwx5fwoQi4glnnGH8ga1UvYlk5EPrn4TIbfHkRxcwlocOB7jp110VbYYZZ2gUObniA7k5aKMvqSd+1APSeGHAo+9Yal40dPRv7vAtpkIdgbyb0+jE1SdNYGc8/DsGrolx43z1EfXto68NQFcZzRxobX61iLJblQdYe3gAHnYcEyhwPbWBz3GyuW5Df3WsXhzb5CGPdtHGftSxKTcv5dqyHurJ6+cYEX3SmFOEfOxtjI1Di3MU8NTBRh1lMZ9oB5BFW5qIsWiMRTwXBPPR3jjG11aqHucJ5wVQhm/ac3b9D9oMM8xYaXet8tboX+/673hiorFzEvqkCfRo8PDvGGhv3DhffUR9++hrA9BVRjMHmvNzc2btoZ5YtLWfcfA2ACAH2ujDpl/kwAIc7bWNOsipbeYBtQij19W90RrYhqvsxFGISUDje+oIJwPQlTYflSInsDL40a8JOhnHINp5YKIttNlUfqTGiLqcAMqB+shAPLmjD+HNGbCrQsZN3hs90B7Em4S+lHtiw7MP1CEvmjya/rQhX/WVOZ+O92SlXACdDJ47WZ/IR3bdHPTR7wPH+LF5jtAYC8aRgi5+l7tNG/iuLXwQbWMe7F55NQx1PNzJDgqvn+fC04/UuP349InjHJGTExRe81/7+qR5c1ZuTIAuN3Z4xlHuXCMfaNv3pRzQj/qxb376t6+Nuug5L5qwH31hA42yCPSE/rWBRj+AvmP7gLE8oR5ouQ6uO/W0Qdbo4OMFz4eo+5xe/wM7rjE/lgHaA3S115dyH2zhxfVTp821Nnk0/Wnz16//0ZsHeVD7INqBafWBY2xtHluaPgHjSAFyxtjYtIFPLsB6Em1jHtjwalhb/eqbAuqr6a7gdX6sK8PiSQ4DH+jAo8bR6KOHLyg8dKxlxvMVtXJzAZPqeUjRJ4ZxJo2E3cIBKcABrd+3ENqwiQsI0IkTAlE/TlxoHz/H7fuOiw/awgUf9uVzIOUZj4ZffEkBfXRs6BkXGbDAqgtFT1/GUg70p4++PtQLKF74joF65qqO+vq3mHZP3Z0NvHiRa4MvdGjai85utAZQY1NoYh40+1LtAL6crzzh/Lz4gRRdCyvw1THHoO8HeEM2N2BMeH1+pOQL4o0KHi3mhoyc9Ys8ygD6cb5Rro65yIu66kQ/NPrqAPrmTd+dG32bttrEsbw4BynQR7+PjmMaY3woB+rYBxPpmz9Q33MCNN3B2yPgugns3cmCuKulsYbGMB4Nv66tPumjY0PPuMiABbbT7fygpy9j6QvozzdNfX2o55TXJnAM1DNXddTv/I9ici5ceP7ZZdHXzlUWX+Bl5egjD238GANfRx9xaJMv9rqXltWWX6w8+ODvymOPPlretflGjUe78PwfDXMG47j+KW7IgRTdqB91rS0RFj5zA8ZE1udHSj0C+FYfHi3mhow89ItcmTmh3+INdCb5Ia8NZkR0EGU49+lCvgvpAuObQFMFrDL1aPR9OsBnXAgQ/UP1rz2IfXTwEXVcFPhcdDR19Q2wAf0cgP646dPnYoai68EH9PWLzBzk2QdSb6ZA/WhnvvKEN5Ao5yZgDo5bvrV1vKlv1PGEib61gRflUOJBjQO0Vd+5y1MPigyK/4j+WlJMKZzAYsuY5g5WDPWqX2NNBOdLc03AaH26XG2Mycv1sGkP5aajj769cIyOfKj+4xgdeVGfPk1wHLRXhzGAR19/+gZQxrS4HvIjtFFf4JN5R74xjadv+fCQxdzo+3ZAWUT0D1VPexD7nCeeH/JjHqyZ10v0DfAL+jkAY6LPA2vXyHf0Z0iAvn7jPOXZB1LyMab60c585Qn45BDl9M3hlptuLPvs+ely0ZW3tPadbx/TeOYB0P3ZLT8tX/naseX6n/+mnHPxdWW22WYvjz3+WPngR3ZpvBNPO6/s+4XPld/97n+H+UCNA/Rnjs5dnnpQZFDXW8CPa0kc10V7xjRsKWYi6qk7EfDf8qsNH+pSe+ibq836hZyGDRQ9+lDqlz6sczYxCSc6l4KoBNSj4QzK9thK37dtxbU2ii1F2krvgsRFdruPD4COPkHkqxdphDr9mx8tLizo25sbT4LoxhNY8GoqUueBDvb6APqGyjeXGNe+caTm7glt/p4s+oXa2MV2J2iXOzcEiq25udvt9Ec3FvODH/MjpjJhPvDNNQK+uQN1u5idX8b6lRcvMmzbw0xtyF1vEMcWYH3EmBPFb34Hc6Lv2D5tIpgrlPXFRvTXYyJf9uXrLyLqOB/A2HjqIFfHeQH9og+f3CJPvjBnfUSfERPNjeuEtXAcbdGnuTbKYi5CHXyAGAtEvnqRRlBk4fntdOLoqz/3vr25ja7/0c5V2JfGt0TY6wPoGyofPVqMa//Pff8j1393TOBfcvH55W1v37zMPPOsZZZZZitv2+Q/y6WXXFAuOO+Hdbe6cXnsscdanH970czlpS99eevjA9+zz/7isvgSS7WYc8710vKCF7ywyYH5EMNcI+CbO1DXHAFjGpCHX4EtPpxzjBPH2kojf6L48FpBrGP6NGJY07Tpg3oGsKPm4UO4HrFG9n0NtWGaCDT2Ner3DR71aRYoF9tEtKMJ+iYooq4LhC9l8OLCyUfHg8UJB8gFXjxg+gCMafoHyOBhp/6w1Ru7N/f41IzMOI6hxgWMgeM4hxifsbrwzdV1laLjfNFRb+R/VGzRkz+6OXTzNHaMC3UdnBPAB83cQdSBN9Fc4MmHulZRF5/MDZ5x+tAfx6Ctfy24rRgPxrR2zGcYHQsQfZp78xMo/JiPvNiHAvraASmgT4u+IqIfaDxvRN+f8Wzw+vG1j7Yxf4COvpSBvs/Yh07Uj76jzPPTOXnuaUcT9M1HRF1kUNey8XirMeBrp44fLfDFONDOhcH6qt98DHJnTNM/MB++sa9+vwGuI68hePE4Mtav+oyB4ziHGJ+xuvDN1XWVokNMgI56/Xj4aHqDZfcBuyqUR//0p/LzW24qG6+3WntFfNThBw9Eo/PkhmuvKq9bYOG208U3zdzVjfOeaC4thwHffCIP4JO5wTdOH/ozjr4d4w8fbYM3kAP6vpWl3kD103wM+OgJeHFNtQPWLMduJAE8WpxblU99EgMnbAIaivi6GbkBox5BPBj4ipOjAXUBTxQ0coHfp064LeKgiApk+ESmnjxsfTWF3JjIOdiM9W8smnnSgLTJ6s29ySqN+gDK2PiO9a1OzFMfQD1yUweoY57qGRfA63xzsnYXIIDn8eTGgJyLLa4HwB4Yhxw6m+64CMZSm77UjTrG4O8+nZNyxurQjOn8ms7gtbC7FQssff0AeOi0bx/XfuNVuTGMbSyaPOho/Ub66sX5A3jA+OpONHd9awNVV7B+QFv9OAbqYAt/opxsxATmoB/H2vb7AFvPF3g2Ec8L+BPp4dM1wZd97YC6QD528PvU+fBxgUVUIMM2ftQAhYftxNf/6BWr/o1FMx8akI5k+u9sop7+Or1urG91nA8UvjL1nt313+nMM+9ry5Ff+0p75fvIH/9Yzj/nrBq8lJVWeVM54psn1XWcsTz/BS8oXz/mxPaK+MdXdK+XKbz4OObIw9rnu2d+/9Sy5z4HDKKM1gJqc23pm4c68MHjE1z/sWDRJrz+BzZQePq39gj6+IvfPoZipwwYi6ZvZNSsvr56sWgCeMA46uoDtHo2iDHJQBRPgCITATqLUCbUwU9fvxXPkAAwCWDf18sxyUhp+CA2zZzhIXPho452wIMHpcmLJ4c6wJwd0zdmu9kPdrTIachtkU8ejr1xCXXNFUiR0Vcn5uarIQAv2oDRLpYT1Yuxm486QB5wbvgyZ+CYhg7NmJ3/zl7f5hX9kS9jdeBNlL86jOn3dWjtG8V17b2J0toudpBz3OUO5YM86QOp8Ya2A504ptknnzjWT+yD6Be+Y+wZ06INchr6xlamn0iR4YsxdvqMPuh7zkRf8IU68ugDfQBs+lAm1MFPX9+84GtnPsA+sdWRFylNOcfXnOEha3Y8eIW3GtoB1wLqPNmtekyVqW/OjukbM86zK7aMu2Mz4nex45w9/kLdieaMjL46Mbe/fv13eeJ3ldXWKFu/+wNlpWUWKqsuv2iZa/B6GET/2sw662xliSWXbq+cwRbbvK/ceOv95S1rr1+WXWK+cvNNNwxj4l97KM289Ifec3r913VAB3nTq408rC3I6LtpQ8c86QOp8ZCD5rfKoi8aoDbxutgxVD+xD/oFd1isr/vl/c/oAEQj+iYCWnWuPLTbJHFQGx8Gx89Zac35YOzTAlAG5MuDRsBjQWIOQD0p8r4tiD71xcHiIGojHwqMpS50qDd4Wl68PuU917juF/e1GMSP+RnbvABy8215DdYo9vl8Cdv4+qvbyeKLC3d0McCDYqc9Y/tQEGNAQewDfUVe9IEMIKc512lBfxZP/3yHz+DaTZcHH3z58DPYyeofGNNczS/K+8daTDSWB3VNmIfnlhS+evYjX3/qiMiDuj70J/ILor16/XOdpi/6V1x+cfned75Vzv7h98vDf3io8V808yzlTWusVd668dvL69+wwlTHxpgAah7sGImlPMros64xLnwgXx40Ap46X9l/n3Lm6Se3zxz/c6v3NLn6+mgILqJPffXXRD4UmKe60KhHgHj9UGTp62+YRwV9/ZlLlAN1zIF+/5jJF54DwLyQxz462DIHfXxy5+3Lv6+1Xu1Pajvdg792bJnpec9rMvP4xEe2b4V15VXfPPQF3eVjO5a3rLV+WWX1fx/mCmIf6CvyuMdzrwfIAHKac50W9GdjPtQdao658Y3pZwN289QvcuznPtFYHpQcLMT4gN5SH0gWXHjRpqPesNAyYSahM3gskN8s1qkLgww+ExXq9QuofJp6AD2SBOrYx2//CUOg5wWjrnJp5PV1GSunOSd4UPNWh5s5r6scLzrvnGWZ5VZsLf4jAwA5iDx9RqAH7yeXXlR+ctlF5VoOdnj6U2eYQ6UAX8AcBX1+6WnGGWdqulEOZdzl0FFz4qZhARb0XS9t+1AfGnNDVxvt1IGiQ1/qsely+fN1AhTPuFMVzZ+7l8GOhmOFHxHzA8Yzfsw1nicxl+hDnnJl2AJ9yp/Ij3LtofaBsZxHtKEp11ZoH31FyH/o9w+WT+28Q7m8nndLTFm6XH3l5eXIb51c401ftth03bLk0m8o115zZXlDPb93+8J+ZZa608GWfFw7WswFmA885w1PPk094LyAOvaRedz32v1T5Yc/OK2ccc7lZenJryrX14fSeKz6foAPYKCvy1gbWjwfYt7qcH3wJcM49uca0Y3Xj9S5gO5hd7ROwAKNT3Rpz/76f7L9hKI+ox9eGx95+FfKV756bLn0kgvLN75+SO1/s7zghS8cxvjZzT8t2227WSvAjzzyxzL3PPO1L0Xx6nmLTdcr++53WFlgoclDn9KYm3GdE1AHGtcZanFCV/s+oizK8Ud9mDz/SwacfwwUWvyai36pP4Aa1X9QiHN1HgA9/lGBRRebMqyDbXPKv94TFwIKcAR0JnyamGkaB5SxyVgoGbuw0Rd9JoZPbfuIvmNuxo3x1I1xoPa92ByLaB/7+HEdQItVL352tNvtuHNrf3jo940ffZon6M87Ur7td3B9Uv/KfnuXi676+VB35llmHd4M8E2/xR7kBiJfO/tQ8+8o83YenY9oB436rlP0BaTaIKPPDYI+0HYi6Ju8gb7xxU2CvnnxeRs32ZibUK8V1UEBpsg2fijGjIHzAtraR2ZMeQI+uTqnvh8QeX1dxsppyIgDD4p/daXxZguNayUfSJ0LQDeOAXraQimyfOP0Fa98Vfn4p/csG62zajnw0KPL0m9YvuledsmPy47v37KcePp55Qu7frLcddevy5HHntzOSf39pRs6Y3OAOk/nrS6g73ppG7H1Ozcov779tnLfb+4p79/hI+WkE45t63Pm+Vc23X48fcciq28QY0VE+9gnX88L0MWC1x0TAS/6xE705x2pfOegLvDcge9xpYnI184+FL//+78P1OO7Srn/vt+Ul7zkpeXEM85vX2jSHl10Nl531aYDKL4rrrx6+fnPbipbveOt5eGH/zDks5sFxDIO/Wd7/VMjprWhaw27wboAxtQW8+Bz5GeDa2+5p/kBMXdyicWXeMqlkacuhXahyYu1MXkjb4W2aVXAcBKAyQL4Lop99egDxkAdEoiFFp5ybYT6kcpXF6qfieTCsTocVOcBPIgAGTcNeNhN64T2IDR+/W+x+gRFkeXip/+P4vpb7x8W2gj4EebsnARj1iueuDT4rk3LeQDnCXzC1qf6nuCR76tBxyD6tU8urpV6EfD0D7CjH485gB/jtEJaxxRT+vIpsq0/KLTKhsW32jT7gb/YF8ZnftCoCxyjF88b+PKQx3lJ8QeiT2NDXa/Ipy+ijbEY03dMLhwfYF7aqAvMZcf3bck7jbLfwUeVU046vhx9xCHlu6ed12TY0DZce5WyxdbvLettuEkrugB95dE/DTCW0lzL/vy0i1A/0pO/e1x7XTzvfK9tb2n2P/QbdRe+Pcplj727L+ZM5MtzABngo4b499auG+jWjn+YoVu3P/zh92WDtVYaFh1w4GHHlFVXf0u54Nwf1t3eOxvvJXO9tJx0xgXNZqO6Vvff3+m/qD44f+O4U8trF1io+fbciHnSd46Opcr6czJndYX6xALY0fTlWHgsgFSf6hMHvcj//379D8Y0Y2kLYqFld+ouMtYobe3zDWsx0atjKHCMT4ooQNfaZhGO87r5p9eXRRZdYvhw0Hz46pgBijruLwg8+xZVJwMPpySgrj7t88RCYvRZWKBOXBR1gHr66fdjfhHqyO8uqO5mBJDRmCPgiQyoL9WHlHhctO5o3/tfHy6n1puVMuhEfcE45sXnYBba3fbav5x39g/K2Wed0T6vJWdPXPKMvqCnn/LdsvOO3WdVYN8DvlbesvZbqx4nbadHrDt+/auy1qqvL3vvd1hZe72NmvyIww4qX9rrc03nhl/eP8wHes1VPylbbLJuGwt1zME5RB4UvG/rTctFF5xbfnDeFeXVr5lnyIcuNv9c5ahvn1qWev2yzYd8qTzo4YceUO6+89flU7vWh5BOZVhMoVddcVn55E7/1V4nast6sW7I2dU0m5CrawpvrdWWKbvXNV9qmeXa2DlwnsRdJTzhGAroe4wiL+pEG3n65ria0yknfrvJNnjbO9oYvnZQYpDbRP6g2KgHjAG04TPZHd67RTnrgqva25RdPrpD+yyJL71oC+WXgm6qN4s99zmwvbFZY+WlygG10C2z7IrD2MA+tJ+zfPvk7jqhC9SJftRZY6Ulyzs2f1f54hc+286l6qW8ZdWlW/+Vr5q72TtX7CLiQxYgr4mv/47Ha2Hwu989UDbfdN2y75e/2l6R6oNv4X54h3eXY044vcw88yx1fHP5/e9/V+Z/3YJlq3e+tezz5UPLwnUHw6tZXtEefPhxZaaZZmq2xBaM8en8wSiX7n6LjnbowZvo+kcGD2CPvnqM5asDHEd+7EPNAeq1wNgGX5vIg4IYYyLf8diDKJcX7SLk921j0fxHcAP328EcqFN8a9mdaMxjovgeo8i78fpryyKLdf8erTa1vnUHHuqBcuzBHCgOCyyw+lu1TQ5Q5V1Q+hZZ9OmLFmvgm3joYGdTB5mNA2+/r9enHljmpQ08wckZTxKpugAezXjq8I0wbLlRLbzI4mWhyYu21wULVgpvgYUXKW/697VbMV1goUUaj4aefWMA9UDM0QvQhwFsyOHKyy+pBfC3rSh/v958dtr+3eXqKy+rcm8+Xa5HfvWgNhZ33nF7OeFbR7Xi+Y3jTyu77bLzcE57fOajrcjeeNtvmxx61HGnlDNOPbHpkAfNdTDPOA8W5tVzz1N2+/TOg3FfPvVYP/D6egCe+QGKKIi712Zb+fhBlyILjf70Y/4DZuMzjsc2xhvqDtBiDXw5BozVVR4pMI5jjylF9lO16NFO+s6xTW4+nrueBxH6E+jHeAIdzvWvHbJf3bU9VJZf8rVl8XpzOrnG3XuPXcqi87+kLFYfHheZb87W5zNRcqKPLl+U+toh+0/l1/yM78MJINfYt8iiHwtezJfmseEVcZWWX/zsprL+Rpu2wsru9q0bvb3M/Zp5h/roGgc/jQ7OC8b6cw2NIfjs1N0sGJChLkB2zz13tl3s82Z6fhsvWK/tZZdfqfNVbSYNrjnyYzd8+223Nj18QMkBSoswjnxtYo4e9/71D6Ie66o/YLy+PyA/6gLG9NGHEpP49OXTnI9+9QP00edFxLF+4PX1ADx0hDryqBnPFu0cqY1a1MYhnueXID71yvgxH3VhMTb3gc1owMWoYRz77plmAAorMouviw/QFyyEi9F81n47WKMEGtWWvhSeOSgnjg2eB1vIw8aTlL40Ql2oF6N8+8pbvHoRD/+Gr6bDTf4/1lutvG3dVcvG66za6CbrrT6k/B0atupA0YPSkNEAcQQ8LhwfBECcC42dHnr0KWx8rvKbe+JnDZPKXXf8ulx84blNJupKNIrt09UnEyHOD04/ueqeV66/9b5hXsx5ybr7ZCesX3iAsTnBU47dDjt9su5qz2m7buCxAnGNtcMPUA86OAuGn7e5mwVtx2LBrfqxzzHxm8mi2ddmDsy3o92xJQdof41pnn/RXhtbH9Fem4goo7BSYNld03b56I6tACIXrAeIPBD9xHPFdRX0mdttt/6ivSa+4db7WwOXXnNrufZn95Yb60MbDf7FV/28yRxjc9utP2s+nA83YeMDjx1wfUFcI3Qdo6s9TVv6Z//wjLLtdh9q6/BfH/xoufuuO2v/uPYW6cRahHkAOOjLezUbfYvGGzx8xeMpjdAeiq5ixuoiX2yJpev8f16OO/aIOu9u9zuMXdXQjfPXFgovNo8lcOzxinp/7foH6DlWT9rXE/LheTyNE/Vp5gpfv/IYm5P5A3j4i/ZQfcYY2mED1IOaZ+wjA9FPLIrgp/V8vamet7wOZqcaGzzktAhywKfzsSZBmUs/PjGta847Qn3stWlaOmFSTj6OqfYtgdrQJRBF1yIr3+bOVsjDJ7otxsBWTMvOfOgDxlzk5gOcDIDHmIZNX0e+ffwBY9nXB81Y3NB9Jdlkgxs/u9Ejv3VKa18/9nvliGNPbnx08LX/oUeX/Q45qrZvtL5jcwPGFp6sNseelC2fwTw6ylxGOwmw26c/Unbfe/8uj0Hpmnueect/vGPL9hqXLzt84rNfaDbfqzf8HT78ial82pDjI66PaL4HOvLvufvOss9+h5Wdd3xvG6MTwfjrhx3YdtDKoOusvmwt+N8b+oEc+bWD2m5r0fleUt63zaZTFVuALv3vn3pS26UtMu+cZfI8c5Tvn3ZS82l7z1abDHdthx+6f7N9alDEyR39Jfhh9aHOAcP5Ym9OgHGUeSxs8KIMKAPK+dMaCutue+3XXhlv+B/vbH0+i0QW/UG5+WorX7j+6tKITYNHu/uuO9puzDHgS07a4YM262yzN75jXqNS7JwnupyH9EF//thEyMMOXfraimi3f71OrrnyJ3WHuGl5+SteVQ7ef++2W3zlq15d1t9wk7IBH7kcsG/zBZwLaJ/P1zENn30d+faN2cV/pu3eN15v1bLI/HOW1ZZftH3j9sUvnqP84Nwr2ue08C8470fVtpsPD9z4YGfMx0jsfN11G4trF5CLzTHoYo+OH/h7r39lzkcw1jcwJsCncu2iTxsy/Pd1AHx1Ih8YC52JKPqR55z0A4359vVBv47wDeSF6/XL62Q+u40NHnLarLPOWiZPnlxWWmmlcuxRh5TTTj6hXH3V5fVe0v24Ev6tRy23EKcvo+Cad8yROmn+7Qcr4kFF0QVlHHen6tgnGI7Qt/BiL9SBRzLuYm3AJ5LmK9jGHGjoQ4nHDQe5DZ56nGxR3xOz36eJmI+yvg5gndw9AeWveOWry+uXXaF9c5PPsegDfbxo5pnbjWuW2lp/5lnab4+Su3FjDlLzZYwuYw8cY3wju+qKS9vnomvVnSdjbgJfP+yA8qpXv6YstUz3bdKaSaN8LrX1ez4weDX8wPDYY7/YEks1352P7sKijw4wtvMS6nX5VHkdr7nuBmXTzbYuu3965yajCft4UKbvOhr2jzvmiEZ5hc2fdPz6V7eVPT770cYTPPgQn88f0aEdddypZecPdkUe37t/pssBmTs5PruuCTc+xR195dD/2XvXxsc36OY2mkNEXA/76jqWBwW8HmUnS2Hd8G3dl2w4r+mzs0XG7g3oi+PQzsHgB9CP54P9yNMHoB/PI8+BaM+ulrHHnuKmDoCihx8o52Y/jjrGY6yOevpTD9x95x3dDnaHnctdd/66fO+7x5UPfLD7iKPFCzbmwMMWcr5DQR9fbfx3Xv8vetEs5bunnld3P/eVsy/qfmAfPO/5z2/fvj7xtPPrufKe9nvB+Hj4YQrzaq0AH/HVg8oXDzi8/W2q64IOVMgjHn0ouuZgH/yt1z/QntafW1ufgS4+7NM89hH6MD/PAWMjizbq6dcYjmMD0iiPOcY4QBlNmbDg/a2Yf/75y0477VR23nnnstlmm5U111yzrLvO2mWZpRYvz5v0RDn6iIPbN90BuTA3YO2aCMjMtctz6jm2vPk/nSHsNwqo22TGTJSCSAFmjD0UOWCMzMRagR34j31kAF8sFjYedGXARdYOoEdDhi4HFoqePAD1sw2ADTzlURdbYQ4xH+K3PAY7Wu2AcvvK8A+2eecGrW39zrcOKU35RMCH+TpmLsYxLz4/3fw/1ik/OO/K5g/+3XfeWf5nr13LLrvtM7QH0baj3Zg4AhlNXwI/jmPe8NWNseh/ate9WrHki0uCItyOV+3XlZoqBmDshbrCSquVrd79gcZnp7LnFw9sDwTtYQe7QTjiM1ex9DLLNcoNm4L67W8eWXbZde9hftu8Z/v2ur0y2poc8KXP1x34V5vcfBizq8Q3fPSgsakbqbJ4PkiRs9b49XUxOzWgLdhok81aAf70x7rXyPoH5gE8P8jRY+JY0Nc3D4Q3/7T7dR998Oc+MVcan9Gys29vCOrugM9x99z3oKFvqLH1ZUzGyCJf/7GPDPgZMbGISWHl81g+m31F3cEevP++bY0onu3NRtXl82NeI5tLO5/qOYFO4w0ehpHFn2s0Z2NrD8hX1Cug8eM8yJv+axdYsLx/+53a3/UCfuDjpNPPL9f97N72L9/MPvuLh/rYRzh3fRnfHIB9qPk6nuj6hzJ/gD/9Cu1BtI00xoGnD+XAWKDvX136+lE/+gDk4P26HwMoh9oAujTG+rbmRPjK2NfEUBq266yzTtlmm23qMeoengT/YMKcc76kLLTwIq3oXnvFj8uF53YPUtgRj7jUKjeTjTfI3TlAO9lorRmDajdaHA2cqIH8fDYi7mBp6AGKJnYsAnQUvCuoAB72xsUPY+LqRxm6Yhij6sGPOaLvhUHTHt0+XAR9S/3cCX/o2EeOb3nCvvIoE/COP/WccsKp5w4b4++cdt4wbh/wJ8oRHnEAfnfb5SPl5O9+q/050Kvmfs0w/rZbbFyOPuH0Nu7HYAwfX1FG4fnNb0af8bJurgd6NNfCV5jRP9Sc4XtM9t7v0PKpj2zf+GC6ym9+2mjq3AA2NnLi81Z8d79j++f6APkdt/+q3Yi9GYN77727UcAXasjPHAVxwEtf9vLhnGhzvfRl7ckWHs3jTx+gY1/Ai2sQga7xv1ALGX+iwkcO+oHaWHt3tl/Y7ZPD81q5ffOhAeVAHWWs+Tzzvba8re6+WKPJ887R+CsuvUAbT1nwFe0bxsT79jePKGutu2E5/JiTykc/tXs5qT4Y7Pm5jzd9QY7Go3nemJPninnQXBt42FPQ2a0yT75NzJsEvlvAbvYDdTc73NnWokrR9TPj6+qNc7sdPjJVLPx7rrQd7aDYxj/tETGPSNvbu2rGl5vQcV6XXXJhufXnNzfe4489Xs6vN+HXLdh9K5lTGP5fuv71H+XyafEeJW+iHI0D+r4iBa4JdpHvGF/6BvRpHsdnc/2jN1F8qDL42grlUc9zn3zwr69pwVfGviaG0tZaa62ywgrdm0Zxyy23lC9+8YtlySUml5XfWB/Oaxx+nOXNa6xR/vD7+6a6/jk3qF8WV2rWRPm7Bv08u1UdwIMI9cTBkAkLnMcx8KChH799DOAhQ8fiC9quN+gxxq/x8BGTbbzBCalP86Wv35ibcvWRSYF2yGnENifH6tAAO6s++MmtH515Wjn7rNPbn+dABX7uuevO9m3fe++5s31Oxg2EJ3cw9DvILSLGxQ8wR17JcvM55IjjGx+ge+YZJ7ddHLvcRerNlL/z5YtJ/CkQn9n6x/bGs73tHVuUww760nDOxqPfB7baowf1fEEdyrGCzxep+Fz4iMMObH/uA5rP2iDCeADf3bg7b+jTflMLJ764kVYG4nY8+GUj/lyHmzU3Yl8PR+DT8xqf7dVxhfO79567hn1oi/WaedsYW/OA2swrtnjOoaNP5YAvIPE3qsC5xtiCXd1l1/6yrSU6Uteepr0+iAnIQz3AP+iw7ft3bDuwS67+RVsjdoo7f3K31r/mlrvbZ7N8gY/c+Mz6nnqubrbltuUDtdDBB8aMcJ7kEHddIOYV8yE//oyIgskDBw9VyA/ab6/2mvplr3jl4JvGfOv41U32N13/4fqk8AL1jW/+2iGnPf3M0+Xhhx4qG627Sll8gXqjnm+OctThX2lF9T1bb1Jv2HOV1y82d/vceMtt3t98gOplqmMdY+CXPnK+5cw4Ar465iPiWDv0aSDqAsae3zTHrFt/7jEeTWhnvCgT2GqPHpQ49LFH5vWvHymAT3MeIMqxt1agg6xvz5iiN9Gutg9eF/eL7O23315OOOGEskYtqueef3H58v4HcTtpmHGGGctyyy1fzvvR6fWh4okWw3pEPjTH/dYe1iroo0euoO1onbBO4AEmHKFR3N1qi8xGtQcsBAnB0yeU1vQG/hnj09jIXGjG5uWFJZADbYA+PNDEiDkyRg6gNHgxF29oxqcJ4/jaEpzzw++3HwLo2haNAu3hfWi7rcr279m89T/4/k6PmLzO84snMU4//jBuBX9fevGPzytbb/tfgwurOx7orLnOBu2z1+t+8Zv25z/sdldcebWyz/5fLbvsuk/V6daCnUOcMzdhPgNde/U3ND9esLz29c97zLGfD3BcRcM+/ukT90t77dp2ncix59vMxx97ZHsAQe+MU08aFj/icO7wyveaqy7vvnlcdyh8jrrB4PPMSdN3a4XsN/fc3W7UrCXxKBKCz6n51vWudffvjXrPz36sUUDst719i+Y7zotxe2VZxzRk6NJcA88xbYC6IPrznLIJ7dWNOsQyZ+09l5Xblw8PP+jDMz7H8w3LvbEss+wK7TdvAT8hyo5RW+lmW2zbdty83kbOn6QBfZkT0AaZjXzkmYM8KA0eIAfG5utr4Xvvvmuwm/1o49P+4vXPw1eF54qf1bIeMUePHzAXeLTZZntxOefi69svBd3wC1473le2fNd27XXwuRff0Mbw2YFjh/6pZ11cFp68ePNnPoA+jevM3P0CFbGAFKBjPuDC837Udmb8ji8/lxh9X3j+2WX1FRdvX9TyOgXonHf2meXTH/9g6/Plrcnzzdl88M/f4Zt/Fu9dm2809M1nzfBdW3Jix44P/HIOuEPk95HNkb8Xxh5ZzG+Xj32wxUSfByn4jz36aNnmPzcsi9SHfvQvPP9HwzUHUn0Q1zeeyFwb+lBgfYibumlhww03HPRGuOSSS8qyyy5bFl988XocZytTllyqu6UPcmBnu9SSS9T7zxXtXkRcYpoDjXOWHMwbqAugytoMWWSNcRQnHI18epAC5RH6aIkFOYtiAzFBoC8nEHOJuvQdm/MwZjhhyD/aMZZHi/HgA+zkQ9Ub0nrxUhj50xl4Z15wVTnz/EEb9M+68Orywx9fUzbf+r3NN5+f0oa6A4o9T/P8pBy++RtHfAPzcF5S2j31JnTH7be1H86YPM+LyxKvqyd8PbkpktgwF/8xga6w1vnUZbDIAr4UNfqb226Nvn/eT8qKK61e/dan+XnYDc9VDj3wS21Xil8akArG5gjwBo+5A15rf2jnXVqfUMj40Qq+LLXWqsu0bwpfcdnFrVjWjDv/VRH5IQd8sXsdPN9Lmo+11t2g3UgHKTes/dZu1+znfD+pvoB5HfL149rrUD9zXPoNK7RYyFmrrbf9QPnvj3662dr2/vKh7Qtdnk/4iRcWtsi8duSB/hjIo+HH4wniMfaLfurCo7FThEagp199eB4DxiDG5kcoeJvCD1fwW8Z33XlHueonlzYd87380h+3b0FTUPhW9Anf+kbjGz/moU2EuUCjnNxsgt/6Fuo++ODv2sMA1wY/FQmcC3AuABvi+G1jd7HwiBPtjK298f78+u/mh1y9PuXh1uvJB904b98c+aMY/VzoO9YnQI/5H7Tf3u2frbvoylvKCd8+uvziZzcPi+Rx9Vyea67uh/Q9l7DjrQX/zN3mW723/crVgdXHBZff1Pzg45abbyx/evRPZcedPtU+U+az5X0//7lWsAE58I/Bn3j8Me1NBr99zBsFPvO88Cc3l+9UPjx+rCP6hn/LTTe2HN+60SbtM9EW87hvNP0W88OfbPwTTzuv7PuFz7U5xjn312Kisdcf41jQ4p/wMC8aD5SAbxf7meyL56j3yHovW6e266+/vv1rRnvttVd7dfyVA/dr9y1a81v987ntfffe1WyJS/GH0qhrXPvsYM3PWufY/ED7ZSiYAEP68aQDFEyLI87UZ7KO7QMCoG9BRm5QKAlHmSdKTNAYE/XRp8/CA+Xwoz1jdBjTgHGYaz9m9MeNTdvIg37iwx9oPxFHIeU1UtSpg9avg/Z5ZPNdh6041CItVbfZ1j6vlPm8ihvcx3bZo8nJz2PA2Pk1n9XO/I0Pmt8KdKPcvuAmwc2g+x3kjq8ewA9rxBpEX+bjWslDDmXsupmztvp27Y0BNW8Q+dq33cngZtp8DXYujdZxRLQzJ3MwN/j6AlJtkNH3mIN4PkTAi776UB4BD//2pcZ33UG0led8lEV/INpGv4zbPypQdyo83Cw++EcF+MWuhRZapOy1xy7tPOSVLjtgvr3OF3823Wyrdl7GmPqG2gcxHujLnBufB7dvFNcd7OpvXqu88tVzlze/cUrLb8t3b1cLxnuG/6CBtvSx1Q9o8vpfOz/CNYaex8z4rttfvv457jMObTve6Pp3bl2x7eIA/QH4MYbXmnTE744JTVv+fOis759Sdv38l5v8qK8f3Oa3VV0T9CiM79160/YAyW5bO4raiSd8s32uzq73zDNOKXvs3e2+2Y1yI/KVN34eeujBsu2Wm5TDjjy+fbsaPb4sx99285EC+Xus/vTII2Xn/35f2eFDHy/33HNX+4iKf3ACG3eu5McYm8drwd7pg+9p+vwkJXzmTIF9/zZvL4cc8e32z/L9tevf2kPftaLOwNMnNELdrTfboPzxDw+2bxdTZJdbYeUmA0vV4jp5cj3f9/mfcumlF5c9dvtsOeKob5YpU5Zs/tDiH1Y444wf1IeO7i8Y3GX30fSrX2U/veHaMnnR7pehAPlOd8OvHnjGxURZA8YA0xgAyuRYAPvoWu2p8PpgMQiib6AMCl97xhZneAC+MaAg9oG+Ig87LxL17RsLCuLFpMymHejb8wUfvj36XIGd7OprrNUuknhzIR5xgbkA5H2ZNhZRc47AptvNjuYFnG8f+kRGY7244fT9CtcIRFv99+OoA+hrC9QH3kDh8U/k+aMUyKOMfj8H48mXp28BL9qKYQ4Dqo8+ok99xZsVMvlQYCx1oVEPxHjGkCcfyAfqRTlQB9/8SRTfauZ7Bfz9KDtIbp58E9jPZAG7G4osMC98xD5zxLc3SGVQcwXKzOPzu35iGOv4U85uPwt5winntHGMAQWxD/QVeS2fJ8d7/Quutag7tazrRxv6+AH69LiLbxxxSDXu/j1Y9M8758xaeE9rRRNQrPi78K8edXz7M0GAL14PzzPf/GWlVd5cjj7y0Hrvnq5tBgCviPHBP+DunOHxEMWbC+dAUZ933teWlVdbo9mZ9+/rw897a8yDa3E/7eTvVP7Tw6LNK+qzfnBq8+MameOhtaDyMKD/8889axgT6B/Qx1agr1x7Gm99WDNqCxs8ZY7NAXz8v7cta6+99rDIolc7bRf79SOPKUsu2f1JI+MdP/jhsuXW7+p0KvBz3LeOLVu8e4c2Nhd824/ADj6FdpHFpjR76iG1cTSripZsdaIBjcTdHgON0bMAN0eVwhfYUjTjwgEXxgWJsfgiFTAPAD+iz9cHzT4HAr0oQx+efWTygPb9eJE3tK838933PqDc+KsH2uegfCZKo2/rPie9b0j9vNS+Y+kl19xa9tjnwKmKLPCioIFInR95WTzpU2Tx4fzgc2F0dHTC0vARoZ1NG2X4c01o9PUR9WnAMXbygDrIwSjPqXWAOq2I1h2sf7JBH547mWiLjU1E/64diHlEG/UdA+chPxYW0PflODZ8RDlNRHvXBBrXHLjm+hTqq+c49o3BjpVXyfzNLF+I4nNZ5BRVv1RG+8RnPj+MQdx2k6t6nptS+IIY6BhbOAcavozFN475p8X4FSrzVD+iz/c40ny7Mfy3ioMMfWztI5MHmv2AFxF50R50vvmS3ei1fscb5W8RhQfi9Wz8mGfTCyk0ff43OMRNPgA/sMEYHw888Nty+qknlilLLdPFrj7qKrc+OqTcXNcOO1A+Q6XgsWsWFMfTTzmxLDZl6aZH62yfKft+/jNl7fU3aj/ewb2k+a98cudeDqL+Pnt+pr2itcgSk89nKfYWdvXBKM/R5O2rw5h41gl3utSZJgu2bYNX2+JLLlOWmPL6xmteBjqzzDJLefjhh1tfK37jAJ0uWimPPfZomXGm7t/rFeRJLBr8uLEEsQ8lJ2j7wYp2YKYBDAV9A/n7xUAKDCLQJQbUHWtMhKZfTir68uQ7lnpiCnhAnr7ihR/hHARjgL3NuKKdULX55wItj3phA/gAfecAjXlE387BuI6jH3hRLvQvTzu/0ci35ECMJboxcUdP0M7TWI6B9tGHcE5QbfAJpcHTpzcbgK/YF/T1qQ59ZexYuXlCG4+bDLvYwRhoC6CxD8in+Rr4FcQF5q1tbMj073xpHmfzjfaMRX/+2gv6/tkELcKxNtrJ17fr7DkiGGMzkW/0yXlaiPr0nZ8PsyDam5tAlxhSdNVxLvo175ir+pHf/7gAHvBc4DzhOvW49oFPbYD549MW8wTk7toCriM/m+1oZ+ccoM7J89rW5hDW3TGtoYatsx/Jh6VgdP0L7W687uqy7vobtx/caKg+arSpdAFjXvHyOea/r7leWWGp17V/NIFY1119RfNBcQTk2n0uvHF53YILT/VNaz4WQ87cKGiAPHhljP6CC01ucQDFiJ01n9Gusea6Zbkp87fX3DE3+m7o6OOLvjL68ZjIcwzIQ59tI1fbrLPNUR55pCuo6DZppW9Za51yyMEHlquvvqp89zvdX24sv/wKI51q+8gf/1heNMvsU8Wibw0jXttk1jH5tuJe++hoI4ZXiEL7OgU+KXjgDQpfXfVbwIGeQA9e3PEOn0KqPnB3DFxkGieWfeEFhL2xop45IKcB+I5p+oj8CMb40KcN8NqSGNHOcbyo4DlWj75+Iy/yY/7yBONp8bqLmte6UxdjKE/enb9u3ugDYtG8gLUBxlFXoIONfRr26MkHHhNuyubbLsyq57pEYIsv5MZEx50sMm1aXHaxtbXXhPUm64NPsxnk1c8Tv1CgDGpschaM+zkyRtcYyp27vhmrA+zTmDs06rtWEcj1q435qQvPtULG2Gaeca3NI64D0Ma+eo6BcZApV9exOUfAh0cewvjogzh/86bJVwb8wpN+ga+KaZwH+qcB+I5p5hL5EYzxoU8bwJYcOzvPoW7tXWsaOt14tNbw9Rt5kf+aeeZvXywyh1/ddmsrdIDxpPBwCR5//PH2haQ3LP/GYW7zzFuL2S0/bXL88A8d4AN7AOX1MP/wyd1339GKCl+Y4hWrwO/OH3pv+dindp+qyDbfN9/Y+vi+7Ze/aJ/DPlH1+Vy26b/r/cNjx6YMClZ701vKm9+yTrn/vnuHPOEOtZvj6FyD53prQ99m7cAeaEN78Rxz1d3+Axi0Atrsa3+77bYviyy6WNlmq/8sRx1xeNn/wIPbn5FZ68D999/X/pIhwjhQdJu/CvI1f0B9i4W/zYZJAJkaOwb21cWJlZ2JEsSJouNCAZ9U4mL1Y+Gv0YFP+epia2z9e1IjZwz14GojnwbU1Rf69iPwEe2BN3Iual5f9nOkyQPyiQHwB88cHRNDOYjzMjY6UU8f6sVcLabIpMp4xRz9IqM429cfNPoE0abPI2cQZfDIk890AXx8SuVpCxjjw76IvKjD7oUG3NEgMw/1gDHhMS9ljtWPfNHXMQ9l8tGhGUvE+dJXVx5rBA/AV44u1Hixb9zoDz/Rnocc5OroX3uADMAD8h0D++rqH+o1pAyKTHg+wzduP5ZUn5GP7kT+43XCOQC14GrjXGmg6Vaevsy9D3xEexBt+LJUP0eaPCA/fvMYnteuY2IoB6+sN/drr7myfemJxjeJV3jjqkGv5jOIRaOIUhAWWnjRFg+9l73slc0Hr4P5fJVCvNzyK7d/BhOf6CG77pqrmu3tt/+y/aiLv4WN30svOr/9bbVFHj54+ctfVa69uvNtfiu+cbVy2aUXts+M1ff6v+mGa5su9vxD89jyjV8AL27AGFsLjAfIB8CLBa4VtMG6yIPS0F16mWXLFVdeXR566Pcjf1U22+yzl098Ypdy9bU/LaeecVZZaeVVcc6LgNbQv+rqa8sSS3avna13+NC3/iyo8M3HWiiqTpdcBEYedGEQnbibVRZpBP5bIeaEHiQTY9KHj1/jthiDk1FdDlpcUPSaz0rVMR8BH55UuRR/Xqy2qINv7Zp8cCNnzAUdgR/guqHvnJDpA8hnjL428mnOy8bYV4uM8QlPG/qdLf663PSlXCDHB3zHMX9kALnHgb6xADz1QPRvPBo29onBWKBHi/MCxGR9lduAO1jBw0/b7XLzqcAHsaI/bY0t7cuB9gB+zF++0B4+fW2N3adRpw91iMf8GatHH3iMzB8+/XjssAXGQh7j6wvI7wN+P0f9QJ2jvsxHGoH/djwHczIPYU76xzd99KNuPHfgOVeoOp4DQt9SGpDiD7/IbVEnzlN5JyP26J/7A/EYAHSdk39qp718xuhrI59CtdPHPlNWWmah1j7y8c+V1y2w8NTXycAWm0tqQfTLPjT4/EMQH/nYZ8sbX79ga/iDx282r7nq69tntI3/8c8035df8uOywoqrNFvzZKfKr4L597LY8IWr5vvjnW/ywwc72l/98tb2t8/o8TezNL6UxeecxMSP+vgwX3a8w3lVWC+U2wAUmWi1qDblrilj+jwQrfKmtctFF11U7xvdMeuiVAziVeWOgspjJ3/xxReXlVdfszyv5o6/uJEU5gufPgWXvrGtd218/W2/rbSbiEwOHmAcT3h1CMxTSLQxCfoWXE8coA8XCRl+gD7s05BFewAPGWhxBic3wG9fHzCeiG98YwFj96FOo/Wmrg5P0e5yo47xjAmPvjrkbb6OAX304rzgAf0C9bTVt3AMjXPv4ncnsHz18MOFDL/TC/OsPGXagGgPkJsvYAycK4h+oy3xtYXGbzajN1zn8NrMG6u7mYZKYo4xHkBmLkA7dRw7l5hjfw7RliafBhjrB6CvnXo05egiY+w5wJimH32Kvr0UnnHi+jPuwxjIjAW0hSqDml+0MYdoD2UM9IE/YI5AH/ZpyKI9gIcMwHeNAA9f7TzoFVvziX6A8Y0FjN2HOh1lPZgffjlnRw826hjPmPDoq0Pez9X1z9/e8/OYu33+y62IAmNB49yNH/nw2JXutdsny2d2/2J5wQtfONSDAnTHff1TT6wh6MRfGERPv9oCbak3FDURczQe39x+5KHflmWXW779WdEQ2g30+dMyiuy/zTJHWe3NazXbGAdYWOXTt8jSv+nG68oiiy7Rxtg0PoUWIQm5kCIuCvy4xeepAydRHzDhifgeBPy5gCSn/wjziRTEAxll5m1MePTVec5O7Hqz5/MhLmbkwlhQcwHGj3z1iDm+wvZke5J74onHa5zR0zQNWfet5MExCDcLYEwa/c6mWzsoBRBqHtG3ICf9qKecPuiP0XcNIg+0h5taYIe71tpHT76+GMeHn358m2tmjow9BxjTzMe5iL69FJ5x4o2FcR/GQGYsoC1UGdT8oo05RHsoY6AP/AFzBPqwT0MW7QE8ZAB+vE6cY9QHjCfiG99YwNh9qBMp6M9BmfFazPqf54o65G2+jgF9bOK8on/0gXrdm5+pd6eAa4kxfHMBxo989fDDFxfhq6dPeM+2sHGd8gMW8byh9Y/bRD6Q0ehHG/1CzSP6FvjTj3rK6YP+2DzUlwf6fPqxsNEHsbAB40r55Tl+VnHppaaUOeaYo7zw315Unve855dHH/1T+zvh395/f7ny6mvaTnb++RdofpyLwI/rJd+Yxrn+uqvbN+gB40avvfW+ZyZaFJoLDODr0IkB9e2318ADe8bA4gvUV9aPPVFfoMskOXmgURc4Ro/cgSeaPORxXlIXL/o0NtQFbxcwu6oa0rgg2hjLuI7JhQsImJc26gJzkR9lAply4Hw7Hidgd5FE/xZXxlL0JtrlKte/gEd+kcpXt4vV+VHuGsB3LlB8aIcu66LeVL7DTmV4Ix3QyAPGkLLm3CAY2+A3vz0eFCiD2hfRjr48EI9DpIC+aybfYw2iTcwDOI5r3sdEfOxcZxB9S523MiiNuSAD0U+Mo779aE9ffvQTZf3YE/WF8ad5/XNO1DEPW368MPH13z1sAvNyfaJPY0ORx1yB1xOINvgmhnEdW1zBeK//zmfs60cdKc217M9Puwj1I5WvLlQ/yvHtde1coMYG6LKZYxOnvXx1gOPIj32oc6Hu8GqaHTJ1iM3HlT+5rPzvA/eVhx58oDz++KP13jBT+3bxK141d1liytJ13H3+bgzqWdwxO1YuD5D7T2+oO9rFuh+sUN52tCTj5EjQMZMmSUBf5wayePZPjCgTyJQD/AN9QZVL1WUspf0zTowoF8Ob+kCH3W38vJB8POG5kOJTabywBH3k9oH6tpgTYA748qYR86Q/erU1ylO9bt1GNwfgTUBdoT6xQD8fx8K8gVSf+upDeQS2+FK/xQoFFPiKMBZc9Nrrw7Ce+olx4Dum77jFGfjX1n6UOU95E/WF8VlDaNQFjtGL5w18ecih5iN1faJPY0ORoxv59EW0MRZj+o7J5Z/zYNj5jH39qCOluZbEUF+5Nu0rphXqRypfXWh8OAVRLrox8Zgb1zS7u9Fnta4bcO3MMa6foO86yVffRh7mBJgDvoijTFv6/TlKlakrzFldoT6xQD8fx8K8gVSf+upDeQS2+FLfWEBqLGVQ6gc1BRmATw1iYxjjqG/fsb7kRz9Rhk/rlfVQuX1/Gcr41M7279H2k6G4EsjEaegIAgB42COXByyy2qEDOKAebHRItvkPseOkgHnJ7x+AqA+1GYeTHR0b0IZGfMacUPThCXntlSR69YbOTV5wY+/7lBIfe8Y05q5vbYztGOqNTV8Cf4yxAVD8ux7o0yic6nV5dHHRi6+I9c0NxjzRixjpTLzO8KKOVJ43HXOnxXmgy1jb6Mu+r4FZe38NSliA0Ynx45oAxyDquZaAMb5pcV2NN8xnkL/HM/qgrx4wlusAYpy4BtE/PGzg0Z/o+OhDu9gXxgIxT3Vp/fjAAkEOUJrrAczDXJ2HMJZ2yvAXbYgpFeYklMk3D8dRH8o5QTPO3379d9/W1hdg3bs5dOuAnjth0D2gdnPVp5T4Hjea54u6QJ+Ooc/++h+tq3lI1QX6RjbR+QWiTpRD5UUdqTzPe3On2e/nB6Iv++bM2DyFduhYf/QJ5DkG2kCtU8CYtLapDHEjpZ5Z1Ps+XHth/FZHG6MaGwRg4CIBnNHg6dji6MTgm6z8x594ounBYwwITl9dY5uk/DahgU8gH6ouFHjCIVNfHV8ZkjtjWlxE9YE+9ePFYXHVHl6/D+yTj4BHPHPVLraYm/HVp0+zj479eIzgq6s+PuKNwT43h5FO93TsmgBz6q9TXBt5gnH0Qd/jEu3gQeFjg0xb7aH6brvVwc4VHn0/i6X58NN2ttUPcO1AsxnwgecDgPYvXsDc8WGOw1wGetGnuTKmaSPouw4groVjqXb6UifGgDpWDpRFH0BdPq+DZ3zzAfSRaYNOPLcYy4MCdfWl38g3Jo2xfBt8Y2Ovnnx9aqdcXXNp6zt42FJfnefk+h9eN86FnPGP7uh4o0uffAQ85wL0EVvMzfjq06fZR8d+PEbw1VUfH/oBMYeogx/XBCCPPPXR1X/0ARhHH/Q976MdPCh8bJBpqz1U38iMRVPXmqQPZYCxiHzAK2R9U4soqlEO3GASh/qlvnrY2XcjyRhdbKI/+m1H2xQGicWE7VtAAXwcA6s1gK+doO8k5EP7iyNiv8kHNuYGWj7Vp30bJ0X0JwX9iUcdbWjoRcDTzpNDWHjVifbqSZ2rfZoXCDr09R9t7EdbYBzXQV1a1FXPHa3odLkIRv+oM3ZxXcmJG5R+bOhNlI9+BH14tr6sD/WAMWjyWhGtBRVwQ4XvjVVb/WrTpwAd5hb1Yz6umXOEOj+BPjxo3w8t5g3guUOk77kK9E0zNoh8jkvMJ1LkMb5Ue/ro2gC5wFcOjX4jT3sogG+e8kD0JeiTO1Q+FH/S6KPvTxv0BDrxPLW1NR08bCkTroVQBjUHWlx/AE87YmoHLLwW3GivntS52qeRL0CHvv6jjf1oC4zjOqhLi7rqQfUF1PXYaBfXlZz+pa7/gT9gPOoQNYg6MVEx7FOADkUUnvqxjuEbOEcocfo+0DMn/TR+bTFvAP+JJ58s/w++uAIlkmAtIwAAAABJRU5ErkJggg==\" alt=\"\"><br></p>', '2023-03-01 09:53:24', 1),
(112, 307, 1, '<p>dsdfsd</p>', '2023-03-01 16:49:57', 1),
(113, 307, 1, '<p>sdfsdf</p>', '2023-03-01 16:49:59', 1),
(114, 307, 1, '<p>sdfsdf</p>', '2023-03-01 16:50:01', 1),
(115, 307, 1, '<p>sdfsdf</p>', '2023-03-01 16:50:04', 1),
(116, 307, 1, '<p>sdfsdf</p>', '2023-03-01 16:50:07', 1),
(117, 307, 1, '<p>sdfsdf</p>', '2023-03-01 16:50:10', 1),
(118, 307, 1, '<p>fsdf</p>', '2023-03-01 16:50:12', 1),
(119, 298, 1, 'Ticket Re-Abierto...', '2023-03-07 15:35:34', 1),
(120, 319, 1, '<p>YA SE DERIVO PARA LA COMPRA, HAZL EEL SEGUIMIENTO, MEDIANTE EL CHAT</p>', '2023-03-08 08:43:41', 1),
(121, 319, 1, '<p>SE REALIZO EL CAMBIO, PROCEDE AL CERRAR EL TICKET</p><p><br></p>', '2023-03-08 08:44:56', 1),
(122, 319, 1, 'Ticket Cerrado...', '2023-03-08 12:25:00', 1),
(123, 318, 1, 'Ticket Cerrado...', '2023-03-08 12:25:23', 1),
(124, 309, 1, 'Ticket Re-Abierto...', '2023-03-08 12:26:06', 1),
(125, 309, 1, 'Ticket Cerrado...', '2023-03-08 12:26:17', 1),
(126, 297, 1, 'Ticket Re-Abierto...', '2023-03-08 12:26:36', 1),
(127, 297, 1, 'Ticket Cerrado...', '2023-03-08 12:26:48', 1),
(128, 320, 1, 'SE ASIGNO AL AREA&nbsp;', '2023-03-09 09:12:24', 1),
(129, 297, 1, 'Ticket Re-Abierto...', '2023-03-20 13:02:55', 1),
(130, 297, 1, '<p>aasdasd</p>', '2023-03-20 13:03:03', 1),
(131, 321, 15, '<p>dddd</p>', '2023-03-21 18:22:56', 1),
(132, 321, 1, '<p>aun no se factura indicar motivos</p>', '2023-03-21 18:23:35', 1),
(133, 321, 15, 'Ticket Cerrado...', '2023-03-22 11:02:51', 1),
(134, 321, 15, 'Ticket Re-Abierto...', '2023-03-22 16:51:04', 1),
(135, 321, 15, '<p><img src=\"data:image/png;base64,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\" alt=\"\"><br></p>', '2023-03-22 16:51:32', 1),
(136, 322, 15, '<p>en que estado esta</p>', '2023-03-24 18:26:34', 1),
(137, 325, 1, '<p>se realizo</p>', '2023-04-17 12:44:26', 1),
(138, 325, 15, '<p>asdhldhlasd</p>', '2023-04-17 12:44:55', 1),
(139, 325, 15, 'Ticket Cerrado...', '2023-04-17 12:45:56', 1),
(140, 322, 15, '<p>uilouilj</p>', '2023-04-19 09:58:59', 1),
(141, 322, 15, '<p>oipopñioñ</p>', '2023-04-19 09:59:01', 1),
(142, 324, 15, 'Ticket Cerrado...', '2023-04-20 15:04:35', 1),
(143, 322, 15, '<p>sadsadasdds</p>', '2023-04-24 14:59:16', 1),
(144, 322, 15, '<p>aasaaaaaaaaaaaaaaaaaa</p>', '2023-04-24 14:59:22', 1),
(145, 329, 6, '<p>dsfsdfsdf</p>', '2023-05-08 12:48:51', 1),
(146, 326, 6, 'Ticket Cerrado...', '2023-05-23 08:20:54', 1),
(147, 337, 6, '<p>gfgdfg</p>', '2023-05-26 12:56:00', 1),
(148, 368, 6, '<p>dsfsdfsd</p>', '2023-06-07 15:07:30', 1),
(149, 368, 6, '<p>sdfsdfsdf</p>', '2023-06-07 15:07:35', 1),
(150, 368, 6, '<p><img src=\"data:image/png;base64,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\" alt=\"\"><br></p>', '2023-06-07 15:08:22', 1),
(151, 326, 1, 'Ticket Re-Abierto...', '2023-06-21 09:20:25', 1),
(152, 326, 1, 'Ticket Cerrado...', '2023-06-21 09:20:38', 1),
(153, 374, 68, '<p>dcscsd</p>', '2023-06-22 12:25:56', 1),
(154, 375, 68, '<p>dfsdf</p>', '2023-06-23 11:48:16', 1),
(155, 375, 68, 'Ticket Cerrado...', '2023-06-23 12:26:01', 1),
(156, 375, 68, 'Ticket Re-Abierto...', '2023-06-23 12:26:44', 1),
(157, 376, 6, 'enviame tus credenciales del teamwiever', '2023-06-26 17:42:33', 1),
(158, 376, 6, '<p>ok&nbsp;</p>', '2023-06-26 17:42:43', 1),
(159, 376, 6, 'Ticket Cerrado...', '2023-06-26 17:43:18', 1),
(160, 376, 6, 'Ticket Re-Abierto...', '2023-06-26 17:43:45', 1),
(161, 376, 6, 'Ticket Cerrado...', '2023-06-26 17:44:27', 1),
(162, 321, 15, 'Ticket Cerrado...', '2023-07-15 09:32:55', 1),
(163, 321, 15, 'Ticket Re-Abierto...', '2023-07-22 11:43:26', 1),
(164, 324, 15, 'Ticket Re-Abierto...', '2023-07-22 11:43:43', 1),
(165, 325, 15, 'Ticket Re-Abierto...', '2023-07-22 11:43:46', 1),
(166, 377, 15, '<p>fdfgfdg</p>', '2023-07-22 11:57:47', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_servicio`
--

CREATE TABLE `tipo_servicio` (
  `id_modalidad` int(11) NOT NULL,
  `modalidad` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tipo_servicio`
--

INSERT INTO `tipo_servicio` (`id_modalidad`, `modalidad`, `estado`) VALUES
(1, 'Otros', 1),
(2, 'Saneamiento', 1),
(3, 'Succion', 1),
(4, 'Gestión de Residuos', 1),
(5, 'Portatiles', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_acopio`
--

CREATE TABLE `tm_acopio` (
  `id_acopio` int(11) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_acopio`
--

INSERT INTO `tm_acopio` (`id_acopio`, `descripcion`, `estado`) VALUES
(1, 'Cilindros', 1),
(2, 'Cajas de Madera / Cartón', 1),
(3, 'Sacos', 1),
(4, 'Palets / Paletas', 1),
(5, 'A Granel', 1),
(6, 'Otros / Bolsas', 1),
(7, 'Pozo Septico(PS)', 1),
(8, 'Trampa de Grasa(TG)', 1),
(9, 'Efluentes Industriales', 1),
(10, 'PTAR', 1),
(11, 'Trampa de Grasa de Carroa', 1),
(12, 'Otros', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_cargo`
--

CREATE TABLE `tm_cargo` (
  `id_cargo` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_cargo`
--

INSERT INTO `tm_cargo` (`id_cargo`, `descripcion`, `estado`) VALUES
(1, 'Gerente general', 1),
(2, 'Gerente Comercial', 1),
(3, 'Director de Proyectos', 1),
(4, 'Gerente de Operaciones', 1),
(5, 'Jefatura de RRHH - Contabilidad', 1),
(6, 'Administrador', 1),
(7, 'Asistente RRHH', 1),
(8, 'Supervisor de Seguridad', 1),
(9, 'Supervisor de Saneamiento', 1),
(10, 'Supervisor de Campo', 1),
(11, 'Programacion -  Documentacion', 1),
(12, 'Asistente programacion', 1),
(13, 'Conductor', 1),
(14, 'Operadores', 1),
(15, 'Auxiliares', 1),
(16, 'Facturación y Cobranza', 1),
(17, 'Contabilidad', 1),
(18, 'Supervisor de Operaciones', 1),
(19, 'Asistente de Licitaciones', 1),
(20, 'Técnico Servicio Generales', 1),
(21, 'Desarrollo y Soporte de Sistemas', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_categoria`
--

CREATE TABLE `tm_categoria` (
  `cat_id` int(11) NOT NULL,
  `cat_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_categoria`
--

INSERT INTO `tm_categoria` (`cat_id`, `cat_nom`, `est`) VALUES
(1, 'SOPORTE DE HARDWARE', 1),
(2, 'SOPORTE DE SOFTWARE', 1),
(3, 'OTROS', 1),
(4, 'INCIDENCIAS', 1),
(5, 'REQUERIMIENTOS', 1),
(6, 'SOLICITUD DE PAGOS', 1),
(7, 'SOPORTE DE RED', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_cliente`
--

CREATE TABLE `tm_cliente` (
  `id_cliente` int(11) NOT NULL,
  `tipodoc_id` int(11) NOT NULL,
  `nro_doc` varchar(15) NOT NULL,
  `nom_cli` varchar(200) NOT NULL,
  `direc_cli` varchar(300) NOT NULL,
  `id_ccredito` int(11) DEFAULT NULL,
  `id_departamento` int(11) DEFAULT NULL,
  `id_provincia` int(11) DEFAULT NULL,
  `id_distrito` int(11) DEFAULT NULL,
  `tele_cli` varchar(30) DEFAULT NULL,
  `correo_cli` varchar(100) DEFAULT NULL,
  `contacto_telf` varchar(15) DEFAULT NULL,
  `contacto_cli` varchar(150) DEFAULT NULL,
  `fech_crea` datetime NOT NULL,
  `fech_modi` datetime DEFAULT NULL,
  `fech_elim` datetime DEFAULT NULL,
  `est` int(11) NOT NULL,
  `contacto_factu` varchar(100) DEFAULT NULL,
  `correo_fac` varchar(100) DEFAULT NULL,
  `contacto_cobra` varchar(100) DEFAULT NULL,
  `correo_cobra` varchar(100) DEFAULT NULL,
  `tele_cobra` varchar(30) DEFAULT NULL,
  `contacto_adi` varchar(100) DEFAULT NULL,
  `correo_adi` varchar(100) DEFAULT NULL,
  `tele_adi` varchar(30) DEFAULT NULL,
  `web` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_cliente`
--

INSERT INTO `tm_cliente` (`id_cliente`, `tipodoc_id`, `nro_doc`, `nom_cli`, `direc_cli`, `id_ccredito`, `id_departamento`, `id_provincia`, `id_distrito`, `tele_cli`, `correo_cli`, `contacto_telf`, `contacto_cli`, `fech_crea`, `fech_modi`, `fech_elim`, `est`, `contacto_factu`, `correo_fac`, `contacto_cobra`, `correo_cobra`, `tele_cobra`, `contacto_adi`, `correo_adi`, `tele_adi`, `web`) VALUES
(187, 2, '45687899', 'AGRICOLA ANDREA S.A.C. ', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201', 1, 1, 1, 1, '436989', 'ventas@sanipperu.com', '997307803', 'Tania Peñafiel', '2023-05-17 09:29:33', NULL, NULL, 1, 'dfghdh', 'dfghdfgh@fdgsdfg', 'dfhdfh', 'dfghdfghdfghdfgh@dfgdsgsd', 'fdghdfgh', 'sdfgsdfgsdfg', 'dfgsdf@ergfwergfe', '565', 'dfgdsfgwdgsdfg'),
(188, 1, '20505688902', 'NOMA INMOBILIARIA S.A.C. ', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 1, 15, 127, 1281, '', 'dan.msaj@gmail.com', '', 'SDFSDF', '2023-05-17 09:30:18', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(189, 1, '20100366747', 'LLAMA GAS S A ', 'AV. EL POLO NRO. 397 (PISO 3 Y 4 ESQ. JR.EMANCIPACION 103 -107) LIMA - LIMA - SANTIAGO DE SURCO', 2, 15, 127, 1290, '', 'sistemas@sanipperu.com', '9978307803', 'Manuel Garcia', '2023-05-17 09:31:01', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(190, 1, '20511317038', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 1, 15, 127, 1281, 'NULL', 'chinacivil@construcction.com', '9978307803', 'Manuel Garcia', '2023-05-17 09:33:33', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(202, 1, '20550372640', 'RUTAS DE LIMA S.A.C.', 'CAR.PANAMERICANA SUR KM. 19.65 NRO. S/N LIMA - LIMA - VILLA EL SALVADOR', 4, 15, 127, 1292, '', 'fghfghfgh@dsfdsfsf', '997307803', 'alkdfhaoisd', '2023-05-17 16:59:16', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(203, 1, '20516390060', 'CLASEM SAC ', 'AV. REPUBLICA DE COLOMBIA NRO. 185 INT. 501 LIMA - LIMA - SAN ISIDRO', 2, 15, 127, 1266, '', 'fghfghfgh@dsfdsfsf', '997307803', 'alkdfhaoisd', '2023-05-17 18:32:54', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(204, 1, '20604748802', 'NOMA INMOBILIARIA S.A.C. ', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201\"CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL ', 2, 15, 127, 1280, '', 'fghfghfgh@dsfdsfsf', '', 'alkdfhaoisd', '2023-05-18 09:13:18', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(205, 2, '10210310', 'ASDASDASDASDASD', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201', 2, 2, 9, 96, '997307803', 'asdasdd@adad', '997307803', 'ASDASD', '2023-05-18 09:13:57', NULL, '2023-05-18 12:13:45', 0, 'Luis Martinez', 'dan.msaj@gmail.com', 'Angela Paredes', 'cobranza@rrhh.com', '987456213', 'Margarita Suxe', 'Contabilidad.com', '967438288', 'www.google.com'),
(206, 2, '47856925', 'AGRICOLA ANDREA S.A.C. ', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201', 3, 1, 2, 22, '997307803', 'dan.msaj@gmail.com', '997307803', 'Luis Aguila', '2023-05-18 11:56:44', NULL, '2023-05-18 12:13:48', 0, 'aaaaaaaaaaaaaaaaa', 'fghfhfgh@asdas', '', '', '', '', '', '', ''),
(207, 1, '20587458965', 'AGRICOLA ANDREA S.A.C. ', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201', 5, 2, 10, 103, '997307803', 'dan-ms@hotmail.com', '446686', 'Daniel Moscoso', '2023-05-19 08:23:30', NULL, '2023-05-23 15:15:38', 0, 'rrrrrrrrrrrrrrrrrrrrrr', 'fghfhfgh@asdas', 'rrrrrrrrrrrrrrrrrrr', 'rrrrrrrrr@sadasdasd', '56+6946', 'wwwwwwwwww', 'wwwwwwwwwwwwww@sss', 'wwwwwwwwwwww', 'www.google.com'),
(208, 2, '46391315', 'Daniel Moscoso silva', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) ', 3, 15, 127, 1281, '', 'chinacivil@construcction.com', '9978307803', '', '2023-06-07 09:07:31', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(209, 1, '11111111111', 'DFSDFSDFSDFSDF', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 2, 15, 127, 1281, '', 'dan.msaj@gmail.com', '9978307803', 'Manuel Garcia', '2023-07-14 15:38:11', NULL, NULL, 1, '', '', '', '', '', '', '', '', ''),
(210, 1, '22222222222', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 3, 1, 1, 3, '', 'chinacivil@construcction.com', '9978307803', 'Manuel Garcia', '2023-07-22 11:32:23', NULL, NULL, 1, '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_concredito`
--

CREATE TABLE `tm_concredito` (
  `id_ccredito` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_concredito`
--

INSERT INTO `tm_concredito` (`id_ccredito`, `descripcion`, `estado`) VALUES
(1, '7 Días', 1),
(2, '15 Dias', 1),
(3, '30 Dias', 1),
(4, ' Al Contado', 1),
(5, 'Pago Adelantado', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_correo`
--

CREATE TABLE `tm_correo` (
  `id_correo` int(11) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contraseña` varchar(40) DEFAULT NULL,
  `usu_id` int(11) DEFAULT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_correo`
--

INSERT INTO `tm_correo` (`id_correo`, `correo`, `contraseña`, `usu_id`, `estado`) VALUES
(1, 'administracion@sanipperu.com\r\n', 'Alfredo_sanip2023', 11, 1),
(2, 'almacen@sanipperu.com	\r\n', '', 11, 1),
(3, 'amelgar@sanipperu.com\r\n', 'Melgar2023_', 11, 1),
(4, 'asesor1@sanipperu.com', 'Ventas_sanip2023', 11, 1),
(5, 'asesor2@sanipperu.com', 'Asesor2023_', 11, 1),
(6, 'asesor3@sanipperu.com', 'Asesor2023_', 11, 1),
(7, 'asesor4@sanipperu.com', 'Asesor2023_', 11, 1),
(8, 'asesor5@sanipperu.com', 'Asesor2023_', 11, 1),
(9, 'asesor6@sanipperu.com', 'Asesor2023_', 11, 1),
(10, 'asesor7@sanipperu.com', 'Asesor2023_', 11, 1),
(11, 'asesor_informatico@sanipperu.com', '', 11, 1),
(12, 'asistente_cobranzas@sanipperu.com', 'Asistentec2023_', 11, 1),
(13, 'asistente_fracturacion@sanipperu.com', 'Asistentef2023_', 11, 1),
(14, 'asistente_operaciones@sanipperu.com', '', 11, 1),
(15, 'asistente_operaciones2@sanipperu.com', 'Asistente2023_', 11, 1),
(16, 'cobranzas@sanipperu.com', 'Cobranzas2023_', 11, 1),
(17, 'comercial@sanipperu.com', '', 11, 1),
(18, 'comercial.sanip@sanipperu.com', 'Comercials2023_', 11, 1),
(19, 'comercialresiduoss@sanipperu.com', '', 11, 1),
(20, 'consultoria@sanipperu.com', '', 11, 1),
(21, 'contabilidad@sanipperu.com', 'Katty2023_', 11, 1),
(22, 'contabilidad2@sanipperu.com', '', 11, 1),
(23, 'coordinador@sanipperu.com', '', 11, 1),
(24, 'coordinadoradministrativo@sanipperu.com', 'Angela2023_', 11, 1),
(25, 'creditos@sanipperu.com', '', 11, 1),
(26, 'dcollantes@sanipperu.com', '', 11, 1),
(27, 'esanchez@sanipperu.com', 'Edgardo_sanchez_sanip2023', 11, 1),
(28, 'espaciosconfinados@sanipperu.com', '', 11, 1),
(29, 'eyalta@sanipperu.com', '', 11, 1),
(30, 'facturacion@sanipperu.com', 'Facturacion2023_', 11, 1),
(31, 'gcontabilidad@sanipperu.com', '', 11, 1),
(32, 'gerente@sanipperu.com', '', 11, 1),
(33, 'gestioncomercialrs@sanipperu.com', '', 11, 1),
(34, 'heidyyalta@sanipperu.com', '', 11, 1),
(35, 'hyalta@sanipperu.com', '', 11, 1),
(36, 'informatica@sanipperu.com', '', 11, 1),
(37, 'jefesoma@sanipperu.com', '', 11, 1),
(38, 'jefessoma@sanipperu.com', '', 11, 1),
(39, 'legal@sanipperu.com', '', 11, 1),
(40, 'leuribe@sanipperu.com', '', 11, 1),
(41, 'licitaciones@sanipperu.com', 'Licitaciones2023_', 11, 1),
(42, 'logistica@sanipperu.com', '', 11, 1),
(43, 'lpacheco@sanipperu.com', '', 11, 1),
(44, 'mdigital@sanipperu.com', '', 11, 1),
(45, 'mhuarcaya@sanipperu.com', '', 11, 1),
(46, 'nestor.yalta@sanipperu.com', '', 11, 1),
(47, 'nyalta@sanipperu.com', 'Yalta2023_', 11, 1),
(48, 'pchachapoyas@sanipperu.com', '', 11, 1),
(49, 'postventa@sanipperu.com', '', 11, 1),
(50, 'programacion@sanipperu.com', '', 11, 1),
(51, 'programacionepp@sanipperu.com', '', 11, 1),
(52, 'proyectos@sanipperu.com', '', 11, 1),
(53, 'redessociales@sanipperu.com', 'Redessociales2023_', 11, 1),
(54, 'redessociales2@sanipperu.com', 'Redessociales2023_', 11, 1),
(55, 'rrhh@sanipperu.com', 'Recursos2023_', 11, 1),
(56, 'saneamiento@sanipperu.com', 'Saneamiento2023_', 11, 1),
(57, 'serviciosgenerales@sanipperu.com', 'Servicios2023_', 11, 1),
(58, 'sistemas@sanipperu.com', 'Daniel_2023@', 11, 1),
(59, 'soporte_admin@sanipperu.com', '', 11, 1),
(60, 'ssoma@sanipperu.com', '', 11, 1),
(61, 'ssomaplanta@sanipperu.com', '', 11, 1),
(62, 'subgerente@sanipperu.com', '', 11, 1),
(63, 'supervisor_operaciones@sanipperu.com', 'Supervisor2023_', 11, 1),
(64, 'tesoreria@sanipperu.com', '', 11, 1),
(65, 'ventas@sanipperu.com', '', 11, 1),
(66, 'wvasquez@sanipperu.com', '', 11, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_departamento`
--

CREATE TABLE `tm_departamento` (
  `id_departamento` int(11) NOT NULL,
  `departamento` varchar(150) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_departamento`
--

INSERT INTO `tm_departamento` (`id_departamento`, `departamento`, `estado`) VALUES
(1, 'AMAZONAS', 1),
(2, 'ANCASH', 1),
(3, 'APURIMAC', 1),
(4, 'AREQUIPA', 1),
(5, 'AYACUCHO', 1),
(6, 'CAJAMARCA', 1),
(7, 'CALLAO', 1),
(8, 'CUSCO', 1),
(9, 'HUANCAVELICA', 1),
(10, 'HUANUCO', 1),
(11, 'ICA', 1),
(12, 'JUNIN', 1),
(13, 'LA LIBERTAD', 1),
(14, 'LAMBAYEQUE', 1),
(15, 'LIMA', 1),
(16, 'LORETO', 1),
(17, 'MADRE DE DIOS', 1),
(18, 'MOQUEGUA', 1),
(19, 'PASCO', 1),
(20, 'PIURA', 1),
(21, 'PUNO', 1),
(22, 'SAN MARTIN', 1),
(23, 'TACNA', 1),
(24, 'TUMBES', 1),
(25, 'UCAYALI', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_disposicion_final`
--

CREATE TABLE `tm_disposicion_final` (
  `id_disposicion` int(30) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_disposicion_final`
--

INSERT INTO `tm_disposicion_final` (`id_disposicion`, `descripcion`, `estado`) VALUES
(1, 'Libre por SANIP', 1),
(2, 'Petramas', 1),
(3, 'Tower & Tower', 1),
(4, 'Kanay', 1),
(5, 'Innova Ambiental', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_distrito`
--

CREATE TABLE `tm_distrito` (
  `id_distrito` int(11) NOT NULL,
  `nom_distrito` varchar(150) NOT NULL,
  `id_provincia` int(11) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_distrito`
--

INSERT INTO `tm_distrito` (`id_distrito`, `nom_distrito`, `id_provincia`, `estado`) VALUES
(1, 'CHACHAPOYAS', 1, 1),
(2, 'ASUNCION', 1, 1),
(3, 'BALSAS', 1, 1),
(4, 'CHETO', 1, 1),
(5, 'CHILIQUIN', 1, 1),
(6, 'CHUQUIBAMBA', 1, 1),
(7, 'GRANADA', 1, 1),
(8, 'HUANCAS', 1, 1),
(9, 'LA JALCA', 1, 1),
(10, 'LEIMEBAMBA', 1, 1),
(11, 'LEVANTO', 1, 1),
(12, 'MAGDALENA', 1, 1),
(13, 'MARISCAL CASTILLA', 1, 1),
(14, 'MOLINOPAMPA', 1, 1),
(15, 'MONTEVIDEO', 1, 1),
(16, 'OLLEROS', 1, 1),
(17, 'QUINJALCA', 1, 1),
(18, 'SAN FRANCISCO DE DAGUAS', 1, 1),
(19, 'SAN ISIDRO DE MAINO', 1, 1),
(20, 'SOLOCO', 1, 1),
(21, 'SONCHE', 1, 1),
(22, 'LA PECA', 2, 1),
(23, 'ARAMANGO', 2, 1),
(24, 'COPALLIN', 2, 1),
(25, 'EL PARCO', 2, 1),
(26, 'IMAZA', 2, 1),
(27, 'JUMBILLA', 3, 1),
(28, 'CHISQUILLA', 3, 1),
(29, 'CHURUJA', 3, 1),
(30, 'COROSHA', 3, 1),
(31, 'CUISPES', 3, 1),
(32, 'FLORIDA', 3, 1),
(33, 'JAZAN', 3, 1),
(34, 'RECTA', 3, 1),
(35, 'SAN CARLOS', 3, 1),
(36, 'SHIPASBAMBA', 3, 1),
(37, 'VALERA', 3, 1),
(38, 'YAMBRASBAMBA', 3, 1),
(39, 'NIEVA', 4, 1),
(40, 'EL CENEPA', 4, 1),
(41, 'RIO SANTIAGO', 4, 1),
(42, 'LAMUD', 5, 1),
(43, 'CAMPORREDONDO', 5, 1),
(44, 'COCABAMBA', 5, 1),
(45, 'COLCAMAR', 5, 1),
(46, 'CONILA', 5, 1),
(47, 'INGUILPATA', 5, 1),
(48, 'LONGUITA', 5, 1),
(49, 'LONYA CHICO', 5, 1),
(50, 'LUYA', 5, 1),
(51, 'LUYA VIEJO', 5, 1),
(52, 'MARIA', 5, 1),
(53, 'OCALLI', 5, 1),
(54, 'OCUMAL', 5, 1),
(55, 'PISUQUIA', 5, 1),
(56, 'PROVIDENCIA', 5, 1),
(57, 'SAN CRISTOBAL', 5, 1),
(58, 'SAN FRANCISCO DEL YESO', 5, 1),
(59, 'SAN JERONIMO', 5, 1),
(60, 'SAN JUAN DE LOPECANCHA', 5, 1),
(61, 'SANTA CATALINA', 5, 1),
(62, 'SANTO TOMAS', 5, 1),
(63, 'TINGO', 5, 1),
(64, 'TRITA', 5, 1),
(65, 'SAN NICOLAS', 6, 1),
(66, 'CHIRIMOTO', 6, 1),
(67, 'COCHAMAL', 6, 1),
(68, 'HUAMBO', 6, 1),
(69, 'LIMABAMBA', 6, 1),
(70, 'LONGAR', 6, 1),
(71, 'MARISCAL BENAVIDES', 6, 1),
(72, 'MILPUC', 6, 1),
(73, 'OMIA', 6, 1),
(74, 'SANTA ROSA', 6, 1),
(75, 'TOTORA', 6, 1),
(76, 'VISTA ALEGRE', 6, 1),
(77, 'BAGUA GRANDE', 7, 1),
(78, 'CAJARURO', 7, 1),
(79, 'CUMBA', 7, 1),
(80, 'EL MILAGRO', 7, 1),
(81, 'JAMALCA', 7, 1),
(82, 'LONYA GRANDE', 7, 1),
(83, 'YAMON', 7, 1),
(84, 'HUARAZ', 8, 1),
(85, 'COCHABAMBA', 8, 1),
(86, 'COLCABAMBA', 8, 1),
(87, 'HUANCHAY', 8, 1),
(88, 'INDEPENDENCIA', 8, 1),
(89, 'JANGAS', 8, 1),
(90, 'LA LIBERTAD', 8, 1),
(91, 'OLLEROS', 8, 1),
(92, 'PAMPAS', 8, 1),
(93, 'PARIACOTO', 8, 1),
(94, 'PIRA', 8, 1),
(95, 'TARICA', 8, 1),
(96, 'AIJA', 9, 1),
(97, 'CORIS', 9, 1),
(98, 'HUACLLAN', 9, 1),
(99, 'LA MERCED', 9, 1),
(100, 'SUCCHA', 9, 1),
(101, 'LLAMELLIN', 10, 1),
(102, 'ACZO', 10, 1),
(103, 'CHACCHO', 10, 1),
(104, 'CHINGAS', 10, 1),
(105, 'MIRGAS', 10, 1),
(106, 'SAN JUAN DE RONTOY', 10, 1),
(107, 'CHACAS', 11, 1),
(108, 'ACOCHACA', 11, 1),
(109, 'CHIQUIAN', 12, 1),
(110, 'ABELARDO PARDO LEZAMETA', 12, 1),
(111, 'ANTONIO RAYMONDI', 12, 1),
(112, 'AQUIA', 12, 1),
(113, 'CAJACAY', 12, 1),
(114, 'CANIS', 12, 1),
(115, 'COLQUIOC', 12, 1),
(116, 'HUALLANCA', 12, 1),
(117, 'HUASTA', 12, 1),
(118, 'HUAYLLACAYAN', 12, 1),
(119, 'LA PRIMAVERA', 12, 1),
(120, 'MANGAS', 12, 1),
(121, 'PACLLON', 12, 1),
(122, 'SAN MIGUEL DE CORPANQUI', 12, 1),
(123, 'TICLLOS', 12, 1),
(124, 'CARHUAZ', 13, 1),
(125, 'ACOPAMPA', 13, 1),
(126, 'AMASHCA', 13, 1),
(127, 'ANTA', 13, 1),
(128, 'ATAQUERO', 13, 1),
(129, 'MARCARA', 13, 1),
(130, 'PARIAHUANCA', 13, 1),
(131, 'SAN MIGUEL DE ACO', 13, 1),
(132, 'SHILLA', 13, 1),
(133, 'TINCO', 13, 1),
(134, 'YUNGAR', 13, 1),
(135, 'SAN LUIS', 14, 1),
(136, 'SAN NICOLAS', 14, 1),
(137, 'YAUYA', 14, 1),
(138, 'CASMA', 15, 1),
(139, 'BUENA VISTA ALTA', 15, 1),
(140, 'COMANDANTE NOEL', 15, 1),
(141, 'YAUTAN', 15, 1),
(142, 'CORONGO', 16, 1),
(143, 'ACO', 16, 1),
(144, 'BAMBAS', 16, 1),
(145, 'CUSCA', 16, 1),
(146, 'LA PAMPA', 16, 1),
(147, 'YANAC', 16, 1),
(148, 'YUPAN', 16, 1),
(149, 'HUARI', 17, 1),
(150, 'ANRA', 17, 1),
(151, 'CAJAY', 17, 1),
(152, 'CHAVIN DE HUANTAR', 17, 1),
(153, 'HUACACHI', 17, 1),
(154, 'HUACCHIS', 17, 1),
(155, 'HUACHIS', 17, 1),
(156, 'HUANTAR', 17, 1),
(157, 'MASIN', 17, 1),
(158, 'PAUCAS', 17, 1),
(159, 'PONTO', 17, 1),
(160, 'RAHUAPAMPA', 17, 1),
(161, 'RAPAYAN', 17, 1),
(162, 'SAN MARCOS', 17, 1),
(163, 'SAN PEDRO DE CHANA', 17, 1),
(164, 'UCO', 17, 1),
(165, 'HUARMEY', 18, 1),
(166, 'COCHAPETI', 18, 1),
(167, 'CULEBRAS', 18, 1),
(168, 'HUAYAN', 18, 1),
(169, 'MALVAS', 18, 1),
(170, 'CARAZ', 26, 1),
(171, 'HUALLANCA', 26, 1),
(172, 'HUATA', 26, 1),
(173, 'HUAYLAS', 26, 1),
(174, 'MATO', 26, 1),
(175, 'PAMPAROMAS', 26, 1),
(176, 'PUEBLO LIBRE', 26, 1),
(177, 'SANTA CRUZ', 26, 1),
(178, 'SANTO TORIBIO', 26, 1),
(179, 'YURACMARCA', 26, 1),
(180, 'PISCOBAMBA', 27, 1),
(181, 'CASCA', 27, 1),
(182, 'ELEAZAR GUZMAN BARRON', 27, 1),
(183, 'FIDEL OLIVAS ESCUDERO', 27, 1),
(184, 'LLAMA', 27, 1),
(185, 'LLUMPA', 27, 1),
(186, 'LUCMA', 27, 1),
(187, 'MUSGA', 27, 1),
(188, 'OCROS', 21, 1),
(189, 'ACAS', 21, 1),
(190, 'CAJAMARQUILLA', 21, 1),
(191, 'CARHUAPAMPA', 21, 1),
(192, 'COCHAS', 21, 1),
(193, 'CONGAS', 21, 1),
(194, 'LLIPA', 21, 1),
(195, 'SAN CRISTOBAL DE RAJAN', 21, 1),
(196, 'SAN PEDRO', 21, 1),
(197, 'SANTIAGO DE CHILCAS', 21, 1),
(198, 'CABANA', 22, 1),
(199, 'BOLOGNESI', 22, 1),
(200, 'CONCHUCOS', 22, 1),
(201, 'HUACASCHUQUE', 22, 1),
(202, 'HUANDOVAL', 22, 1),
(203, 'LACABAMBA', 22, 1),
(204, 'LLAPO', 22, 1),
(205, 'PALLASCA', 22, 1),
(206, 'PAMPAS', 22, 1),
(207, 'SANTA ROSA', 22, 1),
(208, 'TAUCA', 22, 1),
(209, 'POMABAMBA', 23, 1),
(210, 'HUAYLLAN', 23, 1),
(211, 'PAROBAMBA', 23, 1),
(212, 'QUINUABAMBA', 23, 1),
(213, 'RECUAY', 24, 1),
(214, 'CATAC', 24, 1),
(215, 'COTAPARACO', 24, 1),
(216, 'HUAYLLAPAMPA', 24, 1),
(217, 'LLACLLIN', 24, 1),
(218, 'MARCA', 24, 1),
(219, 'PAMPAS CHICO', 24, 1),
(220, 'PARARIN', 24, 1),
(221, 'TAPACOCHA', 24, 1),
(222, 'TICAPAMPA', 24, 1),
(223, 'CHIMBOTE', 25, 1),
(224, 'CACERES DEL PERU', 25, 1),
(225, 'COISHCO', 25, 1),
(226, 'MACATE', 25, 1),
(227, 'MORO', 25, 1),
(228, 'NEPE&Ntilde;A', 25, 1),
(229, 'SAMANCO', 25, 1),
(230, 'SANTA', 25, 1),
(231, 'NUEVO CHIMBOTE', 25, 1),
(232, 'SIHUAS', 26, 1),
(233, 'ACOBAMBA', 26, 1),
(234, 'ALFONSO UGARTE', 26, 1),
(235, 'CASHAPAMPA', 26, 1),
(236, 'CHINGALPO', 26, 1),
(237, 'HUAYLLABAMBA', 26, 1),
(238, 'QUICHES', 26, 1),
(239, 'RAGASH', 26, 1),
(240, 'SAN JUAN', 26, 1),
(241, 'SICSIBAMBA', 26, 1),
(242, 'YUNGAY', 27, 1),
(243, 'CASCAPARA', 27, 1),
(244, 'MANCOS', 27, 1),
(245, 'MATACOTO', 27, 1),
(246, 'QUILLO', 27, 1),
(247, 'RANRAHIRCA', 27, 1),
(248, 'SHUPLUY', 27, 1),
(249, 'YANAMA', 27, 1),
(250, 'ABANCAY', 28, 1),
(251, 'CHACOCHE', 28, 1),
(252, 'CIRCA', 28, 1),
(253, 'CURAHUASI', 28, 1),
(254, 'HUANIPACA', 28, 1),
(255, 'LAMBRAMA', 28, 1),
(256, 'PICHIRHUA', 28, 1),
(257, 'SAN PEDRO DE CACHORA', 28, 1),
(258, 'TAMBURCO', 28, 1),
(259, 'ANDAHUAYLAS', 29, 1),
(260, 'ANDARAPA', 29, 1),
(261, 'CHIARA', 29, 1),
(262, 'HUANCARAMA', 29, 1),
(263, 'HUANCARAY', 29, 1),
(264, 'HUAYANA', 29, 1),
(265, 'KISHUARA', 29, 1),
(266, 'PACOBAMBA', 29, 1),
(267, 'PACUCHA', 29, 1),
(268, 'PAMPACHIRI', 29, 1),
(269, 'POMACOCHA', 29, 1),
(270, 'SAN ANTONIO DE CACHI', 29, 1),
(271, 'SAN JERONIMO', 29, 1),
(272, 'SAN MIGUEL DE CHACCRAMPA', 29, 1),
(273, 'SANTA MARIA DE CHICMO', 29, 1),
(274, 'TALAVERA', 29, 1),
(275, 'TUMAY HUARACA', 29, 1),
(276, 'TURPO', 29, 1),
(277, 'KAQUIABAMBA', 29, 1),
(278, 'ANTABAMBA', 30, 1),
(279, 'EL ORO', 30, 1),
(280, 'HUAQUIRCA', 30, 1),
(281, 'JUAN ESPINOZA MEDRANO', 30, 1),
(282, 'OROPESA', 30, 1),
(283, 'PACHACONAS', 30, 1),
(284, 'SABAINO', 30, 1),
(285, 'CHALHUANCA', 31, 1),
(286, 'CAPAYA', 31, 1),
(287, 'CARAYBAMBA', 31, 1),
(288, 'CHAPIMARCA', 31, 1),
(289, 'COLCABAMBA', 31, 1),
(290, 'COTARUSE', 31, 1),
(291, 'HUAYLLO', 31, 1),
(292, 'JUSTO APU SAHUARAURA', 31, 1),
(293, 'LUCRE', 31, 1),
(294, 'POCOHUANCA', 31, 1),
(295, 'SAN JUAN DE CHAC&Ntilde;A', 31, 1),
(296, 'SA&Ntilde;AYCA', 31, 1),
(297, 'SORAYA', 31, 1),
(298, 'TAPAIRIHUA', 31, 1),
(299, 'TINTAY', 31, 1),
(300, 'TORAYA', 31, 1),
(301, 'YANACA', 31, 1),
(302, 'TAMBOBAMBA', 32, 1),
(303, 'COTABAMBAS', 32, 1),
(304, 'COYLLURQUI', 32, 1),
(305, 'HAQUIRA', 32, 1),
(306, 'MARA', 32, 1),
(307, 'CHALLHUAHUACHO', 32, 1),
(308, 'CHINCHEROS', 33, 1),
(309, 'ANCO-HUALLO', 33, 1),
(310, 'COCHARCAS', 33, 1),
(311, 'HUACCANA', 33, 1),
(312, 'OCOBAMBA', 33, 1),
(313, 'ONGOY', 33, 1),
(314, 'URANMARCA', 33, 1),
(315, 'RANRACANCHA', 33, 1),
(316, 'CHUQUIBAMBILLA', 34, 1),
(317, 'CURPAHUASI', 34, 1),
(318, 'GAMARRA', 34, 1),
(319, 'HUAYLLATI', 34, 1),
(320, 'MAMARA', 34, 1),
(321, 'MICAELA BASTIDAS', 34, 1),
(322, 'PATAYPAMPA', 34, 1),
(323, 'PROGRESO', 34, 1),
(324, 'SAN ANTONIO', 34, 1),
(325, 'SANTA ROSA', 34, 1),
(326, 'TURPAY', 34, 1),
(327, 'VILCABAMBA', 34, 1),
(328, 'VIRUNDO', 34, 1),
(329, 'CURASCO', 34, 1),
(330, 'AREQUIPA', 35, 1),
(331, 'ALTO SELVA ALEGRE', 35, 1),
(332, 'CAYMA', 35, 1),
(333, 'CERRO COLORADO', 35, 1),
(334, 'CHARACATO', 35, 1),
(335, 'CHIGUATA', 35, 1),
(336, 'JACOBO HUNTER', 35, 1),
(337, 'LA JOYA', 35, 1),
(338, 'MARIANO MELGAR', 35, 1),
(339, 'MIRAFLORES', 35, 1),
(340, 'MOLLEBAYA', 35, 1),
(341, 'PAUCARPATA', 35, 1),
(342, 'POCSI', 35, 1),
(343, 'POLOBAYA', 35, 1),
(344, 'QUEQUE&Ntilde;A', 35, 1),
(345, 'SABANDIA', 35, 1),
(346, 'SACHACA', 35, 1),
(347, 'SAN JUAN DE SIGUAS', 35, 1),
(348, 'SAN JUAN DE TARUCANI', 35, 1),
(349, 'SANTA ISABEL DE SIGUAS', 35, 1),
(350, 'SANTA RITA DE SIGUAS', 35, 1),
(351, 'SOCABAYA', 35, 1),
(352, 'TIABAYA', 35, 1),
(353, 'UCHUMAYO', 35, 1),
(354, 'VITOR', 35, 1),
(355, 'YANAHUARA', 35, 1),
(356, 'YARABAMBA', 35, 1),
(357, 'YURA', 35, 1),
(358, 'JOSE LUIS BUSTAMANTE Y RIVERO', 35, 1),
(359, 'CAMANA', 36, 1),
(360, 'JOSE MARIA QUIMPER', 36, 1),
(361, 'MARIANO NICOLAS VALCARCEL', 36, 1),
(362, 'MARISCAL CACERES', 36, 1),
(363, 'NICOLAS DE PIEROLA', 36, 1),
(364, 'OCO&Ntilde;A', 36, 1),
(365, 'QUILCA', 36, 1),
(366, 'SAMUEL PASTOR', 36, 1),
(367, 'CARAVELI', 37, 1),
(368, 'ACARI', 37, 1),
(369, 'ATICO', 37, 1),
(370, 'ATIQUIPA', 37, 1),
(371, 'BELLA UNION', 37, 1),
(372, 'CAHUACHO', 37, 1),
(373, 'CHALA', 37, 1),
(374, 'CHAPARRA', 37, 1),
(375, 'HUANUHUANU', 37, 1),
(376, 'JAQUI', 37, 1),
(377, 'LOMAS', 37, 1),
(378, 'QUICACHA', 37, 1),
(379, 'YAUCA', 37, 1),
(380, 'APLAO', 38, 1),
(381, 'ANDAGUA', 38, 1),
(382, 'AYO', 38, 1),
(383, 'CHACHAS', 38, 1),
(384, 'CHILCAYMARCA', 38, 1),
(385, 'CHOCO', 38, 1),
(386, 'HUANCARQUI', 38, 1),
(387, 'MACHAGUAY', 38, 1),
(388, 'ORCOPAMPA', 38, 1),
(389, 'PAMPACOLCA', 38, 1),
(390, 'TIPAN', 38, 1),
(391, 'U&Ntilde;ON', 38, 1),
(392, 'URACA', 38, 1),
(393, 'VIRACO', 38, 1),
(394, 'CHIVAY', 39, 1),
(395, 'ACHOMA', 39, 1),
(396, 'CABANACONDE', 39, 1),
(397, 'CALLALLI', 39, 1),
(398, 'CAYLLOMA', 39, 1),
(399, 'COPORAQUE', 39, 1),
(400, 'HUAMBO', 39, 1),
(401, 'HUANCA', 39, 1),
(402, 'ICHUPAMPA', 39, 1),
(403, 'LARI', 39, 1),
(404, 'LLUTA', 39, 1),
(405, 'MACA', 39, 1),
(406, 'MADRIGAL', 39, 1),
(407, 'SAN ANTONIO DE CHUCA', 39, 1),
(408, 'SIBAYO', 39, 1),
(409, 'TAPAY', 39, 1),
(410, 'TISCO', 39, 1),
(411, 'TUTI', 39, 1),
(412, 'YANQUE', 39, 1),
(413, 'MAJES', 39, 1),
(414, 'CHUQUIBAMBA', 40, 1),
(415, 'ANDARAY', 40, 1),
(416, 'CAYARANI', 40, 1),
(417, 'CHICHAS', 40, 1),
(418, 'IRAY', 40, 1),
(419, 'RIO GRANDE', 40, 1),
(420, 'SALAMANCA', 40, 1),
(421, 'YANAQUIHUA', 40, 1),
(422, 'MOLLENDO', 41, 1),
(423, 'COCACHACRA', 41, 1),
(424, 'DEAN VALDIVIA', 41, 1),
(425, 'ISLAY', 41, 1),
(426, 'MEJIA', 41, 1),
(427, 'PUNTA DE BOMBON', 41, 1),
(428, 'COTAHUASI', 42, 1),
(429, 'ALCA', 42, 1),
(430, 'CHARCANA', 42, 1),
(431, 'HUAYNACOTAS', 42, 1),
(432, 'PAMPAMARCA', 42, 1),
(433, 'PUYCA', 42, 1),
(434, 'QUECHUALLA', 42, 1),
(435, 'SAYLA', 42, 1),
(436, 'TAURIA', 42, 1),
(437, 'TOMEPAMPA', 42, 1),
(438, 'TORO', 42, 1),
(439, 'AYACUCHO', 43, 1),
(440, 'ACOCRO', 43, 1),
(441, 'ACOS VINCHOS', 43, 1),
(442, 'CARMEN ALTO', 43, 1),
(443, 'CHIARA', 43, 1),
(444, 'OCROS', 43, 1),
(445, 'PACAYCASA', 43, 1),
(446, 'QUINUA', 43, 1),
(447, 'SAN JOSE DE TICLLAS', 43, 1),
(448, 'SAN JUAN BAUTISTA', 43, 1),
(449, 'SANTIAGO DE PISCHA', 43, 1),
(450, 'SOCOS', 43, 1),
(451, 'TAMBILLO', 43, 1),
(452, 'VINCHOS', 43, 1),
(453, 'JESUS NAZARENO', 43, 1),
(454, 'CANGALLO', 44, 1),
(455, 'CHUSCHI', 44, 1),
(456, 'LOS MOROCHUCOS', 44, 1),
(457, 'MARIA PARADO DE BELLIDO', 44, 1),
(458, 'PARAS', 44, 1),
(459, 'TOTOS', 44, 1),
(460, 'SANCOS', 45, 1),
(461, 'CARAPO', 45, 1),
(462, 'SACSAMARCA', 45, 1),
(463, 'SANTIAGO DE LUCANAMARCA', 45, 1),
(464, 'HUANTA', 46, 1),
(465, 'AYAHUANCO', 46, 1),
(466, 'HUAMANGUILLA', 46, 1),
(467, 'IGUAIN', 46, 1),
(468, 'LURICOCHA', 46, 1),
(469, 'SANTILLANA', 46, 1),
(470, 'SIVIA', 46, 1),
(471, 'LLOCHEGUA', 46, 1),
(472, 'SAN MIGUEL', 47, 1),
(473, 'ANCO', 47, 1),
(474, 'AYNA', 47, 1),
(475, 'CHILCAS', 47, 1),
(476, 'CHUNGUI', 47, 1),
(477, 'LUIS CARRANZA', 47, 1),
(478, 'SANTA ROSA', 47, 1),
(479, 'TAMBO', 47, 1),
(480, 'PUQUIO', 48, 1),
(481, 'AUCARA', 48, 1),
(482, 'CABANA', 48, 1),
(483, 'CARMEN SALCEDO', 48, 1),
(484, 'CHAVI&Ntilde;A', 48, 1),
(485, 'CHIPAO', 48, 1),
(486, 'HUAC-HUAS', 48, 1),
(487, 'LARAMATE', 48, 1),
(488, 'LEONCIO PRADO', 48, 1),
(489, 'LLAUTA', 48, 1),
(490, 'LUCANAS', 48, 1),
(491, 'OCA&Ntilde;A', 48, 1),
(492, 'OTOCA', 48, 1),
(493, 'SAISA', 48, 1),
(494, 'SAN CRISTOBAL', 48, 1),
(495, 'SAN JUAN', 48, 1),
(496, 'SAN PEDRO', 48, 1),
(497, 'SAN PEDRO DE PALCO', 48, 1),
(498, 'SANCOS', 48, 1),
(499, 'SANTA ANA DE HUAYCAHUACHO', 48, 1),
(500, 'SANTA LUCIA', 48, 1),
(501, 'CORACORA', 49, 1),
(502, 'CHUMPI', 49, 1),
(503, 'CORONEL CASTA&Ntilde;EDA', 49, 1),
(504, 'PACAPAUSA', 49, 1),
(505, 'PULLO', 49, 1),
(506, 'PUYUSCA', 49, 1),
(507, 'SAN FRANCISCO DE RAVACAYCO', 49, 1),
(508, 'UPAHUACHO', 49, 1),
(509, 'PAUSA', 50, 1),
(510, 'COLTA', 50, 1),
(511, 'CORCULLA', 50, 1),
(512, 'LAMPA', 50, 1),
(513, 'MARCABAMBA', 50, 1),
(514, 'OYOLO', 50, 1),
(515, 'PARARCA', 50, 1),
(516, 'SAN JAVIER DE ALPABAMBA', 50, 1),
(517, 'SAN JOSE DE USHUA', 50, 1),
(518, 'SARA SARA', 50, 1),
(519, 'QUEROBAMBA', 51, 1),
(520, 'BELEN', 51, 1),
(521, 'CHALCOS', 51, 1),
(522, 'CHILCAYOC', 51, 1),
(523, 'HUACA&Ntilde;A', 51, 1),
(524, 'MORCOLLA', 51, 1),
(525, 'PAICO', 51, 1),
(526, 'SAN PEDRO DE LARCAY', 51, 1),
(527, 'SAN SALVADOR DE QUIJE', 51, 1),
(528, 'SANTIAGO DE PAUCARAY', 51, 1),
(529, 'SORAS', 51, 1),
(530, 'HUANCAPI', 52, 1),
(531, 'ALCAMENCA', 52, 1),
(532, 'APONGO', 52, 1),
(533, 'ASQUIPATA', 52, 1),
(534, 'CANARIA', 52, 1),
(535, 'CAYARA', 52, 1),
(536, 'COLCA', 52, 1),
(537, 'HUAMANQUIQUIA', 52, 1),
(538, 'HUANCARAYLLA', 52, 1),
(539, 'HUAYA', 52, 1),
(540, 'SARHUA', 52, 1),
(541, 'VILCANCHOS', 52, 1),
(542, 'VILCAS HUAMAN', 53, 1),
(543, 'ACCOMARCA', 53, 1),
(544, 'CARHUANCA', 53, 1),
(545, 'CONCEPCION', 53, 1),
(546, 'HUAMBALPA', 53, 1),
(547, 'INDEPENDENCIA', 53, 1),
(548, 'SAURAMA', 53, 1),
(549, 'VISCHONGO', 53, 1),
(550, 'CAJAMARCA', 54, 1),
(551, 'CAJAMARCA', 54, 1),
(552, 'ASUNCION', 54, 1),
(553, 'CHETILLA', 54, 1),
(554, 'COSPAN', 54, 1),
(555, 'ENCA&Ntilde;ADA', 54, 1),
(556, 'JESUS', 54, 1),
(557, 'LLACANORA', 54, 1),
(558, 'LOS BA&Ntilde;OS DEL INCA', 54, 1),
(559, 'MAGDALENA', 54, 1),
(560, 'MATARA', 54, 1),
(561, 'NAMORA', 54, 1),
(562, 'SAN JUAN', 54, 1),
(563, 'CAJABAMBA', 55, 1),
(564, 'CACHACHI', 55, 1),
(565, 'CONDEBAMBA', 55, 1),
(566, 'SITACOCHA', 55, 1),
(567, 'CELENDIN', 56, 1),
(568, 'CHUMUCH', 56, 1),
(569, 'CORTEGANA', 56, 1),
(570, 'HUASMIN', 56, 1),
(571, 'JORGE CHAVEZ', 56, 1),
(572, 'JOSE GALVEZ', 56, 1),
(573, 'MIGUEL IGLESIAS', 56, 1),
(574, 'OXAMARCA', 56, 1),
(575, 'SOROCHUCO', 56, 1),
(576, 'SUCRE', 56, 1),
(577, 'UTCO', 56, 1),
(578, 'LA LIBERTAD DE PALLAN', 56, 1),
(579, 'CHOTA', 57, 1),
(580, 'ANGUIA', 57, 1),
(581, 'CHADIN', 57, 1),
(582, 'CHIGUIRIP', 57, 1),
(583, 'CHIMBAN', 57, 1),
(584, 'CHOROPAMPA', 57, 1),
(585, 'COCHABAMBA', 57, 1),
(586, 'CONCHAN', 57, 1),
(587, 'HUAMBOS', 57, 1),
(588, 'LAJAS', 57, 1),
(589, 'LLAMA', 57, 1),
(590, 'MIRACOSTA', 57, 1),
(591, 'PACCHA', 57, 1),
(592, 'PION', 57, 1),
(593, 'QUEROCOTO', 57, 1),
(594, 'SAN JUAN DE LICUPIS', 57, 1),
(595, 'TACABAMBA', 57, 1),
(596, 'TOCMOCHE', 57, 1),
(597, 'CHALAMARCA', 57, 1),
(598, 'CONTUMAZA', 58, 1),
(599, 'CHILETE', 58, 1),
(600, 'CUPISNIQUE', 58, 1),
(601, 'GUZMANGO', 58, 1),
(602, 'SAN BENITO', 58, 1),
(603, 'SANTA CRUZ DE TOLED', 58, 1),
(604, 'TANTARICA', 58, 1),
(605, 'YONAN', 58, 1),
(606, 'CUTERVO', 59, 1),
(607, 'CALLAYUC', 59, 1),
(608, 'CHOROS', 59, 1),
(609, 'CUJILLO', 59, 1),
(610, 'LA RAMADA', 59, 1),
(611, 'PIMPINGOS', 59, 1),
(612, 'QUEROCOTILLO', 59, 1),
(613, 'SAN ANDRES DE CUTERVO', 59, 1),
(614, 'SAN JUAN DE CUTERVO', 59, 1),
(615, 'SAN LUIS DE LUCMA', 59, 1),
(616, 'SANTA CRUZ', 59, 1),
(617, 'SANTO DOMINGO DE LA CAPILLA', 59, 1),
(618, 'SANTO TOMAS', 59, 1),
(619, 'SOCOTA', 59, 1),
(620, 'TORIBIO CASANOVA', 59, 1),
(621, 'BAMBAMARCA', 60, 1),
(622, 'CHUGUR', 60, 1),
(623, 'HUALGAYOC', 60, 1),
(624, 'JAEN', 61, 1),
(625, 'BELLAVISTA', 61, 1),
(626, 'CHONTALI', 61, 1),
(627, 'COLASAY', 61, 1),
(628, 'HUABAL', 61, 1),
(629, 'LAS PIRIAS', 61, 1),
(630, 'POMAHUACA', 61, 1),
(631, 'PUCARA', 61, 1),
(632, 'SALLIQUE', 61, 1),
(633, 'SAN FELIPE', 61, 1),
(634, 'SAN JOSE DEL ALTO', 61, 1),
(635, 'SANTA ROSA', 61, 1),
(636, 'SAN IGNACIO', 62, 1),
(637, 'CHIRINOS', 62, 1),
(638, 'HUARANGO', 62, 1),
(639, 'LA COIPA', 62, 1),
(640, 'NAMBALLE', 62, 1),
(641, 'SAN JOSE DE LOURDES', 62, 1),
(642, 'TABACONAS', 62, 1),
(643, 'PEDRO GALVEZ', 63, 1),
(644, 'CHANCAY', 63, 1),
(645, 'EDUARDO VILLANUEVA', 63, 1),
(646, 'GREGORIO PITA', 63, 1),
(647, 'ICHOCAN', 63, 1),
(648, 'JOSE MANUEL QUIROZ', 63, 1),
(649, 'JOSE SABOGAL', 63, 1),
(650, 'SAN MIGUEL', 64, 1),
(651, 'SAN MIGUEL', 64, 1),
(652, 'BOLIVAR', 64, 1),
(653, 'CALQUIS', 64, 1),
(654, 'CATILLUC', 64, 1),
(655, 'EL PRADO', 64, 1),
(656, 'LA FLORIDA', 64, 1),
(657, 'LLAPA', 64, 1),
(658, 'NANCHOC', 64, 1),
(659, 'NIEPOS', 64, 1),
(660, 'SAN GREGORIO', 64, 1),
(661, 'SAN SILVESTRE DE COCHAN', 64, 1),
(662, 'TONGOD', 64, 1),
(663, 'UNION AGUA BLANCA', 64, 1),
(664, 'SAN PABLO', 65, 1),
(665, 'SAN BERNARDINO', 65, 1),
(666, 'SAN LUIS', 65, 1),
(667, 'TUMBADEN', 65, 1),
(668, 'SANTA CRUZ', 66, 1),
(669, 'ANDABAMBA', 66, 1),
(670, 'CATACHE', 66, 1),
(671, 'CHANCAYBA&Ntilde;OS', 66, 1),
(672, 'LA ESPERANZA', 66, 1),
(673, 'NINABAMBA', 66, 1),
(674, 'PULAN', 66, 1),
(675, 'SAUCEPAMPA', 66, 1),
(676, 'SEXI', 66, 1),
(677, 'UTICYACU', 66, 1),
(678, 'YAUYUCAN', 66, 1),
(679, 'CALLAO', 67, 1),
(680, 'BELLAVISTA', 67, 1),
(681, 'CARMEN DE LA LEGUA REYNOSO', 67, 1),
(682, 'LA PERLA', 67, 1),
(683, 'LA PUNTA', 67, 1),
(684, 'VENTANILLA', 67, 1),
(685, 'CUSCO', 67, 1),
(686, 'CCORCA', 67, 1),
(687, 'POROY', 67, 1),
(688, 'SAN JERONIMO', 67, 1),
(689, 'SAN SEBASTIAN', 67, 1),
(690, 'SANTIAGO', 67, 1),
(691, 'SAYLLA', 67, 1),
(692, 'WANCHAQ', 67, 1),
(693, 'ACOMAYO', 68, 1),
(694, 'ACOPIA', 68, 1),
(695, 'ACOS', 68, 1),
(696, 'MOSOC LLACTA', 68, 1),
(697, 'POMACANCHI', 68, 1),
(698, 'RONDOCAN', 68, 1),
(699, 'SANGARARA', 68, 1),
(700, 'ANTA', 69, 1),
(701, 'ANCAHUASI', 69, 1),
(702, 'CACHIMAYO', 69, 1),
(703, 'CHINCHAYPUJIO', 69, 1),
(704, 'HUAROCONDO', 69, 1),
(705, 'LIMATAMBO', 69, 1),
(706, 'MOLLEPATA', 69, 1),
(707, 'PUCYURA', 69, 1),
(708, 'ZURITE', 69, 1),
(709, 'CALCA', 70, 1),
(710, 'COYA', 70, 1),
(711, 'LAMAY', 70, 1),
(712, 'LARES', 70, 1),
(713, 'PISAC', 70, 1),
(714, 'SAN SALVADOR', 70, 1),
(715, 'TARAY', 70, 1),
(716, 'YANATILE', 70, 1),
(717, 'YANAOCA', 71, 1),
(718, 'CHECCA', 71, 1),
(719, 'KUNTURKANKI', 71, 1),
(720, 'LANGUI', 71, 1),
(721, 'LAYO', 71, 1),
(722, 'PAMPAMARCA', 71, 1),
(723, 'QUEHUE', 71, 1),
(724, 'TUPAC AMARU', 71, 1),
(725, 'SICUANI', 72, 1),
(726, 'CHECACUPE', 72, 1),
(727, 'COMBAPATA', 72, 1),
(728, 'MARANGANI', 72, 1),
(729, 'PITUMARCA', 72, 1),
(730, 'SAN PABLO', 72, 1),
(731, 'SAN PEDRO', 72, 1),
(732, 'TINTA', 72, 1),
(733, 'SANTO TOMAS', 73, 1),
(734, 'CAPACMARCA', 73, 1),
(735, 'CHAMACA', 73, 1),
(736, 'COLQUEMARCA', 73, 1),
(737, 'LIVITACA', 73, 1),
(738, 'LLUSCO', 73, 1),
(739, 'QUI&Ntilde;OTA', 73, 1),
(740, 'VELILLE', 73, 1),
(741, 'ESPINAR', 74, 1),
(742, 'CONDOROMA', 74, 1),
(743, 'COPORAQUE', 74, 1),
(744, 'OCORURO', 74, 1),
(745, 'PALLPATA', 74, 1),
(746, 'PICHIGUA', 74, 1),
(747, 'SUYCKUTAMBO', 74, 1),
(748, 'ALTO PICHIGUA', 74, 1),
(749, 'SANTA ANA', 75, 1),
(750, 'ECHARATE', 75, 1),
(751, 'HUAYOPATA', 75, 1),
(752, 'MARANURA', 75, 1),
(753, 'OCOBAMBA', 75, 1),
(754, 'QUELLOUNO', 75, 1),
(755, 'KIMBIRI', 75, 1),
(756, 'SANTA TERESA', 75, 1),
(757, 'VILCABAMBA', 75, 1),
(758, 'PICHARI', 75, 1),
(759, 'PARURO', 76, 1),
(760, 'ACCHA', 76, 1),
(761, 'CCAPI', 76, 1),
(762, 'COLCHA', 76, 1),
(763, 'HUANOQUITE', 76, 1),
(764, 'OMACHA', 76, 1),
(765, 'PACCARITAMBO', 76, 1),
(766, 'PILLPINTO', 76, 1),
(767, 'YAURISQUE', 76, 1),
(768, 'PAUCARTAMBO', 77, 1),
(769, 'CAICAY', 77, 1),
(770, 'CHALLABAMBA', 77, 1),
(771, 'COLQUEPATA', 77, 1),
(772, 'HUANCARANI', 77, 1),
(773, 'KOS&Ntilde;IPATA', 77, 1),
(774, 'URCOS', 78, 1),
(775, 'ANDAHUAYLILLAS', 78, 1),
(776, 'CAMANTI', 78, 1),
(777, 'CCARHUAYO', 78, 1),
(778, 'CCATCA', 78, 1),
(779, 'CUSIPATA', 78, 1),
(780, 'HUARO', 78, 1),
(781, 'LUCRE', 78, 1),
(782, 'MARCAPATA', 78, 1),
(783, 'OCONGATE', 78, 1),
(784, 'OROPESA', 78, 1),
(785, 'QUIQUIJANA', 78, 1),
(786, 'URUBAMBA', 79, 1),
(787, 'CHINCHERO', 79, 1),
(788, 'HUAYLLABAMBA', 79, 1),
(789, 'MACHUPICCHU', 79, 1),
(790, 'MARAS', 79, 1),
(791, 'OLLANTAYTAMBO', 79, 1),
(792, 'YUCAY', 79, 1),
(793, 'HUANCAVELICA', 80, 1),
(794, 'ACOBAMBILLA', 80, 1),
(795, 'ACORIA', 80, 1),
(796, 'CONAYCA', 80, 1),
(797, 'CUENCA', 80, 1),
(798, 'HUACHOCOLPA', 80, 1),
(799, 'HUAYLLAHUARA', 80, 1),
(800, 'IZCUCHACA', 80, 1),
(801, 'LARIA', 80, 1),
(802, 'MANTA', 80, 1),
(803, 'MARISCAL CACERES', 80, 1),
(804, 'MOYA', 80, 1),
(805, 'NUEVO OCCORO', 80, 1),
(806, 'PALCA', 80, 1),
(807, 'PILCHACA', 80, 1),
(808, 'VILCA', 80, 1),
(809, 'YAULI', 80, 1),
(810, 'ASCENSION', 80, 1),
(811, 'HUANDO', 80, 1),
(812, 'ACOBAMBA', 81, 1),
(813, 'ANDABAMBA', 81, 1),
(814, 'ANTA', 81, 1),
(815, 'CAJA', 81, 1),
(816, 'MARCAS', 81, 1),
(817, 'PAUCARA', 81, 1),
(818, 'POMACOCHA', 81, 1),
(819, 'ROSARIO', 81, 1),
(820, 'LIRCAY', 82, 1),
(821, 'ANCHONGA', 82, 1),
(822, 'CALLANMARCA', 82, 1),
(823, 'CCOCHACCASA', 82, 1),
(824, 'CHINCHO', 82, 1),
(825, 'CONGALLA', 82, 1),
(826, 'HUANCA-HUANCA', 82, 1),
(827, 'HUAYLLAY GRANDE', 82, 1),
(828, 'JULCAMARCA', 82, 1),
(829, 'SAN ANTONIO DE ANTAPARCO', 82, 1),
(830, 'SANTO TOMAS DE PATA', 82, 1),
(831, 'SECCLLA', 82, 1),
(832, 'CASTROVIRREYNA', 83, 1),
(833, 'ARMA', 83, 1),
(834, 'AURAHUA', 83, 1),
(835, 'CAPILLAS', 83, 1),
(836, 'CHUPAMARCA', 83, 1),
(837, 'COCAS', 83, 1),
(838, 'HUACHOS', 83, 1),
(839, 'HUAMATAMBO', 83, 1),
(840, 'MOLLEPAMPA', 83, 1),
(841, 'SAN JUAN', 83, 1),
(842, 'SANTA ANA', 83, 1),
(843, 'TANTARA', 83, 1),
(844, 'TICRAPO', 83, 1),
(845, 'CHURCAMPA', 84, 1),
(846, 'ANCO', 84, 1),
(847, 'CHINCHIHUASI', 84, 1),
(848, 'EL CARMEN', 84, 1),
(849, 'LA MERCED', 84, 1),
(850, 'LOCROJA', 84, 1),
(851, 'PAUCARBAMBA', 84, 1),
(852, 'SAN MIGUEL DE MAYOCC', 84, 1),
(853, 'SAN PEDRO DE CORIS', 84, 1),
(854, 'PACHAMARCA', 84, 1),
(855, 'HUAYTARA', 85, 1),
(856, 'AYAVI', 85, 1),
(857, 'CORDOVA', 85, 1),
(858, 'HUAYACUNDO ARMA', 85, 1),
(859, 'LARAMARCA', 85, 1),
(860, 'OCOYO', 85, 1),
(861, 'PILPICHACA', 85, 1),
(862, 'QUERCO', 85, 1),
(863, 'QUITO-ARMA', 85, 1),
(864, 'SAN ANTONIO DE CUSICANCHA', 85, 1),
(865, 'SAN FRANCISCO DE SANGAYAICO', 85, 1),
(866, 'SAN ISIDRO', 85, 1),
(867, 'SANTIAGO DE CHOCORVOS', 85, 1),
(868, 'SANTIAGO DE QUIRAHUARA', 85, 1),
(869, 'SANTO DOMINGO DE CAPILLAS', 85, 1),
(870, 'TAMBO', 85, 1),
(871, 'PAMPAS', 86, 1),
(872, 'ACOSTAMBO', 86, 1),
(873, 'ACRAQUIA', 86, 1),
(874, 'AHUAYCHA', 86, 1),
(875, 'COLCABAMBA', 86, 1),
(876, 'DANIEL HERNANDEZ', 86, 1),
(877, 'HUACHOCOLPA', 86, 1),
(878, 'HUARIBAMBA', 86, 1),
(879, '&Ntilde;AHUIMPUQUIO', 86, 1),
(880, 'PAZOS', 86, 1),
(881, 'QUISHUAR', 86, 1),
(882, 'SALCABAMBA', 86, 1),
(883, 'SALCAHUASI', 86, 1),
(884, 'SAN MARCOS DE ROCCHAC', 86, 1),
(885, 'SURCUBAMBA', 86, 1),
(886, 'TINTAY PUNCU', 86, 1),
(887, 'HUANUCO', 87, 1),
(888, 'AMARILIS', 87, 1),
(889, 'CHINCHAO', 87, 1),
(890, 'CHURUBAMBA', 87, 1),
(891, 'MARGOS', 87, 1),
(892, 'QUISQUI', 87, 1),
(893, 'SAN FRANCISCO DE CAYRAN', 87, 1),
(894, 'SAN PEDRO DE CHAULAN', 87, 1),
(895, 'SANTA MARIA DEL VALLE', 87, 1),
(896, 'YARUMAYO', 87, 1),
(897, 'PILLCO MARCA', 87, 1),
(898, 'AMBO', 88, 1),
(899, 'CAYNA', 88, 1),
(900, 'COLPAS', 88, 1),
(901, 'CONCHAMARCA', 88, 1),
(902, 'HUACAR', 88, 1),
(903, 'SAN FRANCISCO', 88, 1),
(904, 'SAN RAFAEL', 88, 1),
(905, 'TOMAY KICHWA', 88, 1),
(906, 'LA UNION', 89, 1),
(907, 'CHUQUIS', 89, 1),
(908, 'MARIAS', 89, 1),
(909, 'PACHAS', 89, 1),
(910, 'QUIVILLA', 89, 1),
(911, 'RIPAN', 89, 1),
(912, 'SHUNQUI', 89, 1),
(913, 'SILLAPATA', 89, 1),
(914, 'YANAS', 89, 1),
(915, 'HUACAYBAMBA', 90, 1),
(916, 'CANCHABAMBA', 90, 1),
(917, 'COCHABAMBA', 90, 1),
(918, 'PINRA', 90, 1),
(919, 'LLATA', 91, 1),
(920, 'ARANCAY', 91, 1),
(921, 'CHAVIN DE PARIARCA', 91, 1),
(922, 'JACAS GRANDE', 91, 1),
(923, 'JIRCAN', 91, 1),
(924, 'MIRAFLORES', 91, 1),
(925, 'MONZON', 91, 1),
(926, 'PUNCHAO', 91, 1),
(927, 'PU&Ntilde;OS', 91, 1),
(928, 'SINGA', 91, 1),
(929, 'TANTAMAYO', 91, 1),
(930, 'RUPA-RUPA', 92, 1),
(931, 'DANIEL ALOMIA ROBLES', 92, 1),
(932, 'HERMILIO VALDIZAN', 92, 1),
(933, 'JOSE CRESPO Y CASTILLO', 92, 1),
(934, 'LUYANDO', 92, 1),
(935, 'MARIANO DAMASO BERAUN', 92, 1),
(936, 'HUACRACHUCO', 93, 1),
(937, 'CHOLON', 93, 1),
(938, 'SAN BUENAVENTURA', 93, 1),
(939, 'PANAO', 94, 1),
(940, 'CHAGLLA', 94, 1),
(941, 'MOLINO', 94, 1),
(942, 'UMARI', 94, 1),
(943, 'PUERTO INCA', 95, 1),
(944, 'CODO DEL POZUZO', 95, 1),
(945, 'HONORIA', 95, 1),
(946, 'TOURNAVISTA', 95, 1),
(947, 'YUYAPICHIS', 95, 1),
(948, 'JESUS', 96, 1),
(949, 'BA&Ntilde;OS', 96, 1),
(950, 'JIVIA', 96, 1),
(951, 'QUEROPALCA', 96, 1),
(952, 'RONDOS', 96, 1),
(953, 'SAN FRANCISCO DE ASIS', 96, 1),
(954, 'SAN MIGUEL DE CAURI', 96, 1),
(955, 'CHAVINILLO', 97, 1),
(956, 'CAHUAC', 97, 1),
(957, 'CHACABAMBA', 97, 1),
(958, 'APARICIO POMARES', 97, 1),
(959, 'JACAS CHICO', 97, 1),
(960, 'OBAS', 97, 1),
(961, 'PAMPAMARCA', 97, 1),
(962, 'CHORAS', 97, 1),
(963, 'ICA', 98, 1),
(964, 'LA TINGUI&Ntilde;A', 98, 1),
(965, 'LOS AQUIJES', 98, 1),
(966, 'OCUCAJE', 98, 1),
(967, 'PACHACUTEC', 98, 1),
(968, 'PARCONA', 98, 1),
(969, 'PUEBLO NUEVO', 98, 1),
(970, 'SALAS', 98, 1),
(971, 'SAN JOSE DE LOS MOLINOS', 98, 1),
(972, 'SAN JUAN BAUTISTA', 98, 1),
(973, 'SANTIAGO', 98, 1),
(974, 'SUBTANJALLA', 98, 1),
(975, 'TATE', 98, 1),
(976, 'YAUCA DEL ROSARIO', 98, 1),
(977, 'CHINCHA ALTA', 99, 1),
(978, 'ALTO LARAN', 99, 1),
(979, 'CHAVIN', 99, 1),
(980, 'CHINCHA BAJA', 99, 1),
(981, 'EL CARMEN', 99, 1),
(982, 'GROCIO PRADO', 99, 1),
(983, 'PUEBLO NUEVO', 99, 1),
(984, 'SAN JUAN DE YANAC', 99, 1),
(985, 'SAN PEDRO DE HUACARPANA', 99, 1),
(986, 'SUNAMPE', 99, 1),
(987, 'TAMBO DE MORA', 99, 1),
(988, 'NAZCA', 100, 1),
(989, 'CHANGUILLO', 100, 1),
(990, 'EL INGENIO', 100, 1),
(991, 'MARCONA', 100, 1),
(992, 'VISTA ALEGRE', 100, 1),
(993, 'PALPA', 101, 1),
(994, 'LLIPATA', 101, 1),
(995, 'RIO GRANDE', 101, 1),
(996, 'SANTA CRUZ', 101, 1),
(997, 'TIBILLO', 101, 1),
(998, 'PISCO', 102, 1),
(999, 'HUANCANO', 102, 1),
(1000, 'HUMAY', 102, 1),
(1001, 'INDEPENDENCIA', 102, 1),
(1002, 'PARACAS', 102, 1),
(1003, 'SAN ANDRES', 102, 1),
(1004, 'SAN CLEMENTE', 102, 1),
(1005, 'TUPAC AMARU INCA', 102, 1),
(1006, 'HUANCAYO', 103, 1),
(1007, 'CARHUACALLANGA', 103, 1),
(1008, 'CHACAPAMPA', 103, 1),
(1009, 'CHICCHE', 103, 1),
(1010, 'CHILCA', 103, 1),
(1011, 'CHONGOS ALTO', 103, 1),
(1012, 'CHUPURO', 103, 1),
(1013, 'COLCA', 103, 1),
(1014, 'CULLHUAS', 103, 1),
(1015, 'EL TAMBO', 103, 1),
(1016, 'HUACRAPUQUIO', 103, 1),
(1017, 'HUALHUAS', 103, 1),
(1018, 'HUANCAN', 103, 1),
(1019, 'HUASICANCHA', 103, 1),
(1020, 'HUAYUCACHI', 103, 1),
(1021, 'INGENIO', 103, 1),
(1022, 'PARIAHUANCA', 103, 1),
(1023, 'PILCOMAYO', 103, 1),
(1024, 'PUCARA', 103, 1),
(1025, 'QUICHUAY', 103, 1),
(1026, 'QUILCAS', 103, 1),
(1027, 'SAN AGUSTIN', 103, 1),
(1028, 'SAN JERONIMO DE TUNAN', 103, 1),
(1029, 'SA&Ntilde;O', 103, 1),
(1030, 'SAPALLANGA', 103, 1),
(1031, 'SICAYA', 103, 1),
(1032, 'SANTO DOMINGO DE ACOBAMBA', 103, 1),
(1033, 'VIQUES', 103, 1),
(1034, 'CONCEPCION', 104, 1),
(1035, 'ACO', 104, 1),
(1036, 'ANDAMARCA', 104, 1),
(1037, 'CHAMBARA', 104, 1),
(1038, 'COCHAS', 104, 1),
(1039, 'COMAS', 104, 1),
(1040, 'HEROINAS TOLEDO', 104, 1),
(1041, 'MANZANARES', 104, 1),
(1042, 'MARISCAL CASTILLA', 104, 1),
(1043, 'MATAHUASI', 104, 1),
(1044, 'MITO', 104, 1),
(1045, 'NUEVE DE JULIO', 104, 1),
(1046, 'ORCOTUNA', 104, 1),
(1047, 'SAN JOSE DE QUERO', 104, 1),
(1048, 'SANTA ROSA DE OCOPA', 104, 1),
(1049, 'CHANCHAMAYO', 105, 1),
(1050, 'PERENE', 105, 1),
(1051, 'PICHANAQUI', 105, 1),
(1052, 'SAN LUIS DE SHUARO', 105, 1),
(1053, 'SAN RAMON', 105, 1),
(1054, 'VITOC', 105, 1),
(1055, 'JAUJA', 106, 1),
(1056, 'ACOLLA', 106, 1),
(1057, 'APATA', 106, 1),
(1058, 'ATAURA', 106, 1),
(1059, 'CANCHAYLLO', 106, 1),
(1060, 'CURICACA', 106, 1),
(1061, 'EL MANTARO', 106, 1),
(1062, 'HUAMALI', 106, 1),
(1063, 'HUARIPAMPA', 106, 1),
(1064, 'HUERTAS', 106, 1),
(1065, 'JANJAILLO', 106, 1),
(1066, 'JULCAN', 106, 1),
(1067, 'LEONOR ORDO&Ntilde;EZ', 106, 1),
(1068, 'LLOCLLAPAMPA', 106, 1),
(1069, 'MARCO', 106, 1),
(1070, 'MASMA', 106, 1),
(1071, 'MASMA CHICCHE', 106, 1),
(1072, 'MOLINOS', 106, 1),
(1073, 'MONOBAMBA', 106, 1),
(1074, 'MUQUI', 106, 1),
(1075, 'MUQUIYAUYO', 106, 1),
(1076, 'PACA', 106, 1),
(1077, 'PACCHA', 106, 1),
(1078, 'PANCAN', 106, 1),
(1079, 'PARCO', 106, 1),
(1080, 'POMACANCHA', 106, 1),
(1081, 'RICRAN', 106, 1),
(1082, 'SAN LORENZO', 106, 1),
(1083, 'SAN PEDRO DE CHUNAN', 106, 1),
(1084, 'SAUSA', 106, 1),
(1085, 'SINCOS', 106, 1),
(1086, 'TUNAN MARCA', 106, 1),
(1087, 'YAULI', 106, 1),
(1088, 'YAUYOS', 106, 1),
(1089, 'JUNIN', 107, 1),
(1090, 'CARHUAMAYO', 107, 1),
(1091, 'ONDORES', 107, 1),
(1092, 'ULCUMAYO', 107, 1),
(1093, 'SATIPO', 108, 1),
(1094, 'COVIRIALI', 108, 1),
(1095, 'LLAYLLA', 108, 1),
(1096, 'MAZAMARI', 108, 1),
(1097, 'PAMPA HERMOSA', 108, 1),
(1098, 'PANGOA', 108, 1),
(1099, 'RIO NEGRO', 108, 1),
(1100, 'RIO TAMBO', 108, 1),
(1101, 'TARMA', 109, 1),
(1102, 'ACOBAMBA', 109, 1),
(1103, 'HUARICOLCA', 109, 1),
(1104, 'HUASAHUASI', 109, 1),
(1105, 'LA UNION', 109, 1),
(1106, 'PALCA', 109, 1),
(1107, 'PALCAMAYO', 109, 1),
(1108, 'SAN PEDRO DE CAJAS', 109, 1),
(1109, 'TAPO', 109, 1),
(1110, 'LA OROYA', 110, 1),
(1111, 'CHACAPALPA', 110, 1),
(1112, 'HUAY-HUAY', 110, 1),
(1113, 'MARCAPOMACOCHA', 110, 1),
(1114, 'MOROCOCHA', 110, 1),
(1115, 'PACCHA', 110, 1),
(1116, 'SANTA BARBARA DE CARHUACAYAN', 110, 1),
(1117, 'SANTA ROSA DE SACCO', 110, 1),
(1118, 'SUITUCANCHA', 110, 1),
(1119, 'YAULI', 110, 1),
(1120, 'CHUPACA', 111, 1),
(1121, 'AHUAC', 111, 1),
(1122, 'CHONGOS BAJO', 111, 1),
(1123, 'HUACHAC', 111, 1),
(1124, 'HUAMANCACA CHICO', 111, 1),
(1125, 'SAN JUAN DE ISCOS', 111, 1),
(1126, 'SAN JUAN DE JARPA', 111, 1),
(1127, 'TRES DE DICIEMBRE', 111, 1),
(1128, 'YANACANCHA', 111, 1),
(1129, 'TRUJILLO', 112, 1),
(1130, 'EL PORVENIR', 112, 1),
(1131, 'FLORENCIA DE MORA', 112, 1),
(1132, 'HUANCHACO', 112, 1),
(1133, 'LA ESPERANZA', 112, 1),
(1134, 'LAREDO', 112, 1),
(1135, 'MOCHE', 112, 1),
(1136, 'POROTO', 112, 1),
(1137, 'SALAVERRY', 112, 1),
(1138, 'SIMBAL', 112, 1),
(1139, 'VICTOR LARCO HERRERA', 112, 1),
(1140, 'ASCOPE', 113, 1),
(1141, 'CHICAMA', 113, 1),
(1142, 'CHOCOPE', 113, 1),
(1143, 'MAGDALENA DE CAO', 113, 1),
(1144, 'PAIJAN', 113, 1),
(1145, 'RAZURI', 113, 1),
(1146, 'SANTIAGO DE CAO', 113, 1),
(1147, 'CASA GRANDE', 113, 1),
(1148, 'BOLIVAR', 114, 1),
(1149, 'BAMBAMARCA', 114, 1),
(1150, 'CONDORMARCA', 114, 1),
(1151, 'LONGOTEA', 114, 1),
(1152, 'UCHUMARCA', 114, 1),
(1153, 'UCUNCHA', 114, 1),
(1154, 'CHEPEN', 115, 1),
(1155, 'PACANGA', 115, 1),
(1156, 'PUEBLO NUEVO', 115, 1),
(1157, 'JULCAN', 116, 1),
(1158, 'CALAMARCA', 116, 1),
(1159, 'CARABAMBA', 116, 1),
(1160, 'HUASO', 116, 1),
(1161, 'OTUZCO', 117, 1),
(1162, 'AGALLPAMPA', 117, 1),
(1163, 'CHARAT', 117, 1),
(1164, 'HUARANCHAL', 117, 1),
(1165, 'LA CUESTA', 117, 1),
(1166, 'MACHE', 117, 1),
(1167, 'PARANDAY', 117, 1),
(1168, 'SALPO', 117, 1),
(1169, 'SINSICAP', 117, 1),
(1170, 'USQUIL', 117, 1),
(1171, 'SAN PEDRO DE LLOC', 118, 1),
(1172, 'GUADALUPE', 118, 1),
(1173, 'JEQUETEPEQUE', 118, 1),
(1174, 'PACASMAYO', 118, 1),
(1175, 'SAN JOSE', 118, 1),
(1176, 'TAYABAMBA', 119, 1),
(1177, 'BULDIBUYO', 119, 1),
(1178, 'CHILLIA', 119, 1),
(1179, 'HUANCASPATA', 119, 1),
(1180, 'HUAYLILLAS', 119, 1),
(1181, 'HUAYO', 119, 1),
(1182, 'ONGON', 119, 1),
(1183, 'PARCOY', 119, 1),
(1184, 'PATAZ', 119, 1),
(1185, 'PIAS', 119, 1),
(1186, 'SANTIAGO DE CHALLAS', 119, 1),
(1187, 'TAURIJA', 119, 1),
(1188, 'URPAY', 119, 1),
(1189, 'HUAMACHUCO', 120, 1),
(1190, 'CHUGAY', 120, 1),
(1191, 'COCHORCO', 120, 1),
(1192, 'CURGOS', 120, 1),
(1193, 'MARCABAL', 120, 1),
(1194, 'SANAGORAN', 120, 1),
(1195, 'SARIN', 120, 1),
(1196, 'SARTIMBAMBA', 120, 1),
(1197, 'SANTIAGO DE CHUCO', 121, 1),
(1198, 'ANGASMARCA', 121, 1),
(1199, 'CACHICADAN', 121, 1),
(1200, 'MOLLEBAMBA', 121, 1),
(1201, 'MOLLEPATA', 121, 1),
(1202, 'QUIRUVILCA', 121, 1),
(1203, 'SANTA CRUZ DE CHUCA', 121, 1),
(1204, 'SITABAMBA', 121, 1),
(1205, 'GRAN CHIMU', 122, 1),
(1206, 'CASCAS', 122, 1),
(1207, 'LUCMA', 122, 1),
(1208, 'MARMOT', 122, 1),
(1209, 'SAYAPULLO', 122, 1),
(1210, 'VIRU', 123, 1),
(1211, 'CHAO', 123, 1),
(1212, 'GUADALUPITO', 123, 1),
(1213, 'CHICLAYO', 124, 1),
(1214, 'CHONGOYAPE', 124, 1),
(1215, 'ETEN', 124, 1),
(1216, 'ETEN PUERTO', 124, 1),
(1217, 'JOSE LEONARDO ORTIZ', 124, 1),
(1218, 'LA VICTORIA', 124, 1),
(1219, 'LAGUNAS', 124, 1),
(1220, 'MONSEFU', 124, 1),
(1221, 'NUEVA ARICA', 124, 1),
(1222, 'OYOTUN', 124, 1),
(1223, 'PICSI', 124, 1),
(1224, 'PIMENTEL', 124, 1),
(1225, 'REQUE', 124, 1),
(1226, 'SANTA ROSA', 124, 1),
(1227, 'SA&Ntilde;A', 124, 1),
(1228, 'CAYALTI', 124, 1),
(1229, 'PATAPO', 124, 1),
(1230, 'POMALCA', 124, 1),
(1231, 'PUCALA', 124, 1),
(1232, 'TUMAN', 124, 1),
(1233, 'FERRE&Ntilde;AFE', 125, 1),
(1234, 'CA&Ntilde;ARIS', 125, 1),
(1235, 'INCAHUASI', 125, 1),
(1236, 'MANUEL ANTONIO MESONES MURO', 125, 1),
(1237, 'PITIPO', 125, 1),
(1238, 'PUEBLO NUEVO', 125, 1),
(1239, 'LAMBAYEQUE', 126, 1),
(1240, 'CHOCHOPE', 126, 1),
(1241, 'ILLIMO', 126, 1),
(1242, 'JAYANCA', 126, 1),
(1243, 'MOCHUMI', 126, 1),
(1244, 'MORROPE', 126, 1),
(1245, 'MOTUPE', 126, 1),
(1246, 'OLMOS', 126, 1),
(1247, 'PACORA', 126, 1),
(1248, 'SALAS', 126, 1),
(1249, 'SAN JOSE', 126, 1),
(1250, 'TUCUME', 126, 1),
(1251, 'LIMA', 127, 1),
(1252, 'ANCON', 127, 1),
(1253, 'ATE', 127, 1),
(1254, 'BARRANCO', 127, 1),
(1255, 'BRE&Ntilde;A', 127, 1),
(1256, 'CARABAYLLO', 127, 1),
(1257, 'CHACLACAYO', 127, 1),
(1258, 'CHORRILLOS', 127, 1),
(1259, 'CIENEGUILLA', 127, 1),
(1260, 'COMAS', 127, 1),
(1261, 'EL AGUSTINO', 127, 1),
(1262, 'INDEPENDENCIA', 127, 1),
(1263, 'JESUS MARIA', 127, 1),
(1264, 'LA MOLINA', 127, 1),
(1265, 'LA VICTORIA', 127, 1),
(1266, 'LINCE', 127, 1),
(1267, 'LOS OLIVOS', 127, 1),
(1268, 'LURIGANCHO', 127, 1),
(1269, 'LURIN', 127, 1),
(1270, 'MAGDALENA DEL MAR', 127, 1),
(1271, 'MAGDALENA VIEJA', 127, 1),
(1272, 'MIRAFLORES', 127, 1),
(1273, 'PACHACAMAC', 127, 1),
(1274, 'PUCUSANA', 127, 1),
(1275, 'PUENTE PIEDRA', 127, 1),
(1276, 'PUNTA HERMOSA', 127, 1),
(1277, 'PUNTA NEGRA', 127, 1),
(1278, 'RIMAC', 127, 1),
(1279, 'SAN BARTOLO', 127, 1),
(1280, 'SAN BORJA', 127, 1),
(1281, 'SAN ISIDRO', 127, 1),
(1282, 'SAN JUAN DE LURIGANCHO', 127, 1),
(1283, 'SAN JUAN DE MIRAFLORES', 127, 1),
(1284, 'SAN LUIS', 127, 1),
(1285, 'SAN MARTIN DE PORRES', 127, 1),
(1286, 'SAN MIGUEL', 127, 1),
(1287, 'SANTA ANITA', 127, 1),
(1288, 'SANTA MARIA DEL MAR', 127, 1),
(1289, 'SANTA ROSA', 127, 1),
(1290, 'SANTIAGO DE SURCO', 127, 1),
(1291, 'SURQUILLO', 127, 1),
(1292, 'VILLA EL SALVADOR', 127, 1),
(1293, 'VILLA MARIA DEL TRIUNFO', 127, 1),
(1294, 'BARRANCA', 128, 1),
(1295, 'PARAMONGA', 128, 1),
(1296, 'PATIVILCA', 128, 1),
(1297, 'SUPE', 128, 1),
(1298, 'SUPE PUERTO', 128, 1),
(1299, 'CAJATAMBO', 129, 1),
(1300, 'COPA', 129, 1),
(1301, 'GORGOR', 129, 1),
(1302, 'HUANCAPON', 129, 1),
(1303, 'MANAS', 129, 1),
(1304, 'CANTA', 130, 1),
(1305, 'ARAHUAY', 130, 1),
(1306, 'HUAMANTANGA', 130, 1),
(1307, 'HUAROS', 130, 1),
(1308, 'LACHAQUI', 130, 1),
(1309, 'SAN BUENAVENTURA', 130, 1),
(1310, 'SANTA ROSA DE QUIVES', 130, 1),
(1311, 'SAN VICENTE DE CA&Ntilde;ETE', 131, 1),
(1312, 'ASIA', 131, 1),
(1313, 'CALANGO', 131, 1),
(1314, 'CERRO AZUL', 131, 1),
(1315, 'CHILCA', 131, 1),
(1316, 'COAYLLO', 131, 1),
(1317, 'IMPERIAL', 131, 1),
(1318, 'LUNAHUANA', 131, 1),
(1319, 'MALA', 131, 1),
(1320, 'NUEVO IMPERIAL', 131, 1),
(1321, 'PACARAN', 131, 1),
(1322, 'QUILMANA', 131, 1),
(1323, 'SAN ANTONIO', 131, 1),
(1324, 'SAN LUIS', 131, 1),
(1325, 'SANTA CRUZ DE FLORES', 131, 1),
(1326, 'ZU&Ntilde;IGA', 131, 1),
(1327, 'HUARAL', 132, 1),
(1328, 'ATAVILLOS ALTO', 132, 1),
(1329, 'ATAVILLOS BAJO', 132, 1),
(1330, 'AUCALLAMA', 132, 1),
(1331, 'CHANCAY', 132, 1),
(1332, 'IHUARI', 132, 1),
(1333, 'LAMPIAN', 132, 1),
(1334, 'PACARAOS', 132, 1),
(1335, 'SAN MIGUEL DE ACOS', 132, 1),
(1336, 'SANTA CRUZ DE ANDAMARCA', 132, 1),
(1337, 'SUMBILCA', 132, 1),
(1338, 'VEINTISIETE DE NOVIEMBRE', 132, 1),
(1339, 'MATUCANA', 133, 1),
(1340, 'ANTIOQUIA', 133, 1),
(1341, 'CALLAHUANCA', 133, 1),
(1342, 'CARAMPOMA', 133, 1),
(1343, 'CHICLA', 133, 1),
(1344, 'CUENCA', 133, 1),
(1345, 'HUACHUPAMPA', 133, 1),
(1346, 'HUANZA', 133, 1),
(1347, 'HUAROCHIRI', 133, 1),
(1348, 'LAHUAYTAMBO', 133, 1),
(1349, 'LANGA', 133, 1),
(1350, 'LARAOS', 133, 1),
(1351, 'MARIATANA', 133, 1),
(1352, 'RICARDO PALMA', 133, 1),
(1353, 'SAN ANDRES DE TUPICOCHA', 133, 1),
(1354, 'SAN ANTONIO', 133, 1),
(1355, 'SAN BARTOLOME', 133, 1),
(1356, 'SAN DAMIAN', 133, 1),
(1357, 'SAN JUAN DE IRIS', 133, 1),
(1358, 'SAN JUAN DE TANTARANCHE', 133, 1),
(1359, 'SAN LORENZO DE QUINTI', 133, 1),
(1360, 'SAN MATEO', 133, 1),
(1361, 'SAN MATEO DE OTAO', 133, 1),
(1362, 'SAN PEDRO DE CASTA', 133, 1),
(1363, 'SAN PEDRO DE HUANCAYRE', 133, 1),
(1364, 'SANGALLAYA', 133, 1),
(1365, 'SANTA CRUZ DE COCACHACRA', 133, 1),
(1366, 'SANTA EULALIA', 133, 1),
(1367, 'SANTIAGO DE ANCHUCAYA', 133, 1),
(1368, 'SANTIAGO DE TUNA', 133, 1),
(1369, 'SANTO DOMINGO DE LOS OLLEROS', 133, 1),
(1370, 'SURCO', 133, 1),
(1371, 'HUACHO', 134, 1),
(1372, 'AMBAR', 134, 1),
(1373, 'CALETA DE CARQUIN', 134, 1),
(1374, 'CHECRAS', 134, 1),
(1375, 'HUALMAY', 134, 1),
(1376, 'HUAURA', 134, 1),
(1377, 'LEONCIO PRADO', 134, 1),
(1378, 'PACCHO', 134, 1),
(1379, 'SANTA LEONOR', 134, 1),
(1380, 'SANTA MARIA', 134, 1),
(1381, 'SAYAN', 134, 1),
(1382, 'VEGUETA', 134, 1),
(1383, 'OYON', 135, 1),
(1384, 'ANDAJES', 135, 1),
(1385, 'CAUJUL', 135, 1),
(1386, 'COCHAMARCA', 135, 1),
(1387, 'NAVAN', 135, 1),
(1388, 'PACHANGARA', 135, 1),
(1389, 'YAUYOS', 136, 1),
(1390, 'ALIS', 136, 1),
(1391, 'AYAUCA', 136, 1),
(1392, 'AYAVIRI', 136, 1),
(1393, 'AZANGARO', 136, 1),
(1394, 'CACRA', 136, 1),
(1395, 'CARANIA', 136, 1),
(1396, 'CATAHUASI', 136, 1),
(1397, 'CHOCOS', 136, 1),
(1398, 'COCHAS', 136, 1),
(1399, 'COLONIA', 136, 1),
(1400, 'HONGOS', 136, 1),
(1401, 'HUAMPARA', 136, 1),
(1402, 'HUANCAYA', 136, 1),
(1403, 'HUANGASCAR', 136, 1),
(1404, 'HUANTAN', 136, 1),
(1405, 'HUA&Ntilde;EC', 136, 1),
(1406, 'LARAOS', 136, 1),
(1407, 'LINCHA', 136, 1),
(1408, 'MADEAN', 136, 1),
(1409, 'MIRAFLORES', 136, 1),
(1410, 'OMAS', 136, 1),
(1411, 'PUTINZA', 136, 1),
(1412, 'QUINCHES', 136, 1),
(1413, 'QUINOCAY', 136, 1),
(1414, 'SAN JOAQUIN', 136, 1),
(1415, 'SAN PEDRO DE PILAS', 136, 1),
(1416, 'TANTA', 136, 1),
(1417, 'TAURIPAMPA', 136, 1),
(1418, 'TOMAS', 136, 1),
(1419, 'TUPE', 136, 1),
(1420, 'VI&Ntilde;AC', 136, 1),
(1421, 'VITIS', 136, 1),
(1422, 'IQUITOS', 137, 1),
(1423, 'ALTO NANAY', 137, 1),
(1424, 'FERNANDO LORES', 137, 1),
(1425, 'INDIANA', 137, 1),
(1426, 'LAS AMAZONAS', 137, 1),
(1427, 'MAZAN', 137, 1),
(1428, 'NAPO', 137, 1),
(1429, 'PUNCHANA', 137, 1),
(1430, 'PUTUMAYO', 137, 1),
(1431, 'TORRES CAUSANA', 137, 1),
(1432, 'BELEN', 137, 1),
(1433, 'SAN JUAN BAUTISTA', 137, 1),
(1434, 'YURIMAGUAS', 138, 1),
(1435, 'BALSAPUERTO', 138, 1),
(1436, 'BARRANCA', 138, 1),
(1437, 'CAHUAPANAS', 138, 1),
(1438, 'JEBEROS', 138, 1),
(1439, 'LAGUNAS', 138, 1),
(1440, 'MANSERICHE', 138, 1),
(1441, 'MORONA', 138, 1),
(1442, 'PASTAZA', 138, 1),
(1443, 'SANTA CRUZ', 138, 1),
(1444, 'TENIENTE CESAR LOPEZ ROJAS', 138, 1),
(1445, 'NAUTA', 139, 1),
(1446, 'PARINARI', 139, 1),
(1447, 'TIGRE', 139, 1),
(1448, 'TROMPETEROS', 139, 1),
(1449, 'URARINAS', 139, 1),
(1450, 'RAMON CASTILLA', 140, 1),
(1451, 'PEBAS', 140, 1),
(1452, 'YAVARI', 140, 1),
(1453, 'SAN PABLO', 140, 1),
(1454, 'REQUENA', 141, 1),
(1455, 'ALTO TAPICHE', 141, 1),
(1456, 'CAPELO', 141, 1),
(1457, 'EMILIO SAN MARTIN', 141, 1),
(1458, 'MAQUIA', 141, 1),
(1459, 'PUINAHUA', 141, 1),
(1460, 'SAQUENA', 141, 1),
(1461, 'SOPLIN', 141, 1),
(1462, 'TAPICHE', 141, 1),
(1463, 'JENARO HERRERA', 141, 1),
(1464, 'YAQUERANA', 141, 1),
(1465, 'CONTAMANA', 142, 1),
(1466, 'INAHUAYA', 142, 1),
(1467, 'PADRE MARQUEZ', 142, 1),
(1468, 'PAMPA HERMOSA', 142, 1),
(1469, 'SARAYACU', 142, 1),
(1470, 'VARGAS GUERRA', 142, 1),
(1471, 'TAMBOPATA', 143, 1),
(1472, 'INAMBARI', 143, 1),
(1473, 'LAS PIEDRAS', 143, 1),
(1474, 'LABERINTO', 143, 1),
(1475, 'MANU', 144, 1),
(1476, 'FITZCARRALD', 144, 1),
(1477, 'MADRE DE DIOS', 144, 1),
(1478, 'HUEPETUHE', 144, 1),
(1479, 'I&Ntilde;APARI', 145, 1),
(1480, 'IBERIA', 145, 1),
(1481, 'TAHUAMANU', 145, 1),
(1482, 'MOQUEGUA', 146, 1),
(1483, 'CARUMAS', 146, 1),
(1484, 'CUCHUMBAYA', 146, 1),
(1485, 'SAMEGUA', 146, 1),
(1486, 'SAN CRISTOBAL', 146, 1),
(1487, 'TORATA', 146, 1),
(1488, 'OMATE', 147, 1),
(1489, 'CHOJATA', 147, 1),
(1490, 'COALAQUE', 147, 1),
(1491, 'ICHU&Ntilde;A', 147, 1),
(1492, 'LA CAPILLA', 147, 1),
(1493, 'LLOQUE', 147, 1),
(1494, 'MATALAQUE', 147, 1),
(1495, 'PUQUINA', 147, 1),
(1496, 'QUINISTAQUILLAS', 147, 1),
(1497, 'UBINAS', 147, 1),
(1498, 'YUNGA', 147, 1),
(1499, 'ILO', 148, 1),
(1500, 'EL ALGARROBAL', 148, 1),
(1501, 'PACOCHA', 148, 1),
(1502, 'CHAUPIMARCA', 149, 1),
(1503, 'HUACHON', 149, 1),
(1504, 'HUARIACA', 149, 1),
(1505, 'HUAYLLAY', 149, 1),
(1506, 'NINACACA', 149, 1),
(1507, 'PALLANCHACRA', 149, 1),
(1508, 'PAUCARTAMBO', 149, 1),
(1509, 'SAN FCO.DE ASIS DE YARUSYACAN', 149, 1),
(1510, 'SIMON BOLIVAR', 149, 1),
(1511, 'TICLACAYAN', 149, 1),
(1512, 'TINYAHUARCO', 149, 1),
(1513, 'VICCO', 149, 1),
(1514, 'YANACANCHA', 149, 1),
(1515, 'YANAHUANCA', 150, 1),
(1516, 'CHACAYAN', 150, 1),
(1517, 'GOYLLARISQUIZGA', 150, 1),
(1518, 'PAUCAR', 150, 1),
(1519, 'SAN PEDRO DE PILLAO', 150, 1),
(1520, 'SANTA ANA DE TUSI', 150, 1),
(1521, 'TAPUC', 150, 1),
(1522, 'VILCABAMBA', 150, 1),
(1523, 'OXAPAMPA', 151, 1),
(1524, 'CHONTABAMBA', 151, 1),
(1525, 'HUANCABAMBA', 151, 1),
(1526, 'PALCAZU', 151, 1),
(1527, 'POZUZO', 151, 1),
(1528, 'PUERTO BERMUDEZ', 151, 1),
(1529, 'VILLA RICA', 151, 1),
(1530, 'PIURA', 152, 1),
(1531, 'CASTILLA', 152, 1),
(1532, 'CATACAOS', 152, 1),
(1533, 'CURA MORI', 152, 1),
(1534, 'EL TALLAN', 152, 1),
(1535, 'LA ARENA', 152, 1),
(1536, 'LA UNION', 152, 1),
(1537, 'LAS LOMAS', 152, 1),
(1538, 'TAMBO GRANDE', 152, 1),
(1539, 'AYABACA', 153, 1),
(1540, 'FRIAS', 153, 1),
(1541, 'JILILI', 153, 1),
(1542, 'LAGUNAS', 153, 1),
(1543, 'MONTERO', 153, 1),
(1544, 'PACAIPAMPA', 153, 1),
(1545, 'PAIMAS', 153, 1),
(1546, 'SAPILLICA', 153, 1),
(1547, 'SICCHEZ', 153, 1),
(1548, 'SUYO', 153, 1),
(1549, 'HUANCABAMBA', 154, 1),
(1550, 'CANCHAQUE', 154, 1),
(1551, 'EL CARMEN DE LA FRONTERA', 154, 1),
(1552, 'HUARMACA', 154, 1),
(1553, 'LALAQUIZ', 154, 1),
(1554, 'SAN MIGUEL DE EL FAIQUE', 154, 1),
(1555, 'SONDOR', 154, 1),
(1556, 'SONDORILLO', 154, 1),
(1557, 'CHULUCANAS', 155, 1),
(1558, 'BUENOS AIRES', 155, 1),
(1559, 'CHALACO', 155, 1),
(1560, 'LA MATANZA', 155, 1),
(1561, 'MORROPON', 155, 1),
(1562, 'SALITRAL', 155, 1),
(1563, 'SAN JUAN DE BIGOTE', 155, 1),
(1564, 'SANTA CATALINA DE MOSSA', 155, 1),
(1565, 'SANTO DOMINGO', 155, 1),
(1566, 'YAMANGO', 155, 1),
(1567, 'PAITA', 156, 1),
(1568, 'AMOTAPE', 156, 1),
(1569, 'ARENAL', 156, 1),
(1570, 'COLAN', 156, 1),
(1571, 'LA HUACA', 156, 1),
(1572, 'TAMARINDO', 156, 1),
(1573, 'VICHAYAL', 156, 1),
(1574, 'SULLANA', 157, 1),
(1575, 'BELLAVISTA', 157, 1),
(1576, 'IGNACIO ESCUDERO', 157, 1),
(1577, 'LANCONES', 157, 1),
(1578, 'MARCAVELICA', 157, 1),
(1579, 'MIGUEL CHECA', 157, 1),
(1580, 'QUERECOTILLO', 157, 1),
(1581, 'SALITRAL', 157, 1),
(1582, 'PARI&Ntilde;AS', 158, 1),
(1583, 'EL ALTO', 158, 1),
(1584, 'LA BREA', 158, 1),
(1585, 'LOBITOS', 158, 1),
(1586, 'LOS ORGANOS', 158, 1),
(1587, 'MANCORA', 158, 1),
(1588, 'SECHURA', 159, 1),
(1589, 'BELLAVISTA DE LA UNION', 159, 1),
(1590, 'BERNAL', 159, 1),
(1591, 'CRISTO NOS VALGA', 159, 1),
(1592, 'VICE', 159, 1),
(1593, 'RINCONADA LLICUAR', 159, 1),
(1594, 'PUNO', 160, 1),
(1595, 'ACORA', 160, 1),
(1596, 'AMANTANI', 160, 1),
(1597, 'ATUNCOLLA', 160, 1),
(1598, 'CAPACHICA', 160, 1),
(1599, 'CHUCUITO', 160, 1),
(1600, 'COATA', 160, 1),
(1601, 'HUATA', 160, 1),
(1602, 'MA&Ntilde;AZO', 160, 1),
(1603, 'PAUCARCOLLA', 160, 1),
(1604, 'PICHACANI', 160, 1),
(1605, 'PLATERIA', 160, 1),
(1606, 'SAN ANTONIO', 160, 1),
(1607, 'TIQUILLACA', 160, 1),
(1608, 'VILQUE', 160, 1),
(1609, 'AZANGARO', 161, 1),
(1610, 'ACHAYA', 161, 1),
(1611, 'ARAPA', 161, 1),
(1612, 'ASILLO', 161, 1),
(1613, 'CAMINACA', 161, 1),
(1614, 'CHUPA', 161, 1),
(1615, 'JOSE DOMINGO CHOQUEHUANCA', 161, 1),
(1616, 'MU&Ntilde;ANI', 161, 1),
(1617, 'POTONI', 161, 1),
(1618, 'SAMAN', 161, 1),
(1619, 'SAN ANTON', 161, 1),
(1620, 'SAN JOSE', 161, 1),
(1621, 'SAN JUAN DE SALINAS', 161, 1),
(1622, 'SANTIAGO DE PUPUJA', 161, 1),
(1623, 'TIRAPATA', 161, 1),
(1624, 'MACUSANI', 162, 1),
(1625, 'AJOYANI', 162, 1),
(1626, 'AYAPATA', 162, 1),
(1627, 'COASA', 162, 1),
(1628, 'CORANI', 162, 1),
(1629, 'CRUCERO', 162, 1),
(1630, 'ITUATA', 162, 1),
(1631, 'OLLACHEA', 162, 1),
(1632, 'SAN GABAN', 162, 1),
(1633, 'USICAYOS', 162, 1),
(1634, 'JULI', 163, 1),
(1635, 'DESAGUADERO', 163, 1),
(1636, 'HUACULLANI', 163, 1),
(1637, 'KELLUYO', 163, 1),
(1638, 'PISACOMA', 163, 1),
(1639, 'POMATA', 163, 1),
(1640, 'ZEPITA', 163, 1),
(1641, 'ILAVE', 164, 1),
(1642, 'CAPAZO', 164, 1),
(1643, 'PILCUYO', 164, 1),
(1644, 'SANTA ROSA', 164, 1),
(1645, 'CONDURIRI', 164, 1),
(1646, 'HUANCANE', 165, 1),
(1647, 'COJATA', 165, 1),
(1648, 'HUATASANI', 165, 1),
(1649, 'INCHUPALLA', 165, 1),
(1650, 'PUSI', 165, 1),
(1651, 'ROSASPATA', 165, 1),
(1652, 'TARACO', 165, 1),
(1653, 'VILQUE CHICO', 165, 1),
(1654, 'LAMPA', 166, 1),
(1655, 'CABANILLA', 166, 1),
(1656, 'CALAPUJA', 166, 1),
(1657, 'NICASIO', 166, 1),
(1658, 'OCUVIRI', 166, 1),
(1659, 'PALCA', 166, 1),
(1660, 'PARATIA', 166, 1),
(1661, 'PUCARA', 166, 1),
(1662, 'SANTA LUCIA', 166, 1),
(1663, 'VILAVILA', 166, 1),
(1664, 'AYAVIRI', 167, 1),
(1665, 'ANTAUTA', 167, 1),
(1666, 'CUPI', 167, 1),
(1667, 'LLALLI', 167, 1),
(1668, 'MACARI', 167, 1),
(1669, 'NU&Ntilde;OA', 167, 1),
(1670, 'ORURILLO', 167, 1),
(1671, 'SANTA ROSA', 167, 1),
(1672, 'UMACHIRI', 167, 1),
(1673, 'MOHO', 168, 1),
(1674, 'CONIMA', 168, 1),
(1675, 'HUAYRAPATA', 168, 1),
(1676, 'TILALI', 168, 1),
(1677, 'PUTINA', 169, 1),
(1678, 'ANANEA', 169, 1),
(1679, 'PEDRO VILCA APAZA', 169, 1),
(1680, 'QUILCAPUNCU', 169, 1),
(1681, 'SINA', 169, 1),
(1682, 'JULIACA', 170, 1),
(1683, 'CABANA', 170, 1),
(1684, 'CABANILLAS', 170, 1),
(1685, 'CARACOTO', 170, 1),
(1686, 'SANDIA', 171, 1),
(1687, 'CUYOCUYO', 171, 1),
(1688, 'LIMBANI', 171, 1),
(1689, 'PATAMBUCO', 171, 1),
(1690, 'PHARA', 171, 1),
(1691, 'QUIACA', 171, 1),
(1692, 'SAN JUAN DEL ORO', 171, 1),
(1693, 'YANAHUAYA', 171, 1),
(1694, 'ALTO INAMBARI', 171, 1),
(1695, 'YUNGUYO', 172, 1),
(1696, 'ANAPIA', 172, 1),
(1697, 'COPANI', 172, 1),
(1698, 'CUTURAPI', 172, 1),
(1699, 'OLLARAYA', 172, 1),
(1700, 'TINICACHI', 172, 1),
(1701, 'UNICACHI', 172, 1),
(1702, 'MOYOBAMBA', 173, 1),
(1703, 'CALZADA', 173, 1),
(1704, 'HABANA', 173, 1),
(1705, 'JEPELACIO', 173, 1),
(1706, 'SORITOR', 173, 1),
(1707, 'YANTALO', 173, 1),
(1708, 'BELLAVISTA', 174, 1),
(1709, 'ALTO BIAVO', 174, 1),
(1710, 'BAJO BIAVO', 174, 1),
(1711, 'HUALLAGA', 174, 1),
(1712, 'SAN PABLO', 174, 1),
(1713, 'SAN RAFAEL', 174, 1),
(1714, 'SAN JOSE DE SISA', 175, 1),
(1715, 'AGUA BLANCA', 175, 1),
(1716, 'SAN MARTIN', 175, 1),
(1717, 'SANTA ROSA', 175, 1),
(1718, 'SHATOJA', 175, 1),
(1719, 'SAPOSOA', 176, 1),
(1720, 'ALTO SAPOSOA', 176, 1),
(1721, 'EL ESLABON', 176, 1),
(1722, 'PISCOYACU', 176, 1),
(1723, 'SACANCHE', 176, 1),
(1724, 'TINGO DE SAPOSOA', 176, 1),
(1725, 'LAMAS', 177, 1),
(1726, 'ALONSO DE ALVARADO', 177, 1),
(1727, 'BARRANQUITA', 177, 1),
(1728, 'CAYNARACHI', 177, 1),
(1729, 'CU&Ntilde;UMBUQUI', 177, 1),
(1730, 'PINTO RECODO', 177, 1),
(1731, 'RUMISAPA', 177, 1),
(1732, 'SAN ROQUE DE CUMBAZA', 177, 1),
(1733, 'SHANAO', 177, 1),
(1734, 'TABALOSOS', 177, 1),
(1735, 'ZAPATERO', 177, 1),
(1736, 'JUANJUI', 178, 1),
(1737, 'CAMPANILLA', 178, 1),
(1738, 'HUICUNGO', 178, 1),
(1739, 'PACHIZA', 178, 1),
(1740, 'PAJARILLO', 178, 1),
(1741, 'PICOTA', 179, 1),
(1742, 'BUENOS AIRES', 179, 1),
(1743, 'CASPISAPA', 179, 1),
(1744, 'PILLUANA', 179, 1),
(1745, 'PUCACACA', 179, 1),
(1746, 'SAN CRISTOBAL', 179, 1),
(1747, 'SAN HILARION', 179, 1),
(1748, 'SHAMBOYACU', 179, 1),
(1749, 'TINGO DE PONASA', 179, 1),
(1750, 'TRES UNIDOS', 179, 1),
(1751, 'RIOJA', 180, 1),
(1752, 'AWAJUN', 180, 1),
(1753, 'ELIAS SOPLIN VARGAS', 180, 1),
(1754, 'NUEVA CAJAMARCA', 180, 1),
(1755, 'PARDO MIGUEL', 180, 1),
(1756, 'POSIC', 180, 1),
(1757, 'SAN FERNANDO', 180, 1),
(1758, 'YORONGOS', 180, 1),
(1759, 'YURACYACU', 180, 1),
(1760, 'TARAPOTO', 181, 1),
(1761, 'ALBERTO LEVEAU', 181, 1),
(1762, 'CACATACHI', 181, 1),
(1763, 'CHAZUTA', 181, 1),
(1764, 'CHIPURANA', 181, 1),
(1765, 'EL PORVENIR', 181, 1),
(1766, 'HUIMBAYOC', 181, 1),
(1767, 'JUAN GUERRA', 181, 1),
(1768, 'LA BANDA DE SHILCAYO', 181, 1),
(1769, 'MORALES', 181, 1),
(1770, 'PAPAPLAYA', 181, 1),
(1771, 'SAN ANTONIO', 181, 1),
(1772, 'SAUCE', 181, 1),
(1773, 'SHAPAJA', 181, 1),
(1774, 'TOCACHE', 182, 1),
(1775, 'NUEVO PROGRESO', 182, 1),
(1776, 'POLVORA', 182, 1),
(1777, 'SHUNTE', 182, 1),
(1778, 'UCHIZA', 182, 1),
(1779, 'TACNA', 183, 1),
(1780, 'ALTO DE LA ALIANZA', 183, 1),
(1781, 'CALANA', 183, 1),
(1782, 'CIUDAD NUEVA', 183, 1),
(1783, 'INCLAN', 183, 1),
(1784, 'PACHIA', 183, 1),
(1785, 'PALCA', 183, 1),
(1786, 'POCOLLAY', 183, 1),
(1787, 'SAMA', 183, 1),
(1788, 'CORONEL GREGORIO ALBARRACIN LANCHIPA', 183, 1),
(1789, 'CANDARAVE', 184, 1),
(1790, 'CAIRANI', 184, 1),
(1791, 'CAMILACA', 184, 1),
(1792, 'CURIBAYA', 184, 1),
(1793, 'HUANUARA', 184, 1),
(1794, 'QUILAHUANI', 184, 1),
(1795, 'LOCUMBA', 185, 1),
(1796, 'ILABAYA', 185, 1),
(1797, 'ITE', 185, 1),
(1798, 'TARATA', 186, 1),
(1799, 'CHUCATAMANI', 186, 1),
(1800, 'ESTIQUE', 186, 1),
(1801, 'ESTIQUE-PAMPA', 186, 1),
(1802, 'SITAJARA', 186, 1),
(1803, 'SUSAPAYA', 186, 1),
(1804, 'TARUCACHI', 186, 1),
(1805, 'TICACO', 186, 1),
(1806, 'TUMBES', 187, 1),
(1807, 'CORRALES', 187, 1),
(1808, 'LA CRUZ', 187, 1),
(1809, 'PAMPAS DE HOSPITAL', 187, 1),
(1810, 'SAN JACINTO', 187, 1),
(1811, 'SAN JUAN DE LA VIRGEN', 187, 1),
(1812, 'ZORRITOS', 188, 1),
(1813, 'CASITAS', 188, 1),
(1814, 'ZARUMILLA', 189, 1),
(1815, 'AGUAS VERDES', 189, 1),
(1816, 'MATAPALO', 189, 1),
(1817, 'PAPAYAL', 189, 1),
(1818, 'CALLERIA', 190, 1),
(1819, 'CAMPOVERDE', 190, 1),
(1820, 'IPARIA', 190, 1),
(1821, 'MASISEA', 190, 1),
(1822, 'YARINACOCHA', 190, 1),
(1823, 'NUEVA REQUENA', 190, 1),
(1824, 'RAYMONDI', 191, 1),
(1825, 'SEPAHUA', 191, 1),
(1826, 'TAHUANIA', 191, 1),
(1827, 'YURUA', 191, 1),
(1828, 'PADRE ABAD', 192, 1),
(1829, 'IRAZOLA', 192, 1),
(1830, 'CURIMANA', 192, 1),
(1831, 'PURUS', 193, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_herramientas`
--

CREATE TABLE `tm_herramientas` (
  `id_herramienta` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_herramientas`
--

INSERT INTO `tm_herramientas` (`id_herramienta`, `descripcion`, `estado`) VALUES
(1, 'Estoca', 1),
(2, 'Balanza Electronica', 1),
(3, 'Pala', 1),
(4, 'Guantes', 1),
(5, 'Barreta', 1),
(6, 'Prescinto de Seguridad', 1),
(7, 'Otros', 1),
(8, 'Pico', 1),
(9, 'Martillo/Punzon', 1),
(10, 'Deodorizante', 1),
(11, 'Cal', 1),
(12, 'Mochilas Manuales', 1),
(13, 'ULV', 1),
(14, 'Termo Nebulizadora', 1),
(15, 'Atomizadora', 1),
(16, 'Cajas Protecta', 1),
(17, 'Jaulas Tomahawk', 1),
(18, 'Trampas Pegantes', 1),
(19, 'Tubulares de PVC', 1),
(20, 'Detector Gas Fosfina', 1),
(21, 'Escobillon', 1),
(22, 'Kit lavado de Pozo', 1),
(23, 'Manguera de Bombero', 1),
(24, 'Bomba de Agua Limpia', 1),
(25, 'Bomba Pozo', 1),
(26, 'Coche de Traslado', 1),
(27, 'Escalera', 1),
(28, 'Tripode', 1),
(29, 'Batidora para Impermeabilizacion', 1),
(30, 'Lampara de Pozo', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_insumos`
--

CREATE TABLE `tm_insumos` (
  `id_insumo` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_insumos`
--

INSERT INTO `tm_insumos` (`id_insumo`, `descripcion`, `estado`) VALUES
(1, 'Fosfuro KillPhos', 1),
(2, 'Bolsas de Pellon', 1),
(3, 'Guantes de Nitrilo', 1),
(4, 'Cinta Metálica', 1),
(5, 'Etiquetas de Fumigación', 1),
(6, 'Trapos Industriales', 1),
(7, 'Traje Tyvek', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_manifiestos`
--

CREATE TABLE `tm_manifiestos` (
  `id_manifiesto` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `representante_legal` varchar(100) DEFAULT NULL,
  `dni_repre` varchar(20) DEFAULT NULL,
  `ing_responsable` varchar(100) DEFAULT NULL,
  `cip_ing` varchar(20) DEFAULT NULL,
  `nom_residuos` varchar(400) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_manifiestos`
--

INSERT INTO `tm_manifiestos` (`id_manifiesto`, `id_pedido`, `fecha`, `id_cliente`, `representante_legal`, `dni_repre`, `ing_responsable`, `cip_ing`, `nom_residuos`) VALUES
(1, 421, '2023-07-19 09:54:16', NULL, 'David Medina Salceo', '46391315', 'Anibal Arguedas CAmpoo', '78965455', 'Array'),
(2, 422, '2023-07-19 10:04:03', 0, 'David Medina Salceo', '46391315', 'Anibal Arguedas CAmpoo', '78965455', 'Array'),
(3, 423, '2023-07-19 10:08:16', 0, 'David Medina Salceo', '46391315', 'Anibal Arguedas CAmpoo', '78965455', 'Array'),
(16, 412, '2023-07-21 10:24:18', 188, '', '', '', '78965455', ''),
(17, 424, '2023-07-21 10:25:06', 190, '', '', '', '', ''),
(22, 426, '2023-07-21 10:43:24', 190, 'David Medina Salceo', '46391315', 'Anibal Arguedas CAmpoo', '0000001', 'tarapos medicos'),
(23, 427, '2023-07-21 11:00:33', 190, '', '', '', '', ''),
(24, 409, '2023-07-21 16:39:55', 190, '', '', '', '', ''),
(25, 425, '2023-07-22 08:39:26', 190, 'David Medina Salceo', '46391315', 'Anibal Arguedas CAmpoo', '78965455', 'trapos medicos'),
(28, 428, '2023-07-22 09:35:48', 190, '', '', '', '', ''),
(33, 429, '2023-07-22 10:01:48', 190, '', '', '', '', ''),
(34, 400, '2023-07-22 10:03:10', 188, '', '', '', '', ''),
(35, 430, '2023-07-22 10:08:43', 208, 'David Medina Salceo', '46391315', 'Anibal Arguedas CAmpoo', '78965455', 'tarapos medico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_pedido`
--

CREATE TABLE `tm_pedido` (
  `id_pedido` int(11) NOT NULL,
  `usu_id` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `nro_doc` varchar(15) NOT NULL,
  `direc_cli` varchar(300) NOT NULL,
  `nom_cli` varchar(200) NOT NULL,
  `fecha_emision` datetime DEFAULT NULL,
  `serie_pedido` varchar(30) DEFAULT NULL,
  `moneda` varchar(20) DEFAULT NULL,
  `id_modalidad` int(11) NOT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `telf_contacto` varchar(50) DEFAULT NULL,
  `dire_entrega` varchar(100) DEFAULT NULL,
  `id_demision` int(11) NOT NULL,
  `asesor` varchar(50) NOT NULL,
  `id_fpago` int(11) NOT NULL,
  `fecha_entrega` date NOT NULL,
  `sub_total` decimal(8,2) NOT NULL,
  `igv` decimal(8,2) NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `observacion` varchar(300) DEFAULT NULL,
  `conta_factu` varchar(80) DEFAULT NULL,
  `correo_cfactu` varchar(60) DEFAULT NULL,
  `telf_cfactu` varchar(20) DEFAULT NULL,
  `conta_cobra` varchar(80) DEFAULT NULL,
  `correo_ccobra` varchar(80) DEFAULT NULL,
  `telf_ccobra` varchar(20) DEFAULT NULL,
  `est_ped` int(11) NOT NULL,
  `cotizacion` varchar(30) DEFAULT NULL,
  `link` varchar(400) DEFAULT NULL,
  `cierre_facturacion` varchar(11) DEFAULT NULL,
  `fecha_pago` varchar(20) DEFAULT NULL,
  `acceso_portal` tinyint(1) DEFAULT NULL,
  `entrega_factura` tinyint(1) DEFAULT NULL,
  `estado_pago` varchar(35) DEFAULT NULL,
  `orden_compra` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_pedido`
--

INSERT INTO `tm_pedido` (`id_pedido`, `usu_id`, `id_cliente`, `nro_doc`, `direc_cli`, `nom_cli`, `fecha_emision`, `serie_pedido`, `moneda`, `id_modalidad`, `contacto`, `telf_contacto`, `dire_entrega`, `id_demision`, `asesor`, `id_fpago`, `fecha_entrega`, `sub_total`, `igv`, `total`, `estado`, `observacion`, `conta_factu`, `correo_cfactu`, `telf_cfactu`, `conta_cobra`, `correo_ccobra`, `telf_ccobra`, `est_ped`, `cotizacion`, `link`, `cierre_facturacion`, `fecha_pago`, `acceso_portal`, `entrega_factura`, `estado_pago`, `orden_compra`) VALUES
(351, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-15 16:59:16', 'NP01-351', 'SOLES', 1, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Mayra Pinglo', 10, '2023-06-01', '3000.00', '540.00', '3540.00', 'Anulado', '<p>Llamar antes de acercarse</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '6', '15-22', 1, 1, 'Anulado', NULL),
(352, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-15 17:03:00', 'NP01-352', 'SOLES', 1, '', '', '', 1, 'Mayra Pinglo', 1, '2023-06-02', '500.00', '90.00', '590.00', 'Anulado', 'llamar antes de acercarse', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', NULL),
(353, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-15 17:03:01', 'NP01-353', 'SOLES', 1, '', '', '', 1, 'Mayra Pinglo', 1, '2023-06-02', '500.00', '90.00', '590.00', 'Anulado', 'llamar antes de acercarse', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', NULL),
(354, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-15 17:03:17', 'NP01-354', 'SOLES', 1, '', '', '', 1, 'Mayra Pinglo', 1, '2023-06-02', '500.00', '90.00', '590.00', 'Anulado', 'llamar antes de acercarse', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', NULL),
(355, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-15 17:05:16', 'NP01-355', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 3, 'Mayra Pinglo', 11, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '15-22', 1, 1, 'Anulado', NULL),
(356, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-16 09:12:28', 'NP01-356', 'SOLES', 5, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 10, '2023-06-23', '500.00', '90.00', '590.00', 'Anulado', 'llamar antes de acercarse', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', NULL),
(357, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-16 09:26:28', 'NP01-357', 'SOLES', 1, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 11, '2023-05-31', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(358, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-16 09:31:39', 'NP01-358', 'SOLES', 2, '', '', '', 1, 'Mayra Pinglo', 1, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(359, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-16 09:34:41', 'NP01-359', 'SOLES', 2, '', '', '', 2, 'Mayra Pinglo', 12, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(360, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-16 09:35:48', 'NP01-360', 'SOLES', 2, '', '', '', 2, 'Mayra Pinglo', 10, '2023-06-10', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(361, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-16 09:38:24', 'NP01-361', 'SOLES', 2, '', 'sdafadfasdf', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 10, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(362, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-17 10:02:40', 'NP01-362', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 3, '2023-06-03', '500.00', '90.00', '590.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '15-22', 1, 1, 'Anulado', NULL),
(363, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-19 08:44:47', 'NP01-363', 'SOLES', 3, 'Miguel Hernandez', '997307803', 'Av. Nicolas Ayllon', 3, 'Mayra Pinglo', 10, '2023-06-01', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 1, 1, 'Anulado', NULL),
(364, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-19 09:01:13', 'NP01-364', 'SOLES', 2, '', '', '', 1, 'Mayra Pinglo', 12, '2023-06-01', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(365, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-19 09:12:14', 'NP01-365', 'SOLES', 2, '', '', '', 1, 'Mayra Pinglo', 12, '2023-06-01', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(370, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-19 11:51:35', 'NP01-370', 'SOLES', 1, '', '', '', 1, 'Mayra Pinglo', 11, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '<p>llamar antes de acercarse</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', NULL),
(371, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-19 11:53:13', 'NP01-371', 'SOLES', 1, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 12, '2023-06-01', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '1-7', 0, 0, 'Anulado', NULL),
(372, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-19 12:31:04', 'NP01-372', 'SOLES', 2, '', '', '', 1, 'Mayra Pinglo', 12, '2023-05-31', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(373, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-19 12:37:34', 'NP01-373', 'SOLES', 1, '', '', '', 1, 'Mayra Pinglo', 11, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(374, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-19 12:42:14', 'NP01-374', 'SOLES', 2, '', '', '', 1, 'Mayra Pinglo', 10, '2023-06-01', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Anulado', NULL),
(375, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-19 12:42:51', 'NP01-375', 'SOLES', 1, '', '', '', 1, 'Mayra Pinglo', 10, '2023-06-02', '250.00', '45.00', '295.00', 'Registrado', '<p><br></p>', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Pendiente', NULL),
(376, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-19 12:44:09', 'NP01-376', 'SOLES', 2, '', '', '', 2, 'Mayra Pinglo', 12, '2023-06-01', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Pagado', NULL),
(377, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-19 12:48:25', 'NP01-377', 'SOLES', 2, '', '', '', 1, 'Mayra Pinglo', 11, '2023-06-03', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 1, 1, 'Anulado', NULL),
(378, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-24 08:35:53', 'NP01-378', 'DOLARES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 5, '2023-06-01', '1200.00', '216.00', '1416.00', 'Registrado', '<p>llamar antes de acercarse // 97889656</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', 'OC-112563'),
(379, 68, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-22 16:02:57', 'NP01-379', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 3, 'Miguel Verastegui Vilva', 1, '2023-06-01', '500.00', '90.00', '590.00', 'Anulado', '<p>llamar antes de acercarse</p>', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', ''),
(380, 68, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-22 16:06:46', 'NP01-380', 'SOLES', 5, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Miguel Verastegui Vilva', 2, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', 'OC-569863'),
(381, 6, 208, '46391315', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'Daniel Moscoso silva', '2023-06-24 12:37:34', 'NP01-381', 'SOLES', 5, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Mayra Pinglo', 2, '2023-06-03', '750.00', '135.00', '885.00', 'Registrado', '<p>sdffsdfsdf</p>', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', ''),
(382, 68, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-22 16:04:00', 'NP01-382', 'SOLES', 4, '', '', '', 2, 'Miguel Verastegui Vilva', 7, '2023-06-02', '600.00', '108.00', '708.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', '', '2', '1-7', 1, 1, 'Pagado', 'OC-452632'),
(392, 68, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-22 08:32:11', 'NP01-392', 'SOLES', 1, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Miguel Verastegui Vilva', 2, '2023-06-01', '950.00', '171.00', '1121.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', NULL),
(393, 6, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-23 17:10:21', 'NP01-393', 'DOLARES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 3, 'Mayra Pinglo', 3, '2023-06-02', '700.00', '126.00', '826.00', 'Registrado', '<p>llamar antes de acercarse</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '1-7', 1, 1, 'Pagado', ''),
(394, 68, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-22 15:48:32', 'NP01-394', 'SOLES', 3, 'Daniel Moscoso SIlva', '997307803', 'Av. Nicolas Ayllon', 2, 'Miguel Verastegui Vilva', 2, '2023-06-01', '600.00', '108.00', '708.00', 'Registrado', 'Llamar antes de Acercarse', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', 'OC-325687'),
(395, 68, 189, '20100366747', 'AV. EL POLO NRO. 397 (PISO 3 Y 4 ESQ. JR.EMANCIPACION 103 -107) LIMA - LIMA - SANTIAGO DE SURCO', 'LLAMA GAS S A ', '2023-06-22 10:22:04', 'NP01-395', 'SOLES', 1, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Miguel Verastegui Vilva', 2, '2023-06-02', '600.00', '108.00', '708.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', NULL),
(396, 6, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-06-24 13:20:33', 'NP01-396', 'DOLARES', 3, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 1, '2023-06-01', '600.00', '108.00', '708.00', 'Registrado', 'llamar antes de acercarse', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '16-22', 0, 1, 'Pagado', 'OC-452632'),
(397, 6, 189, '20100366747', 'AV. EL POLO NRO. 397 (PISO 3 Y 4 ESQ. JR.EMANCIPACION 103 -107) LIMA - LIMA - SANTIAGO DE SURCO', 'LLAMA GAS S A ', '2023-06-24 13:24:17', 'NP01-397', 'DOLARES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 3, 'Mayra Pinglo', 2, '2023-06-02', '600.00', '108.00', '708.00', 'Registrado', '<p>llamar antes de acercarsee</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', '', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '23-30', 1, 1, 'Pendiente', 'OC-452632'),
(398, 6, 189, '20100366747', 'AV. EL POLO NRO. 397 (PISO 3 Y 4 ESQ. JR.EMANCIPACION 103 -107) LIMA - LIMA - SANTIAGO DE SURCO', 'LLAMA GAS S A ', '2023-06-26 16:13:31', 'NP01-398', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Mayra Pinglo', 1, '2023-06-02', '600.00', '108.00', '708.00', 'Registrado', 'llamar antes de acercarse', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 0, 1, 'Pagado', 'OC-112563'),
(399, 15, 189, '20100366747', 'AV. EL POLO NRO. 397 (PISO 3 Y 4 ESQ. JR.EMANCIPACION 103 -107) LIMA - LIMA - SANTIAGO DE SURCO', 'LLAMA GAS S A ', '2023-07-15 11:35:47', 'NP01-399', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 3, 'Katty Suxe', 2, '2023-06-02', '250.00', '45.00', '295.00', 'Anulado', '<p>indicar motivo del cierre</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', 'OC-452632'),
(400, 15, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-07-22 10:03:10', 'NP01-400', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 1, '2023-06-01', '500.00', '90.00', '590.00', 'Registrado', '<p>dfdgsdfgsdf</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '6', '8-15', 1, 1, 'Pagado', 'OC-452632'),
(401, 15, 189, '20100366747', 'AV. EL POLO NRO. 397 (PISO 3 Y 4 ESQ. JR.EMANCIPACION 103 -107) LIMA - LIMA - SANTIAGO DE SURCO', 'LLAMA GAS S A ', '2023-07-15 09:50:11', 'NP01-401', 'SOLES', 5, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 2, '2023-07-02', '2800.00', '504.00', '3304.00', 'Anulado', '<p>indicar el motivodel cierre</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '', 1, '', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', 'OC-112563'),
(402, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-15 12:14:02', 'NP01-402', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 2, '2023-06-02', '500.00', '90.00', '590.00', 'Registrado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 1, 'Pendiente', 'OC-452632'),
(403, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-06-30 17:42:17', 'NP01-403', 'SOLES', 2, 'Manuel Dario', '997307803', 'sdfasdfasdfasdf', 1, 'Katty Suxe', 1, '2023-06-01', '1500.00', '270.00', '1770.00', 'Registrado', '<p><br></p>sdsdfsdfsdf', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-112563'),
(404, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-15 10:42:05', 'NP01-404', 'SOLES', 1, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 1, '2023-06-01', '3400.00', '612.00', '4012.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '16-22', 1, 1, 'Anulado', 'OC-452632'),
(405, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-14 16:22:50', 'NP01-405', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 3, 'Katty Suxe', 2, '2023-06-02', '4550.00', '819.00', '5369.00', 'Registrado', '<p>llmaar antes de acercarse</p>', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', 'OC-452632'),
(406, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-15 09:44:53', 'NP01-406', 'SOLES', 3, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 1, '2023-06-01', '1350.00', '243.00', '1593.00', 'Registrado', 'llamar antes de acercarse', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-452632'),
(407, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-04 08:05:16', 'NP01-407', 'SOLES', 3, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 1, '2023-07-07', '1750.00', '315.00', '2065.00', 'Registrado', '<p>llamar antes de acercarse</p>', '', '', '', '', '', '', 1, '', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '6', '', 0, 0, 'Pagado', ''),
(408, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-10 08:22:53', 'NP01-408', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 2, '2023-07-01', '500.00', '90.00', '590.00', 'Anulado', '<p>Llamar antes de acercarse</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '16-22', 1, 1, 'Anulado', 'OC-452632'),
(409, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-21 16:39:55', 'NP01-409', 'SOLES', 5, 'dfsdfasdfasdf', 'sdafadfasdf', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 2, '2023-07-04', '500.00', '90.00', '590.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 0, 0, 'Pendiente', 'OC-112563'),
(410, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-15 13:43:41', 'NP01-410', 'SOLES', 2, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 1, '2023-07-05', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-452632'),
(411, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-17 08:38:11', 'NP01-411', 'SOLES', 4, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 3, 'Katty Suxe', 3, '2023-07-12', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-452632'),
(412, 15, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-07-21 10:24:18', 'NP01-412', 'SOLES', 5, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 3, '2023-07-06', '350.00', '63.00', '413.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '6', '8-15', 1, 1, 'Pagado', 'OC-112563'),
(413, 15, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-07-17 10:55:33', 'NP01-413', 'SOLES', 5, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 13, '2023-07-06', '700.00', '126.00', '826.00', 'Registrado', '<p>Llamar antes de acercarse</p>', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '6', '16-22', 1, 1, 'Pendiente', 'OC-452632'),
(414, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-17 13:13:58', 'NP01-414', 'SOLES', 3, 'Manuel Dario', '997307803', 'sdfasdfasdfasdf', 1, 'Katty Suxe', 1, '2023-07-05', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-112563'),
(415, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-17 17:10:57', 'NP01-415', 'SOLES', 2, 'dfsdfasdfasdf', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 2, '2023-07-08', '750.00', '135.00', '885.00', 'Registrado', '', 'Luisa Advincula', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', 'OC-452632'),
(416, 15, 189, '20100366747', 'AV. EL POLO NRO. 397 (PISO 3 Y 4 ESQ. JR.EMANCIPACION 103 -107) LIMA - LIMA - SANTIAGO DE SURCO', 'LLAMA GAS S A ', '2023-07-18 11:10:46', 'NP01-416', 'SOLES', 2, 'dfsdfasdfasdf', '997307803', 'Av. Nicolas Ayllon', 3, 'Katty Suxe', 2, '2023-07-07', '500.00', '90.00', '590.00', 'Registrado', 'comunicarse con el clientes antes de acercarse a obra', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '16-22', 1, 1, 'Pendiente', 'OC-452632'),
(417, 15, 188, '20505688902', 'CAL.MIGUEL DASSO NRO. 230 INT. 502 URB. SANTA ISABEL', 'NOMA INMOBILIARIA S.A.C. ', '2023-07-18 10:41:21', 'NP01-417', 'SOLES', 3, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 1, '2023-07-06', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-112563'),
(418, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-19 09:21:58', 'NP01-418', 'SOLES', 3, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 2, '2023-07-14', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', 'OC-452632'),
(419, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-19 09:31:42', 'NP01-419', 'SOLES', 4, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 1, '2023-07-06', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-452632'),
(420, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-19 09:41:56', 'NP01-420', 'SOLES', 3, 'Manuel Dario', 'sdafadfasdf', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 2, '2023-07-06', '350.00', '63.00', '413.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', 'OC-452632'),
(421, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-19 09:54:16', 'NP01-421', 'SOLES', 3, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 2, '2023-07-06', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '16-22', 1, 1, 'Pendiente', 'OC-112563'),
(422, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-19 10:04:03', 'NP01-422', 'SOLES', 3, 'dfsdfasdfasdf', '997307803', 'sdfasdfasdfasdf', 2, 'Katty Suxe', 3, '2023-07-06', '350.00', '63.00', '413.00', 'Anulado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '6', '8-15', 1, 1, 'Anulado', 'OC-112563'),
(423, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-19 10:08:16', 'NP01-423', 'SOLES', 4, 'Manuel Dario', '997307803', '', 3, 'Katty Suxe', 3, '2023-07-05', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, '', '', '', '', 0, 0, 'Pagado', ''),
(424, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-21 10:25:06', 'NP01-424', 'SOLES', 3, 'dfsdfasdfasdf', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 3, '2023-07-07', '350.00', '63.00', '413.00', 'Registrado', '', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '1-7', 1, 1, 'Pagado', 'OC-452632'),
(425, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-22 08:39:26', 'NP01-425', 'SOLES', 3, 'Manuel Dario', '', '', 2, 'Katty Suxe', 2, '2023-07-06', '600.00', '108.00', '708.00', 'Registrado', '', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, '', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '', '1-7', 1, 1, 'Pendiente', 'OC-452632'),
(426, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-21 10:43:24', 'NP01-426', 'SOLES', 4, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 2, '2023-07-06', '250.00', '45.00', '295.00', 'Registrado', '<p>llamar antes de acercarse al punto</p>', 'Luisa Advincula', '', '997307803', '', '', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pendiente', 'OC-452632'),
(427, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-21 11:00:33', 'NP01-427', 'SOLES', 2, '', '', '', 1, 'Katty Suxe', 1, '2023-07-01', '1000.00', '180.00', '1180.00', 'Anulado', '', '', '', '', '', '', '', 1, '', '', '', '', 1, 1, 'Anulado', 'OC-452632'),
(428, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-22 09:35:48', 'NP01-428', 'SOLES', 5, 'dfsdfasdfasdf', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 2, '2023-07-05', '2450.00', '441.00', '2891.00', 'Anulado', '<p>Llamar antes de acercarse</p>', 'Luisa Advincula', 'dan.msaj@gmail.com', '997307803', 'Maria Peña', 'elvis.data@sanipperu.com', '963258753', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Anulado', 'OC-452632'),
(429, 15, 190, '20511317038', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) LIMA - LIMA - SAN ISIDRO \"', 'CHINA CIVIL ENGINEERING CONSTRUCTION CORPORATION SUCURSAL DEL PERU', '2023-07-22 10:01:48', 'NP01-429', 'SOLES', 5, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 1, 'Katty Suxe', 1, '2023-07-06', '1750.00', '315.00', '2065.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '8-15', 1, 1, 'Pagado', 'OC-452632'),
(430, 15, 208, '46391315', '\"AV. LAS CAMELIAS NRO. 280 (280-290 LAS CAMELIAS) ', 'Daniel Moscoso silva', '2023-07-22 10:08:43', 'NP01-430', 'SOLES', 4, 'Manuel Dario', '997307803', 'Av. Nicolas Ayllon', 2, 'Katty Suxe', 2, '2023-07-01', '250.00', '45.00', '295.00', 'Registrado', '', '', '', '', '', '', '', 1, 'coti-0025', 'http://localhost/Tutorial_Helpdesk-main/view/GenerarPedido/', '2', '16-22', 1, 1, 'Pendiente', 'OC-112563');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_portatil`
--

CREATE TABLE `tm_portatil` (
  `id_portatil` int(11) NOT NULL,
  `nom_portatil` varchar(100) NOT NULL,
  `id_modelo` int(11) NOT NULL,
  `serie` varchar(50) DEFAULT NULL,
  `precio_alquiler` decimal(5,2) DEFAULT NULL,
  `precio_venta` decimal(5,2) DEFAULT NULL,
  `fecha_fabricacion` datetime DEFAULT NULL,
  `estado_portatil` varchar(30) DEFAULT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_portatil`
--

INSERT INTO `tm_portatil` (`id_portatil`, `nom_portatil`, `id_modelo`, `serie`, `precio_alquiler`, `precio_venta`, `fecha_fabricacion`, `estado_portatil`, `estado`) VALUES
(8, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 105	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(9, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-00220	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(10, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-0031	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(11, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-00237	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(12, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-50	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(13, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-00266	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(14, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-049	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(15, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-076	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(16, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-234	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(17, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-079	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(18, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-251	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(19, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-182	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(20, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-051	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(21, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-00296	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(22, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-00061	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(23, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-128	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(24, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD-235	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(25, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 177	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(26, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 311	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(27, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 00229	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(28, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 00017	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(29, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 00099	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(30, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 031	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(31, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 249	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(32, 'BAÑO PORTATIL ESTÁNDAR', 2, 'STD 239	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(33, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 088	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(34, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00262	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(35, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-108	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(36, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-27	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(37, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-49	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(38, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-273	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(39, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STDL-00202	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(40, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00248	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(41, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(42, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-149	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(43, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-050	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(44, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-12	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(45, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STDL-224	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(46, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STDL-022	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(47, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-199	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(48, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-223	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(49, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-240	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(50, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0101	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(51, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00105	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(52, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00105	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(53, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-265	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(54, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-126	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(55, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-272	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(56, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-240	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(57, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-031	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(58, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(59, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(60, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00267	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(61, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(62, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-119	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(63, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-247	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(64, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-030	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(65, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-024	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(66, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-036	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(67, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-129	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(68, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-064	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(69, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-093	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(70, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-228	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(71, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-136	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(72, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-243	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(73, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-213	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(74, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-287	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(75, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-005	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(76, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-009	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(77, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-300	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(78, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-036	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(79, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-138	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(80, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-510	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(81, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-110	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(82, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-054	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(83, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-007	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(84, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0078	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(85, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0023	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(86, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00192	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(87, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00196	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(88, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00130	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(89, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00048	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(90, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0087	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(91, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0059	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(92, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(93, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(94, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-312	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(95, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-026	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(96, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-90	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(97, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-209	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(98, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00183	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(99, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-229	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(100, 'BAÑO PORTATIL ESTÁNDAR', 2, '	0137	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(101, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-86	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(102, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-226	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(103, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-021	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(104, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-075	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(105, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0306	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(106, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0127	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(107, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0271	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(108, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-089	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(109, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-080	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(110, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-000015	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(111, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-259	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(112, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-230	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(113, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00203	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(114, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-206	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(115, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-197	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(116, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STDL-145	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(117, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-89	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(118, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0005	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(119, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00072	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(120, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00025	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(121, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-000252	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(122, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00139	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(123, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00311	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(124, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00311	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(125, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(126, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00284	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(127, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-19	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(128, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-102	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(129, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD - 37	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(130, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 198	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(131, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 172	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(132, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00227	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(133, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00309	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(134, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00202	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(135, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-305	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(136, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-049	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(137, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00117	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(138, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00022	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(139, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-264	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(140, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-043	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(141, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-104	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(142, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-238	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(143, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-205	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(144, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STDL-041	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(145, 'BAÑO PORTATIL ESTÁNDAR', 2, '	BTDL-69	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(146, 'BAÑO PORTATIL ESTÁNDAR', 2, '	BTDL-123	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(147, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD- 00085	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(148, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD- 59	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(149, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD- 236	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(150, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD- 138	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(151, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD- 216	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(152, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -190	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(153, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -274	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(154, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -109	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(155, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -35	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(156, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD- 313	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(157, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 253	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(158, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(159, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(160, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(161, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-131	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(162, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-225	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(163, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(164, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-270	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(165, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-107	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(166, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -314	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(167, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -021	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(168, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -348	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(169, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD -038	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(170, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 258	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(171, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 258	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(172, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-20	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(173, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-55	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(174, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-32	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(175, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-206	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(176, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD - 261	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(177, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STDL-18	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(178, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00266	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(179, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00124	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(180, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00268	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(181, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-087	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(182, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-248	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(183, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(184, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(185, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-144	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(186, 'BAÑO PORTATIL ESTÁNDAR', 2, '	0015	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(187, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 040	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(188, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-275	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(189, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-90	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(190, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-043	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(191, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-141	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(192, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-125	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(193, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00051	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(194, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-097	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(195, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00077	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(196, 'BAÑO PORTATIL ESTÁNDAR', 2, '	 STD-26	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(197, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(198, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00054	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(199, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-16	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(200, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-250	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(201, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-184	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(202, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 050	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(203, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 095	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(204, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 082	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(205, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-37	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(206, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(207, 'BAÑO PORTATIL ESTÁNDAR', 2, '	0077	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(208, 'BAÑO PORTATIL ESTÁNDAR', 2, '	0280	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(209, 'BAÑO PORTATIL ESTÁNDAR', 2, '	0124	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(210, 'BAÑO PORTATIL ESTÁNDAR', 2, '	0020	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(211, 'BAÑO PORTATIL ESTÁNDAR', 2, '	0046	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(212, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(213, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-281	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(214, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(215, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-64	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(216, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-28	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(217, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-47	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(218, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-290	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(219, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(220, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0088	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(221, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-41	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(222, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-49	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(223, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-277	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(224, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-029	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(225, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 193	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(226, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 050	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(227, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 189	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(228, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-034	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(229, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-034	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(230, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00175	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(231, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00060	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(232, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00018	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(233, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00018	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(234, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-046	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(235, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD 74	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(236, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-00013	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(237, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(238, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-006	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(239, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-0065	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(240, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-254	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(241, 'BAÑO PORTATIL ESTÁNDAR', 2, '	STD-010	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(243, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL- 00015	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(244, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-06	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(245, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-66	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(246, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-00003	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(247, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00142	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(248, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00187	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(249, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-4	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(250, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00060	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(251, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00021	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(252, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-00070	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(253, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(254, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(255, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-18	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(256, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(257, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD 002	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(258, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD 096	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(259, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD 00255	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(260, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-278	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(261, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-67	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(262, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(263, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-347	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(264, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-39	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(265, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-00059	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(266, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-00049	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(267, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-84	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(268, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-17	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(269, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-269	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(270, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL- 00033	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(271, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00036	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(272, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00029	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(273, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-92	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(274, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STD-52	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(275, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00177	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(276, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-17	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(277, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	LVM1- 103	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(278, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-321	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(279, 'BAÑO PORTATIL ESTÁNDAR/LVM', 1, '	STDL-00177	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(282, 'DUCHA PORTATIL', 3, '	DUCHA-044	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(283, 'DUCHA PORTATIL', 3, '	STD-135	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(284, 'DUCHA PORTATIL', 3, '	DUCHA-00071	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(285, 'DUCHA PORTATIL', 3, '	0103	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(286, 'DUCHA PORTATIL', 3, '	DUCHA-75	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(287, 'DUCHA PORTATIL', 3, '	DUCHA-107	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(288, 'DUCHA PORTATIL', 3, '	DUCHA- 00017	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(289, 'DUCHA PORTATIL', 3, '	DUCHA- 00086	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(290, 'DUCHA PORTATIL', 3, '	DUCHA- 00080	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(291, 'DUCHA PORTATIL', 3, '	DUCHA- 0009	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(292, 'DUCHA PORTATIL', 3, '	DUCHA- 000097	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(293, 'DUCHA PORTATIL', 3, '	DUCHA- 000097	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(294, 'DUCHA PORTATIL', 3, '	DUCHA	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(295, 'DUCHA PORTATIL', 3, '	DUCHA-111	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(296, 'DUCHA PORTATIL', 3, '	DUCHA-125	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(297, 'DUCHA PORTATIL', 3, '	DUCHA-00030	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(298, 'DUCHA PORTATIL', 3, '	DUCHA	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(299, 'DUCHA PORTATIL', 3, '	DUCHA-00065	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(300, 'DUCHA PORTATIL', 3, '	DUCHA	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(301, 'DUCHA PORTATIL', 3, '	DUCHA-00054	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(302, 'DUCHA PORTATIL', 3, '	DUCHA	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(303, 'DUCHA PORTATIL', 3, '	DUCHA 137	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(304, 'DUCHA PORTATIL', 3, '	DUCHA	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(305, 'DUCHA PORTATIL', 3, '	DUCHA	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(306, 'DUCHA PORTATIL', 3, '	DUCHA- 124	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(307, 'DUCHA PORTATIL', 3, '	DUCHA- 128	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(308, 'DUCHA PORTATIL', 3, '	DUCHA-00123	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(309, 'DUCHA PORTATIL', 3, '	DUCHA-126	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(310, 'DUCHA PORTATIL', 3, '	DUCHA-9	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(311, 'DUCHA PORTATIL', 3, '	DUCHA-039	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(312, 'DUCHA PORTATIL', 3, '	DUCHA-069	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(313, 'DUCHA PORTATIL', 3, '	DUCHA-033	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(314, 'DUCHA PORTATIL', 3, '	DUCHA-189	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(315, 'DUCHA PORTATIL', 3, '	DUCHA	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(316, 'DUCHA PORTATIL', 3, '	DUCHA- 32	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(317, 'DUCHA PORTATIL', 3, '	DUCHA-121	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(318, 'DUCHA PORTATIL', 3, '	DUCHA-064	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(319, 'DUCHA PORTATIL', 3, '	DUCHA-07	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(320, 'DUCHA PORTATIL', 3, '	DUCHA-20	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(321, 'DUCHA PORTATIL', 3, '	DUCHA-56	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(322, 'DUCHA PORTATIL', 3, '	DUCHA-92	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(323, 'DUCHA PORTATIL', 3, '	DUCHA-101	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(324, 'DUCHA PORTATIL', 3, '	DUCHA-127	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(325, 'DUCHA PORTATIL', 3, '	DUCHA-47	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(326, 'DUCHA PORTATIL', 3, '	DUCHA- 83	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(327, 'DUCHA PORTATIL', 3, '	DUCHA- 112	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(328, 'DUCHA PORTATIL', 3, '	DUCHA- 41	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(329, 'DUCHA PORTATIL', 3, '	DUCHA- 29	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(330, 'DUCHA PORTATIL', 3, '	DUCHA- 24	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(331, 'DUCHA PORTATIL', 3, '	DUCHA- 59	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(332, 'DUCHA PORTATIL', 3, '	DUCHA-74	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(333, 'DUCHA PORTATIL', 3, '	DUCHA-31	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(334, 'DUCHA PORTATIL', 3, '	DUCHA-26	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(335, 'DUCHA PORTATIL', 3, '	DUCHA-19	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(336, 'DUCHA PORTATIL', 3, '	STD-104	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(337, 'DUCHA PORTATIL', 3, '	STD-130	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(338, 'DUCHA PORTATIL', 3, '	DUCHA-00084	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(339, 'DUCHA PORTATIL', 3, '	DUCHA-00010	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(340, 'DUCHA PORTATIL', 3, '	DUCHA-081	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(341, 'DUCHA PORTATIL', 3, '	DUCHA-43	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(342, 'DUCHA PORTATIL', 3, '	DUCHA-00098	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(343, 'DUCHA PORTATIL', 3, '	DUCHA-6	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(344, 'DUCHA PORTATIL', 3, '	0091	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(345, 'DUCHA PORTATIL', 3, '	0031	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(346, 'DUCHA PORTATIL', 3, '	0131	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(347, 'DUCHA PORTATIL', 3, '	0109	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(348, 'DUCHA PORTATIL', 3, '	DUCHA-021	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(349, 'DUCHA PORTATIL', 3, '	STD-242	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(350, 'DUCHA PORTATIL', 3, '	STD-242	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(351, 'DUCHA PORTATIL', 3, '	DUCHA - 89	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(352, 'DUCHA PORTATIL', 3, '	DUCHA - 89	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(353, 'DAFAD', 4, NULL, NULL, NULL, NULL, NULL, 1),
(354, 'LAVAMANO GRANDE', 4, '	LVM1-65	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(355, 'LAVAMANO GRANDE', 4, '	LVM1-0011	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(356, 'LAVAMANO GRANDE', 4, '	LVM1-109	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(357, 'LAVAMANO GRANDE', 4, '	LVM1-00039	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(358, 'LAVAMANO GRANDE', 4, '	LVM1-042	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(359, 'LAVAMANO GRANDE', 4, '	LVM1-063	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(360, 'LAVAMANO GRANDE', 4, '	LVM1-93	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(361, 'LAVAMANO GRANDE', 4, '	LVM1-39	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(362, 'LAVAMANO GRANDE', 4, '	LVM1-045	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(363, 'LAVAMANO GRANDE', 4, '	LVM1-045	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(364, 'LAVAMANO GRANDE', 4, '	LVM1-045	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(365, 'LAVAMANO GRANDE', 4, '	LVM-36	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(366, 'LAVAMANO GRANDE', 4, '	LVM-5	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(367, 'LAVAMANO GRANDE', 4, '	LVM-112	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(368, 'LAVAMANO GRANDE', 4, '	LVM I-028	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(369, 'LAVAMANO GRANDE', 4, '	LVM I-100	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(370, 'LAVAMANO GRANDE', 4, '	0003	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(371, 'LAVAMANO GRANDE', 4, '	LVM1-34	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(372, 'LAVAMANO GRANDE', 4, '	LVM 1 - 050	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(373, 'LAVAMANO GRANDE', 4, '	LVM 1 - 26	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(374, 'LAVAMANO GRANDE', 4, '	LVM 1 - 75	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(375, 'LAVAMANO GRANDE', 4, '	LVM 1 - 005	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(376, 'LAVAMANO GRANDE', 4, '	LVM1-00047	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(377, 'LAVAMANO GRANDE', 4, '	LVM 1 -002	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(378, 'LAVAMANO GRANDE', 4, '	LVM 1- 025	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(379, 'LAVAMANO GRANDE', 4, '	LVM 1 - 60	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(380, 'LAVAMANO GRANDE', 4, '	LVM1 - 74	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(381, 'LAVAMANO GRANDE', 4, '	LVM1-107	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(382, 'LAVAMANO GRANDE', 4, '	LVM1-00107	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(383, 'LAVAMANO GRANDE', 4, '	LVM - 87	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(384, 'LAVAMANO GRANDE', 4, '	LVM - 112	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(385, 'LAVAMANO GRANDE', 4, '	LVM - 23	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(386, 'LAVAMANO GRANDE', 4, '	LVM1-64	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(387, 'LAVAMANO GRANDE', 4, NULL, NULL, NULL, NULL, '	DISPONIPLE', 1),
(388, 'LAVAMANO GRANDE', 4, '	LVM1-00068	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(389, 'LAVAMANO GRANDE', 4, NULL, NULL, NULL, NULL, '	DISPONIPLE', 1),
(390, 'LAVAMANO GRANDE', 4, '	LVM1-00041	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(391, 'LAVAMANO GRANDE', 4, NULL, NULL, NULL, NULL, '	DISPONIPLE', 1),
(392, 'LAVAMANO GRANDE', 4, '	LVM 1 - 102	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(393, 'LAVAMANO GRANDE', 4, '	LVM1-95	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(394, 'LAVAMANO GRANDE', 4, '	LVM1-88	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(395, 'LAVAMANO GRANDE', 4, '	LVM1	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(396, 'LAVAMANO GRANDE', 4, '	LVM1-53	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(397, 'LAVAMANO GRANDE', 4, '	LVM1-75	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(398, 'LAVAMANO GRANDE', 4, '	LVM1-56	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(399, 'LAVAMANO GRANDE', 4, '	LVM1-101	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(400, 'LAVAMANO GRANDE', 4, '	LVM1-24	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(401, 'LAVAMANO GRANDE', 4, '	LVM1-105	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(402, 'LAVAMANO GRANDE', 4, '	LVM1-049	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(403, 'LAVAMANO GRANDE', 4, '	LVM1-083	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(404, 'LAVAMANO GRANDE', 4, '	LVM1-116	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(405, 'LAVAMANO GRANDE', 4, '	LVM1-00043	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(406, 'LAVAMANO GRANDE', 4, '	LVM1-00037	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(407, 'LAVAMANO GRANDE', 4, '	LVM1-0068	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(408, 'LAVAMANO GRANDE', 4, '	LVM1-0068	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(409, 'LAVAMANO GRANDE', 4, 'LVM1-77	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(410, 'LAVAMANO GRANDE', 4, '0076	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(411, 'LAVAMANO GRANDE', 4, '0097	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(412, 'LAVAMANO GRANDE', 4, 'LVM 1 - 031	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(414, 'LAVAMANO GRANDE', 4, '0081	', NULL, NULL, NULL, '	DISPONIPLE', 1),
(415, 'LAVAMANO GRANDE', 4, '0103	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(416, 'LAVAMANO GRANDE', 4, '0035	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(417, 'LAVAMANO GRANDE', 4, '0107	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(418, 'LAVAMANO GRANDE', 4, '0006	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(430, 'LAVAMANO GRANDE', 4, '0094	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(433, 'LAVAMANO GRANDE', 4, 'LVM-	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(443, 'LAVAMANO GRANDE', 4, 'STD-242	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(444, 'LAVAMANO GRANDE', 4, 'STD-242	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(445, 'PORTATIL LAVAMANO CLASICO', 5, 'LVM-36', NULL, NULL, NULL, 'DISPONIBLE', 1),
(446, 'PORTATIL LAVAMANO CLASICO', 5, 'LVM-26', NULL, NULL, NULL, 'DISPONIBLE', 1),
(447, 'PORTATIL LAVAMANO CLASICO', 5, '0106', NULL, NULL, NULL, 'DISPONIPLE', 1),
(449, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 003	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(450, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-53	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(451, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-014	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(452, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-57	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(453, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 00038	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(454, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-43	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(455, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-38	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(456, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-41	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(457, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-010	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(458, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-52	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(459, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-00019	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(460, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-026	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(461, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-00022	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(462, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-033	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(463, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE - 42	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(464, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE - 47	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(465, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(466, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-30	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(467, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-00027	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(468, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-00034	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(469, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-00001	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(470, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-39	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(471, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-56	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(472, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE- 035	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(473, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-040	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(474, 'BAÑO PORTATIL EJECUTIVO', 6, 'STD-125	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(475, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(476, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(477, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-00034	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(478, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-00035	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(479, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 006	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(480, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 031	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(481, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 037	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(482, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(483, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-66	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(484, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-28	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(485, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-60	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(486, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE-12	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(487, 'BAÑO PORTATIL EJECUTIVO', 6, NULL, NULL, NULL, NULL, 'DISPONIPLE', 1),
(488, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 015	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(489, 'BAÑO PORTATIL EJECUTIVO', 6, 'EJE 011	', NULL, NULL, NULL, 'DISPONIPLE', 1),
(490, 'BAÑO PORTATIL STANDAR / LVM', 1, 'STDL-106', NULL, NULL, NULL, 'DISPONIPLE', 1),
(491, 'BAÑO PORTATIL STANDAR / LVM', 1, 'STDL - 308', NULL, NULL, NULL, 'DISPONIPLE', 1),
(492, 'BAÑO PORTATIL STANDAR / LVM', 1, 'STDL - 308', NULL, NULL, NULL, 'DISPONIPLE', 1),
(493, 'BAÑO PORTATIL STANDAR / LVM', 1, 'STDL - 364', NULL, NULL, NULL, 'DISPONIPLE', 1),
(494, 'BAÑO PORTATIL STANDAR / LVM', 1, 'STD 68', NULL, NULL, NULL, 'DISPONIBLE', 1),
(495, 'LAVAMANOS GRANDE\r\n', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(496, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(497, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(498, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(499, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(500, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(501, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(502, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(503, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(504, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(505, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(506, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(507, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(508, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(509, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(510, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(511, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(512, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(513, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(514, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(515, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(516, 'LAVAMANOS GRANDE', 4, 'LVM 1', NULL, NULL, NULL, 'DISPONIPLE', 1),
(517, 'LAVAMANOS CLASICO', 5, 'LVM - 31', NULL, NULL, NULL, 'DISPONIPLE', 1),
(518, '', 5, 'LVM - 6', NULL, NULL, NULL, 'DISPONIPLE', 1),
(519, 'LAVAMANOS CLASICO', 5, 'LVM 1 - 91', NULL, NULL, NULL, 'DISPONIPLE', 1),
(520, '', 5, 'LVM 1 - 48', NULL, NULL, NULL, 'DISPONIPLE', 1),
(521, 'LAVAMANOS CLASICO', 5, 'LVM 1 - 61', NULL, NULL, NULL, 'DISPONIBLE', 1),
(522, 'LAVAMANOS CLASICO', 5, 'LVM 1 - 80', NULL, NULL, NULL, 'DISPONIBLE', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_prioridad`
--

CREATE TABLE `tm_prioridad` (
  `prio_id` int(11) NOT NULL,
  `prio_nom` varchar(50) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_prioridad`
--

INSERT INTO `tm_prioridad` (`prio_id`, `prio_nom`, `est`) VALUES
(1, 'Bajo', 1),
(2, 'Medio', 1),
(3, 'Alto', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_provincia`
--

CREATE TABLE `tm_provincia` (
  `id_provincia` int(11) NOT NULL,
  `nom_provincia` varchar(100) NOT NULL,
  `id_departamento` int(11) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_provincia`
--

INSERT INTO `tm_provincia` (`id_provincia`, `nom_provincia`, `id_departamento`, `est`) VALUES
(1, 'CHACHAPOYAS ', 1, 1),
(2, 'BAGUA', 1, 1),
(3, 'BONGARA', 1, 1),
(4, 'CONDORCANQUI', 1, 1),
(5, 'LUYA', 1, 1),
(6, 'RODRIGUEZ DE MENDOZA', 1, 1),
(7, 'UTCUBAMBA', 1, 1),
(8, 'HUARAZ', 2, 1),
(9, 'AIJA', 2, 1),
(10, 'ANTONIO RAYMONDI', 2, 1),
(11, 'ASUNCION', 2, 1),
(12, 'BOLOGNESI', 2, 1),
(13, 'CARHUAZ', 2, 1),
(14, 'CARLOS FERMIN FITZCARRALD', 2, 1),
(15, 'CASMA', 2, 1),
(16, 'CORONGO', 2, 1),
(17, 'HUARI', 2, 1),
(18, 'HUARMEY', 2, 1),
(19, 'HUAYLAS', 2, 1),
(20, 'MARISCAL LUZURIAGA', 2, 1),
(21, 'OCROS', 2, 1),
(22, 'PALLASCA', 2, 1),
(23, 'POMABAMBA', 2, 1),
(24, 'RECUAY', 2, 1),
(25, 'SANTA', 2, 1),
(26, 'SIHUAS', 2, 1),
(27, 'YUNGAY', 2, 1),
(28, 'ABANCAY', 3, 1),
(29, 'ANDAHUAYLAS', 3, 1),
(30, 'ANTABAMBA', 3, 1),
(31, 'AYMARAES', 3, 1),
(32, 'COTABAMBAS', 3, 1),
(33, 'CHINCHEROS', 3, 1),
(34, 'GRAU', 3, 1),
(35, 'AREQUIPA', 4, 1),
(36, 'CAMANA', 4, 1),
(37, 'CARAVELI', 4, 1),
(38, 'CASTILLA', 4, 1),
(39, 'CAYLLOMA', 4, 1),
(40, 'CONDESUYOS', 4, 1),
(41, 'ISLAY', 4, 1),
(42, 'LA UNION', 4, 1),
(43, 'HUAMANGA', 5, 1),
(44, 'CANGALLO', 5, 1),
(45, 'HUANCA SANCOS', 5, 1),
(46, 'HUANTA', 5, 1),
(47, 'LA MAR', 5, 1),
(48, 'LUCANAS', 5, 1),
(49, 'PARINACOCHAS', 5, 1),
(50, 'PAUCAR DEL SARA SARA', 5, 1),
(51, 'SUCRE', 5, 1),
(52, 'VICTOR FAJARDO', 5, 1),
(53, 'VILCAS HUAMAN', 5, 1),
(54, 'CAJAMARCA', 6, 1),
(55, 'CAJABAMBA', 6, 1),
(56, 'CELENDIN', 6, 1),
(57, 'CHOTA ', 6, 1),
(58, 'CONTUMAZA', 6, 1),
(59, 'CUTERVO', 6, 1),
(60, 'HUALGAYOC', 6, 1),
(61, 'JAEN', 6, 1),
(62, 'SAN IGNACIO', 6, 1),
(63, 'SAN MARCOS', 6, 1),
(64, 'SAN PABLO', 6, 1),
(65, 'SANTA CRUZ', 6, 1),
(66, 'CALLAO', 7, 1),
(67, 'CUSCO', 8, 1),
(68, 'ACOMAYO', 8, 1),
(69, 'ANTA', 8, 1),
(70, 'CALCA', 8, 1),
(71, 'CANAS', 8, 1),
(72, 'CANCHIS', 8, 1),
(73, 'CHUMBIVILCAS', 8, 1),
(74, 'ESPINAR', 8, 1),
(75, 'LA CONVENCION', 8, 1),
(76, 'PARURO', 8, 1),
(77, 'PAUCARTAMBO', 8, 1),
(78, 'QUISPICANCHI', 8, 1),
(79, 'URUBAMBA', 8, 1),
(80, 'HUANCAVELICA', 9, 1),
(81, 'ACOBAMBA', 9, 1),
(82, 'ANGARAES', 9, 1),
(83, 'CASTROVIRREYNA', 9, 1),
(84, 'CHURCAMPA', 9, 1),
(85, 'HUAYTARA', 9, 1),
(86, 'TAYACAJA', 9, 1),
(87, 'HUANUCO', 10, 1),
(88, 'AMBO', 10, 1),
(89, 'DOS DE MAYO', 10, 1),
(90, 'HUACAYBAMBA', 10, 1),
(91, 'HUAMALIES', 10, 1),
(92, 'LEONCIO PRADO', 10, 1),
(93, 'MARA&Ntilde;ON', 10, 1),
(94, 'PACHITEA', 10, 1),
(95, 'PUERTO INCA', 10, 1),
(96, 'LAURICOCHA', 10, 1),
(97, 'YAROWILCA', 10, 1),
(98, 'ICA', 11, 1),
(99, 'CHINCHA', 11, 1),
(100, 'NAZCA', 11, 1),
(101, 'PALPA', 11, 1),
(102, 'PISCO', 11, 1),
(103, 'HUANCAYO', 12, 1),
(104, 'CONCEPCION', 12, 1),
(105, 'CHANCHAMAYO', 12, 1),
(106, 'JAUJA', 12, 1),
(107, 'JUNIN', 12, 1),
(108, 'SATIPO', 12, 1),
(109, 'TARMA', 12, 1),
(110, 'YAULI', 12, 1),
(111, 'CHUPACA', 12, 1),
(112, 'TRUJILLO', 13, 1),
(113, 'ASCOPE', 13, 1),
(114, 'BOLIVAR', 13, 1),
(115, 'CHEPEN', 13, 1),
(116, 'JULCAN', 13, 1),
(117, 'OTUZCO', 13, 1),
(118, 'PACASMAYO', 13, 1),
(119, 'PATAZ', 13, 1),
(120, 'SANCHEZ CARRION', 13, 1),
(121, 'SANTIAGO DE CHUCO', 13, 1),
(122, 'GRAN CHIMU', 13, 1),
(123, 'VIRU', 13, 1),
(124, 'CHICLAYO', 14, 1),
(125, 'FERRE&Ntilde;AFE', 14, 1),
(126, 'LAMBAYEQUE', 14, 1),
(127, 'LIMA', 15, 1),
(128, 'BARRANCA', 15, 1),
(129, 'CAJATAMBO', 15, 1),
(130, 'CANTA', 15, 1),
(131, 'CA&Ntilde;ETE', 15, 1),
(132, 'HUARAL', 15, 1),
(133, 'HUAROCHIRI', 15, 1),
(134, 'HUAURA', 15, 1),
(135, 'OYON', 15, 1),
(136, 'YAUYOS', 15, 1),
(137, 'MAYNAS', 16, 1),
(138, 'ALTO AMAZONAS', 16, 1),
(139, 'LORETO', 16, 1),
(140, 'MARISCAL RAMON CASTILLA', 16, 1),
(141, 'REQUENA', 16, 1),
(142, 'UCAYALI', 16, 1),
(143, 'TAMBOPATA', 17, 1),
(144, 'MANU', 17, 1),
(145, 'TAHUAMANU', 17, 1),
(146, 'MARISCAL NIETO', 18, 1),
(147, 'GENERAL SANCHEZ CERRO', 18, 1),
(148, 'ILO', 18, 1),
(149, 'PASCO', 19, 1),
(150, 'DANIEL ALCIDES CARRION', 19, 1),
(151, 'OXAPAMPA', 19, 1),
(152, 'PIURA', 20, 1),
(153, 'AYABACA', 20, 1),
(154, 'HUANCABAMBA', 20, 1),
(155, 'MORROPON', 20, 1),
(156, 'PAITA', 20, 1),
(157, 'SULLANA', 20, 1),
(158, 'TALARA', 20, 1),
(159, 'SECHURA', 20, 1),
(160, 'PUNO', 21, 1),
(161, 'AZANGARO', 21, 1),
(162, 'CARABAYA', 21, 1),
(163, 'CHUCUITO', 21, 1),
(164, 'EL COLLAO', 21, 1),
(165, 'HUANCANE', 21, 1),
(166, 'LAMPA', 21, 1),
(167, 'MELGAR', 21, 1),
(168, 'MOHO', 21, 1),
(169, 'SAN ANTONIO DE PUTINA', 21, 1),
(170, 'SAN ROMAN', 21, 1),
(171, 'SANDIA', 21, 1),
(172, 'YUNGUYO', 21, 1),
(173, 'MOYOBAMBA', 22, 1),
(174, 'BELLAVISTA', 22, 1),
(175, 'EL DORADO', 22, 1),
(176, 'HUALLAGA', 22, 1),
(177, 'LAMAS', 22, 1),
(178, 'MARISCAL CACERES', 22, 1),
(179, 'PICOTA', 22, 1),
(180, 'RIOJA', 22, 1),
(181, 'SAN MARTIN', 22, 1),
(182, 'TOCACHE', 22, 1),
(183, 'TACNA', 23, 1),
(184, 'CANDARAVE', 23, 1),
(185, 'JORGE BASADRE', 23, 1),
(186, 'TARATA', 23, 1),
(187, 'TUMBES', 24, 1),
(188, 'CONTRALMIRANTE VILLAR', 24, 1),
(189, 'ZARUMILLA', 24, 1),
(190, 'CORONEL PORTILLO', 25, 1),
(191, 'ATALAYA', 25, 1),
(192, 'PADRE ABAD', 25, 1),
(193, 'PURUS', 25, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_servicio`
--

CREATE TABLE `tm_servicio` (
  `id_servicio` int(11) NOT NULL,
  `id_modalidad` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `precio` decimal(8,2) DEFAULT NULL,
  `id_medida` int(11) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_servicio`
--

INSERT INTO `tm_servicio` (`id_servicio`, `id_modalidad`, `descripcion`, `precio`, `id_medida`, `estado`) VALUES
(1, 2, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', '250.00', 2, 1),
(2, 2, 'LIMPIEZA DE TRAMPA DE GRASA\r\n', '250.00', 2, 1),
(3, 2, 'LIMPIEZA DE POZO SÉPTICO\r\n', '250.00', 2, 1),
(4, 2, 'DESATORO DE RED DE DESAGÜE\r\n', '250.00', 4, 1),
(5, 2, 'LIMPIEZA DE CAMPANA EXTRACTORA\r\n', '250.00', 1, 1),
(6, 2, 'LIMPIEZA DE ESPACIOS CONFINADOS', '250.00', 2, 1),
(7, 2, 'DESINFECCIÓN', '250.00', 3, 1),
(8, 2, 'DESINSECTACIÓN', '250.00', 3, 1),
(9, 2, 'DESRATIZACIÓN\r\n', '250.00', 1, 1),
(10, 2, 'CONTROL AVIAR', '250.00', 1, 1),
(11, 5, 'MANTENIMIENTO/LIMPIEZA DE EQUIPOS PORTATILES', '250.00', 1, 1),
(12, 5, 'REPARACION DE EQUIPOS PORTATILES', '250.00', 1, 1),
(13, 5, 'BAÑO STANDAR / LVM', '350.00', 1, 1),
(14, 5, 'BAÑO STANDAR', '350.00', 1, 1),
(15, 5, 'DUCHA', '350.00', 1, 1),
(16, 5, 'LAVAMANOS GRANDE', '350.00', 1, 1),
(17, 5, 'LVM - CLASICO', '350.00', 1, 1),
(18, 5, 'BAÑO EJECUTIVO', '350.00', 1, 1),
(19, 2, 'LIMPIEZA DE TANQUES/RESERVORIOS', '350.00', 2, 1),
(20, 2, 'LIMPIEZA DE REDES DE ALCANTARILLADO', '250.00', 2, 1),
(21, 2, 'LIMPIEZA DE TANQUES DE AGUA DE CONSUMO', '350.00', 2, 1),
(22, 2, 'LIMPIEZA DE TANQUES INDUSTRIALES', '350.00', 3, 1),
(23, 2, 'SERVICIO DE LIMPIEZA E HIPERMEABILIZACION', '350.00', 2, 1),
(24, 2, 'DESINFECCION COVID-19', '250.00', 3, 1),
(25, 3, 'SERVICIO DE SUCCION DE RESIDUOS NO PELIGROSOS', '350.00', 3, 1),
(26, 3, 'SERVICIO DE SUCCION DE RESIDUOS NO PELIGROSOS', '250.00', 3, 1),
(27, 4, 'RECOJO DE RESIDUOS SOLIDOS NO PELIGROSOS', '350.00', 3, 1),
(28, 4, 'RECOJO DE RESIDUOS SOLIDOS PELIGROSOS', '250.00', 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_subcategoria`
--

CREATE TABLE `tm_subcategoria` (
  `cats_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `cats_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_subcategoria`
--

INSERT INTO `tm_subcategoria` (`cats_id`, `cat_id`, `cats_nom`, `est`) VALUES
(1, 1, 'TECLADO', 1),
(2, 1, 'MONITOR', 1),
(3, 2, 'OUTLOOK', 1),
(4, 2, 'OFFICE', 1),
(5, 4, 'CORTE DE RED/INTERNET', 1),
(6, 4, 'CORTE DE ENERGIA', 1),
(7, 5, 'MATERIALES', 1),
(8, 5, 'INFRAESTRUCTURA', 1),
(9, 6, 'SCTR', 1),
(10, 6, 'SOAT', 1),
(11, 3, 'Otros', 1),
(12, 2, 'TEAMWIEVER', 1),
(13, 2, 'Otros', 1),
(14, 1, 'CPU', 1),
(15, 1, 'DISCO DURO', 1),
(16, 1, 'MEMORIA RAM', 1),
(17, 1, 'HEADPHONE', 1),
(18, 1, 'MOUSE', 1),
(19, 1, 'IMPRESORA', 1),
(20, 2, 'DRIVERS DE IMPRESORA', 1),
(21, 2, 'DRIVERS CONTROLADORES', 1),
(22, 2, 'INSTALACION/ACTUALIZACION', 1),
(23, 2, 'DESINSTALACION', 1),
(24, 4, 'ACCIDENTE LABORAL', 1),
(25, 4, 'ACOSO LABORAL', 1),
(26, 4, 'INTERRUPCIONES EXTERNAS', 1),
(27, 5, 'CONTRATACION LEGAL', 1),
(28, 5, 'HOMOLOGACION', 1),
(29, 5, 'EPP\'s/HIGIENE LABORAL', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_ticket`
--

CREATE TABLE `tm_ticket` (
  `tick_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `cats_id` int(11) NOT NULL,
  `tick_titulo` varchar(250) NOT NULL,
  `tick_descrip` mediumtext DEFAULT NULL,
  `tick_estado` varchar(15) DEFAULT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `usu_asig` int(11) DEFAULT NULL,
  `fech_asig` datetime DEFAULT NULL,
  `fech_cierre` datetime DEFAULT NULL,
  `prio_id` int(11) DEFAULT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_ticket`
--

INSERT INTO `tm_ticket` (`tick_id`, `usu_id`, `cat_id`, `cats_id`, `tick_titulo`, `tick_descrip`, `tick_estado`, `fech_crea`, `usu_asig`, `fech_asig`, `fech_cierre`, `prio_id`, `est`) VALUES
(297, 51, 1, 2, 'Laptop Averiada', 'Solicitud de nuevo equipo.', 'Abierto', '2023-02-27 11:21:14', 3, '2023-02-27 11:21:36', '2023-03-08 12:26:48', 1, 1),
(298, 1, 5, 2, 'Hosting y dominio', '<p>Adquisición de hosting y dominio.</p>', 'Abierto', '2023-02-27 11:23:26', 50, '2023-02-27 11:23:36', NULL, 1, 1),
(303, 1, 2, 3, 'Test', '<p>dasdasdasd</p>', 'Cerrado', '2023-02-27 15:07:06', 3, '2023-02-27 15:53:31', '2023-02-27 16:20:43', 1, 1),
(305, 1, 3, 11, 'ASDASD', '<p>sdfsdf</p>', 'Abierto', '2023-02-27 15:20:48', 3, '2023-03-08 12:24:39', NULL, 1, 1),
(306, 1, 3, 11, 'ASDASD', '<p>asdasd</p>', 'Abierto', '2023-02-27 15:21:13', 1, '2023-03-14 09:30:18', NULL, 1, 1),
(307, 1, 1, 1, 'adasd', '<p>asdasd</p>', 'Abierto', '2023-02-27 15:21:57', NULL, NULL, NULL, 1, 1),
(309, 1, 1, 1, 'dzcasc', '<p>asdsadasdsadsadsadas</p>', 'Cerrado', '2023-02-27 15:43:10', NULL, NULL, '2023-03-08 12:26:17', 1, 1),
(310, 1, 1, 2, 'fadf', '<p>dfsdfdf</p>', 'Abierto', '2023-02-27 16:01:21', NULL, NULL, NULL, 1, 1),
(311, 1, 2, 3, 'Test', '<p>asdqdaw</p>', 'Abierto', '2023-02-27 17:25:18', NULL, NULL, NULL, 1, 1),
(312, 1, 2, 3, 'Test', '<p><img src=\"data:image/png;base64,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kXrdkBCU5ct24vRZLJh7i7I2OVu2bMFjjz2mrF0dpJfR6n9dOjLg0RV55plnUF9fr6x9uWKHnSj5XQna64qHp+QG44jFBpCr1cpPLGYjHothYDAX2lmTjFHxGGL9uKJjX/axsnW5bVX6FRottNLTo2PpF3XGp7jOVJkZokx618TjiOdosr7GRERXm2toqnQylL9QMOKvKQTRJE0TZr5GhFQkjuD/dSOQPrB5LgD3rnaYvls08j4q8ctcen3EVPxCl55avawgJQWQKzz2ZR8rW5fbVqVfxw1YEilcTXWdqTKZXaNhaCOia9N1FtwM+Ik0ffn0PcPTkspfLVDVH5WnDBrc9j9z0bLWmJyOk/7KQPleYI0XziWjbn8nIiJSLU6V0pT60qdKpek4aUpx1BAMERGR+l1nI250zZOm4xjaiIjoGvWFB7d58+bhD3/4g7JG1xLpukrXl4iIiKbHFz5V+tFHH+HVV1/FBx9M8V8LoC+dFNruv/9+fO1rX1O2EBER0VT6woMbEREREV0Z3uNGREREpBIMbkREREQqweBGREREpBIMbkREREQqkVVwu+GGGzD45z8ra0REREQ0nbIKbjffqMGFi3FljYiIiIimU1bBLX/mTTj3yaf45MJn+HyQI29ERERE0ymr97hJLsb/hN6+C/j0YhxZVkVEREREE8g6uBERERHRF4NPlRIRERGpBIMbERERkUowuBERERGpBIMbERERkUowuBERERGpBIMbERERkUowuBERERGpBIMbERERkUowuBERERGpAvD/Ab5l5iV75zeNAAAAAElFTkSuQmCC\" alt=\"\">FF<br></p>', 'Abierto', '2023-02-28 08:30:45', 3, '2023-02-28 08:31:18', NULL, 1, 1),
(313, 1, 1, 2, 'Cambio de Monitor', '<p>Se requiere cambio de equipo monitor para el área de marketing</p>', 'Abierto', '2023-03-01 09:48:59', 3, '2023-03-01 09:50:47', '2023-03-01 09:51:42', 2, 1),
(315, 9, 1, 2, 'Mouse', '<p>Se requiere mouse&nbsp; sede surco</p>', 'Abierto', '2023-03-01 15:46:32', NULL, NULL, NULL, 2, 1),
(318, 1, 1, 1, 'Cambio de Movil', '<p>marketing</p>', 'Cerrado', '2023-03-06 16:47:36', 3, '2023-03-08 12:25:49', '2023-03-08 12:25:23', 2, 1),
(319, 1, 1, 18, 'CAMBIO DE MOUSE', '<p>SE REQUIERE CAMBIO DE MOUSE PARA LICITACIONES. MOUSE AVERIADO</p>', 'Cerrado', '2023-03-08 08:42:21', 3, '2023-03-08 08:42:40', '2023-03-08 12:25:00', 2, 1),
(320, 9, 5, 8, 'TOMACORRIENTE', '<p>SE SOLICITA TOMACORRIENTE PARA CONTABILIDAD</p>', 'Abierto', '2023-03-09 09:10:51', 11, '2023-03-09 09:12:57', NULL, 2, 1),
(321, 15, 1, 1, 'mouse', '<p>mouse para contabilidad</p>', 'Abierto', '2023-03-20 14:44:55', NULL, NULL, '2023-07-15 09:32:55', 1, 1),
(322, 15, 1, 2, 'Cambio de cable de monitor', '<p>urgente</p>', 'Abierto', '2023-03-24 18:26:09', NULL, NULL, NULL, 3, 1),
(323, 15, 1, 2, 'monitor en mal estado', '<p>urgente</p>', 'Abierto', '2023-03-30 10:22:14', NULL, NULL, NULL, 1, 1),
(324, 15, 3, 11, 'mm.jk.', '<p>gklgkl</p>', 'Abierto', '2023-04-10 11:40:06', NULL, NULL, '2023-04-20 15:04:35', 2, 1),
(325, 15, 2, 3, 'pedio 202', '<p>se genero pedio 202</p>', 'Abierto', '2023-04-17 12:42:51', NULL, NULL, '2023-04-17 12:45:56', 1, 1),
(326, 6, 2, 4, 'defsdf', '<p>sdfsdfsd</p>', 'Cerrado', '2023-05-05 16:55:03', NULL, NULL, '2023-06-21 09:20:38', 2, 1),
(327, 6, 2, 4, 'dfdsf', '<p>dsfsdfsd</p>', 'Abierto', '2023-05-06 10:37:36', NULL, NULL, NULL, 1, 1),
(328, 6, 1, 1, 'pedio 202', '<p>sdfsfsd</p>', 'Abierto', '2023-05-08 12:47:35', NULL, NULL, NULL, 2, 1),
(329, 6, 1, 1, 'werwerwer', '<p>werewr</p>', 'Abierto', '2023-05-08 12:48:09', NULL, NULL, NULL, 2, 1),
(330, 6, 1, 15, 'pedio 202', '<p>sadasdasd</p>', 'Abierto', '2023-05-09 17:30:27', NULL, NULL, NULL, 1, 1),
(331, 6, 2, 4, 'sdfdsf', '<p>sdfsdfsdf</p>', 'Abierto', '2023-05-11 08:57:02', NULL, NULL, NULL, 1, 1),
(332, 1, 2, 3, 'asdasdasd', '<p>asdasdasdsd</p>', 'Abierto', '2023-05-11 09:02:55', NULL, NULL, NULL, 1, 1),
(333, 6, 2, 12, 'dfsdfsdfdsf', '<p><sub>sdfsdfsd</sub></p>', 'Abierto', '2023-05-12 10:33:50', NULL, NULL, NULL, 2, 1),
(334, 6, 2, 12, 'dfdfsdf', '<p><sub>sdfsdfsd</sub></p>', 'Abierto', '2023-05-12 10:34:25', NULL, NULL, NULL, 2, 1),
(335, 6, 2, 12, 'sdfsdfsd', '<p><sub>sdfsdfsd</sub></p>', 'Abierto', '2023-05-12 10:34:30', NULL, NULL, NULL, 2, 1),
(336, 6, 2, 12, 'sdfdsf', '<p><sub>sdfsdfsdssdfsdf</sub></p>', 'Abierto', '2023-05-12 10:34:42', NULL, NULL, NULL, 2, 1),
(337, 6, 1, 1, '77777777', '<p>fsdfsdf</p>', 'Abierto', '2023-05-12 10:35:14', NULL, NULL, NULL, 1, 1),
(338, 6, 1, 1, ',,m.,m.b.', '<p>fsdfsdf</p>', 'Abierto', '2023-05-12 10:35:44', NULL, NULL, NULL, 1, 1),
(339, 6, 3, 11, '77777777', '<p>gfhfgh</p>', 'Abierto', '2023-05-12 10:37:53', NULL, NULL, NULL, 2, 1),
(340, 6, 1, 1, '77777777', '<p>bnmvnmvm</p>', 'Abierto', '2023-05-12 10:40:53', NULL, NULL, NULL, 1, 1),
(341, 6, 1, 2, '77777777', '<p>cvbnvbncvbncn</p>', 'Abierto', '2023-05-12 10:42:44', NULL, NULL, NULL, 2, 1),
(342, 6, 2, 4, '77777777', '<p>dfgfdg</p>', 'Abierto', '2023-05-12 10:44:20', NULL, NULL, NULL, 2, 1),
(343, 6, 3, 11, 'dfgdfg', '<p>dfgdfgfdg</p>', 'Abierto', '2023-05-12 10:44:41', NULL, NULL, NULL, 2, 1),
(344, 6, 1, 1, 'sdffdfsdf', '<p>sdfsdfdsf</p>', 'Abierto', '2023-05-12 10:45:22', NULL, NULL, NULL, 2, 1),
(345, 6, 1, 1, 'sdfsdf', '<p>sdfsdfdsfsdfsdf</p>', 'Abierto', '2023-05-12 10:45:31', NULL, NULL, NULL, 2, 1),
(346, 6, 1, 1, 'dfdsf', '<p>sdfsdfdsfsdfsdf</p>', 'Abierto', '2023-05-12 10:45:48', NULL, NULL, NULL, 2, 1),
(347, 6, 2, 4, 'dfsdf', '<p>sdfsdf</p>', 'Abierto', '2023-05-12 10:45:58', NULL, NULL, NULL, 1, 1),
(348, 6, 2, 13, 'ssadfsdsad', '<p>asdasdasd</p>', 'Abierto', '2023-05-12 10:46:39', NULL, NULL, NULL, 1, 1),
(349, 6, 1, 2, '744444444444', '<p>gfhgfhgfh</p>', 'Abierto', '2023-05-12 10:53:48', NULL, NULL, NULL, 1, 1),
(350, 6, 1, 2, 'pedio 202', '<p>dghdhdfgh</p>', 'Abierto', '2023-05-12 10:54:24', NULL, NULL, NULL, 2, 1),
(351, 6, 2, 4, 'dfgdfgdfg', '<p>dfgdfgdfg</p>', 'Abierto', '2023-05-12 10:54:50', NULL, NULL, NULL, 2, 1),
(352, 6, 4, 6, 'fghfghdfgh', '<p>gfhhdfghdgh</p>', 'Abierto', '2023-05-12 10:55:53', NULL, NULL, NULL, 2, 1),
(353, 6, 1, 1, '77777777', '<p>dsadasdasd</p>', 'Abierto', '2023-05-12 10:57:25', NULL, NULL, NULL, 1, 1),
(354, 6, 2, 3, 'pedio 202', '<p>dsfdsfds</p>', 'Abierto', '2023-05-12 10:58:08', NULL, NULL, NULL, 1, 1),
(355, 6, 1, 2, 'pedio 202', '<p>sadasdasd</p>', 'Abierto', '2023-05-12 11:00:19', NULL, NULL, NULL, 1, 1),
(356, 6, 1, 2, 'pedio 202', '<p>ASDASDASD</p>', 'Abierto', '2023-05-12 11:05:02', NULL, NULL, NULL, 2, 1),
(357, 6, 1, 1, 'dsfsdfds', '<p>dsfsdfsdf</p>', 'Abierto', '2023-05-12 11:09:06', NULL, NULL, NULL, 2, 1),
(358, 6, 2, 4, 'pedio 202', '<p>sdfsfsdf</p>', 'Abierto', '2023-05-12 11:40:47', NULL, NULL, NULL, 2, 1),
(359, 6, 1, 1, 'fdgdfgdfg', '<p>vbncvbbvcb</p>', 'Abierto', '2023-05-13 08:43:39', NULL, NULL, NULL, 1, 1),
(360, 6, 3, 11, 'dffd', '<p>sdfsdfsdf</p>', 'Abierto', '2023-05-13 08:46:16', NULL, NULL, NULL, 1, 1),
(361, 6, 1, 1, 'pedio 202', '<p>dsfsdfsdf</p>', 'Abierto', '2023-05-13 08:47:14', NULL, NULL, NULL, 2, 1),
(362, 6, 3, 11, 'pedio 202', '<p>sdfsdfsdfsd</p>', 'Abierto', '2023-05-13 08:48:10', NULL, NULL, NULL, 3, 1),
(363, 15, 1, 1, 'asdsad', '<p>asdasdasd</p>', 'Abierto', '2023-05-13 12:32:12', NULL, NULL, NULL, 1, 1),
(364, 15, 5, 28, 'defsdf', '<p>sadasd</p>', 'Abierto', '2023-05-13 12:32:33', NULL, NULL, NULL, 1, 1),
(365, 1, 1, 2, 'pedio 202', '<p>asdasdasdasdasd</p>', 'Abierto', '2023-05-19 14:22:33', NULL, NULL, NULL, 1, 1),
(366, 1, 2, 4, '77777777', '<p>dasdasdasd</p>', 'Abierto', '2023-05-19 14:29:24', NULL, NULL, NULL, 2, 1),
(367, 6, 1, 2, 'Pc averiada', '<p>dfsdfsdf</p>', 'Abierto', '2023-05-26 12:54:26', NULL, NULL, NULL, 1, 1),
(368, 6, 1, 1, 'sdfsdfsdf', '<p>rfsdfsdfsdfsdf</p>', 'Abierto', '2023-06-07 15:07:03', NULL, NULL, NULL, 1, 1),
(369, 6, 2, 4, 'sdfsdfsdf', '<p>KHKHJ</p>', 'Abierto', '2023-06-07 17:47:25', NULL, NULL, NULL, 1, 1),
(370, 6, 1, 1, 'sdfsdfsdf', '<p>ghdfgdfgdfg</p>', 'Abierto', '2023-06-08 08:11:38', NULL, NULL, NULL, 1, 1),
(371, 6, 1, 1, 'sdfsdfsdf', '<p><br></p>dfdsfsdfsdfsd', 'Abierto', '2023-06-15 12:25:04', NULL, NULL, NULL, 1, 1),
(372, 6, 2, 12, 'sdfsdfsdf', '<p>sdfsdfsdf</p>', 'Abierto', '2023-06-19 08:45:34', NULL, NULL, NULL, 2, 1),
(373, 6, 3, 11, 'wwwwwwwww', '<p>wwwwwwwwwwwwww</p>', 'Abierto', '2023-06-20 16:35:02', NULL, NULL, NULL, 1, 1),
(374, 68, 1, 14, 'wwwwwwwww', '<p>sdsadasd</p>', 'Abierto', '2023-06-21 11:51:00', NULL, NULL, NULL, 2, 1);
INSERT INTO `tm_ticket` (`tick_id`, `usu_id`, `cat_id`, `cats_id`, `tick_titulo`, `tick_descrip`, `tick_estado`, `fech_crea`, `usu_asig`, `fech_asig`, `fech_cierre`, `prio_id`, `est`) VALUES
(375, 68, 4, 5, 'Inconvenientes con el acceso al correo', '<p><img src=\"data:image/png;base64,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\" alt=\"\"><br></p>', 'Abierto', '2023-06-23 11:18:46', NULL, NULL, '2023-06-23 12:26:01', 1, 1);
INSERT INTO `tm_ticket` (`tick_id`, `usu_id`, `cat_id`, `cats_id`, `tick_titulo`, `tick_descrip`, `tick_estado`, `fech_crea`, `usu_asig`, `fech_asig`, `fech_cierre`, `prio_id`, `est`) VALUES
(376, 6, 2, 3, 'Configuracion de Correo', 'Urgente configuracion de correo', 'Cerrado', '2023-06-26 17:41:46', NULL, NULL, '2023-06-26 17:44:27', 3, 1),
(377, 15, 5, 7, 'compra de hojas para certificado', '<p>1 millar</p>', 'Abierto', '2023-07-22 11:57:14', NULL, NULL, NULL, 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_tipodocumento`
--

CREATE TABLE `tm_tipodocumento` (
  `tipodoc_id` int(11) NOT NULL,
  `nom_tipdoc` varchar(50) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_tipodocumento`
--

INSERT INTO `tm_tipodocumento` (`tipodoc_id`, `nom_tipdoc`, `est`) VALUES
(1, 'RUC', 1),
(2, 'DNI', 1),
(3, 'CE', 1),
(4, 'PASAPORTE', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_tipo_vehiculo`
--

CREATE TABLE `tm_tipo_vehiculo` (
  `id_unidad_vehicular` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_tipo_vehiculo`
--

INSERT INTO `tm_tipo_vehiculo` (`id_unidad_vehicular`, `descripcion`, `estado`) VALUES
(1, 'Camión Furgón de 4 TN / 25 m3', 1),
(2, 'Camión Furgón de 10 TN / 60 m3', 1),
(3, 'Camión Furgón de 30 TN / 90 m3', 1),
(4, 'Brazo Hidráulico con Contenedor 10 m3', 1),
(5, 'Brazo Hidráulico con Contenedor 13 m3', 1),
(6, 'Brazo Hidráulico con Contenedor 25 m3', 1),
(7, 'Plataforma', 1),
(8, 'Camión Furgón - Puertas tipo gaviota de 10 TN / 60 m3', 1),
(9, 'Camión furgón de 4 TN / 25 m3 con rampa', 1),
(10, 'Camión furgón de 10 TN / 60 m3 con rampa', 1),
(11, 'Camión Cisterna 1 m3', 1),
(12, 'Camión Cisterna de 3.5 m3', 1),
(13, 'Camión Cisterna 10,13,15 m3', 1),
(14, 'Camión Cisterna de 30 m3', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_umedida`
--

CREATE TABLE `tm_umedida` (
  `id_medida` int(11) NOT NULL,
  `descripcion` varchar(30) NOT NULL,
  `abreviatura` varchar(10) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_umedida`
--

INSERT INTO `tm_umedida` (`id_medida`, `descripcion`, `abreviatura`, `estado`) VALUES
(1, 'Unidades', 'UN', 1),
(2, 'Metro Cubico', 'M3', 1),
(3, 'Metro Cuadrado', 'M2', 1),
(4, 'Metro Lineal', 'ML', 1),
(5, 'Kilogramo', 'KG', 1),
(6, 'Galones', 'GL', 1),
(7, 'Hora', 'HRS', 1),
(8, 'Litros', 'L', 1),
(9, 'Toneladas', 'TN', 1),
(10, 'VIAJE', 'VJ', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_usuario`
--

CREATE TABLE `tm_usuario` (
  `usu_id` int(11) NOT NULL,
  `usu_nom` varchar(150) NOT NULL,
  `usu_ape` varchar(150) NOT NULL,
  `usu_correo` varchar(150) NOT NULL,
  `usu_pass` varchar(20) NOT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `fech_modi` datetime DEFAULT NULL,
  `fech_elim` datetime DEFAULT NULL,
  `est` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci COMMENT='tabla mantenedor usuarios';

--
-- Volcado de datos para la tabla `tm_usuario`
--

INSERT INTO `tm_usuario` (`usu_id`, `usu_nom`, `usu_ape`, `usu_correo`, `usu_pass`, `rol_id`, `fech_crea`, `fech_modi`, `fech_elim`, `est`) VALUES
(1, 'Daniel', 'Moscoso Silva', 'sistemas@sanipperu.com', '1234', 2, '2023-05-18 11:20:13', NULL, NULL, 1),
(3, 'Willinton', 'Moscoso Silva', 'soporte_admin@sanipperu.com', '1505', 2, '2023-02-07 14:44:46', NULL, NULL, 1),
(6, 'Mayra', 'Pinglo', 'ssoma@sanipperu.com', 'aaaa', 1, '2023-02-08 12:21:19', NULL, NULL, 1),
(7, 'Gandy', 'Olivera Moreno', 'saneamiento@sanipperu.com', '7777', 1, '2023-02-08 12:21:38', NULL, NULL, 1),
(8, 'Maria Isabel', 'Huarcaya', 'mhuarcaya@sanipperu.com', '1111', 1, '2023-02-08 12:24:26', NULL, NULL, 1),
(9, 'Miguel', 'Verastegui Vilva', 'mdigital@sanipperu.com', '1111', NULL, '2023-02-08 12:24:37', NULL, NULL, 1),
(11, 'Alfredo', 'Rodríguez Baltazar', 'administracion@sanipperu.com', '1111', 2, '2023-02-08 12:52:34', NULL, NULL, 1),
(13, 'Edgardo', 'Sanchez', 'esanchez@sanipperu.com', '1111', 2, '2023-02-08 16:15:33', NULL, NULL, 1),
(15, 'Katty', 'Suxe', 'contabilidad@sanipperu.com', '1111', 1, '2023-02-08 16:30:45', NULL, NULL, 1),
(17, 'Daniel', 'Silva', 'dan.msaj@gmail.com', '1111', 1, '2023-02-09 14:19:19', NULL, NULL, 1),
(48, 'alex', 'Moncada Rios', 'dan.msaj@gmail.com', '1231', 1, '2023-02-13 09:10:23', NULL, NULL, 1),
(49, 'Richard', 'Echevarria', 'ssoma@sanipperu.com', 'b59c67bf196a4758191e', 1, '2023-02-23 16:38:59', NULL, NULL, 1),
(50, 'Nestor', 'Yalta Huaman', 'eyalta@sanipperu.com', 'b59c67bf196a4758191e', 1, '2023-02-24 10:57:03', NULL, NULL, 1),
(51, 'Heidy', 'Yalta', 'hyalta@sanipperu.com', 'b59c67bf196a4758191e', 2, '2023-02-27 10:40:45', NULL, NULL, 1),
(68, 'Miguel', 'Verastegui Vilva', 'sistemas@sanipperu.com', '1234', 1, '2023-05-19 16:29:00', NULL, NULL, 1),
(72, 'Andres ', 'Carrillo', 'kjshskdh@fkvefv.com', '81dc9bdb52d04dc20036', 1, '2023-06-21 08:51:46', NULL, NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `det_pedido`
--
ALTER TABLE `det_pedido`
  ADD PRIMARY KEY (`id_detpedido`);

--
-- Indices de la tabla `doc_emision`
--
ALTER TABLE `doc_emision`
  ADD PRIMARY KEY (`id_demision`);

--
-- Indices de la tabla `forma_pago`
--
ALTER TABLE `forma_pago`
  ADD PRIMARY KEY (`id_fpago`);

--
-- Indices de la tabla `tdoc_emision`
--
ALTER TABLE `tdoc_emision`
  ADD PRIMARY KEY (`id_tdocemi`);

--
-- Indices de la tabla `td_documento`
--
ALTER TABLE `td_documento`
  ADD PRIMARY KEY (`doc_id`);

--
-- Indices de la tabla `td_documentopedido`
--
ALTER TABLE `td_documentopedido`
  ADD PRIMARY KEY (`id_documento`);

--
-- Indices de la tabla `td_documentoseguimiento`
--
ALTER TABLE `td_documentoseguimiento`
  ADD PRIMARY KEY (`id_docseguimiento`);

--
-- Indices de la tabla `td_pedidoseguimiento`
--
ALTER TABLE `td_pedidoseguimiento`
  ADD PRIMARY KEY (`id_seguimiento`);

--
-- Indices de la tabla `td_ticketdetalle`
--
ALTER TABLE `td_ticketdetalle`
  ADD PRIMARY KEY (`tickd_id`);

--
-- Indices de la tabla `tipo_servicio`
--
ALTER TABLE `tipo_servicio`
  ADD PRIMARY KEY (`id_modalidad`);

--
-- Indices de la tabla `tm_acopio`
--
ALTER TABLE `tm_acopio`
  ADD PRIMARY KEY (`id_acopio`);

--
-- Indices de la tabla `tm_cargo`
--
ALTER TABLE `tm_cargo`
  ADD PRIMARY KEY (`id_cargo`);

--
-- Indices de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  ADD PRIMARY KEY (`cat_id`);

--
-- Indices de la tabla `tm_cliente`
--
ALTER TABLE `tm_cliente`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `tm_concredito`
--
ALTER TABLE `tm_concredito`
  ADD PRIMARY KEY (`id_ccredito`);

--
-- Indices de la tabla `tm_correo`
--
ALTER TABLE `tm_correo`
  ADD PRIMARY KEY (`id_correo`);

--
-- Indices de la tabla `tm_departamento`
--
ALTER TABLE `tm_departamento`
  ADD PRIMARY KEY (`id_departamento`);

--
-- Indices de la tabla `tm_disposicion_final`
--
ALTER TABLE `tm_disposicion_final`
  ADD PRIMARY KEY (`id_disposicion`);

--
-- Indices de la tabla `tm_distrito`
--
ALTER TABLE `tm_distrito`
  ADD PRIMARY KEY (`id_distrito`);

--
-- Indices de la tabla `tm_herramientas`
--
ALTER TABLE `tm_herramientas`
  ADD PRIMARY KEY (`id_herramienta`);

--
-- Indices de la tabla `tm_insumos`
--
ALTER TABLE `tm_insumos`
  ADD PRIMARY KEY (`id_insumo`);

--
-- Indices de la tabla `tm_manifiestos`
--
ALTER TABLE `tm_manifiestos`
  ADD PRIMARY KEY (`id_manifiesto`);

--
-- Indices de la tabla `tm_pedido`
--
ALTER TABLE `tm_pedido`
  ADD PRIMARY KEY (`id_pedido`);

--
-- Indices de la tabla `tm_portatil`
--
ALTER TABLE `tm_portatil`
  ADD PRIMARY KEY (`id_portatil`);

--
-- Indices de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  ADD PRIMARY KEY (`prio_id`);

--
-- Indices de la tabla `tm_provincia`
--
ALTER TABLE `tm_provincia`
  ADD PRIMARY KEY (`id_provincia`);

--
-- Indices de la tabla `tm_servicio`
--
ALTER TABLE `tm_servicio`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  ADD PRIMARY KEY (`cats_id`);

--
-- Indices de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  ADD PRIMARY KEY (`tick_id`);

--
-- Indices de la tabla `tm_tipodocumento`
--
ALTER TABLE `tm_tipodocumento`
  ADD PRIMARY KEY (`tipodoc_id`);

--
-- Indices de la tabla `tm_tipo_vehiculo`
--
ALTER TABLE `tm_tipo_vehiculo`
  ADD PRIMARY KEY (`id_unidad_vehicular`);

--
-- Indices de la tabla `tm_umedida`
--
ALTER TABLE `tm_umedida`
  ADD PRIMARY KEY (`id_medida`);

--
-- Indices de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  ADD PRIMARY KEY (`usu_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `det_pedido`
--
ALTER TABLE `det_pedido`
  MODIFY `id_detpedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1185;

--
-- AUTO_INCREMENT de la tabla `doc_emision`
--
ALTER TABLE `doc_emision`
  MODIFY `id_demision` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `forma_pago`
--
ALTER TABLE `forma_pago`
  MODIFY `id_fpago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tdoc_emision`
--
ALTER TABLE `tdoc_emision`
  MODIFY `id_tdocemi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `td_documento`
--
ALTER TABLE `td_documento`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `td_documentopedido`
--
ALTER TABLE `td_documentopedido`
  MODIFY `id_documento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=216;

--
-- AUTO_INCREMENT de la tabla `td_documentoseguimiento`
--
ALTER TABLE `td_documentoseguimiento`
  MODIFY `id_docseguimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `td_pedidoseguimiento`
--
ALTER TABLE `td_pedidoseguimiento`
  MODIFY `id_seguimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de la tabla `td_ticketdetalle`
--
ALTER TABLE `td_ticketdetalle`
  MODIFY `tickd_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=167;

--
-- AUTO_INCREMENT de la tabla `tipo_servicio`
--
ALTER TABLE `tipo_servicio`
  MODIFY `id_modalidad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tm_acopio`
--
ALTER TABLE `tm_acopio`
  MODIFY `id_acopio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `tm_cargo`
--
ALTER TABLE `tm_cargo`
  MODIFY `id_cargo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tm_cliente`
--
ALTER TABLE `tm_cliente`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- AUTO_INCREMENT de la tabla `tm_concredito`
--
ALTER TABLE `tm_concredito`
  MODIFY `id_ccredito` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tm_correo`
--
ALTER TABLE `tm_correo`
  MODIFY `id_correo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT de la tabla `tm_departamento`
--
ALTER TABLE `tm_departamento`
  MODIFY `id_departamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `tm_disposicion_final`
--
ALTER TABLE `tm_disposicion_final`
  MODIFY `id_disposicion` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tm_distrito`
--
ALTER TABLE `tm_distrito`
  MODIFY `id_distrito` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1832;

--
-- AUTO_INCREMENT de la tabla `tm_herramientas`
--
ALTER TABLE `tm_herramientas`
  MODIFY `id_herramienta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `tm_insumos`
--
ALTER TABLE `tm_insumos`
  MODIFY `id_insumo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tm_manifiestos`
--
ALTER TABLE `tm_manifiestos`
  MODIFY `id_manifiesto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `tm_pedido`
--
ALTER TABLE `tm_pedido`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=431;

--
-- AUTO_INCREMENT de la tabla `tm_portatil`
--
ALTER TABLE `tm_portatil`
  MODIFY `id_portatil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=523;

--
-- AUTO_INCREMENT de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  MODIFY `prio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tm_provincia`
--
ALTER TABLE `tm_provincia`
  MODIFY `id_provincia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=194;

--
-- AUTO_INCREMENT de la tabla `tm_servicio`
--
ALTER TABLE `tm_servicio`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  MODIFY `cats_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  MODIFY `tick_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=378;

--
-- AUTO_INCREMENT de la tabla `tm_tipodocumento`
--
ALTER TABLE `tm_tipodocumento`
  MODIFY `tipodoc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tm_tipo_vehiculo`
--
ALTER TABLE `tm_tipo_vehiculo`
  MODIFY `id_unidad_vehicular` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `tm_umedida`
--
ALTER TABLE `tm_umedida`
  MODIFY `id_medida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
