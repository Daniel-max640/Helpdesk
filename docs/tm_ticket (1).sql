-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-02-2023 a las 23:34:01
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
(297, 51, 1, 2, 'Laptop Averiada', 'Solicitud de nuevo equipo.', 'Cerrado', '2023-02-27 11:21:14', 3, '2023-02-27 11:21:36', NULL, NULL, 1),
(298, 1, 5, 2, 'Hosting y dominio', '<p>Adquisición de hosting y dominio.</p>', 'Cerrado', '2023-02-27 11:23:26', 50, '2023-02-27 11:23:36', NULL, NULL, 1),
(303, 1, 2, 3, 'Test', '<p>dasdasdasd</p>', 'Cerrado', '2023-02-27 15:07:06', 3, '2023-02-27 15:53:31', '2023-02-27 16:20:43', NULL, 1),
(304, 1, 1, 1, 'sdfsdf', '<p>sdfsf</p>', 'Abierto', '2023-02-27 15:19:04', NULL, NULL, NULL, NULL, 1),
(305, 1, 3, 11, 'ASDASD', '<p>sdfsdf</p>', 'Abierto', '2023-02-27 15:20:48', NULL, NULL, NULL, NULL, 1),
(306, 1, 3, 11, 'ASDASD', '<p>asdasd</p>', 'Abierto', '2023-02-27 15:21:13', NULL, NULL, NULL, NULL, 1),
(307, 1, 1, 1, 'adasd', '<p>asdasd</p>', 'Abierto', '2023-02-27 15:21:57', NULL, NULL, NULL, NULL, 1),
(309, 1, 1, 1, 'dzcasc', '<p>asdsadasdsadsadsadas</p>', 'Cerrado', '2023-02-27 15:43:10', NULL, NULL, NULL, NULL, 1),
(310, 1, 1, 2, 'fadf', '<p>dfsdfdf</p>', 'Abierto', '2023-02-27 16:01:21', NULL, NULL, NULL, NULL, 1),
(311, 1, 2, 3, 'Test', '<p>asdqdaw</p>', 'Abierto', '2023-02-27 17:25:18', NULL, NULL, NULL, 1, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  ADD PRIMARY KEY (`tick_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  MODIFY `tick_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=312;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
