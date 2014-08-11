-- MySQL dump 10.13  Distrib 5.5.25, for Linux (x86_64)
--
-- Host: 10.0.0.199    Database: real_usermgt
-- ------------------------------------------------------
-- Server version	5.5.29-enterprise-commercial-advanced-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `real_usermgt`
--

/*!40000 DROP DATABASE IF EXISTS `real_usermgt`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `real_usermgt` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `real_usermgt`;

--
-- Table structure for table `databasechangelog`
--

DROP TABLE IF EXISTS `databasechangelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `databasechangelog` (
  `ID` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `FILENAME` varchar(255) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int(11) NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `databasechangelog`
--

LOCK TABLES `databasechangelog` WRITE;
/*!40000 ALTER TABLE `databasechangelog` DISABLE KEYS */;
INSERT INTO `databasechangelog` VALUES ('1','iam','db/iam.changelog.xml','2014-08-05 19:14:54',1,'EXECUTED','7:685bec7b86565a12e2fdf7364dae5982','createTable','',NULL,'3.1.1'),('2','iam','db/iam.changelog.xml','2014-08-05 19:14:54',2,'EXECUTED','7:8da4266be47e28964fd173b6d9328682','createTable','',NULL,'3.1.1'),('3','iam','db/iam.changelog.xml','2014-08-05 19:14:54',3,'EXECUTED','7:99a1c22ee18cf87fd0175d826127aa48','createTable','',NULL,'3.1.1'),('4','iam','db/iam.changelog.xml','2014-08-05 19:14:54',4,'EXECUTED','7:8725305589d9dc283df7407aaae12ec4','createTable','',NULL,'3.1.1'),('5','iam','db/iam.changelog.xml','2014-08-05 19:14:54',5,'EXECUTED','7:a8423944a89789e454d9024a79360853','createTable','',NULL,'3.1.1'),('6','iam','db/iam.changelog.xml','2014-08-05 19:14:54',6,'EXECUTED','7:c1884b90f1341c2b4fe020382f2f1d66','createTable','',NULL,'3.1.1'),('7','iam','db/iam.changelog.xml','2014-08-05 19:14:54',7,'EXECUTED','7:3b9794ce68b262fa848efa372e101f91','createTable','',NULL,'3.1.1'),('8','iam','db/iam.changelog.xml','2014-08-05 19:14:54',8,'EXECUTED','7:189ed69689c3e525c490f4ed8eda7218','createTable','',NULL,'3.1.1'),('9','iam','db/iam.changelog.xml','2014-08-05 19:14:54',9,'EXECUTED','7:84087fc1d3b81d0285ee373fcdfae4ff','createTable','',NULL,'3.1.1'),('10','iam','db/iam.changelog.xml','2014-08-05 19:14:54',10,'EXECUTED','7:0c469a5b164bd012fbf11ab1afe2ff3e','createTable','',NULL,'3.1.1'),('11','iam','db/iam.changelog.xml','2014-08-05 19:14:54',11,'EXECUTED','7:abfba49c7e2ac37568deb7f29feb21b7','createTable','',NULL,'3.1.1'),('12','iam','db/iam.changelog.xml','2014-08-05 19:14:54',12,'EXECUTED','7:c7b4ccabef012dbb12e2f5126b083425','createTable','',NULL,'3.1.1'),('13','iam','db/iam.changelog.xml','2014-08-05 19:14:54',13,'EXECUTED','7:6eff65d87bc25594753a64bb9200dd3b','createTable','',NULL,'3.1.1'),('14','iam','db/iam.changelog.xml','2014-08-05 19:14:55',14,'EXECUTED','7:def8e9cc2cf44c6551d8545832f72b23','createTable','',NULL,'3.1.1'),('15','iam','db/iam.changelog.xml','2014-08-05 19:14:55',15,'EXECUTED','7:a1789e834a55e5b60ae554c348774197','createTable','',NULL,'3.1.1'),('16','iam','db/iam.changelog.xml','2014-08-05 19:14:55',16,'EXECUTED','7:8c34501df6d8c8e5d15ec1497668cbc1','createTable','',NULL,'3.1.1'),('17','iam','db/iam.changelog.xml','2014-08-05 19:14:55',17,'EXECUTED','7:76717162196268650e71d0465d133ad0','createTable','',NULL,'3.1.1'),('18','iam','db/iam.changelog.xml','2014-08-05 19:14:55',18,'EXECUTED','7:7d64feac05d6b7eaf10796908ec41c7a','createTable','',NULL,'3.1.1'),('19','iam','db/iam.changelog.xml','2014-08-05 19:14:55',19,'EXECUTED','7:20fc13e85379cfc5ea455aeb6e81eb49','createTable','',NULL,'3.1.1'),('20','iam','db/iam.changelog.xml','2014-08-05 19:14:55',20,'EXECUTED','7:03a85fa2a3a830d3f3d3824a16bd476a','createTable','',NULL,'3.1.1'),('21','iam','db/iam.changelog.xml','2014-08-05 19:14:55',21,'EXECUTED','7:ddbbf1513f9fb665d6236777dc56abd5','createTable','',NULL,'3.1.1'),('22','iam','db/iam.changelog.xml','2014-08-05 19:14:55',22,'EXECUTED','7:dafe9c37019f730354e9999321f0afeb','addForeignKeyConstraint','',NULL,'3.1.1'),('23','iam','db/iam.changelog.xml','2014-08-05 19:14:55',23,'EXECUTED','7:79679e4b66eb8aa85eee2450329835f8','addForeignKeyConstraint','',NULL,'3.1.1'),('24','iam','db/iam.changelog.xml','2014-08-05 19:14:55',24,'EXECUTED','7:7c5de5baf80d4c033f54d37c4e4d0d09','addForeignKeyConstraint','',NULL,'3.1.1'),('25','iam','db/iam.changelog.xml','2014-08-05 19:14:55',25,'EXECUTED','7:ba1413897e265f362ab0aee804187bc5','addForeignKeyConstraint','',NULL,'3.1.1'),('26','iam','db/iam.changelog.xml','2014-08-05 19:14:55',26,'EXECUTED','7:b6ba905852997bd3ee48b1808714d8df','addForeignKeyConstraint','',NULL,'3.1.1'),('27','iam','db/iam.changelog.xml','2014-08-05 19:14:55',27,'EXECUTED','7:49e9e79633636c6c6544f74ba91599ec','addForeignKeyConstraint','',NULL,'3.1.1'),('28','iam','db/iam.changelog.xml','2014-08-05 19:14:55',28,'EXECUTED','7:57154fb9c50b44744af1abe82532dc44','addForeignKeyConstraint','',NULL,'3.1.1'),('29','iam','db/iam.changelog.xml','2014-08-05 19:14:55',29,'EXECUTED','7:2e951977538a1a55247a536f36be9cb6','addForeignKeyConstraint','',NULL,'3.1.1'),('30','iam','db/iam.changelog.xml','2014-08-05 19:14:55',30,'EXECUTED','7:544d748ca1d2c056991591d55389fc17','addForeignKeyConstraint','',NULL,'3.1.1'),('31','iam','db/iam.changelog.xml','2014-08-05 19:14:55',31,'EXECUTED','7:c3ef409ce87ff1ba83e3cf2aae4e4acc','addForeignKeyConstraint','',NULL,'3.1.1'),('32','iam','db/iam.changelog.xml','2014-08-05 19:14:55',32,'EXECUTED','7:fa31f4d4133e097b928afa2db8f034ac','addForeignKeyConstraint','',NULL,'3.1.1'),('33','iam','db/iam.changelog.xml','2014-08-05 19:14:56',33,'EXECUTED','7:c8bd0b862c19983c94cdb35784fd3741','addForeignKeyConstraint','',NULL,'3.1.1'),('34','iam','db/iam.changelog.xml','2014-08-05 19:14:56',34,'EXECUTED','7:fcdcfb8d785c4e1b07ccfd071c9c0b4e','addForeignKeyConstraint','',NULL,'3.1.1'),('35','iam','db/iam.changelog.xml','2014-08-05 19:14:56',35,'EXECUTED','7:d48532c542269bfdb5307ee71b745f8b','addForeignKeyConstraint','',NULL,'3.1.1'),('36','iam','db/iam.changelog.xml','2014-08-05 19:14:56',36,'EXECUTED','7:9d12f5f4ff48a9c9046728355fc2a632','addForeignKeyConstraint','',NULL,'3.1.1'),('37','iam','db/iam.changelog.xml','2014-08-05 19:14:56',37,'EXECUTED','7:88d7ec794305a2633a70f95b22911ef0','addForeignKeyConstraint','',NULL,'3.1.1'),('38','iam','db/iam.changelog.xml','2014-08-05 19:14:56',38,'EXECUTED','7:bec4e0ff2a69c12265a1fef31f0bb7f1','addForeignKeyConstraint','',NULL,'3.1.1'),('39','iam','db/iam.changelog.xml','2014-08-05 19:14:56',39,'EXECUTED','7:488fa946e10922fbfe539b360129ae3d','addForeignKeyConstraint','',NULL,'3.1.1'),('40','iam','db/iam.changelog.xml','2014-08-05 19:14:56',40,'EXECUTED','7:566a9949652dfa4b2b575b3339b4db0f','addForeignKeyConstraint','',NULL,'3.1.1'),('41','iam','db/iam.changelog.xml','2014-08-05 19:14:56',41,'EXECUTED','7:13396ffa56ff0e118fd2d331d92f76d7','addForeignKeyConstraint','',NULL,'3.1.1'),('42','iam','db/iam.changelog.xml','2014-08-05 19:14:56',42,'EXECUTED','7:a7cea4bddd2e570da4ba08f9c1d2ff2d','addUniqueConstraint','',NULL,'3.1.1'),('43','iam','db/iam.changelog.xml','2014-08-05 19:14:56',43,'EXECUTED','7:9df40c50277b82fbc3fcb7fc700d3d44','addUniqueConstraint','',NULL,'3.1.1'),('44','iam','db/iam.changelog.xml','2014-08-05 19:14:56',44,'EXECUTED','7:8b1a200e0c165e69cb474bc5d77b4d47','addUniqueConstraint','',NULL,'3.1.1'),('45','iam','db/iam.changelog.xml','2014-08-05 19:14:56',45,'EXECUTED','7:ce5a086e404881792409ba04b3b71413','addUniqueConstraint','',NULL,'3.1.1'),('46','iam','db/iam.changelog.xml','2014-08-05 19:14:56',46,'EXECUTED','7:7d46a1b42ff1cf4cda870fd418b8180c','addUniqueConstraint','',NULL,'3.1.1'),('47','iam','db/iam.changelog.xml','2014-08-05 19:14:56',47,'EXECUTED','7:52c649d75b069661153f038a24d4a0ed','addUniqueConstraint','',NULL,'3.1.1'),('48','iam','db/iam.changelog.xml','2014-08-05 19:14:56',48,'EXECUTED','7:0ed9b9a758a00ce0be6f62542ce14200','addUniqueConstraint','',NULL,'3.1.1'),('49','iam','db/iam.changelog.xml','2014-08-05 19:14:56',49,'EXECUTED','7:c3785339dc16d29bc4d69a833cdf7e80','addUniqueConstraint','',NULL,'3.1.1'),('50','iam','db/iam.changelog.xml','2014-08-05 19:14:57',50,'EXECUTED','7:2e78abc7b0385e4be1613ed064536b90','addUniqueConstraint','',NULL,'3.1.1'),('51','iam','db/iam.changelog.xml','2014-08-05 19:14:57',51,'EXECUTED','7:dfe4bd90d2edf5044d6bd598a045ee38','addUniqueConstraint','',NULL,'3.1.1'),('52','iam','db/iam.changelog.xml','2014-08-05 19:14:57',52,'EXECUTED','7:4403e356052256ea31d6130a6ba0a82b','addUniqueConstraint','',NULL,'3.1.1'),('53','iam','db/iam.changelog.xml','2014-08-05 19:14:57',53,'EXECUTED','7:b4432655f4542ceb1c0aa52df09016ea','createIndex','',NULL,'3.1.1'),('54','iam','db/iam.changelog.xml','2014-08-05 19:14:57',54,'EXECUTED','7:70a5d22f3831748d5cf923cd2a02a7cd','createIndex','',NULL,'3.1.1'),('55','iam','db/iam.changelog.xml','2014-08-05 19:14:57',55,'EXECUTED','7:011b32e360b592d2e10f5b568363449b','createIndex','',NULL,'3.1.1'),('56','iam','db/iam.changelog.xml','2014-08-05 19:14:57',56,'EXECUTED','7:b99475667619871af9b1f9dd12e3d4c6','createIndex','',NULL,'3.1.1'),('57','iam','db/iam.changelog.xml','2014-08-05 19:14:57',57,'EXECUTED','7:d9edb715521a2607fa31349b61167180','createIndex','',NULL,'3.1.1'),('58','iam','db/iam.changelog.xml','2014-08-05 19:14:57',58,'EXECUTED','7:c3c4663b0f30d66a2265afc93bf366d5','createIndex','',NULL,'3.1.1'),('59','iam','db/iam.changelog.xml','2014-08-05 19:14:57',59,'EXECUTED','7:acc904608256a1bcfd15500742e463c2','createIndex','',NULL,'3.1.1'),('60','iam','db/iam.changelog.xml','2014-08-05 19:14:57',60,'EXECUTED','7:0b9d5c532f44c3b81a2afda93c6697ba','createIndex','',NULL,'3.1.1'),('61','iam','db/iam.changelog.xml','2014-08-05 19:14:57',61,'EXECUTED','7:03d589321ba6ef331ac3955548110dac','createIndex','',NULL,'3.1.1'),('62','iam','db/iam.changelog.xml','2014-08-05 19:14:57',62,'EXECUTED','7:41eaa683df48cd996ea297eda045eead','createIndex','',NULL,'3.1.1'),('63','iam','db/iam.changelog.xml','2014-08-05 19:14:57',63,'EXECUTED','7:f3734175af9658ac9f0ecff005dfcba2','createIndex','',NULL,'3.1.1'),('64','iam','db/iam.changelog.xml','2014-08-05 19:14:57',64,'EXECUTED','7:68c58fa5e796d46a1ef5ec454c1ce9d2','createIndex','',NULL,'3.1.1'),('iam','author','db/initData.sql','2014-08-05 19:14:57',65,'EXECUTED','7:f84f38ef23d8cdb46eeda500f7bb1c9f','sql','',NULL,'3.1.1'),('raw','includeAll','db/iam_large_entity.sql','2014-08-05 19:14:58',66,'EXECUTED','7:c69860d5d35ae04893d874568d1e10e3','sql','',NULL,'3.1.1');
/*!40000 ALTER TABLE `databasechangelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `databasechangeloglock`
--

DROP TABLE IF EXISTS `databasechangeloglock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `databasechangeloglock` (
  `ID` int(11) NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `databasechangeloglock`
--

LOCK TABLES `databasechangeloglock` WRITE;
/*!40000 ALTER TABLE `databasechangeloglock` DISABLE KEYS */;
INSERT INTO `databasechangeloglock` VALUES (1,'\0',NULL,NULL);
/*!40000 ALTER TABLE `databasechangeloglock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_entity_attribute`
--

DROP TABLE IF EXISTS `iam_entity_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_entity_attribute` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `ENTITY_TYPE` varchar(64) NOT NULL,
  `ENTITY_ID` bigint(19) NOT NULL,
  `ATTRIBUTE_NAME` varchar(64) DEFAULT NULL,
  `ATTRIBUTE_VALUE` varchar(255) DEFAULT NULL,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  KEY `entity_attribute_index` (`ENTITY_TYPE`,`ENTITY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_entity_attribute`
--

LOCK TABLES `iam_entity_attribute` WRITE;
/*!40000 ALTER TABLE `iam_entity_attribute` DISABLE KEYS */;
INSERT INTO `iam_entity_attribute` VALUES (1,'com.altisource.usermgmt.domain.User',2,'User Attribute Name','User Attribute Value',NULL,NULL,NULL,NULL,1),(2,'com.altisource.usermgmt.domain.Group',1,'Group Attribute Name','Group Attribute Value',NULL,NULL,NULL,NULL,1),(3,'com.altisource.usermgmt.domain.User',28,'User Attribute Name for milind.deobhankar@altisource.com','User Attribute Value for milind.deobhankar@altisource.com',NULL,NULL,NULL,NULL,1),(4,'com.altisource.usermgmt.domain.User',2,'Tenant','System',NULL,NULL,NULL,NULL,1),(5,'com.altisource.usermgmt.domain.User',57,'Tenant','Ocwen',NULL,NULL,NULL,NULL,1),(6,'com.altisource.usermgmt.domain.User',62,'Tenant','Equator',NULL,NULL,NULL,NULL,1),(7,'com.altisource.usermgmt.domain.User',59,'Tenant','BANA',NULL,NULL,NULL,NULL,1),(8,'com.altisource.usermgmt.domain.User',1,'Tenant','System',NULL,NULL,NULL,NULL,1),(9,'com.altisource.usermgmt.domain.User',58,'Tenant','Ocwen',NULL,NULL,NULL,NULL,1),(10,'com.altisource.usermgmt.domain.User',63,'Tenant','Equator',NULL,NULL,NULL,NULL,1),(11,'com.altisource.usermgmt.domain.User',60,'Tenant','BANA',NULL,NULL,NULL,NULL,1),(12,'com.altisource.usermgmt.domain.User',56,'Tenant','System',NULL,NULL,NULL,NULL,1),(13,'com.altisource.usermgmt.domain.User',37,'Tenant','Ocwen',NULL,NULL,NULL,NULL,1),(14,'com.altisource.usermgmt.domain.User',64,'Tenant','Equator',NULL,NULL,NULL,NULL,1),(16,'com.altisource.usermgmt.domain.User',61,'Tenant','BANA',NULL,NULL,NULL,NULL,1),(17,'com.altisource.usermgmt.domain.User',65,'Loan','09876543321',NULL,NULL,NULL,NULL,1),(18,'com.altisource.usermgmt.domain.User',66,'Org','PPI',NULL,NULL,NULL,NULL,1),(19,'com.altisource.usermgmt.domain.User',67,'Investor','FannieMae',NULL,NULL,NULL,NULL,1),(20,'com.altisource.usermgmt.domain.User',67,'Portfolio','02110',NULL,NULL,NULL,NULL,1),(21,'com.altisource.usermgmt.domain.User',68,'Vendor','1234567890',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `iam_entity_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_group`
--

DROP TABLE IF EXISTS `iam_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_group` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `TENANT_ID` bigint(19) NOT NULL,
  `GROUP_NAME` varchar(36) DEFAULT NULL,
  `GROUP_DESC` char(255) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `GROUP_NAME` (`GROUP_NAME`,`TENANT_ID`),
  KEY `FKrf_group1` (`TENANT_ID`),
  KEY `active` (`ACTIVE`),
  CONSTRAINT `FKrf_group1` FOREIGN KEY (`TENANT_ID`) REFERENCES `iam_tenant` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_group`
--

LOCK TABLES `iam_group` WRITE;
/*!40000 ALTER TABLE `iam_group` DISABLE KEYS */;
INSERT INTO `iam_group` VALUES (1,2,'GRP_REAL_ADMIN','REALSuite App Admin Group','',NULL,NULL,NULL,NULL,1),(2,2,'GRP_REAL_TEST','REALSuite App Admin Group TEST','',NULL,NULL,NULL,NULL,1),(3,2,'GRP_REAL_FOO_TEST','REALSuite App Admin Group FOO TEST','',NULL,NULL,NULL,NULL,1),(21,1,'Hosting Admins','Hosting Admins Group','',NULL,NULL,NULL,NULL,1),(22,1,'Rule Managers','Rule Managers Group','',NULL,NULL,NULL,NULL,1),(23,1,'Workflow Managers','Workflow Managers Group','',NULL,NULL,NULL,NULL,1),(24,1,'Credit Reporters','Credit Reporters Group','',NULL,NULL,NULL,NULL,1),(25,1,'Credit Managers','Credit Managers Group','',NULL,NULL,NULL,NULL,1),(26,1,'Servicing Analysts','Servicing Analysts Group','',NULL,NULL,NULL,NULL,1),(27,1,'Servicing Managers','Servicing Managers Group','',NULL,NULL,NULL,NULL,1),(28,2,'Ocwen Admins','Ocwen Admins Group','',NULL,NULL,NULL,NULL,1),(29,2,'Rule Managers O2','Ocwen Rule Managers Group','',NULL,NULL,NULL,NULL,1),(30,2,'Workflow Managers O2','Ocwen Workflow Managers Group','',NULL,NULL,NULL,NULL,1),(31,2,'Credit Reporters O2','Ocwen Credit Reporters Group','',NULL,NULL,NULL,NULL,1),(32,2,'Credit Managers O2','Ocwen Credit Managers Group','',NULL,NULL,NULL,NULL,1),(33,2,'Servicing Analysts O2','Ocwen Servicing Analysts Group','',NULL,NULL,NULL,NULL,1),(34,2,'Servicing Managers O2','Ocwen Servicing Managers Group','',NULL,NULL,NULL,NULL,1),(35,2,'Order Coordinators O2','Ocwen Order Coordinators Group','',NULL,NULL,NULL,NULL,1),(36,3,'Equator Admins','Equator Admins Group','',NULL,NULL,NULL,NULL,1),(37,3,'Rule Managers E3','Equator Rule Managers Group','',NULL,NULL,NULL,NULL,1),(38,3,'Workflow Managers E3','Equator Workflow Managers Group','',NULL,NULL,NULL,NULL,1),(39,3,'Credit Reporters E3','Equator Credit Reporters Group','',NULL,NULL,NULL,NULL,1),(40,3,'Credit Managers E3','Equator Credit Managers Group','',NULL,NULL,NULL,NULL,1),(41,3,'Servicing Analysts E3','Equator Servicing Analysts Group','',NULL,NULL,NULL,NULL,1),(42,3,'Servicing Managers E3','Equator Servicing Managers Group','',NULL,NULL,NULL,NULL,1),(43,3,'Order Coordinators E3','Equator Order Coordinators Group','',NULL,NULL,NULL,NULL,1),(44,4,'BoB Admins','BoB Admins Group','',NULL,NULL,NULL,NULL,1),(45,4,'Rule Managers B4','BOB Rule Managers Group','',NULL,NULL,NULL,NULL,1),(46,4,'Workflow Managers B4','BOB Workflow Managers Group','',NULL,NULL,NULL,NULL,1),(47,4,'Credit Reporters B4','BOB Credit Reporters Group','',NULL,NULL,NULL,NULL,1),(48,4,'Credit Managers B4','BOB Credit Managers Group','',NULL,NULL,NULL,NULL,1),(49,4,'Servicing Analysts B4','BOB Servicing Analysts Group','',NULL,NULL,NULL,NULL,1),(50,4,'Servicing Managers B4','BOB Servicing Managers Group','',NULL,NULL,NULL,NULL,1),(51,4,'Order Coordinators B4','BOB Order Coordinators Group','',NULL,NULL,NULL,NULL,1),(52,5,'Demo Admins','Demo Admins Group','',NULL,NULL,NULL,NULL,1),(53,5,'Demo Rules','Demo Rule Managers Group','',NULL,NULL,NULL,NULL,1),(54,5,'Demo Managers','Demo Workflow Managers Group','',NULL,NULL,NULL,NULL,1),(55,5,'Credit Reporters D5','Demo Credit Reporters Group','',NULL,NULL,NULL,NULL,1),(56,5,'Credit Managers D5','Demo Credit Managers Group','',NULL,NULL,NULL,NULL,1),(57,5,'Servicing Analysts D5','Demo Servicing Analysts Group','',NULL,NULL,NULL,NULL,1),(58,5,'Servicing Managers D5','Demo Servicing Managers Group','',NULL,NULL,NULL,NULL,1),(59,5,'Order Coordinators D5','Demo Order Coordinators Group','',NULL,NULL,NULL,NULL,1),(60,5,'Borrowers','Demo Borrowers Group','',NULL,NULL,NULL,NULL,1),(61,5,'Facilitators','Demo Facilitators Group','',NULL,NULL,NULL,NULL,1),(62,5,'Investors','Demo Investors Group','',NULL,NULL,NULL,NULL,1),(63,5,'Vendors','Demo Vendors Group','',NULL,NULL,NULL,NULL,1),(64,1,'Loan-boarding','Loan-boarding Group','',NULL,NULL,NULL,NULL,1),(65,2,'Loan-boarding O2','Ocwen Loan-boarding Group','',NULL,NULL,NULL,NULL,1),(66,3,'Loan-boarding E3','Equator Loan-boarding Group','',NULL,NULL,NULL,NULL,1),(67,4,'Loan-boarding B4','BOB Loan-boarding Group','',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `iam_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_group_role`
--

DROP TABLE IF EXISTS `iam_group_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_group_role` (
  `GROUP_ID` bigint(19) NOT NULL,
  `ROLE_ID` bigint(19) NOT NULL,
  KEY `FKrf_group_role1` (`ROLE_ID`),
  KEY `FKrf_group_role2` (`GROUP_ID`),
  CONSTRAINT `FKrf_group_role2` FOREIGN KEY (`GROUP_ID`) REFERENCES `iam_group` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FKrf_group_role1` FOREIGN KEY (`ROLE_ID`) REFERENCES `iam_role` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_group_role`
--

LOCK TABLES `iam_group_role` WRITE;
/*!40000 ALTER TABLE `iam_group_role` DISABLE KEYS */;
INSERT INTO `iam_group_role` VALUES (1,6),(1,7),(1,8),(1,9),(1,10);
/*!40000 ALTER TABLE `iam_group_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_hostname_mapping`
--

DROP TABLE IF EXISTS `iam_hostname_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_hostname_mapping` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `TENANT_ID` bigint(19) DEFAULT NULL,
  `HOST_NAME_PATTERN` varchar(255) NOT NULL,
  `MANAGED` bit(1) NOT NULL DEFAULT b'1',
  `WHITE_LIST` bit(1) NOT NULL DEFAULT b'1',
  `USER_TYPE` varchar(36) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `HOST_NAME_PATTERN` (`HOST_NAME_PATTERN`,`USER_TYPE`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_hostname_mapping`
--

LOCK TABLES `iam_hostname_mapping` WRITE;
/*!40000 ALTER TABLE `iam_hostname_mapping` DISABLE KEYS */;
INSERT INTO `iam_hostname_mapping` VALUES (1,2,'gmail.com','','','Vendor','',57,NULL,NULL,NULL,1),(2,NULL,'yahoo.com','','\0',NULL,'',3,NULL,NULL,NULL,1),(3,1,'altisource.com','\0','','Admin','',2,1406905225552,NULL,NULL,1),(4,NULL,'junkmail.com','','\0',NULL,'',NULL,NULL,NULL,NULL,1),(5,NULL,'n3.com','','\0',NULL,'',NULL,NULL,NULL,NULL,1),(6,2,'ocwen.com','\0','','Servicer','',58,NULL,NULL,NULL,1),(7,3,'equator.com','\0','','Servicer','',62,NULL,NULL,NULL,1),(8,4,'BankOfBoston.com','\0','','Servicer','',59,NULL,NULL,NULL,1),(9,5,'altilab.com','\0','','Servicer','',65,NULL,NULL,NULL,1),(10,1,'altisource.com','\0','','Servicer','',33,NULL,NULL,NULL,1),(11,1,'altisource.com','\0','','Patner','',33,NULL,NULL,NULL,1),(12,1,'altisource.com','\0','','Investor','',57,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `iam_hostname_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_large_entity`
--

DROP TABLE IF EXISTS `iam_large_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_large_entity` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `ENTITY_NAME` varchar(72) NOT NULL,
  `STR_ENTITY` longtext,
  `BIN_ENTITY` blob,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `large_entity_name` (`ENTITY_NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_large_entity`
--

LOCK TABLES `iam_large_entity` WRITE;
/*!40000 ALTER TABLE `iam_large_entity` DISABLE KEYS */;
INSERT INTO `iam_large_entity` VALUES (1,'HEADER',NULL,'{\n  \"headerTabs\": [\n    {\n      \"displayName\": \"HOME\",\n      \"applicationTitle\": \"My Tasks\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": null,\n          \"columnCount\": 0\n        }\n      ]\n    },\n    {\n      \"displayName\": \"SERVICING\",\n      \"applicationTitle\": \"Loan Servicing\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Servicing Processes\",\n          \"columnCount\": 4,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Tax\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Insurance\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Escrow\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Mortgage Insurance\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Credit Reporting\",\n              \"url\": \"/cr\",\n              \"permission\": \"UI.CreditReporting.Read\"\n            },\n            {\n              \"displayName\": \"ARM Review\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Investor Relations\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Investor Reporting\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Cashiering\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Collateral\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Payoff\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Reade\"\n            },\n            {\n              \"displayName\": \"Collections\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Compliance\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Contracts\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Research\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"End of Year\",\n              \"url\": \"\",\n              \"permission\": \"UI.Servicing.Read\"\n            }\n          ]\n        },\n        {\n          \"groupTitle\": \"Servicing Functions\",\n          \"columnCount\": 4,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Payables\",\n              \"url\": \"/rs31\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Receivables\",\n              \"url\": \"/rs32\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Borrowers Account\",\n              \"url\": \"/rs33\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Billing\",\n              \"url\": \"/rs34\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Calculators\",\n              \"url\": \"/rs35\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Core Entities\",\n              \"url\": \"/rs36\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Compliance\",\n              \"url\": \"/rs37\",\n              \"permission\": \"UI.Servicing.Read\"\n            },\n            {\n              \"displayName\": \"Statements\",\n              \"url\": \"/rs38\",\n              \"permission\": \"UI.Servicing.Read\"\n            }\n          ]\n        }\n      ]\n    },\n    {\n      \"displayName\": \"Investors\",\n      \"applicationTitle\": \"Loan Boarding\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Loan Boarding\",\n          \"columnCount\": 1,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Deals\",\n              \"url\": \"/loan-boarding-client/#/deals\",\n              \"permission\": \"UI.LoanBoarding.Read\"\n            },\n            {\n              \"displayName\": \"Tasks\",\n              \"url\": \"/loan-boarding-client/#/tasks\",\n              \"permission\": \"UI.LoanBoarding.Read\"\n            }\n          ]\n        }\n      ]\n    },\n    {\n      \"displayName\": \"DOCUMENTS\",\n      \"applicationTitle\": \"REALDoc\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Document Center\",\n          \"columnCount\": 1,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Vault\",\n              \"url\": \"\",\n              \"permission\": \"UI.Documents.Read\"\n            },\n            {\n              \"displayName\": \"Correspondence\",\n              \"url\": \"\",\n              \"permission\": \"UI.Documents.Read\"\n            },\n            {\n              \"displayName\": \"Capture\",\n              \"url\": \"\",\n              \"permission\": \"UI.Documents.Read\"\n            },\n            {\n              \"displayName\": \"Configuration\",\n              \"url\": \"\",\n              \"permission\": \"UI.Documents.Read\"\n            }\n          ]\n        }\n      ]\n    },\n    {\n      \"displayName\": \"ORDERS\",\n      \"applicationTitle\": \"Vendor Portal\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Transactions\",\n          \"columnCount\": 1,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Requester\",\n              \"url\": \"\",\n              \"permission\": \"UI.Orders.Read\"\n            },\n            {\n              \"displayName\": \"Facilitator\",\n              \"url\": \"\",\n              \"permission\": \"UI.Orders.Read\"\n            },\n            {\n              \"displayName\": \"Vendor\",\n              \"url\": \"\",\n              \"permission\": \"UI.Orders.Read\"\n            }\n          ]\n        },\n        {\n          \"groupTitle\": \"Invoices\",\n          \"columnCount\": 1,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Submit\",\n              \"url\": \"\",\n              \"permission\": \"UI.Orders.Read\"\n            },\n            {\n              \"displayName\": \"Approve\",\n              \"url\": \"\",\n              \"permission\": \"UI.Orders.Read\"\n            },\n            {\n              \"displayName\": \"Manage\",\n              \"url\": \"\",\n              \"permission\": \"UI.Orders.Read\"\n            }\n          ]\n        }\n      ]\n    },\n    {\n      \"displayName\": \"DEFAULT\",\n      \"applicationTitle\": \"Default Management\",\n      \"url\": \"/rs\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Default Management\",\n          \"columnCount\": 1,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Modification\",\n              \"url\": \"\",\n              \"permission\": \"UI.Default.Read\"\n            },\n            {\n              \"displayName\": \"Short Sale\",\n              \"url\": \"\",\n              \"permission\": \"UI.Default.Read\"\n            },\n            {\n              \"displayName\": \"Deed-in-Lieu\",\n              \"url\": \"\",\n              \"permission\": \"UI.Default.Read\"\n            },\n            {\n              \"displayName\": \"Foreclosure\",\n              \"url\": \"\",\n              \"permission\": \"UI.Default.Read\"\n            },\n            {\n              \"displayName\": \"Bankruptcy\",\n              \"url\": \"\",\n              \"permission\": \"UI.Default.Read\"\n            }\n          ]\n        }\n      ]\n    },\n    {\n      \"displayName\": \"REO\",\n      \"applicationTitle\": \"Real Estate Owned\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Real Estate Owned\",\n          \"columnCount\": 1,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Menu item 1\",\n              \"url\": \"\",\n              \"permission\": \"UI.REO.Read\"\n            },\n            {\n              \"displayName\": \"Menu item 2\",\n              \"url\": \"\",\n              \"permission\": \"UI.REO.Read\"\n            },\n            {\n              \"displayName\": \"Menu item 3\",\n              \"url\": \"\",\n              \"permission\": \"UI.REO.Read\"\n            }\n          ]\n        }\n      ]\n    },\n    {\n      \"displayName\": \"REPORTS\",\n      \"applicationTitle\": \"Reporting Dashboard\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Reporting and Analytics\",\n          \"columnCount\": 2,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"Investor Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            },\n            {\n              \"displayName\": \"Vendor Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            },\n            {\n              \"displayName\": \"Payment Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            },\n            {\n              \"displayName\": \"Security Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            },\n            {\n              \"displayName\": \"User Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            },\n            {\n              \"displayName\": \"Business Rules Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            },\n            {\n              \"displayName\": \"Workflow Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            },\n            {\n              \"displayName\": \"Custom Reports\",\n              \"url\": \"\",\n              \"permission\": \"UI.Reports.Read\"\n            }\n          ]\n        }\n      ]\n    },\n    {\n      \"displayName\": \"ADMINISTRATION\",\n      \"applicationTitle\": \"Administration\",\n      \"url\": \"\",\n      \"httpLinkGroups\": [\n        {\n          \"groupTitle\": \"Administrative Consoles\",\n          \"columnCount\": 3,\n          \"httpLinks\": [\n            {\n              \"displayName\": \"User Management\",\n              \"url\": \"/iam\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Investors\",\n              \"url\": \"\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Tenants\",\n              \"url\": \"/upload\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Rules Management\",\n              \"url\": \"/rulesmgt\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Workflows\",\n              \"url\": \"\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Search\",\n              \"url\": \"\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Loan Boarding\",\n              \"url\": \"/admin17\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Loan Deboarding\",\n              \"url\": \"\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Configurations\",\n              \"url\": \"/iam/#/configurations\",\n              \"permission\": \"UI.Administration.Read\"\n            },\n            {\n              \"displayName\": \"Audit\",\n              \"url\": \"/iam/#/audit\",\n              \"permission\": \"UI.Audit.Read\"\n            }\n          ]\n        }\n      ]\n    }\n  ]\n}',2,1404758210376,2,1404758210376,1);
/*!40000 ALTER TABLE `iam_large_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_permission`
--

DROP TABLE IF EXISTS `iam_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_permission` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `RESOURCE_ID` bigint(19) NOT NULL,
  `OPERATION` char(36) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_rf_permission` (`RESOURCE_ID`,`OPERATION`),
  KEY `active` (`ACTIVE`),
  CONSTRAINT `FKrf_permission1` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `iam_resource` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=332 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_permission`
--

LOCK TABLES `iam_permission` WRITE;
/*!40000 ALTER TABLE `iam_permission` DISABLE KEYS */;
INSERT INTO `iam_permission` VALUES (18,6,'Create','',NULL,NULL,NULL,NULL,1),(19,6,'Read','',NULL,NULL,NULL,NULL,1),(20,6,'Update','',NULL,NULL,NULL,NULL,1),(21,6,'Delete','',NULL,NULL,NULL,NULL,1),(22,7,'Create','',NULL,NULL,NULL,NULL,1),(23,7,'Read','',NULL,NULL,NULL,NULL,1),(24,7,'Update','',NULL,NULL,NULL,NULL,1),(25,7,'Delete','',NULL,NULL,NULL,NULL,1),(26,8,'Create','',NULL,NULL,NULL,NULL,1),(27,9,'Create','',NULL,NULL,NULL,NULL,1),(28,10,'Create','',NULL,NULL,NULL,NULL,1),(29,11,'Create','',NULL,NULL,NULL,NULL,1),(30,12,'Create','',NULL,NULL,NULL,NULL,1),(31,13,'Create','',NULL,NULL,NULL,NULL,1),(32,14,'Create','',NULL,NULL,NULL,NULL,1),(33,15,'Create','',NULL,NULL,NULL,NULL,1),(34,16,'Create','',NULL,NULL,NULL,NULL,1),(35,17,'Read','',NULL,NULL,NULL,NULL,1),(36,18,'Read','',NULL,NULL,NULL,NULL,1),(201,101,'Read','',NULL,NULL,NULL,NULL,1),(202,102,'Read','',NULL,NULL,NULL,NULL,1),(203,103,'Read','',NULL,NULL,NULL,NULL,1),(204,104,'Read','',NULL,NULL,NULL,NULL,1),(205,105,'Read','',NULL,NULL,NULL,NULL,1),(206,106,'Read','',NULL,NULL,NULL,NULL,1),(207,107,'Read','',NULL,NULL,NULL,NULL,1),(208,108,'Read','',NULL,NULL,NULL,NULL,1),(209,109,'Read','',NULL,NULL,NULL,NULL,1),(210,110,'Read','',NULL,NULL,NULL,NULL,1),(211,111,'Read','',NULL,NULL,NULL,NULL,1),(212,112,'Read','',NULL,NULL,NULL,NULL,1),(213,113,'Read','',NULL,NULL,NULL,NULL,1),(214,114,'Read','',NULL,NULL,NULL,NULL,1),(215,115,'Read','',NULL,NULL,NULL,NULL,1),(216,116,'Read','',NULL,NULL,NULL,NULL,1),(217,117,'Read','',NULL,NULL,NULL,NULL,1),(218,118,'Read','',NULL,NULL,NULL,NULL,1),(219,119,'Create','',NULL,NULL,NULL,NULL,1),(220,119,'Read','',NULL,NULL,NULL,NULL,1),(221,119,'Update','',NULL,NULL,NULL,NULL,1),(222,119,'Disable','',NULL,NULL,NULL,NULL,1),(223,119,'Relate','',NULL,NULL,NULL,NULL,1),(224,119,'Upload','',NULL,NULL,NULL,NULL,1),(225,120,'Create','',NULL,NULL,NULL,NULL,1),(226,120,'Read','',NULL,NULL,NULL,NULL,1),(227,120,'Update','',NULL,NULL,NULL,NULL,1),(228,120,'Disable','',NULL,NULL,NULL,NULL,1),(229,120,'Relate','',NULL,NULL,NULL,NULL,1),(230,121,'Create','',NULL,NULL,NULL,NULL,1),(231,121,'Read','',NULL,NULL,NULL,NULL,1),(232,121,'Update','',NULL,NULL,NULL,NULL,1),(233,121,'Disable','',NULL,NULL,NULL,NULL,1),(234,121,'Relate','',NULL,NULL,NULL,NULL,1),(235,122,'Read','',NULL,NULL,NULL,NULL,1),(236,122,'Relate','',NULL,NULL,NULL,NULL,1),(237,123,'Create','',NULL,NULL,NULL,NULL,1),(238,123,'Read','',NULL,NULL,NULL,NULL,1),(239,123,'Update','',NULL,NULL,NULL,NULL,1),(240,123,'Disable','',NULL,NULL,NULL,NULL,1),(241,123,'Relate','',NULL,NULL,NULL,NULL,1),(242,123,'Upload','',NULL,NULL,NULL,NULL,1),(243,123,'Download','',NULL,NULL,NULL,NULL,1),(244,124,'Create','',NULL,NULL,NULL,NULL,1),(245,124,'Read','',NULL,NULL,NULL,NULL,1),(246,124,'Update','',NULL,NULL,NULL,NULL,1),(247,124,'Disable','',NULL,NULL,NULL,NULL,1),(248,124,'Relate','',NULL,NULL,NULL,NULL,1),(249,125,'Read','',NULL,NULL,NULL,NULL,1),(250,126,'Create','',NULL,NULL,NULL,NULL,1),(251,126,'Read','',NULL,NULL,NULL,NULL,1),(252,126,'Update','',NULL,NULL,NULL,NULL,1),(253,126,'Disable','',NULL,NULL,NULL,NULL,1),(254,126,'Relate','',NULL,NULL,NULL,NULL,1),(255,126,'Upload','',NULL,NULL,NULL,NULL,1),(256,126,'Download','',NULL,NULL,NULL,NULL,1),(257,127,'Create','',NULL,NULL,NULL,NULL,1),(258,127,'Read','',NULL,NULL,NULL,NULL,1),(259,127,'Update','',NULL,NULL,NULL,NULL,1),(260,127,'Disable','',NULL,NULL,NULL,NULL,1),(261,127,'Upload','',NULL,NULL,NULL,NULL,1),(262,127,'Download','',NULL,NULL,NULL,NULL,1),(263,128,'Create','',NULL,NULL,NULL,NULL,1),(264,128,'Read','',NULL,NULL,NULL,NULL,1),(265,128,'Update','',NULL,NULL,NULL,NULL,1),(266,128,'Disable','',NULL,NULL,NULL,NULL,1),(267,128,'Upload','',NULL,NULL,NULL,NULL,1),(268,128,'Download','',NULL,NULL,NULL,NULL,1),(269,129,'Create','',NULL,NULL,NULL,NULL,1),(270,129,'Read','',NULL,NULL,NULL,NULL,1),(271,129,'Update','',NULL,NULL,NULL,NULL,1),(272,129,'Disable','',NULL,NULL,NULL,NULL,1),(273,129,'Upload','',NULL,NULL,NULL,NULL,1),(274,129,'Download','',NULL,NULL,NULL,NULL,1),(275,130,'Create','',NULL,NULL,NULL,NULL,1),(276,130,'Read','',NULL,NULL,NULL,NULL,1),(277,130,'Update','',NULL,NULL,NULL,NULL,1),(278,130,'Disable','',NULL,NULL,NULL,NULL,1),(279,130,'Relate','',NULL,NULL,NULL,NULL,1),(280,130,'Upload','',NULL,NULL,NULL,NULL,1),(281,130,'Download','',NULL,NULL,NULL,NULL,1),(282,131,'Create','',NULL,NULL,NULL,NULL,1),(283,131,'Read','',NULL,NULL,NULL,NULL,1),(284,131,'Update','',NULL,NULL,NULL,NULL,1),(285,131,'Disable','',NULL,NULL,NULL,NULL,1),(286,131,'Relate','',NULL,NULL,NULL,NULL,1),(287,131,'Upload','',NULL,NULL,NULL,NULL,1),(288,131,'Download','',NULL,NULL,NULL,NULL,1),(289,132,'Create','',NULL,NULL,NULL,NULL,1),(290,132,'Read','',NULL,NULL,NULL,NULL,1),(291,132,'Update','',NULL,NULL,NULL,NULL,1),(292,132,'Disable','',NULL,NULL,NULL,NULL,1),(293,132,'Relate','',NULL,NULL,NULL,NULL,1),(294,132,'Upload','',NULL,NULL,NULL,NULL,1),(295,132,'Download','',NULL,NULL,NULL,NULL,1),(296,133,'Create','',NULL,NULL,NULL,NULL,1),(297,133,'Read','',NULL,NULL,NULL,NULL,1),(298,133,'Update','',NULL,NULL,NULL,NULL,1),(299,133,'Disable','',NULL,NULL,NULL,NULL,1),(300,133,'Relate','',NULL,NULL,NULL,NULL,1),(301,133,'Upload','',NULL,NULL,NULL,NULL,1),(302,133,'Download','',NULL,NULL,NULL,NULL,1),(303,134,'Create','',NULL,NULL,NULL,NULL,1),(304,134,'Read','',NULL,NULL,NULL,NULL,1),(305,134,'Update','',NULL,NULL,NULL,NULL,1),(306,134,'Disable','',NULL,NULL,NULL,NULL,1),(307,134,'Relate','',NULL,NULL,NULL,NULL,1),(308,134,'Upload','',NULL,NULL,NULL,NULL,1),(309,134,'Download','',NULL,NULL,NULL,NULL,1),(310,135,'Create','',NULL,NULL,NULL,NULL,1),(311,135,'Read','',NULL,NULL,NULL,NULL,1),(312,135,'Update','',NULL,NULL,NULL,NULL,1),(313,135,'Disable','',NULL,NULL,NULL,NULL,1),(314,135,'Relate','',NULL,NULL,NULL,NULL,1),(315,135,'Upload','',NULL,NULL,NULL,NULL,1),(316,135,'Download','',NULL,NULL,NULL,NULL,1),(317,136,'Create','',NULL,NULL,NULL,NULL,1),(318,136,'Read','',NULL,NULL,NULL,NULL,1),(319,136,'Update','',NULL,NULL,NULL,NULL,1),(320,136,'Disable','',NULL,NULL,NULL,NULL,1),(321,136,'Relate','',NULL,NULL,NULL,NULL,1),(322,136,'Upload','',NULL,NULL,NULL,NULL,1),(323,136,'Download','',NULL,NULL,NULL,NULL,1),(324,137,'Create','',NULL,NULL,NULL,NULL,1),(325,137,'Read','',NULL,NULL,NULL,NULL,1),(326,137,'Update','',NULL,NULL,NULL,NULL,1),(327,137,'Disable','',NULL,NULL,NULL,NULL,1),(328,137,'Relate','',NULL,NULL,NULL,NULL,1),(329,137,'Upload','',NULL,NULL,NULL,NULL,1),(330,137,'Download','',NULL,NULL,NULL,NULL,1),(331,138,'Read','',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `iam_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_postal_address`
--

DROP TABLE IF EXISTS `iam_postal_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_postal_address` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `ADDRESS1` varchar(255) DEFAULT NULL,
  `ADDRESS2` varchar(255) DEFAULT NULL,
  `CITY` char(255) DEFAULT NULL,
  `STATE` char(2) DEFAULT NULL,
  `POSTAL_CODE` char(8) DEFAULT NULL,
  `COUNTRY` char(12) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  KEY `active` (`ACTIVE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_postal_address`
--

LOCK TABLES `iam_postal_address` WRITE;
/*!40000 ALTER TABLE `iam_postal_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `iam_postal_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_product`
--

DROP TABLE IF EXISTS `iam_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_product` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `PRODUCT_NAME` char(36) NOT NULL,
  `PRODUCT_DESC` char(255) DEFAULT NULL,
  `DEFAULT_ROLE_ID` bigint(19) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PRODUCT_NAME` (`PRODUCT_NAME`),
  KEY `FKiam_product1` (`DEFAULT_ROLE_ID`),
  KEY `active` (`ACTIVE`),
  CONSTRAINT `FKiam_product1` FOREIGN KEY (`DEFAULT_ROLE_ID`) REFERENCES `iam_role` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_product`
--

LOCK TABLES `iam_product` WRITE;
/*!40000 ALTER TABLE `iam_product` DISABLE KEYS */;
INSERT INTO `iam_product` VALUES (4,'REALServicing','REALServicing',6,'',NULL,NULL,NULL,NULL,1),(5,'REALDoc','REALDoc',7,'',NULL,NULL,NULL,NULL,1),(6,'REALTrans','REALTrans',8,'',NULL,NULL,NULL,NULL,1),(7,'REALRemit','REALRemit',9,'',NULL,NULL,NULL,NULL,1),(8,'CreditReporting','Credit Reporting',18,'',NULL,NULL,NULL,NULL,1),(9,'LoanBoarding','Loan Boarding',17,'',NULL,NULL,NULL,NULL,1),(16,'UI','Real Foundation UI',51,'',NULL,NULL,NULL,NULL,1),(17,'IAM','Identity Access Management',55,'',NULL,NULL,NULL,NULL,1),(18,'Rules Management','Rules Management',62,'',NULL,NULL,NULL,NULL,1),(19,'Workflow','Workflow',64,'',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `iam_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_ref_code`
--

DROP TABLE IF EXISTS `iam_ref_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_ref_code` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `REF_DESC` varchar(255) NOT NULL,
  `REF_TYPE` varchar(8) NOT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  `REF_CODE` char(36) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `active` (`ACTIVE`),
  KEY `ref_type` (`REF_TYPE`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_ref_code`
--

LOCK TABLES `iam_ref_code` WRITE;
/*!40000 ALTER TABLE `iam_ref_code` DISABLE KEYS */;
INSERT INTO `iam_ref_code` VALUES (30,'Admin','UTYPE','',NULL,NULL,NULL,NULL,1,'Admin'),(31,'Vendor','UTYPE','',NULL,NULL,NULL,NULL,1,'Vendor'),(32,'Servicer','UTYPE','',NULL,NULL,NULL,NULL,1,'Servicer'),(33,'Borrower','UTYPE','',NULL,NULL,NULL,NULL,1,'Borrower'),(34,'Partner','UTYPE','',NULL,NULL,NULL,NULL,1,'Partner'),(35,'Investor','UTYPE','',NULL,NULL,NULL,NULL,1,'Investor'),(50,'Create','PTYPE','',NULL,NULL,NULL,NULL,1,'Create'),(51,'Read','PTYPE','',NULL,NULL,NULL,NULL,1,'Read'),(52,'Update','PTYPE','',NULL,NULL,NULL,NULL,1,'Update'),(53,'Delete','PTYPE','',NULL,NULL,NULL,NULL,1,'Delete'),(54,'Report','PTYPE','',NULL,NULL,NULL,NULL,1,'Report'),(55,'Upload','PTYPE','',NULL,NULL,NULL,NULL,1,'Upload'),(56,'Download','PTYPE','',NULL,NULL,NULL,NULL,1,'Download'),(57,'Assign','PTYPE','',NULL,NULL,NULL,NULL,1,'Assign'),(58,'Claim','PTYPE','',NULL,NULL,NULL,NULL,1,'Claim'),(101,'Disable','PTYPE','',NULL,NULL,NULL,NULL,1,'Disable'),(102,'Relate','PTYPE','',NULL,NULL,NULL,NULL,1,'Relate');
/*!40000 ALTER TABLE `iam_ref_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_registration`
--

DROP TABLE IF EXISTS `iam_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_registration` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `FIRST_NAME` varchar(255) NOT NULL,
  `LAST_NAME` varchar(255) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `TOKEN` char(36) NOT NULL,
  `APPROVED_BY` bigint(19) DEFAULT NULL,
  `APPROVED_ON` bigint(19) DEFAULT NULL,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  `USER_TYPE` varchar(36) NOT NULL,
  `TENANT_ID` bigint(19) NOT NULL,
  `MANAGED` bit(1) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `EMAIL` (`EMAIL`),
  KEY `token` (`TOKEN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_registration`
--

LOCK TABLES `iam_registration` WRITE;
/*!40000 ALTER TABLE `iam_registration` DISABLE KEYS */;
/*!40000 ALTER TABLE `iam_registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_resource`
--

DROP TABLE IF EXISTS `iam_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_resource` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `PRODUCT_ID` bigint(19) NOT NULL,
  `RESOURCE_NAME` char(128) NOT NULL,
  `RESOURCE_DESC` char(255) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_rf_resource` (`PRODUCT_ID`,`RESOURCE_NAME`),
  KEY `active` (`ACTIVE`),
  CONSTRAINT `FKrf_resource1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `iam_product` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_resource`
--

LOCK TABLES `iam_resource` WRITE;
/*!40000 ALTER TABLE `iam_resource` DISABLE KEYS */;
INSERT INTO `iam_resource` VALUES (6,8,'Exception.Task','RSNG CR Exception Task','',NULL,NULL,NULL,NULL,1),(7,8,'Approval.Task','RSNG CR Approval Task','',NULL,NULL,NULL,NULL,1),(8,8,'Exception.Missing.Required.Field','Exception.Missing.Required.Field','',NULL,NULL,NULL,NULL,1),(9,8,'Exception.Investor.Data','Exception.Investor.Data','',NULL,NULL,NULL,NULL,1),(10,8,'Exception.Special.Payment','Exception.Special.Payment','',NULL,NULL,NULL,NULL,1),(11,8,'Exception.Invalid.Field','Exception.Invalid.Field','',NULL,NULL,NULL,NULL,1),(12,8,'Exception.Bankruptcy.Data','Exception.Bankruptcy.Data','',NULL,NULL,NULL,NULL,1),(13,8,'Exception.Foreclosure.Data','Exception.Foreclosure.Data','',NULL,NULL,NULL,NULL,1),(14,8,'Exception.Portfolio.Transfer','Exception.Portfolio.Transfer','',NULL,NULL,NULL,NULL,1),(15,8,'Exception.Charge-off.Data','Exception.Charge-off.Data','',NULL,NULL,NULL,NULL,1),(16,8,'Exception.Account.Close','Exception.Account.Close','',NULL,NULL,NULL,NULL,1),(17,9,'Deals','Deals','',NULL,NULL,NULL,NULL,1),(18,9,'MyDealSetupTasks','MyDealSetupTasks','',NULL,NULL,NULL,NULL,1),(101,16,'Home','Controls Visibility of Home tab in the NavBar','',NULL,NULL,NULL,NULL,1),(102,16,'Servicing','Controls Visibility of Servicing tab in the NavBar','',NULL,NULL,NULL,NULL,1),(103,16,'Documents','Controls Visibility of Documents tab in the NavBar','',NULL,NULL,NULL,NULL,1),(104,16,'Orders','Controls Visibility of Orders tab in the NavBar','',NULL,NULL,NULL,NULL,1),(105,16,'Default','Controls Visibility of Default tab in the NavBar','',NULL,NULL,NULL,NULL,1),(106,16,'REO','Controls Visibility of REO tab in the NavBar','',NULL,NULL,NULL,NULL,1),(107,16,'Reports','Controls Visibility of Reports tab in the NavBar','',NULL,NULL,NULL,NULL,1),(108,16,'Administration','Controls Visibility of Administration tab in the NavBar','',NULL,NULL,NULL,NULL,1),(109,16,'UserMgmt','Controls Visibility of UserMgmt in Admin tab','',NULL,NULL,NULL,NULL,1),(110,16,'RuleMgmt','Controls Visibility of RuleMgmt in Admin tab','',NULL,NULL,NULL,NULL,1),(111,16,'TenantMgmt','Controls Visibility of TenantMgmt in Admin tab','',NULL,NULL,NULL,NULL,1),(112,16,'InvestorMgmt','Controls Visibility of InvestorMgmt in Admin tab','',NULL,NULL,NULL,NULL,1),(113,16,'LoanBoarding','Controls Visibility of LoanBoarding in Admin tab','',NULL,NULL,NULL,NULL,1),(114,16,'LoanDeboarding','Controls Visibility of LoanDeboarding in Admin tab','',NULL,NULL,NULL,NULL,1),(115,16,'UsageBilling','Controls Visibility of UsageBilling in Admin tab','',NULL,NULL,NULL,NULL,1),(116,16,'SystemConfig','Controls Visibility of SystemConfig in Admin tab','',NULL,NULL,NULL,NULL,1),(117,16,'Audit','Controls Visibility of Audit in Admin tab','',NULL,NULL,NULL,NULL,1),(118,16,'CreditReporting','Controls Visibility of CreditReporting in Servicing tab','',NULL,NULL,NULL,NULL,1),(119,17,'Resource','Controls CRUD to resources and relation to role','',NULL,NULL,NULL,NULL,1),(120,17,'Role','Controls CRUD to roles and relation to group','',NULL,NULL,NULL,NULL,1),(121,17,'Group','Controls CRUD to groups and relation to users','',NULL,NULL,NULL,NULL,1),(122,17,'Product','Controls CRUD to product','',NULL,NULL,NULL,NULL,1),(123,17,'User','Controls CRUD to users and relation to role','',NULL,NULL,NULL,NULL,1),(124,17,'Tenant','Controls CRUD to tenant configuration and mgmt.','',NULL,NULL,NULL,NULL,1),(125,17,'UserAdmin','UI.UserMgmt.Read','',NULL,NULL,NULL,NULL,1),(126,18,'Rule Set','Controls CRUD to rule sets and relation to publish','',NULL,NULL,NULL,NULL,1),(127,18,'Rules','Controls CRUD to rules','',NULL,NULL,NULL,NULL,1),(128,18,'Tests','Controls CRUD to tests','',NULL,NULL,NULL,NULL,1),(129,18,'FactModels','Controls CRUD to fact model(s)','',NULL,NULL,NULL,NULL,1),(130,19,'Reports','Reports','',NULL,NULL,NULL,NULL,1),(131,19,'UsageBilling','UsageBilling','',NULL,NULL,NULL,NULL,1),(132,19,'InvestorAccess','InvestorAccess','',NULL,NULL,NULL,NULL,1),(133,19,'CoordinatorAccess','CoordinatorAccess','',NULL,NULL,NULL,NULL,1),(134,19,'PerformerAccess','PerformerAccess','',NULL,NULL,NULL,NULL,1),(135,19,'AnalystAccess','AnalystAccess','',NULL,NULL,NULL,NULL,1),(136,19,'ManagerAccess','ManagerAccess','',NULL,NULL,NULL,NULL,1),(137,19,'BorrowerAccess','BorrowerAccess','',NULL,NULL,NULL,NULL,1),(138,16,'Configurations','Configurations','',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `iam_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_role`
--

DROP TABLE IF EXISTS `iam_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_role` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `ROLE_NAME` varchar(36) DEFAULT NULL,
  `ROLE_DESC` char(255) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  `TENANT_ID` bigint(19) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ROLE_NAME` (`ROLE_NAME`,`TENANT_ID`),
  KEY `FKiam_role_tenant1` (`TENANT_ID`),
  KEY `active` (`ACTIVE`),
  CONSTRAINT `FKiam_role_tenant1` FOREIGN KEY (`TENANT_ID`) REFERENCES `iam_tenant` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_role`
--

LOCK TABLES `iam_role` WRITE;
/*!40000 ALTER TABLE `iam_role` DISABLE KEYS */;
INSERT INTO `iam_role` VALUES (1,'ROLE_GUEST','Guest User Role','',NULL,NULL,NULL,NULL,1,2),(2,'ROLE_USER','Regular User Role','',NULL,NULL,NULL,NULL,1,2),(6,'ROLE_SVC_ADMIN','REALServicing Admin Role','',NULL,NULL,NULL,NULL,1,2),(7,'ROLE_DOC_ADMIN','REALDoc Admin Role','',NULL,NULL,NULL,NULL,1,2),(8,'ROLE_TRANS_ADMIN','REALTrans Admin Role','',NULL,NULL,NULL,NULL,1,2),(9,'ROLE_REMIT_ADMIN','REALRemit Admin Role','',NULL,NULL,NULL,NULL,1,2),(10,'ROLE_RESOLUTION_ADMIN','REALResolution Admin Role','',NULL,NULL,NULL,NULL,1,2),(11,'ROLE_RESOLUTION_BK','REALResolution BK Role','',NULL,NULL,NULL,NULL,1,2),(12,'ROLE_RESOLUTION_FC','REALResolution FC Role','',NULL,NULL,NULL,NULL,1,2),(13,'ROLE_CR_SPECIALIST_1','Credit Reporting Specialist 1','',NULL,NULL,NULL,NULL,1,2),(14,'ROLE_CR_MANAGER','Credit Reporting Manager','',NULL,NULL,NULL,NULL,1,2),(15,'ROLE_CR_SPECIALIST_2','Credit Reporting Specialist 2','',NULL,NULL,NULL,NULL,1,2),(16,'ROLE_DEAL_SUPERVISOR','Loan boarding deal supervisor','',NULL,NULL,NULL,NULL,1,2),(17,'ROLE_DEAL_ANALYST','Loan boarding deal analyst','',NULL,NULL,NULL,NULL,1,2),(18,'ROLE_CR_USER','CR default user role','',NULL,NULL,NULL,NULL,1,2),(51,'UI_USER','UI_USER','',NULL,NULL,NULL,NULL,1,1),(52,'UI_Admin','UI_Admin','',NULL,NULL,NULL,NULL,1,1),(53,'BOB_UI_USER','BOB_UI_USER','',NULL,NULL,NULL,NULL,1,1),(54,'Equator_UI_USER','Equator_UI_USER','',NULL,NULL,NULL,NULL,1,1),(55,'ROLE_IAM_USER','IAM_User','',NULL,NULL,NULL,NULL,1,1),(56,'ROLE_IAM_ADMIN','IAM_Admin','',NULL,NULL,NULL,NULL,1,1),(57,'Sys_Admin','Sys_Admin','',NULL,NULL,NULL,NULL,1,1),(58,'Tenant_Admin','Tenant_Admin','',NULL,NULL,NULL,NULL,1,1),(59,'HelpDesk','HelpDesk','',NULL,NULL,NULL,NULL,1,1),(60,'Delegated Sys_Admin','Delegated Sys_Admin','',NULL,NULL,NULL,NULL,1,1),(61,'Delegated Tenant_Admin','Delegated Tenant_Admin','',NULL,NULL,NULL,NULL,1,1),(62,'Rules_User','Rules_User','',NULL,NULL,NULL,NULL,1,1),(63,'ROLE_RULES_ADMIN','Rules_admin','',NULL,NULL,NULL,NULL,1,1),(64,'ReportsAdmin','ReportsAdmin','',NULL,NULL,NULL,NULL,1,1),(65,'BillingAdmin','BillingAdmin','',NULL,NULL,NULL,NULL,1,1),(66,'InvestorView','InvestorView','',NULL,NULL,NULL,NULL,1,1),(67,'Coordinator','Coordinator','',NULL,NULL,NULL,NULL,1,1),(68,'Performer','Performer','',NULL,NULL,NULL,NULL,1,1),(69,'Analyst','Analyst','',NULL,NULL,NULL,NULL,1,1),(70,'Manager','Manager','',NULL,NULL,NULL,NULL,1,1),(71,'PayerView','PayerView','',NULL,NULL,NULL,NULL,1,1),(101,'Servicer_View','Servicer View','',NULL,NULL,NULL,NULL,1,1),(102,'Admin_View','Admin View','',NULL,NULL,NULL,NULL,1,1),(103,'Vendor_View','Vendor View','',NULL,NULL,NULL,NULL,1,1),(104,'Facilitator_View','Facilitator View','',NULL,NULL,NULL,NULL,1,1),(105,'Investor_View','Investor View','',NULL,NULL,NULL,NULL,1,1),(106,'Borrower_View','Borrower View','',NULL,NULL,NULL,NULL,1,1),(107,'Partner_View','Partner View','',NULL,NULL,NULL,NULL,1,1);
/*!40000 ALTER TABLE `iam_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_role_permission`
--

DROP TABLE IF EXISTS `iam_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_role_permission` (
  `ROLE_ID` bigint(19) NOT NULL,
  `PERMISSION_ID` bigint(19) NOT NULL,
  KEY `FKrf_role_permission1` (`PERMISSION_ID`),
  KEY `FKrf_role_permission2` (`ROLE_ID`),
  CONSTRAINT `FKrf_role_permission2` FOREIGN KEY (`ROLE_ID`) REFERENCES `iam_role` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FKrf_role_permission1` FOREIGN KEY (`PERMISSION_ID`) REFERENCES `iam_permission` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_role_permission`
--

LOCK TABLES `iam_role_permission` WRITE;
/*!40000 ALTER TABLE `iam_role_permission` DISABLE KEYS */;
INSERT INTO `iam_role_permission` VALUES (13,18),(13,19),(13,20),(13,21),(14,18),(14,19),(14,20),(14,21),(14,22),(14,23),(14,24),(14,25),(13,26),(13,27),(13,28),(13,29),(15,30),(15,31),(15,32),(15,33),(15,34),(16,35),(16,36),(17,35),(17,36),(16,213),(16,214),(17,213),(17,214),(51,201),(52,201),(52,202),(52,203),(52,204),(52,205),(52,206),(52,207),(52,208),(52,209),(52,210),(52,211),(52,212),(52,213),(52,214),(52,215),(52,216),(52,217),(52,218),(53,201),(53,202),(53,203),(53,204),(53,205),(53,206),(53,207),(53,208),(53,217),(53,218),(54,201),(54,207),(54,208),(54,209),(54,210),(54,211),(54,212),(54,213),(54,214),(54,215),(54,216),(54,217),(54,218),(55,220),(55,226),(55,231),(55,235),(55,238),(55,244),(55,209),(55,208),(55,201),(56,219),(56,220),(56,221),(56,222),(56,223),(56,224),(56,225),(56,226),(56,227),(56,228),(56,229),(56,230),(56,231),(56,232),(56,233),(56,234),(56,237),(56,238),(56,239),(56,240),(56,241),(56,242),(56,209),(56,208),(56,201),(57,219),(57,220),(57,221),(57,222),(57,223),(57,224),(57,225),(57,226),(57,227),(57,228),(57,229),(57,230),(57,231),(57,232),(57,233),(57,234),(57,235),(57,236),(57,237),(57,238),(57,239),(57,240),(57,241),(57,242),(57,243),(57,244),(57,245),(57,246),(57,247),(57,209),(57,208),(57,201),(58,220),(58,223),(58,224),(58,225),(58,226),(58,227),(58,228),(58,229),(58,230),(58,231),(58,232),(58,233),(58,234),(58,237),(58,238),(58,239),(58,240),(58,241),(58,242),(58,209),(58,208),(58,201),(59,220),(59,222),(59,223),(59,226),(59,229),(59,231),(59,232),(59,233),(59,234),(59,235),(59,236),(59,237),(59,238),(59,239),(59,240),(59,242),(59,244),(59,247),(59,209),(60,220),(60,223),(60,225),(60,226),(60,227),(60,228),(60,229),(60,230),(60,231),(60,232),(60,233),(60,234),(60,235),(60,236),(60,237),(60,238),(60,239),(60,240),(60,241),(60,242),(60,244),(60,245),(60,209),(61,220),(61,224),(61,226),(61,227),(61,228),(61,229),(61,230),(61,231),(61,232),(61,233),(61,234),(61,237),(61,238),(61,239),(61,240),(61,242),(61,209),(62,250),(62,256),(62,261),(62,266),(62,210),(62,208),(63,249),(63,250),(63,251),(63,252),(63,253),(63,254),(63,255),(63,256),(63,257),(63,258),(63,259),(63,260),(63,261),(63,262),(63,263),(63,264),(63,265),(63,266),(63,267),(63,268),(63,269),(63,210),(63,208),(64,270),(64,271),(64,272),(64,273),(64,274),(64,275),(65,276),(65,277),(65,278),(65,279),(65,280),(65,281),(66,282),(66,283),(66,284),(66,285),(66,286),(66,287),(66,212),(66,201),(66,207),(67,288),(67,289),(67,290),(67,291),(67,292),(67,293),(67,204),(67,201),(68,294),(68,295),(68,296),(68,297),(68,298),(68,299),(68,204),(68,201),(69,300),(69,301),(69,302),(69,303),(69,304),(69,305),(69,218),(69,201),(70,306),(70,307),(70,308),(70,309),(70,310),(70,311),(70,218),(70,201),(71,313),(71,314),(71,218),(71,201),(101,201),(101,202),(101,208),(101,212),(101,209),(102,201),(102,208),(102,209),(102,210),(102,331),(103,201),(103,204),(103,207),(103,208),(103,215),(103,209),(104,201),(104,204),(104,207),(104,208),(104,215),(104,209),(105,201),(105,204),(105,207),(105,208),(105,215),(105,209),(106,201),(106,207),(106,208),(106,215),(106,209),(107,201),(107,207),(107,208),(107,215),(107,209);
/*!40000 ALTER TABLE `iam_role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_tenant`
--

DROP TABLE IF EXISTS `iam_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_tenant` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) NOT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  `BRANDING` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME` (`NAME`),
  KEY `active` (`ACTIVE`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_tenant`
--

LOCK TABLES `iam_tenant` WRITE;
/*!40000 ALTER TABLE `iam_tenant` DISABLE KEYS */;
INSERT INTO `iam_tenant` VALUES (1,'SYSTEM','',NULL,NULL,NULL,NULL,1,NULL),(2,'OCWEN','',NULL,NULL,NULL,NULL,1,NULL),(3,'EQUATOR','',NULL,NULL,NULL,NULL,1,NULL),(4,'BankOfBoston','',NULL,NULL,NULL,NULL,1,NULL),(5,'Demo','',NULL,NULL,NULL,NULL,1,NULL);
/*!40000 ALTER TABLE `iam_tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_tenant_product`
--

DROP TABLE IF EXISTS `iam_tenant_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_tenant_product` (
  `TENANT_ID` bigint(19) NOT NULL,
  `PRODUCT_ID` bigint(19) NOT NULL,
  KEY `FKrf_tenant_product1` (`TENANT_ID`),
  KEY `FKrf_tenant_product2` (`PRODUCT_ID`),
  CONSTRAINT `FKrf_tenant_product2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `iam_product` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FKrf_tenant_product1` FOREIGN KEY (`TENANT_ID`) REFERENCES `iam_tenant` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_tenant_product`
--

LOCK TABLES `iam_tenant_product` WRITE;
/*!40000 ALTER TABLE `iam_tenant_product` DISABLE KEYS */;
INSERT INTO `iam_tenant_product` VALUES (1,16),(1,17),(1,18),(1,19),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(2,16),(2,17),(2,18),(2,19),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(3,16),(3,17),(3,18),(3,19),(3,7),(3,8),(3,9),(4,16),(4,17),(4,18),(4,19),(4,4),(4,5),(4,6);
/*!40000 ALTER TABLE `iam_tenant_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_tenant_user`
--

DROP TABLE IF EXISTS `iam_tenant_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_tenant_user` (
  `TENANT_ID` bigint(19) NOT NULL,
  `USER_ID` bigint(19) NOT NULL,
  KEY `FKiam_tenat_user1` (`TENANT_ID`),
  KEY `FKiam_tenat_user2` (`USER_ID`),
  CONSTRAINT `FKiam_tenat_user2` FOREIGN KEY (`USER_ID`) REFERENCES `iam_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKiam_tenat_user1` FOREIGN KEY (`TENANT_ID`) REFERENCES `iam_tenant` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_tenant_user`
--

LOCK TABLES `iam_tenant_user` WRITE;
/*!40000 ALTER TABLE `iam_tenant_user` DISABLE KEYS */;
INSERT INTO `iam_tenant_user` VALUES (1,3),(1,33),(1,39),(1,40),(2,19),(2,20),(2,21),(2,22),(2,23),(2,24),(2,25),(2,26),(2,27),(2,28),(2,29),(2,30),(2,31),(2,32),(2,34),(2,35),(2,36),(2,38),(2,40),(2,41),(2,42),(2,43),(2,44),(2,45),(2,46),(2,47),(2,48),(2,49),(2,50),(2,51),(2,52),(2,53),(1,1),(1,2),(1,56),(2,57),(2,58),(2,37),(4,59),(4,60),(4,61),(3,62),(3,63),(3,64),(5,65),(5,66),(5,67),(5,68);
/*!40000 ALTER TABLE `iam_tenant_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_user`
--

DROP TABLE IF EXISTS `iam_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_user` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `USER_NAME` varchar(128) NOT NULL,
  `ACCESS_HOUR_START` decimal(5,2) DEFAULT NULL,
  `ACCESS_HOUR_END` decimal(5,2) DEFAULT NULL,
  `ACCESS_IP_MASK` varchar(24) DEFAULT NULL,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  `USER_TYPE` varchar(36) NOT NULL,
  `MANAGED` bit(1) NOT NULL DEFAULT b'1',
  `SECRET_QUESTION_1` varchar(255) DEFAULT NULL,
  `SECRET_ANSWER_1` varchar(255) DEFAULT NULL,
  `SECRET_QUESTION_2` varchar(255) DEFAULT NULL,
  `SECRET_ANSWER_2` varchar(255) DEFAULT NULL,
  `ACTIVE` bit(1) NOT NULL DEFAULT b'1',
  `DEACTIVATE_DATE` bigint(19) DEFAULT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `NAME_PREFIX` varchar(36) DEFAULT NULL,
  `FIRST_NAME` varchar(255) NOT NULL,
  `LAST_NAME` varchar(255) NOT NULL,
  `MIDDLE_NAME` varchar(255) DEFAULT NULL,
  `NAME_SUFFIX` varchar(36) DEFAULT NULL,
  `ALIAS` varchar(255) DEFAULT NULL,
  `PRIMARY_PHONE` varchar(36) DEFAULT NULL,
  `ALTERNATIVE_PHONE` varchar(36) DEFAULT NULL,
  `FAX` varchar(36) DEFAULT NULL,
  `ADDRESS_ID` bigint(19) DEFAULT NULL,
  `COMPANY` varchar(255) DEFAULT NULL,
  `DEPARTMENT` varchar(255) DEFAULT NULL,
  `Office` varchar(255) DEFAULT NULL,
  `TAGS` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `USER_NAME` (`USER_NAME`),
  KEY `FKrf_user5` (`ADDRESS_ID`),
  KEY `active` (`ACTIVE`),
  CONSTRAINT `FKrf_user5` FOREIGN KEY (`ADDRESS_ID`) REFERENCES `iam_postal_address` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_user`
--

LOCK TABLES `iam_user` WRITE;
/*!40000 ALTER TABLE `iam_user` DISABLE KEYS */;
INSERT INTO `iam_user` VALUES (1,'steve.brown@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown@altisource.com',NULL,'Steve','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'peter.pan@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Admin','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'peter.pan@altisource.com',NULL,'Peter','Pan',NULL,NULL,NULL,'737-223-1099',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'chenyi',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Admin','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'yi.chen@altisource.com',NULL,'Brandon','Chen',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,'srao',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'sunil.rao@altisource.com',NULL,'Sunil','Rao',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,'rroy',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'rana.roy@altisource.com',NULL,'Rana','Roy',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,'bkumar',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'binit.kumar@altisource.com',NULL,'Binit','Kumar',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,'skumar',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'sunil.Krishnamurthy@altisource.com',NULL,'Sunil','Kumar',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,'peter.cr@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'peter.cr@altisource.com',NULL,'Peter','Smith',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(24,'mark.cr@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'mark.cr@altisource.com',NULL,'Mark','Sloan',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(25,'mary.cr@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'mary.cr@altisource.com',NULL,'Mary','Chen',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(26,'rules.user@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'rules.user@altisource.com',NULL,'Rules','User',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(27,'rules.admin@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'rules.admin@altisource.com',NULL,'Rules','Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(28,'milind.deobhankar@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'milind.deobhankar@altisource.com',NULL,'Milind','Deobhankar',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(29,'arindum.roy@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'arindum.roy@altisource.com',NULL,'Arindum','Roy',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(30,'david.cr@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'david.cr@altisource.com',NULL,'David','Martinez',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(31,'bruce.cr@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'bruce.cr@altisource.com',NULL,'Bruce','Almighty',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(32,'amy.cr@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'amy.cr@altisource.com',NULL,'Amy','Adams',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(33,'iam.sysadmin@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Admin','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'iam.sysadmin@altisource.com',NULL,'IAM','SYSADMIN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(34,'mary.stevens@ocwen.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'mary.stevens@ocwen.com',NULL,'Mary','Stevens',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(35,'mike.chu@ocwen.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'mike.chu@ocwen.com',NULL,'Mike','Chu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(36,'ed.helmsley@ocwen.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'ed.helmsley@ocwen.com',NULL,'Ed','Helmsley',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(37,'kristen.allen@ocwen.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'kristen.allen@ocwen.com',NULL,'Kristen','Allen',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(38,'ted.kim@ocwen.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'ted.kim@ocwen.com',NULL,'Ted','Kim',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(39,'iam.user@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'iam.user@altisource.com',NULL,'IAM','USER',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(40,'iam.norole@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'iam.norole@altisource.com',NULL,'IAM','NO ROLE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(41,'steve.brown1@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown1@altisource.com',NULL,'Steve1','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(42,'steve.brown2@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown2@altisource.com',NULL,'Steve2','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(43,'steve.brown3@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown3@altisource.com',NULL,'Steve3','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(44,'steve.brown4@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown4@altisource.com',NULL,'Steve4','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(45,'steve.brown5@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown5@altisource.com',NULL,'Steve5','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(46,'steve.brown6@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown6@altisource.com',NULL,'Steve6','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(47,'steve.brown7@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown7@altisource.com',NULL,'Steve7','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(48,'steve.brown8@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown8@altisource.com',NULL,'Steve8','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(49,'steve.brown9@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown9@altisource.com',NULL,'Steve9','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(50,'steve.brown10@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown10@altisource.com',NULL,'Steve10','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(51,'steve.brown19@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown11@altisource.com',NULL,'Steve11','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(52,'steve.brown110@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown12@altisource.com',NULL,'Steve12','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(53,'steve.brownddd9@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown13@altisource.com',NULL,'Steve13','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(54,'steve.brown12de10@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown14@altisource.com',NULL,'Steve14','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(56,'kristen.allen@altisource.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'kristen.allen@altisource.com',NULL,'Kristen','Allen',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(57,'peter.pan@ocwen.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Admin','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'peter.pan@ocwen.com',NULL,'Peter','Pan',NULL,NULL,NULL,'737-223-1099',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(58,'steve.brown@ocwen.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown@ocwen.com',NULL,'Steve','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(59,'peter.pan@BankOfBoston.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Admin','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'peter.pan@BankOfBoston.com',NULL,'Peter','Pan',NULL,NULL,NULL,'737-223-1099',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(60,'steve.brown@BankOfBoston.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown@BankOfBoston.com',NULL,'Steve','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(61,'kristen.allen@BankOfBoston.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'kristen.allen@BankOfBoston.com',NULL,'Kristen','Allen',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(62,'peter.pan@equator.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Admin','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'peter.pan@equator.com',NULL,'Peter','Pan',NULL,NULL,NULL,'737-223-1099',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(63,'steve.brown@equator.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'steve.brown@equator.com',NULL,'Steve','Brown',NULL,NULL,NULL,'617-374-2239',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(64,'kristen.allen@equator.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Servicer','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'kristen.allen@equator.com',NULL,'Kristen','Allen',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(65,'Demo.borrower@altilab.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Borrower','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'Demo.borrower@altilab.com',NULL,'Demo','Barrower',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(66,'Demo.facilitator@altilab.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'facilitator','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'Demo.facilitator@altilab.com',NULL,'Demo','Facilitator',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(67,'Demo.investor@altilab.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Investor','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'Demo.investor@altilab.com',NULL,'Demo','Investor',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(68,'Demo.vendor@altilab.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Vendor','','test question 1','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','test question 2','yCCCmaduvmePyQxfUuMnIxRJM1LzyVkng5gorYPlcyQ=','',NULL,'Demo.vendor@altilab.com',NULL,'Demo','Vendor',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `iam_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_user_group`
--

DROP TABLE IF EXISTS `iam_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_user_group` (
  `USER_ID` bigint(19) NOT NULL,
  `GROUP_ID` bigint(19) NOT NULL,
  KEY `FKrf_user_group1` (`GROUP_ID`),
  KEY `FKrf_user_group2` (`USER_ID`),
  CONSTRAINT `FKrf_user_group2` FOREIGN KEY (`USER_ID`) REFERENCES `iam_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKrf_user_group1` FOREIGN KEY (`GROUP_ID`) REFERENCES `iam_group` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_user_group`
--

LOCK TABLES `iam_user_group` WRITE;
/*!40000 ALTER TABLE `iam_user_group` DISABLE KEYS */;
INSERT INTO `iam_user_group` VALUES (2,1),(2,21),(57,28),(62,36),(59,44),(1,24),(1,64),(58,31),(58,65),(60,47),(60,67),(63,39),(63,66),(56,24),(56,64),(37,31),(37,65),(61,47),(61,67),(64,39),(64,66);
/*!40000 ALTER TABLE `iam_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_user_legacy`
--

DROP TABLE IF EXISTS `iam_user_legacy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_user_legacy` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `USER_ID` bigint(19) NOT NULL,
  `LEGACY_ID` varchar(48) NOT NULL,
  `SP_NAME` varchar(48) NOT NULL,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  KEY `FKiam_user_legacy1` (`USER_ID`),
  CONSTRAINT `FKiam_user_legacy1` FOREIGN KEY (`USER_ID`) REFERENCES `iam_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_user_legacy`
--

LOCK TABLES `iam_user_legacy` WRITE;
/*!40000 ALTER TABLE `iam_user_legacy` DISABLE KEYS */;
/*!40000 ALTER TABLE `iam_user_legacy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_user_password_token`
--

DROP TABLE IF EXISTS `iam_user_password_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_user_password_token` (
  `ID` bigint(19) NOT NULL AUTO_INCREMENT,
  `USER_ID` bigint(19) NOT NULL,
  `TOKEN` char(80) NOT NULL,
  `CLAIMED_ON` bigint(19) DEFAULT NULL,
  `EXPIRES_ON` bigint(19) NOT NULL,
  `CREATED_BY` bigint(19) DEFAULT NULL,
  `CREATED_ON` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_BY` bigint(19) DEFAULT NULL,
  `LAST_UPDATED_ON` bigint(19) DEFAULT NULL,
  `VERSION_NUMBER` bigint(19) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `token` (`TOKEN`),
  KEY `FKrf_user_password_token` (`USER_ID`),
  CONSTRAINT `FKrf_user_password_token` FOREIGN KEY (`USER_ID`) REFERENCES `iam_user` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_user_password_token`
--

LOCK TABLES `iam_user_password_token` WRITE;
/*!40000 ALTER TABLE `iam_user_password_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `iam_user_password_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iam_user_role`
--

DROP TABLE IF EXISTS `iam_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iam_user_role` (
  `USER_ID` bigint(19) NOT NULL,
  `ROLE_ID` bigint(19) NOT NULL,
  KEY `FKrf_user_role1` (`ROLE_ID`),
  KEY `FKrf_user_role2` (`USER_ID`),
  CONSTRAINT `FKrf_user_role2` FOREIGN KEY (`USER_ID`) REFERENCES `iam_user` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FKrf_user_role1` FOREIGN KEY (`ROLE_ID`) REFERENCES `iam_role` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iam_user_role`
--

LOCK TABLES `iam_user_role` WRITE;
/*!40000 ALTER TABLE `iam_user_role` DISABLE KEYS */;
INSERT INTO `iam_user_role` VALUES (1,56),(3,56),(25,14),(23,13),(24,13),(2,2),(2,55),(19,10),(19,11),(19,12),(20,10),(20,11),(20,12),(21,11),(22,12),(26,2),(27,2),(27,63),(28,9),(28,2),(29,2),(30,15),(31,15),(32,14),(35,16),(34,16),(38,17),(23,18),(24,18),(25,18),(30,18),(31,18),(32,18),(36,17),(37,17),(33,55),(33,56),(39,55),(2,51),(2,52),(2,56),(2,63),(2,64),(2,65),(2,57),(57,51),(57,52),(57,56),(57,58),(57,63),(57,65),(62,51),(62,54),(62,56),(62,58),(62,63),(62,65),(59,53),(59,58),(59,56),(59,63),(59,65),(1,69),(58,69),(60,69),(63,69),(56,70),(37,70),(61,70),(64,70),(65,71),(66,69),(66,70),(67,66),(68,67),(68,68);
/*!40000 ALTER TABLE `iam_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-08-05 19:29:17
