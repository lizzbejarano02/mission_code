-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: plataforma_gamificada_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add blacklisted token',6,'add_blacklistedtoken'),(22,'Can change blacklisted token',6,'change_blacklistedtoken'),(23,'Can delete blacklisted token',6,'delete_blacklistedtoken'),(24,'Can view blacklisted token',6,'view_blacklistedtoken'),(25,'Can add outstanding token',7,'add_outstandingtoken'),(26,'Can change outstanding token',7,'change_outstandingtoken'),(27,'Can delete outstanding token',7,'delete_outstandingtoken'),(28,'Can view outstanding token',7,'view_outstandingtoken'),(29,'Can add Usuario',8,'add_usuario'),(30,'Can change Usuario',8,'change_usuario'),(31,'Can delete Usuario',8,'delete_usuario'),(32,'Can view Usuario',8,'view_usuario'),(33,'Can add Insignia',9,'add_insignia'),(34,'Can change Insignia',9,'change_insignia'),(35,'Can delete Insignia',9,'delete_insignia'),(36,'Can view Insignia',9,'view_insignia'),(37,'Can add Insignia de usuario',10,'add_usuarioinsignia'),(38,'Can change Insignia de usuario',10,'change_usuarioinsignia'),(39,'Can delete Insignia de usuario',10,'delete_usuarioinsignia'),(40,'Can view Insignia de usuario',10,'view_usuarioinsignia'),(41,'Can add Mision',11,'add_mision'),(42,'Can change Mision',11,'change_mision'),(43,'Can delete Mision',11,'delete_mision'),(44,'Can view Mision',11,'view_mision'),(45,'Can add Nivel',12,'add_nivel'),(46,'Can change Nivel',12,'change_nivel'),(47,'Can delete Nivel',12,'delete_nivel'),(48,'Can view Nivel',12,'view_nivel'),(49,'Can add Pregunta',13,'add_pregunta'),(50,'Can change Pregunta',13,'change_pregunta'),(51,'Can delete Pregunta',13,'delete_pregunta'),(52,'Can view Pregunta',13,'view_pregunta'),(53,'Can add Respuesta',14,'add_respuesta'),(54,'Can change Respuesta',14,'change_respuesta'),(55,'Can delete Respuesta',14,'delete_respuesta'),(56,'Can view Respuesta',14,'view_respuesta'),(57,'Can add Respuesta de usuario',15,'add_respuestausuario'),(58,'Can change Respuesta de usuario',15,'change_respuestausuario'),(59,'Can delete Respuesta de usuario',15,'delete_respuestausuario'),(60,'Can view Respuesta de usuario',15,'view_respuestausuario'),(61,'Can add Ranking',16,'add_ranking'),(62,'Can change Ranking',16,'change_ranking'),(63,'Can delete Ranking',16,'delete_ranking'),(64,'Can view Ranking',16,'view_ranking'),(65,'Can add Estadistica',17,'add_estadistica'),(66,'Can change Estadistica',17,'change_estadistica'),(67,'Can delete Estadistica',17,'delete_estadistica'),(68,'Can view Estadistica',17,'view_estadistica'),(69,'Can add Progreso de usuario',18,'add_progresousuario'),(70,'Can change Progreso de usuario',18,'change_progresousuario'),(71,'Can delete Progreso de usuario',18,'delete_progresousuario'),(72,'Can view Progreso de usuario',18,'view_progresousuario'),(73,'Can add Recomendacion',19,'add_recomendacion'),(74,'Can change Recomendacion',19,'change_recomendacion'),(75,'Can delete Recomendacion',19,'delete_recomendacion'),(76,'Can view Recomendacion',19,'view_recomendacion'),(77,'Can add Notificacion',20,'add_notificacion'),(78,'Can change Notificacion',20,'change_notificacion'),(79,'Can delete Notificacion',20,'delete_notificacion'),(80,'Can view Notificacion',20,'view_notificacion'),(81,'Can add Mensaje de chat',21,'add_mensajechat'),(82,'Can change Mensaje de chat',21,'change_mensajechat'),(83,'Can delete Mensaje de chat',21,'delete_mensajechat'),(84,'Can view Mensaje de chat',21,'view_mensajechat');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_usuarios_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_usuarios_id` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-05-21 05:22:04.811734','3','Jaider Uquijo (jaiderurquijo06@gmail.com) - DOCENTE',1,'[{\"added\": {}}]',8,1),(2,'2026-05-21 05:23:14.478228','3','Jaider Uquijo (jaiderurquijo06@gmail.com) - DOCENTE',2,'[{\"changed\": {\"fields\": [\"Codigo universitario\", \"Carrera\", \"Is staff\"]}}]',8,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(21,'assistant','mensajechat'),(20,'assistant','notificacion'),(19,'assistant','recomendacion'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(11,'game','mision'),(12,'game','nivel'),(13,'game','pregunta'),(14,'game','respuesta'),(15,'game','respuestausuario'),(17,'progress','estadistica'),(18,'progress','progresousuario'),(16,'progress','ranking'),(5,'sessions','session'),(6,'token_blacklist','blacklistedtoken'),(7,'token_blacklist','outstandingtoken'),(9,'users','insignia'),(8,'users','usuario'),(10,'users','usuarioinsignia');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-05-21 04:45:25.084157'),(2,'contenttypes','0002_remove_content_type_name','2026-05-21 04:45:25.295191'),(3,'auth','0001_initial','2026-05-21 04:45:25.988314'),(4,'auth','0002_alter_permission_name_max_length','2026-05-21 04:45:26.148758'),(5,'auth','0003_alter_user_email_max_length','2026-05-21 04:45:26.161166'),(6,'auth','0004_alter_user_username_opts','2026-05-21 04:45:26.174871'),(7,'auth','0005_alter_user_last_login_null','2026-05-21 04:45:26.188501'),(8,'auth','0006_require_contenttypes_0002','2026-05-21 04:45:26.196739'),(9,'auth','0007_alter_validators_add_error_messages','2026-05-21 04:45:26.209606'),(10,'auth','0008_alter_user_username_max_length','2026-05-21 04:45:26.223615'),(11,'auth','0009_alter_user_last_name_max_length','2026-05-21 04:45:26.238653'),(12,'auth','0010_alter_group_name_max_length','2026-05-21 04:45:26.268911'),(13,'auth','0011_update_proxy_permissions','2026-05-21 04:45:26.285527'),(14,'auth','0012_alter_user_first_name_max_length','2026-05-21 04:45:26.304551'),(15,'users','0001_initial','2026-05-21 04:45:27.422719'),(16,'admin','0001_initial','2026-05-21 04:45:27.724558'),(17,'admin','0002_logentry_remove_auto_add','2026-05-21 04:45:27.738299'),(18,'admin','0003_logentry_add_action_flag_choices','2026-05-21 04:45:27.754478'),(19,'assistant','0001_initial','2026-05-21 04:45:28.209732'),(20,'game','0001_initial','2026-05-21 04:45:29.176557'),(21,'progress','0001_initial','2026-05-21 04:45:30.132608'),(22,'sessions','0001_initial','2026-05-21 04:45:30.203738'),(23,'token_blacklist','0001_initial','2026-05-21 04:45:30.572691'),(24,'token_blacklist','0002_outstandingtoken_jti_hex','2026-05-21 04:45:30.685364'),(25,'token_blacklist','0003_auto_20171017_2007','2026-05-21 04:45:30.719904'),(26,'token_blacklist','0004_auto_20171017_2013','2026-05-21 04:45:30.874193'),(27,'token_blacklist','0005_remove_outstandingtoken_jti','2026-05-21 04:45:31.030485'),(28,'token_blacklist','0006_auto_20171017_2113','2026-05-21 04:45:31.087559'),(29,'token_blacklist','0007_auto_20171017_2214','2026-05-21 04:45:31.515130'),(30,'token_blacklist','0008_migrate_to_bigautofield','2026-05-21 04:45:32.050516'),(31,'token_blacklist','0010_fix_migrate_to_bigautofield','2026-05-21 04:45:32.083243'),(32,'token_blacklist','0011_linearizes_history','2026-05-21 04:45:32.090668'),(33,'token_blacklist','0012_alter_outstandingtoken_user','2026-05-21 04:45:32.120441');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estadisticas`
--

DROP TABLE IF EXISTS `estadisticas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estadisticas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `total_preguntas_respondidas` int unsigned NOT NULL,
  `total_preguntas_correctas` int unsigned NOT NULL,
  `total_preguntas_incorrectas` int unsigned NOT NULL,
  `total_misiones_completadas` int unsigned NOT NULL,
  `total_niveles_completados` int unsigned NOT NULL,
  `total_puntos` int unsigned NOT NULL,
  `porcentaje_aciertos` decimal(5,2) NOT NULL,
  `tiempo_total_minutos` int unsigned NOT NULL,
  `fecha_actualizacion` datetime(6) NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `estadisticas_usuario_id_d6b3baa9_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `estadisticas_chk_1` CHECK ((`total_preguntas_respondidas` >= 0)),
  CONSTRAINT `estadisticas_chk_2` CHECK ((`total_preguntas_correctas` >= 0)),
  CONSTRAINT `estadisticas_chk_3` CHECK ((`total_preguntas_incorrectas` >= 0)),
  CONSTRAINT `estadisticas_chk_4` CHECK ((`total_misiones_completadas` >= 0)),
  CONSTRAINT `estadisticas_chk_5` CHECK ((`total_niveles_completados` >= 0)),
  CONSTRAINT `estadisticas_chk_6` CHECK ((`total_puntos` >= 0)),
  CONSTRAINT `estadisticas_chk_7` CHECK ((`tiempo_total_minutos` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estadisticas`
--

LOCK TABLES `estadisticas` WRITE;
/*!40000 ALTER TABLE `estadisticas` DISABLE KEYS */;
INSERT INTO `estadisticas` VALUES (1,0,0,0,0,0,0,0.00,0,'2026-05-22 23:02:03.307429',3),(2,0,0,0,0,0,0,0.00,0,'2026-05-22 23:03:41.837337',2),(3,0,0,0,0,0,0,0.00,0,'2026-05-23 00:05:11.225190',5);
/*!40000 ALTER TABLE `estadisticas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insignias`
--

DROP TABLE IF EXISTS `insignias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insignias` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `icono` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `puntos_requeridos` int unsigned NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `insignias_chk_1` CHECK ((`puntos_requeridos` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insignias`
--

LOCK TABLES `insignias` WRITE;
/*!40000 ALTER TABLE `insignias` DISABLE KEYS */;
/*!40000 ALTER TABLE `insignias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mensajes_chat`
--

DROP TABLE IF EXISTS `mensajes_chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensajes_chat` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `remitente` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_envio` datetime(6) NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mensajes_chat_usuario_id_431b59e0_fk_usuarios_id` (`usuario_id`),
  CONSTRAINT `mensajes_chat_usuario_id_431b59e0_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mensajes_chat`
--

LOCK TABLES `mensajes_chat` WRITE;
/*!40000 ALTER TABLE `mensajes_chat` DISABLE KEYS */;
INSERT INTO `mensajes_chat` VALUES (1,'USUARIO','hola','2026-05-22 23:10:01.128217',2),(2,'ASISTENTE','¡Hola Camilo Urquijo! Soy tu asistente de Ingenieria de Software. ¿En que puedo ayudarte hoy?','2026-05-22 23:10:01.140625',2),(3,'USUARIO','q me recomiendas estudiar','2026-05-22 23:10:24.856504',2),(4,'ASISTENTE','Gracias por tu pregunta sobre \"q me recomiendas estudiar\". Estoy aqui para apoyarte en tu aprendizaje de Ingenieria de Software. ¡Explora las misiones disponibles!','2026-05-22 23:10:24.866097',2),(5,'USUARIO','ya las explore pero entonces soy malo en ciclos','2026-05-22 23:10:53.262251',2),(6,'ASISTENTE','Gracias por tu pregunta sobre \"ya las explore pero entonces soy malo en ciclos\". Estoy aqui para apoyarte en tu aprendizaje de Ingenieria de Software. ¡Explora las misiones disponibles!','2026-05-22 23:10:53.285851',2),(7,'USUARIO','hola','2026-05-22 23:59:27.588456',1),(8,'ASISTENTE','¡Hola Administrador Principal! Soy tu asistente de Ingenieria de Software. ¿En que puedo ayudarte hoy?','2026-05-22 23:59:27.598801',1);
/*!40000 ALTER TABLE `mensajes_chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `misiones`
--

DROP TABLE IF EXISTS `misiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `misiones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `dificultad` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `puntos_recompensa` int unsigned NOT NULL,
  `orden` int unsigned NOT NULL,
  `activo` tinyint(1) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `fecha_actualizacion` datetime(6) NOT NULL,
  `nivel_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `misiones_nivel_id_007d15a0_fk_niveles_id` (`nivel_id`),
  CONSTRAINT `misiones_nivel_id_007d15a0_fk_niveles_id` FOREIGN KEY (`nivel_id`) REFERENCES `niveles` (`id`),
  CONSTRAINT `misiones_chk_1` CHECK ((`puntos_recompensa` >= 0)),
  CONSTRAINT `misiones_chk_2` CHECK ((`orden` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `misiones`
--

LOCK TABLES `misiones` WRITE;
/*!40000 ALTER TABLE `misiones` DISABLE KEYS */;
INSERT INTO `misiones` VALUES (1,'Misión Introducción','Aprender conceptos básicos de ingeniería de software','FACIL',50,1,1,'2026-05-25 13:22:02.674329','2026-05-25 13:22:02.674453',1);
/*!40000 ALTER TABLE `misiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `niveles`
--

DROP TABLE IF EXISTS `niveles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `niveles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `orden` int unsigned NOT NULL,
  `puntos_requeridos` int unsigned NOT NULL,
  `imagen` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `fecha_actualizacion` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `niveles_chk_1` CHECK ((`orden` >= 0)),
  CONSTRAINT `niveles_chk_2` CHECK ((`puntos_requeridos` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles`
--

LOCK TABLES `niveles` WRITE;
/*!40000 ALTER TABLE `niveles` DISABLE KEYS */;
INSERT INTO `niveles` VALUES (1,'Nivel 1','Introducción a Ingeniería de Software',1,0,'',1,'2026-05-25 00:41:55.654466','2026-05-25 00:41:55.654570');
/*!40000 ALTER TABLE `niveles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tipo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `leida` tinyint(1) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notificaciones_usuario_id_a75f5971_fk_usuarios_id` (`usuario_id`),
  CONSTRAINT `notificaciones_usuario_id_a75f5971_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntas`
--

DROP TABLE IF EXISTS `preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preguntas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enunciado` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `puntos` int unsigned NOT NULL,
  `orden` int unsigned NOT NULL,
  `activo` tinyint(1) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `mision_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `preguntas_mision_id_e0a3ad05_fk_misiones_id` (`mision_id`),
  CONSTRAINT `preguntas_mision_id_e0a3ad05_fk_misiones_id` FOREIGN KEY (`mision_id`) REFERENCES `misiones` (`id`),
  CONSTRAINT `preguntas_chk_1` CHECK ((`puntos` >= 0)),
  CONSTRAINT `preguntas_chk_2` CHECK ((`orden` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas`
--

LOCK TABLES `preguntas` WRITE;
/*!40000 ALTER TABLE `preguntas` DISABLE KEYS */;
INSERT INTO `preguntas` VALUES (1,'¿Qué es Django?','SELECCION_MULTIPLE','',10,1,1,'2026-05-25 13:26:31.770000',1);
/*!40000 ALTER TABLE `preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progreso_usuario`
--

DROP TABLE IF EXISTS `progreso_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progreso_usuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `porcentaje_completado` decimal(5,2) NOT NULL,
  `puntos_ganados` int unsigned NOT NULL,
  `intentos` int unsigned NOT NULL,
  `fecha_inicio` datetime(6) DEFAULT NULL,
  `fecha_completado` datetime(6) DEFAULT NULL,
  `ultima_actividad` datetime(6) NOT NULL,
  `mision_id` bigint NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `progreso_usuario_usuario_id_mision_id_a8d2925b_uniq` (`usuario_id`,`mision_id`),
  KEY `progreso_usuario_mision_id_d77ef412_fk_misiones_id` (`mision_id`),
  CONSTRAINT `progreso_usuario_mision_id_d77ef412_fk_misiones_id` FOREIGN KEY (`mision_id`) REFERENCES `misiones` (`id`),
  CONSTRAINT `progreso_usuario_usuario_id_7884b8d2_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `progreso_usuario_chk_1` CHECK ((`puntos_ganados` >= 0)),
  CONSTRAINT `progreso_usuario_chk_2` CHECK ((`intentos` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progreso_usuario`
--

LOCK TABLES `progreso_usuario` WRITE;
/*!40000 ALTER TABLE `progreso_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `progreso_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ranking`
--

DROP TABLE IF EXISTS `ranking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ranking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `posicion` int unsigned NOT NULL,
  `puntos` int unsigned NOT NULL,
  `fecha_actualizacion` datetime(6) NOT NULL,
  `nivel_actual_id` bigint DEFAULT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  KEY `ranking_nivel_actual_id_2fe6075c_fk_niveles_id` (`nivel_actual_id`),
  CONSTRAINT `ranking_nivel_actual_id_2fe6075c_fk_niveles_id` FOREIGN KEY (`nivel_actual_id`) REFERENCES `niveles` (`id`),
  CONSTRAINT `ranking_usuario_id_ca62f26c_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `ranking_chk_1` CHECK ((`posicion` >= 0)),
  CONSTRAINT `ranking_chk_2` CHECK ((`puntos` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ranking`
--

LOCK TABLES `ranking` WRITE;
/*!40000 ALTER TABLE `ranking` DISABLE KEYS */;
/*!40000 ALTER TABLE `ranking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recomendaciones`
--

DROP TABLE IF EXISTS `recomendaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recomendaciones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tipo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `leida` tinyint(1) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recomendaciones_usuario_id_a82ad105_fk_usuarios_id` (`usuario_id`),
  CONSTRAINT `recomendaciones_usuario_id_a82ad105_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recomendaciones`
--

LOCK TABLES `recomendaciones` WRITE;
/*!40000 ALTER TABLE `recomendaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `recomendaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestas`
--

DROP TABLE IF EXISTS `respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respuestas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `texto` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `es_correcta` tinyint(1) NOT NULL,
  `retroalimentacion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `orden` int unsigned NOT NULL,
  `pregunta_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `respuestas_pregunta_id_17515b22_fk_preguntas_id` (`pregunta_id`),
  CONSTRAINT `respuestas_pregunta_id_17515b22_fk_preguntas_id` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`id`),
  CONSTRAINT `respuestas_chk_1` CHECK ((`orden` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas`
--

LOCK TABLES `respuestas` WRITE;
/*!40000 ALTER TABLE `respuestas` DISABLE KEYS */;
INSERT INTO `respuestas` VALUES (1,'Django es un framework backend',1,'Muy bien, respuesta correcta',1,1);
/*!40000 ALTER TABLE `respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestas_usuario`
--

DROP TABLE IF EXISTS `respuestas_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respuestas_usuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `es_correcta` tinyint(1) NOT NULL,
  `puntos_obtenidos` int unsigned NOT NULL,
  `fecha_respuesta` datetime(6) NOT NULL,
  `pregunta_id` bigint NOT NULL,
  `respuesta_elegida_id` bigint NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `respuestas_usuario_pregunta_id_21cfca67_fk_preguntas_id` (`pregunta_id`),
  KEY `respuestas_usuario_respuesta_elegida_id_947cf3a3_fk_respuesta` (`respuesta_elegida_id`),
  KEY `respuestas_usuario_usuario_id_a7a03c0f_fk_usuarios_id` (`usuario_id`),
  CONSTRAINT `respuestas_usuario_pregunta_id_21cfca67_fk_preguntas_id` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`id`),
  CONSTRAINT `respuestas_usuario_respuesta_elegida_id_947cf3a3_fk_respuesta` FOREIGN KEY (`respuesta_elegida_id`) REFERENCES `respuestas` (`id`),
  CONSTRAINT `respuestas_usuario_usuario_id_a7a03c0f_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `respuestas_usuario_chk_1` CHECK ((`puntos_obtenidos` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas_usuario`
--

LOCK TABLES `respuestas_usuario` WRITE;
/*!40000 ALTER TABLE `respuestas_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `respuestas_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_blacklistedtoken`
--

DROP TABLE IF EXISTS `token_blacklist_blacklistedtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_blacklistedtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_id` (`token_id`),
  CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_blacklistedtoken`
--

LOCK TABLES `token_blacklist_blacklistedtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_outstandingtoken`
--

DROP TABLE IF EXISTS `token_blacklist_outstandingtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_outstandingtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `jti` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq` (`jti`),
  KEY `token_blacklist_outstandingtoken_user_id_83bc629a_fk_usuarios_id` (`user_id`),
  CONSTRAINT `token_blacklist_outstandingtoken_user_id_83bc629a_fk_usuarios_id` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_outstandingtoken`
--

LOCK TABLES `token_blacklist_outstandingtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_outstandingtoken` VALUES (1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3OTk0NDUyMiwiaWF0IjoxNzc5MzM5NzIyLCJqdGkiOiI2OTc0NTBmNGRhNjM0NjQwYmQyNmI3ZTgwMzM2ZGU4NCIsInVzZXJfaWQiOjJ9.JNx4vWbFcouGjywjgbaWYgxNOeVAF9uU9vKcgApWelY','2026-05-21 05:02:02.796527','2026-05-28 05:02:02.000000',2,'697450f4da634640bd26b7e80336de84'),(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3OTk0NDcwMSwiaWF0IjoxNzc5MzM5OTAxLCJqdGkiOiI1YmYzZGFhZjYxODg0ZmJlYWRlMzZlNzQyYWQzZWRjNyIsInVzZXJfaWQiOjJ9.GUSVIliLMEhQIhbg2XqEThkV0R3-w2OiH0JYKYWvgsg','2026-05-21 05:05:01.130456','2026-05-28 05:05:01.000000',2,'5bf3daaf61884fbeade36e742ad3edc7'),(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3OTk3NzMwNSwiaWF0IjoxNzc5MzcyNTA1LCJqdGkiOiIzMjU5MWI5ZTdjZDg0NjQyYTJlM2RkNDA0MzRkNzRhMSIsInVzZXJfaWQiOjF9.eUSfat_L2YKAXV9LlwGFFoeYGliaZanyY52dSHMwAWs','2026-05-21 14:08:25.507145','2026-05-28 14:08:25.000000',1,'32591b9e7cd84642a2e3dd40434d74a1'),(4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3OTk3NzQyOCwiaWF0IjoxNzc5MzcyNjI4LCJqdGkiOiI5MDE5ZTg4NWI3MmI0NmVmYTY1NjY1MTQ2YzczNzQwYSIsInVzZXJfaWQiOjJ9.bxLci-UtL1kGbVFAtbRm8BAKUcvfAZfzUtHd0ZN1KQk','2026-05-21 14:10:28.734255','2026-05-28 14:10:28.000000',2,'9019e885b72b46efa65665146c73740a'),(5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3OTk3NzUwNiwiaWF0IjoxNzc5MzcyNzA2LCJqdGkiOiJkMTkyNTU2MmRmMTk0MTMzOTgxOTcxMTgwNzk5Yjc1MyIsInVzZXJfaWQiOjN9.ScpIOJZJhHMxRTez8j2QahcWCB2u89QBprcZ704l7jI','2026-05-21 14:11:46.956618','2026-05-28 14:11:46.000000',3,'d1925562df194133981971180799b753'),(6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3OTk3ODA5NiwiaWF0IjoxNzc5MzczMjk2LCJqdGkiOiJmZWQ0MzU1Y2ZjMzk0Y2Q1YTJlMmY3MjlmMDZlMDg1OCIsInVzZXJfaWQiOjR9.QDDzDg6ig5mdkOj3CZbGXf6Z0X0VyKWjjbwRwrra_Tg','2026-05-21 14:21:36.074595','2026-05-28 14:21:36.000000',4,'fed4355cfc394cd5a2e2f729f06e0858'),(7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDA5NTU2NSwiaWF0IjoxNzc5NDkwNzY1LCJqdGkiOiI1N2FhMjU3ZGJlZGI0MWE5ODkwZTAzMjc5Yzc0OWYxZCIsInVzZXJfaWQiOjF9.NG168LklfJvLAuqDK0B_DS7FgvvR61SH9UEo-zlK4X8','2026-05-22 22:59:25.712878','2026-05-29 22:59:25.000000',1,'57aa257dbedb41a9890e03279c749f1d'),(8,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDA5NTcyMSwiaWF0IjoxNzc5NDkwOTIxLCJqdGkiOiJjY2VhNzI2NTNjYzc0YzljYTIwOTU1OTVlOGRhZDM0ZCIsInVzZXJfaWQiOjN9.dTUIx_TiGPH336CKcFpXDGtM1WremczRoLzvo_FZftA','2026-05-22 23:02:01.361742','2026-05-29 23:02:01.000000',3,'ccea72653cc74c9ca2095595e8dad34d'),(9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDA5NTgyMCwiaWF0IjoxNzc5NDkxMDIwLCJqdGkiOiIyOTY5MTY1ZmQ2MWU0M2IyYTJmYWRiNWVhZmY0OWYxMSIsInVzZXJfaWQiOjJ9.2VZyCne_wUwPxlYYTMfJRJbzqQuh3fJMArAYidJl1gc','2026-05-22 23:03:40.900394','2026-05-29 23:03:40.000000',2,'2969165fd61e43b2a2fadb5eaff49f11'),(10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDA5ODkzOCwiaWF0IjoxNzc5NDk0MTM4LCJqdGkiOiIxODc5ZTFlNDBjMDM0NjVhOWY2NzQwNjE4YjA5N2NkMiIsInVzZXJfaWQiOjF9.dYb1abfOFlveStuWTM8XBKovmTXEAGKEcT8o3np-Ei0','2026-05-22 23:55:38.145467','2026-05-29 23:55:38.000000',1,'1879e1e40c03465a9f6740618b097cd2'),(11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDA5OTA4NCwiaWF0IjoxNzc5NDk0Mjg0LCJqdGkiOiJhNDI1NTU4MzBhZjA0ZDM3OWNmMDU5NTZlYzU2ZmQzYyIsInVzZXJfaWQiOjF9.5zWSTfxmwviNPF-1tUVB6JCnEAzXDnWrEZSrjdujBCg','2026-05-22 23:58:04.098652','2026-05-29 23:58:04.000000',1,'a42555830af04d379cf05956ec56fd3c'),(12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDA5OTUxMCwiaWF0IjoxNzc5NDk0NzEwLCJqdGkiOiIwM2YxMTgxY2MyM2I0OWY2OTI2ZjllMDY1NWRmZWNiOSIsInVzZXJfaWQiOjV9.8OuN0J6-Xf0HF4HuaZ2W7aX2YhUVIW829hycdukIgN4','2026-05-23 00:05:10.779761','2026-05-30 00:05:10.000000',5,'03f1181cc23b49f6926f9e0655dfecb9'),(13,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI2NTg1NiwiaWF0IjoxNzc5NjYxMDU2LCJqdGkiOiIwZmY4MTUzN2ZiZGY0ZjMzYjk1Y2ViOWY2OTgxNTY0ZSIsInVzZXJfaWQiOjF9.LoPSyokqQ4sA5kjE9ipZM1FbckynOIhrY0MWgpJDWxE','2026-05-24 22:17:36.156413','2026-05-31 22:17:36.000000',1,'0ff81537fbdf4f33b95ceb9f6981564e'),(14,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI2NjE0NSwiaWF0IjoxNzc5NjYxMzQ1LCJqdGkiOiI0MTAxZTNhZmEyOTU0YTE1OTI3MjBmNWNhOTQ2ZTQwZCIsInVzZXJfaWQiOjJ9.IouLFQwVmcml-6qKm1A9P3Bhqlv59DTJ5z_uZvz8HrI','2026-05-24 22:22:25.537969','2026-05-31 22:22:25.000000',2,'4101e3afa2954a1592720f5ca946e40d'),(15,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI2NjI0OSwiaWF0IjoxNzc5NjYxNDQ5LCJqdGkiOiI2MWJmN2E5MjI1YzQ0YzM4YTRhNjg2N2RmMDllNmM2ZCIsInVzZXJfaWQiOjF9.g8Lx0DsVRtz-mpWsbaY5mpu5NrmICow0mdhrMgs9YF4','2026-05-24 22:24:09.957387','2026-05-31 22:24:09.000000',1,'61bf7a9225c44c38a4a6867df09e6c6d'),(16,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI2NjM3MiwiaWF0IjoxNzc5NjYxNTcyLCJqdGkiOiJmZWIyMTFiMDIyYTE0ZTllOGZhMjRiMjU0ZjQ1YWNlMiIsInVzZXJfaWQiOjN9.nVvXNMjRGammiu8wDs9ZAC6MeN8JOyx0fbiMXvZ5B2k','2026-05-24 22:26:12.997425','2026-05-31 22:26:12.000000',3,'feb211b022a14e9e8fa24b254f45ace2'),(17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI2OTQ1NywiaWF0IjoxNzc5NjY0NjU3LCJqdGkiOiJhY2IyMTBhNTMyMjY0NjkyYjMxODM0MTE2MjM0ZDEzNCIsInVzZXJfaWQiOjF9.p3ITvn0W6FqQsBPt50YajTtVXNzeQeX8c3uiGiSgE80','2026-05-24 23:17:37.554590','2026-05-31 23:17:37.000000',1,'acb210a532264692b31834116234d134'),(18,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI3MTI1NSwiaWF0IjoxNzc5NjY2NDU1LCJqdGkiOiI1OGUwZGQ0NzE2ODg0YmYxYTYwODQ0ZDJiMTdkNTJiMyIsInVzZXJfaWQiOjJ9.jzNDrYA_N8x2hS2FqJpOgmXiRseA7GOi84hSHedAOKg','2026-05-24 23:47:35.155853','2026-05-31 23:47:35.000000',2,'58e0dd4716884bf1a60844d2b17d52b3'),(19,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI3MTQ4NSwiaWF0IjoxNzc5NjY2Njg1LCJqdGkiOiI2MGZjYjFiYjlhNDU0Mjk3YTI1ODdlODFiYjExYzViMiIsInVzZXJfaWQiOjN9.H9miSoARkXQS_ebX9cSrpykotr3oQjfAI8VjTKlulpg','2026-05-24 23:51:25.166147','2026-05-31 23:51:25.000000',3,'60fcb1bb9a454297a2587e81bb11c5b2'),(20,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI3MzU1OSwiaWF0IjoxNzc5NjY4NzU5LCJqdGkiOiIxYWY2NzUxMmM1ZGU0NjQ1Yjc0NzExNGE3ZmM4OWUyNyIsInVzZXJfaWQiOjZ9.ziN8vqOyGmxNEtIQL6a-dd6s5j35ftVOebzzxDJdgX0','2026-05-25 00:25:59.023863','2026-06-01 00:25:59.000000',6,'1af67512c5de4645b747114a7fc89e27'),(21,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI3MzcxNywiaWF0IjoxNzc5NjY4OTE3LCJqdGkiOiJhZTEwNTAwNTAwYjY0ZTFmYmYwYzNkN2Q4YjEyYjRmNCIsInVzZXJfaWQiOjZ9.esXyWgk_EaoQ7gQHL5Ur9c-hOzJaTJ8mbUQyS04F__s','2026-05-25 00:28:37.279222','2026-06-01 00:28:37.000000',6,'ae10500500b64e1fbf0c3d7d8b12b4f4'),(22,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDI3Mzg4MywiaWF0IjoxNzc5NjY5MDgzLCJqdGkiOiIwZTY0MGU4MmM4ZDQ0ZmE1OGZmZWY1YWUzODBkMTVkYyIsInVzZXJfaWQiOjF9.Lt8wtw-3h7vbDgEl4aAWWKPJN1RQ_vXiszUCf0sBz08','2026-05-25 00:31:23.991592','2026-06-01 00:31:23.000000',1,'0e640e82c8d44fa58ffef5ae380d15dc'),(23,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc4MDMxOTQ3MywiaWF0IjoxNzc5NzE0NjczLCJqdGkiOiI5NWQ0YWJjYTU4NDQ0NTQyOTE0Yjg3NTdjNGY3MmQwMCIsInVzZXJfaWQiOjF9.SFbjVpAn8-utB59NF0PchYAXco_MzkcOoh750kNWdh8','2026-05-25 13:11:13.656317','2026-06-01 13:11:13.000000',1,'95d4abca58444542914b8757c4f72d00');
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_insignias`
--

DROP TABLE IF EXISTS `usuario_insignias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_insignias` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha_obtenida` datetime(6) NOT NULL,
  `insignia_id` bigint NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_insignias_usuario_id_insignia_id_bd5e3e16_uniq` (`usuario_id`,`insignia_id`),
  KEY `usuario_insignias_insignia_id_7ced071a_fk_insignias_id` (`insignia_id`),
  CONSTRAINT `usuario_insignias_insignia_id_7ced071a_fk_insignias_id` FOREIGN KEY (`insignia_id`) REFERENCES `insignias` (`id`),
  CONSTRAINT `usuario_insignias_usuario_id_6f3eabf1_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_insignias`
--

LOCK TABLES `usuario_insignias` WRITE;
/*!40000 ALTER TABLE `usuario_insignias` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_insignias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_completo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_universitario` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `carrera` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `puntos_totales` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `codigo_universitario` (`codigo_universitario`),
  CONSTRAINT `usuarios_chk_1` CHECK ((`puntos_totales` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'pbkdf2_sha256$600000$HyNF6JM3fT6BKeEAcCwBup$fQT2a8rgVFINSIUiaCOwoA71BH474J2/rGbjLslBCKc=',1,'romerolizzeth81@gmail.com','admin','Gema Butterfly',NULL,'Ingeniería de Software','','ADMINISTRADOR',0,1,1,'2026-05-21 04:47:34.737323','2026-05-25 13:11:13.770340'),(2,'pbkdf2_sha256$600000$CB9F0NWusHkGLHPsTbKHwA$2KiSCjb9Q3pH88k6aoBDqGUdbgg7yZW8dLxQrVU/w6E=',0,'urquijocamilo8@gmail.com','est001','Camilo Urquijo','2024001','Ingenieria de Sistemas','','ESTUDIANTE',0,1,0,'2026-05-21 05:02:02.274702','2026-05-24 23:47:35.505509'),(3,'pbkdf2_sha256$600000$pIhpLjJ99JmFCCqq3JDIKw$jW0+WebdVHeJSNsYQHSHWNSMWlGQYlY/oKBBARj2P+A=',0,'jaiderurquijo06@gmail.com','docente','Jaider Uquijo','1110','software','','DOCENTE',0,1,1,'2026-05-21 05:22:04.066856','2026-05-24 23:51:25.224041'),(4,'pbkdf2_sha256$600000$NG9zityDeVryWChTXBcQw7$lcCSw447rsXIHfY/14d0DttKi4UJP19UtcJ8/qSexIE=',0,'jajaj@pt.com','*','juan suarez','perros','ing civil','','ESTUDIANTE',0,1,0,'2026-05-21 14:21:34.713976',NULL),(5,'pbkdf2_sha256$600000$ejxb7kQnBuMxxmCnueVw9S$Oqk42UC0wYn/2T80U0VaukEDluOnNkLK373w3P/zmWs=',0,'lizzethbejarano620@gmail.com','marisol','Marisol Romero','20253','software','','ESTUDIANTE',0,1,0,'2026-05-23 00:05:10.064342',NULL),(6,'pbkdf2_sha256$600000$K5sbHUj8JcU3rJZZ4TGXZo$/UJ+R1ux+mEl6J87DhP6Sfbl+8vKoT/8WuHAdj+RpEc=',0,'gema@gmail.com','gema123','Gema Butterfly','20261001','Ingeniería de Software','','ESTUDIANTE',0,1,0,'2026-05-25 00:25:58.411696','2026-05-25 00:28:37.315759');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_groups`
--

DROP TABLE IF EXISTS `usuarios_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_groups_usuario_id_group_id_a66c5ef3_uniq` (`usuario_id`,`group_id`),
  KEY `usuarios_groups_group_id_18c61092_fk_auth_group_id` (`group_id`),
  CONSTRAINT `usuarios_groups_group_id_18c61092_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `usuarios_groups_usuario_id_1132ca50_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_groups`
--

LOCK TABLES `usuarios_groups` WRITE;
/*!40000 ALTER TABLE `usuarios_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_user_permissions`
--

DROP TABLE IF EXISTS `usuarios_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_user_permissions_usuario_id_permission_id_474b33a5_uniq` (`usuario_id`,`permission_id`),
  KEY `usuarios_user_permis_permission_id_af615ca1_fk_auth_perm` (`permission_id`),
  CONSTRAINT `usuarios_user_permis_permission_id_af615ca1_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `usuarios_user_permissions_usuario_id_232fd58d_fk_usuarios_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_user_permissions`
--

LOCK TABLES `usuarios_user_permissions` WRITE;
/*!40000 ALTER TABLE `usuarios_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-25 11:59:10
