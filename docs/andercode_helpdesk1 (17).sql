-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-05-2023 a las 02:04:28
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
SELECT tm_cliente.id_cliente, tm_cliente.tipodoc_id, tm_cliente.nro_doc, tm_cliente.nom_cli, tm_cliente.direc_cli,
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
INNER JOIN tm_tipodocumento on tm_cliente.tipodoc_id = tm_tipodocumento.tipodoc_id 
INNER JOIN tm_departamento on tm_cliente.id_departamento = tm_departamento.id_departamento 
INNER JOIN tm_provincia on tm_cliente.id_provincia = tm_provincia.id_provincia 
INNER JOIN tm_distrito on tm_cliente.id_distrito = tm_distrito.id_distrito 
INNER JOIN tm_concredito on tm_cliente.id_ccredito = tm_concredito.id_ccredito where tm_cliente.est='1';
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
  `id_modelo` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_uni` decimal(8,2) NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `fech_entrega` datetime NOT NULL,
  `fech_devolucion` datetime DEFAULT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `det_pedido`
--

INSERT INTO `det_pedido` (`id_detpedido`, `id_pedido`, `id_servicio`, `id_modelo`, `cantidad`, `precio_uni`, `total`, `fech_entrega`, `fech_devolucion`, `estado`) VALUES
(1, 1, NULL, 1, 10, '250.00', '2500.00', '2023-04-21 17:29:37', NULL, 1),
(2, 1, NULL, 4, 5, '200.00', '1000.00', '2023-04-21 17:29:37', NULL, 1),
(3, 2, 3, NULL, 1, '100.00', '100.00', '2023-04-21 21:17:50', NULL, 1),
(4, 2, 4, NULL, 1, '100.00', '100.00', '2023-04-21 21:17:50', NULL, 1),
(5, 2, 3, NULL, 1, '100.00', '100.00', '2023-04-21 21:17:50', NULL, 1);

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
(36, 359, 'andercode_helpdesk1 (15).sql', '2023-05-13 08:43:39', 1);

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
(111, 313, 1, '<p><img src=\"data:image/png;base64,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\" alt=\"\"><br></p>', '2023-03-01 09:53:24', 1),
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
(145, 329, 6, '<p>dsfsdfsdf</p>', '2023-05-08 12:48:51', 1);

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
(1, 'Servicio', 1),
(2, 'Alquiler', 1),
(3, 'Venta', 1),
(4, 'Transporte', 1),
(5, 'Eventos', 1);

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
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_cliente`
--

INSERT INTO `tm_cliente` (`id_cliente`, `tipodoc_id`, `nro_doc`, `nom_cli`, `direc_cli`, `id_ccredito`, `id_departamento`, `id_provincia`, `id_distrito`, `tele_cli`, `correo_cli`, `contacto_telf`, `contacto_cli`, `fech_crea`, `fech_modi`, `fech_elim`, `est`) VALUES
(187, 1, '20505688903', 'AGRICOLA ANDREA S.A.C. ', 'dfsdfsdfsdf', 1, 0, 0, 0, '', '', '', '', '2023-05-17 09:29:33', NULL, NULL, 1),
(188, 1, '20505688902', 'AGRICOLA ANDREA S.A.C. ', '', NULL, 0, 0, 0, '', '', '', '', '2023-05-17 09:30:18', NULL, NULL, 1),
(189, 1, '20505688908', 'AGRICOLA ANDREA S.A.C. ', '', NULL, 0, 0, 0, '', '', '', '', '2023-05-17 09:31:01', NULL, NULL, 1),
(190, 1, '20505688901', 'AGRICOLA ANDREA S.A.C. ', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201', NULL, 0, 0, 0, '', '', '', '', '2023-05-17 09:33:33', NULL, NULL, 1),
(202, 1, '01256510654', 'AGRICOLA ANDREA S.A.C. ', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201', 1, 2, 9, 97, '', 'fghfghfgh@dsfdsfsf', '997307803', 'alkdfhaoisd', '2023-05-17 16:59:16', NULL, NULL, 1),
(203, 1, '20505688977', 'AGRICOLA ANDREA S.A.C. ', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201', 1, 2, 9, 97, '', 'fghfghfgh@dsfdsfsf', '997307803', 'alkdfhaoisd', '2023-05-17 18:32:54', NULL, NULL, 1);

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
-- Estructura de tabla para la tabla `tm_modeloportatil`
--

CREATE TABLE `tm_modeloportatil` (
  `id_modelo` int(11) NOT NULL,
  `nom_modelo` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `id_medida` int(11) NOT NULL,
  `precio` decimal(8,2) NOT NULL,
  `stock` int(11) DEFAULT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_modeloportatil`
--

INSERT INTO `tm_modeloportatil` (`id_modelo`, `nom_modelo`, `descripcion`, `id_medida`, `precio`, `stock`, `estado`) VALUES
(1, 'STDL', 'BAÑO STANDAR / LVM', 1, '250.00', NULL, 1),
(2, 'STD', 'BAÑO ESTANDAR', 1, '250.00', NULL, 1),
(3, 'DUCHA', 'DUCHA', 1, '250.00', NULL, 1),
(4, 'LVM-I', 'LAVAMANOS GRANDE', 1, '250.00', NULL, 1),
(5, 'LVC', 'LVM - CLASICO', 1, '250.00', NULL, 1),
(6, 'EJE', 'BAÑO EJECUTIVO', 1, '250.00', NULL, 1);

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
  `fecha_entrega` datetime NOT NULL,
  `sub_total` decimal(8,2) NOT NULL,
  `igv` decimal(8,2) NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `observacion` varchar(300) DEFAULT NULL,
  `conta_factu` varchar(80) DEFAULT NULL,
  `correo_cfactu` varchar(60) DEFAULT NULL,
  `telf_cfactu` varchar(20) DEFAULT NULL,
  `conta_cobra` varchar(80) DEFAULT NULL,
  `correo_ccobra` varchar(80) DEFAULT NULL,
  `telf_ccobra` varchar(20) DEFAULT NULL,
  `est_ped` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_pedido`
--

INSERT INTO `tm_pedido` (`id_pedido`, `usu_id`, `id_cliente`, `nro_doc`, `direc_cli`, `nom_cli`, `fecha_emision`, `serie_pedido`, `moneda`, `id_modalidad`, `contacto`, `telf_contacto`, `dire_entrega`, `id_demision`, `asesor`, `id_fpago`, `fecha_entrega`, `sub_total`, `igv`, `total`, `observacion`, `conta_factu`, `correo_cfactu`, `telf_cfactu`, `conta_cobra`, `correo_ccobra`, `telf_ccobra`, `est_ped`) VALUES
(13, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 09:31:42', '1', '1', 2, 'asdasdasd', 'dsfsdf', 'sdfsdfsdf', 2, 'Mayra Pinglo', 3, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>asdasdasd</p>', 'asdasdasdasd', 'asdasd', 'asdasdas', 'asdasd', 'asdasd', 'asdasd', 1),
(14, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 09:42:35', '1', '1', 1, 'asdasdasd', 'sdfsdf', 'sdfsdfsdf', 3, 'Mayra Pinglo', 2, '2023-05-02 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsfsdfsdsdf</p>', 'sdfsdfsdf', 'sdfsdf', 'sdfsdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdfsdf', 1),
(15, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 09:47:05', '1', '1', 1, 'sdfsdfsdf', 'sdfsdf', 'sdfsdfsdf', 2, 'Mayra Pinglo', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>asdasdasd</p>', 'asdasd', 'asdasd', 'asdasd', 'asdasd', 'asdasd', 'asdasdasd', 1),
(16, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 09:50:52', '1', '1', 2, 'asdasdasd', 'sdasdasd', 'asdasdas', 1, 'Mayra Pinglo', 1, '2023-05-04 00:00:00', '250.00', '45.00', '295.00', '<p>asdasdasd</p>', 'asdasdasd', 'asdasd', 'asdasdas', 'asdasdasd', 'asdasd', 'asdasdasd', 1),
(17, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 09:52:53', '1', '1', 2, 'asdasdasd', 'sdasdasd', 'asdasdas', 1, 'Mayra Pinglo', 1, '2023-05-04 00:00:00', '250.00', '45.00', '295.00', '<p>asdasdasd</p>', 'asdasdasd', 'asdasd', 'asdasdas', 'asdasdasd', 'asdasd', 'asdasdasd', 1),
(18, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 09:53:42', '1', '1', 2, 'asdasdasd', 'sdasdasd', 'asdasdas', 1, 'Mayra Pinglo', 1, '2023-05-04 00:00:00', '250.00', '45.00', '295.00', '<p>asdasdasd</p>', 'asdasdasd', 'asdasd', 'asdasdas', 'asdasdasd', 'asdasd', 'asdasdasd', 1),
(19, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 09:56:20', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'sdfsdfsdf', 1, 'Mayra Pinglo', 2, '2023-05-04 00:00:00', '250.00', '45.00', '295.00', '<p>vsdffsdf</p>', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 1),
(33, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 10:25:52', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'dsfsdfsd', 1, 'Mayra Pinglo', 5, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>asdasd</p>', 'asdasd', 'asdasd', 'asdasd', 'asdfasdf', 'asdfasdf', 'asdasdasd', 1),
(34, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 10:28:42', '1', '1', 1, 'sdfsdfsdf', 'sdfsdf', 'asdfasdsa', 1, 'Mayra Pinglo', 3, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>dfsdfsdf</p>', 'sdfsdf', 'dsfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', '3213232323232', 1),
(36, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:10:58', '1', '1', 1, 'sdfsdf', 'sdfsdf', 'dsfsdfsd', 2, 'Mayra Pinglo', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsdfsd</p>', 'sdfsdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 1),
(37, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:11:54', '1', '1', 1, 'sdfsdf', 'sdfsdf', 'dsfsdfsd', 2, 'Mayra Pinglo', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsdfsd</p>', 'sdfsdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 1),
(38, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:16:51', '1', '1', 2, 'sdfsdfsdf', 'sdfsdf', 'sdfsdfsdf', 2, 'Mayra Pinglo', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>dfgdfgdf</p>', 'dfgdfgdfg', 'dfgdfgdf', 'gdfgdf', 'dfgdfg', 'dfgdfg', 'gdfgdfg', 1),
(39, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:22:07', '1', '1', 1, 'asdasdasd', 'czxczxczxc', 'dsfsdfsd', 1, 'Mayra Pinglo', 1, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>xcvxcvxcv</p>', 'xcvxcv', 'xcvxcvcx', 'xcvxcv', 'cxvxcv', 'xcvxcv', 'xcvxcv', 1),
(40, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:29:20', '1', '1', 1, 'asdasdasd', 'czxczxczxc', 'dsfsdfsd', 1, 'Mayra Pinglo', 1, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>xcvxcvxcv</p>', 'xcvxcv', 'xcvxcvcx', 'xcvxcv', 'cxvxcv', 'xcvxcv', 'xcvxcv', 1),
(41, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:30:13', '1', '1', 1, 'sdfsdfsdf', 'dsfsdf', 'sdfsdfsdf', 1, 'Mayra Pinglo', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>dfgsdfg</p>', 'sdfgsdgf', 'sdfgsdf', 'gsdfgsfdg', 'sdfgsdfg', 'sdfgsdfg', 'sdfgsdfg', 1),
(42, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:31:32', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'sdfsdfsdf', 2, 'Mayra Pinglo', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsdf</p>', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdfsd', 'sdfsdf', 'sdfsdf', 1),
(43, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:43:12', '1', '1', 1, 'sdfsdfsdf', 'sdfsdf', 'sdfsdfsdf', 1, 'Mayra Pinglo', 2, '2023-05-04 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsdfsdf</p>', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfdf', 1),
(44, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:46:07', '1', '1', 1, 'sdfsdfsdf', 'sdfsdf', 'sdfsdfsdf', 1, 'Mayra Pinglo', 2, '2023-05-04 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsdfsdf</p>', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfdf', 1),
(47, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 11:59:10', '1', '1', 1, 'asd', 'dsfsdf', 'sdfsdfsdf', 1, 'Mayra Pinglo', 1, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>asdasdsa</p>', 'asdasd', 'asdasd', 'asdasd', 'asdasd', 'asdasd', 'asdasd', 1),
(49, 6, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-12 12:30:43', '1', '1', 1, 'Miguel Hernandez', '997307803', 'Av los Jazminez 214', 1, 'Mayra Pinglo', 2, '2023-05-02 00:00:00', '250.00', '45.00', '295.00', 'Llamar antes de acercarse', 'Miguel Lopez', 'andu@sanip.oco', '988755232', 'Iris Mondragon', 'polo@asa.com', '997307803', 1),
(52, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 08:57:58', '1', '1', 1, 'dsfdsfsdf', 'sdfsdfsdf', 'sdfsdfsdf', 1, 'Katty Suxe', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsdfsdf</p>', 'sdfsdfsdf', 'sdfsdf', 'sdfsdfsd', 'sdfsdfsdf', 'sdfsdfsdf', 'fsdfsdf', 1),
(53, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 08:59:54', '1', '1', 1, 'sdfsdfsdf', 'dsfsdf', 'sdfsdfsdf', 2, 'Katty Suxe', 1, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>fasdfasdfasdf</p>', 'asdfasdfasdf', 'asdfasdfasdfas', 'dfgdfgdfg', 'asdfasdf', 'asdfasdf', 'dfgdfgdfgdfg', 1),
(54, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 09:01:08', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'sdfsdfsdf', 1, 'Katty Suxe', 1, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>zxcz&lt;xc&lt;zxc</p>', 'sdfsdfsdf', 'asdasdas', 'sdfsdfsdf', 'asdasd', 'asdfasdf', 'asdasd', 1),
(55, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 09:05:23', '1', '1', 1, 'sdfsdfsdf', 'sdfsdfsdf', 'dfdsfsdfsdf', 1, 'Katty Suxe', 3, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>sdfsdf</p>', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'sdfsdfsdf', 'sdfsdf', 'sdfsdf', 1),
(56, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 09:32:05', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'dsfsdfsd', 1, 'Katty Suxe', 2, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>sadsdasdas</p>', 'asdasdasd', 'asdasdsa', 'dasdasd', 'sadsadsa', 'asdasdas', 'dasdasdasd', 1),
(57, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 09:37:11', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'dsfsdfsd', 1, 'Katty Suxe', 1, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '', '', '', '', '', '', '', 1),
(58, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 09:41:29', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'dsfsdfsd', 3, 'Katty Suxe', 2, '2023-05-04 00:00:00', '750.00', '135.00', '885.00', '<p>asasdasdsad</p>', 'asdasd', 'asdasdsa', 'dasdasd', 'asdasd', 'asdasd', 'asdasdsa', 1),
(59, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 09:57:07', '1', '1', 1, 'asdasdasd', 'dsfsdf', 'sdfsdfsdf', 1, 'Katty Suxe', 1, '2023-05-04 00:00:00', '1000.00', '180.00', '1180.00', '<p>sdfdsfdsf</p>', 'fsdfsdf', 'dsfsdfsdf', 'sdfdsfdf', 'sdfdsfdsf', 'sdfsdfsdf', 'sdfsdf', 1),
(60, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 10:00:07', '1', '1', 1, 'ghgfhfghfgh', 'dsfsdf', 'sdfsdfsdf', 2, 'Katty Suxe', 1, '2023-05-03 00:00:00', '750.00', '135.00', '885.00', '<p>hdghdgh</p>', 'asdasd', 'ghdgh', 'sdfsdf', 'dfgdfgdfg', 'fghdfh', 'dfghdh', 1),
(61, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 10:04:08', '1', '1', 1, 'dsdfdfsdf', 'fgsfdgsdfg', 'dfgsdfgsdfg', 1, 'Katty Suxe', 1, '2023-05-03 00:00:00', '250.00', '45.00', '295.00', '<p>gfhdfghdfgh</p>', 'ghdghdfgh', 'dfghdfghf', 'fghdfhfg', 'gfhdfghdfgh', 'gfhdfghdfgh', 'dfghdfh', 1),
(62, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 10:07:25', '1', '1', 1, 'sdfsdfsdf', 'sdfsdf', 'sdfsdfsdf', 1, 'Katty Suxe', 2, '2023-05-03 00:00:00', '1000.00', '180.00', '1180.00', '<p>fgfdgsdfgsdfgdf</p>', 'sgsgsdfgsdfg', 'fdgsdfgfds', 'sdfgsdfg', 'dfgsdfgsdfg', 'dsfgsdfg', 'dsfgsdfg', 1),
(63, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 12:35:15', '1', '1', 1, 'asdasdasd', '997307803', 'sdsadas', 2, 'Katty Suxe', 11, '2023-05-30 00:00:00', '250.00', '45.00', '295.00', '<p>sdasdasd</p>', 'asdfasdfasdf', 'asdasdsa', 'dasdasd', 'sdfsdfsdf', 'dfgdfgdfg', 'asdasdasd', 1),
(64, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-13 12:36:16', '1', '1', 1, 'fgfg', 'dfgdfg', 'dfgdfg', 5, 'Katty Suxe', 12, '2023-05-02 00:00:00', '250.00', '45.00', '295.00', '<p>dfgdfg</p>', 'dfgg', 'dfgg', 'dfgdgf', 'dfg', 'dfgg', 'dfgdfg', 1),
(65, 15, 2, '20505688903', 'AV. LOS CONQUISTADORES NRO. 638 INT. 201 LIMA - LIMA - SAN ISIDRO', 'AGRICOLA ANDREA S.A.C. ', '2023-05-15 08:56:03', '1', '1', 1, 'Miguel Hernandez', '997307803', 'Av los Jazminez 987', 1, 'Katty Suxe', 13, '2023-05-02 00:00:00', '750.00', '135.00', '885.00', '<p>aaaaaaaaaaaaaaaaa</p>', 'asdasd', 'aaa', 'aaaa', 'aaaaaaaaaaa', 'aaaaa', 'aaaaaa', 1),
(66, 15, 187, '20505688903', 'dfsdfsdfsdf', 'AGRICOLA ANDREA S.A.C. ', '2023-05-17 18:53:56', '1', '1', 1, 'asdasdasd', 'sdfsdf', 'dsfsdfsd', 2, 'Katty Suxe', 2, '0000-00-00 00:00:00', '250.00', '45.00', '295.00', '', '', '', '', '', '', '', 1);

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
  `descripcion` varchar(100) NOT NULL,
  `precio` decimal(8,2) DEFAULT NULL,
  `id_medida` int(11) NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

--
-- Volcado de datos para la tabla `tm_servicio`
--

INSERT INTO `tm_servicio` (`id_servicio`, `descripcion`, `precio`, `id_medida`, `estado`) VALUES
(1, 'LIMPIEZA Y DESINFECCIÓN DE CISTERNA DE AGUA', '250.00', 2, 1),
(2, 'LIMPIEZA DE TRAMPA DE GRASA\r\n', '250.00', 2, 1),
(3, 'LIMPIEZA DE POZO SÉPTICO\r\n', '250.00', 2, 1),
(4, 'DESATORO DE RED DE DESAGÜE\r\n', '250.00', 4, 1),
(5, 'LIMPIEZA DE CAMPANA EXTRACTORA\r\n', '250.00', 1, 1),
(6, 'LEVANTAMIENTO DE VMA', '250.00', 2, 1),
(7, 'DESINFECCIÓN', '250.00', 3, 1),
(8, 'DESINSECTACIÓN', '250.00', 3, 1),
(9, 'DESRATIZACIÓN\r\n', '250.00', 1, 1),
(10, 'CONTROL AVIAR', '250.00', 1, 1),
(11, 'MANTENIMIENTO/LIMPIEZA DE EQUIPOS PORTATILES', '250.00', 1, 1),
(12, 'REPARACION DE EQUIPOS PORTATILES', '250.00', 1, 1);

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
(321, 15, 1, 1, 'mouse', '<p>mouse para contabilidad</p>', 'Abierto', '2023-03-20 14:44:55', NULL, NULL, '2023-03-22 11:02:51', 1, 1),
(322, 15, 1, 2, 'Cambio de cable de monitor', '<p>urgente</p>', 'Abierto', '2023-03-24 18:26:09', NULL, NULL, NULL, 3, 1),
(323, 15, 1, 2, 'monitor en mal estado', '<p>urgente</p>', 'Abierto', '2023-03-30 10:22:14', NULL, NULL, NULL, 1, 1),
(324, 15, 3, 11, 'mm.jk.', '<p>gklgkl</p>', 'Cerrado', '2023-04-10 11:40:06', NULL, NULL, '2023-04-20 15:04:35', 2, 1),
(325, 15, 2, 3, 'pedio 202', '<p>se genero pedio 202</p>', 'Cerrado', '2023-04-17 12:42:51', NULL, NULL, '2023-04-17 12:45:56', 1, 1),
(326, 6, 2, 4, 'defsdf', '<p>sdfsdfsd</p>', 'Abierto', '2023-05-05 16:55:03', NULL, NULL, NULL, 2, 1),
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
(364, 15, 5, 28, 'defsdf', '<p>sadasd</p>', 'Abierto', '2023-05-13 12:32:33', NULL, NULL, NULL, 1, 1);

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
  `usu_nom` varchar(150) DEFAULT NULL,
  `usu_ape` varchar(150) DEFAULT NULL,
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
(9, 'Miguel', 'Verastegui Vilva', 'mdigital@sanipperu.com', '1111', 1, '2023-02-08 12:24:37', NULL, NULL, 1),
(11, 'Alfredo', 'Rodríguez Baltazar', 'administracion@sanipperu.com', '1111', 2, '2023-02-08 12:52:34', NULL, NULL, 1),
(13, 'Edgardo', 'Sanchez', 'esanchez@sanipperu.com', '1111', 2, '2023-02-08 16:15:33', NULL, NULL, 1),
(15, 'Katty', 'Suxe', 'contabilidad@sanipperu.com', '1111', 1, '2023-02-08 16:30:45', NULL, NULL, 1),
(17, 'Daniel', 'Silva', 'dan.msaj@gmail.com', '1111', 1, '2023-02-09 14:19:19', NULL, NULL, 1),
(26, 'sdfsdf', 'sdfsdf', 'sdfsdfsdf@dsfsdfsdfsd', 'b59c67bf196a4758191e', 1, '2023-02-09 17:14:09', NULL, '2023-02-11 13:03:40', 0),
(27, 'dfdsfd', 'sdfsdf', 'dan.msaj@gmail.com', 'd6e9c56d7f078d298ed4', 2, '2023-02-09 17:16:04', NULL, '2023-02-11 12:23:36', 0),
(28, 'rgtsfg', 'fgfdgdfg', 'ded@fsdsdf', '1111', 1, '2023-02-09 17:18:48', NULL, '2023-02-11 13:03:16', 0),
(29, 'uykyuky', 'yukyuk', 'sistemas@sanipperu.com', '0000', 1, '2023-02-09 17:35:34', NULL, '2023-02-11 13:04:01', 0),
(30, 'Miguel', 'ryrtyr', 'sistemas@sanipperu.com', '31dd4c392c98ad3d3030', 2, '2023-02-11 08:16:28', NULL, '2023-02-11 13:02:42', 0),
(31, 'asdasd', 'asdasd', 'administracion@sanipperu.com', 'asda', 2, '2023-02-11 08:48:45', NULL, '2023-02-11 12:24:20', 0),
(32, 'saaasa', 'Moscoso Silvaasdas', 'sistemas@sanipperu.com', '3f76818f507fe7eb6422', 2, '2023-02-11 08:49:58', NULL, '2023-02-11 13:03:21', 0),
(33, 'dfgdf', 'dfgh', 'dan-ms@hotmail.com', 'dfghdfhg', 2, '2023-02-11 08:50:23', NULL, '2023-02-11 12:24:41', 0),
(34, 'dsfsdfsd', 'fsdfsdfsd', 'sistemas@sanipperu.com', '111111', 1, '2023-02-11 08:50:51', NULL, '2023-02-11 12:23:41', 0),
(35, 'sdfsdfsd', 'fsdfsdf', 'sistemas@sanipperu.com', '1111', 1, '2023-02-11 08:57:01', NULL, '2023-02-11 13:03:50', 0),
(36, 'sdff', 'sdfsdf', 'dan-ms@hotmail.com', '0000', 2, '2023-02-11 08:58:21', NULL, '2023-02-11 13:03:34', 0),
(37, 'Miguel', 'sdfsdf', 'dan-ms@hotmail.com', '4a7d1ed414474e4033ac', 2, '2023-02-11 11:48:25', NULL, '2023-02-11 13:02:47', 0),
(38, 'dfgdg', 'dfgdfg', 'dan-ms@hotmail.com', '51d3ab6534b38f81ff65', 2, '2023-02-11 11:51:45', NULL, '2023-02-11 12:24:10', 0),
(39, 'ghjgh', 'ghjg', 'dan.msaj@gmail.com', '4a7d1ed414474e4033ac', 2, '2023-02-11 11:53:33', NULL, '2023-02-11 13:01:59', 0),
(40, 'sfsdf', 'sdfsdf', 'sdfdsf@defdff', 'd58e3582afa99040e27b', 2, '2023-02-11 12:23:04', NULL, '2023-02-11 13:03:57', 0),
(41, 'sdfsdf', 'sdfsdf', 'coordinadoradministrativo@sanipperu.com', '4a7d1ed414474e4033ac', 2, '2023-02-11 12:24:04', NULL, '2023-02-11 13:03:44', 0),
(42, 'fsdfsdf', 'sdfsdf', 'dan-ms@hotmail.com', 'bcbe3365e6ac95ea2c03', 2, '2023-02-11 12:24:33', NULL, '2023-02-11 12:24:47', 0),
(43, 'sdsdf', 'sdfsdf', 'sistemas@sanipperu.com', 'd93591bdf7860e1e4ee2', 2, '2023-02-11 12:25:00', NULL, '2023-02-11 13:03:53', 0),
(44, 'arte', 'sdfsf', 'dan.msaj@gmail.com', '4a7d1ed414474e4033ac', 2, '2023-02-11 13:00:36', NULL, '2023-02-11 13:01:42', 0),
(45, 'sdfdsf', 'sdfsdf', 'dan-ms@hotmail.com', '4a7d1ed414474e4033ac', 2, '2023-02-11 13:00:59', NULL, '2023-02-11 13:03:31', 0),
(46, 'ssdfsdf', 'sdfsdf', 'dan.msaj@gmail.com', 'b59c67bf196a4758191e', 2, '2023-02-13 08:18:05', NULL, '2023-02-13 08:18:10', 0),
(47, 'dsfdsf', 'sdfsfsd', 'dan.msaj@gmail.com', '81dc9bdb52d04dc20036', 2, '2023-02-13 09:09:55', NULL, '2023-02-21 17:25:40', 0),
(48, 'alex', 'Moncada Rios', 'dan.msaj@gmail.com', '1231', 1, '2023-02-13 09:10:23', NULL, NULL, 1),
(49, 'Richard', 'Echevarria', 'ssoma@sanipperu.com', 'b59c67bf196a4758191e', 1, '2023-02-23 16:38:59', NULL, NULL, 1),
(50, 'Nestor', 'Yalta Huaman', 'eyalta@sanipperu.com', 'b59c67bf196a4758191e', 1, '2023-02-24 10:57:03', NULL, NULL, 1),
(51, 'Heidy', 'Yalta', 'hyalta@sanipperu.com', 'b59c67bf196a4758191e', 2, '2023-02-27 10:40:45', NULL, NULL, 1),
(52, 'ASDASDASDASD', 'ASDASDASD', 'contabilidad@sanipperu.com', '6f6c36665338cceff495', 2, '2023-04-28 12:50:00', NULL, NULL, 1),
(53, 'ASDASDASDASD', 'ASDASDASD', 'contabilidad@sanipperu.com', '6f6c36665338cceff495', 1, '2023-04-28 12:50:30', NULL, NULL, 1),
(54, 'ASDASDASDASD', 'ASDASDASD', 'ASDASDASD64@EFWEFWE', '6f6c36665338cceff495', 2, '2023-04-28 12:51:12', NULL, NULL, 1),
(55, 'ghfhfg', 'hfghgfh', 'contabilidad@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-11 08:58:58', NULL, NULL, 1),
(56, 'ASDASDASDASD', 'ASDASDASD', 'contabilidad@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 08:51:04', NULL, NULL, 1),
(57, 'ASDASDASDASD', 'ASDASDASD', 'contabilidad@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 08:51:34', NULL, NULL, 1),
(58, 'sdfsdf', 'sdfsdf', 'sistemas@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 08:51:47', NULL, NULL, 1),
(59, 'sdfsdf', 'sdfsdf', 'sistemas@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 08:51:50', NULL, NULL, 1),
(60, 'sdfsdf', 'sdfsdf', 'sistemas@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 08:51:51', NULL, NULL, 1),
(61, 'ASDASDASDASD', 'hfghgfh', 'contabilidad@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 08:52:25', NULL, NULL, 1),
(62, 'ASDASDASDASD', 'hfghgfh', 'contabilidad@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 08:52:26', NULL, NULL, 1),
(63, 'ASDASDASDASD', 'ASDASDASD', 'sistemas@sanipperu.com', '6f6c36665338cceff495', 1, '2023-05-13 08:53:21', NULL, NULL, 1),
(64, 'ASDASDASDASD', 'ASDASDASD', 'sistemas@sanipperu.com', '81dc9bdb52d04dc20036', 2, '2023-05-13 08:56:54', NULL, NULL, 1),
(65, 'yanira', 'ASDASDASD', 'sistemas@sanipperu.com', '81dc9bdb52d04dc20036', 1, '2023-05-13 09:23:12', NULL, NULL, 1);

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
-- Indices de la tabla `tm_departamento`
--
ALTER TABLE `tm_departamento`
  ADD PRIMARY KEY (`id_departamento`);

--
-- Indices de la tabla `tm_distrito`
--
ALTER TABLE `tm_distrito`
  ADD PRIMARY KEY (`id_distrito`);

--
-- Indices de la tabla `tm_modeloportatil`
--
ALTER TABLE `tm_modeloportatil`
  ADD PRIMARY KEY (`id_modelo`);

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
  MODIFY `id_detpedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `td_ticketdetalle`
--
ALTER TABLE `td_ticketdetalle`
  MODIFY `tickd_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT de la tabla `tipo_servicio`
--
ALTER TABLE `tipo_servicio`
  MODIFY `id_modalidad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tm_cliente`
--
ALTER TABLE `tm_cliente`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=204;

--
-- AUTO_INCREMENT de la tabla `tm_concredito`
--
ALTER TABLE `tm_concredito`
  MODIFY `id_ccredito` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tm_departamento`
--
ALTER TABLE `tm_departamento`
  MODIFY `id_departamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `tm_distrito`
--
ALTER TABLE `tm_distrito`
  MODIFY `id_distrito` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1832;

--
-- AUTO_INCREMENT de la tabla `tm_modeloportatil`
--
ALTER TABLE `tm_modeloportatil`
  MODIFY `id_modelo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tm_pedido`
--
ALTER TABLE `tm_pedido`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

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
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  MODIFY `cats_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  MODIFY `tick_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=365;

--
-- AUTO_INCREMENT de la tabla `tm_tipodocumento`
--
ALTER TABLE `tm_tipodocumento`
  MODIFY `tipodoc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tm_umedida`
--
ALTER TABLE `tm_umedida`
  MODIFY `id_medida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
