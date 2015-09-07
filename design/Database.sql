-- MySQL Script generated by MySQL Workbench
-- Mon Sep  7 15:52:22 2015
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`tipo_usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`tipo_usuario` ;

CREATE TABLE IF NOT EXISTS `mydb`.`tipo_usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descripcion` TEXT NULL,
  `nombre_corto` VARCHAR(45) NOT NULL,
  `crea_eventos` BINARY NULL DEFAULT 0,
  `lee_eventos` BINARY NULL DEFAULT 0,
  `puede_solicitar` BINARY NULL DEFAULT 0,
  `administrador` BINARY NULL DEFAULT 0,
  `prioridad` INT NOT NULL DEFAULT 99,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`usuario` ;

CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` TEXT NOT NULL,
  `contraseña` TEXT NOT NULL,
  `id_tipo_usuario` INT NOT NULL,
  `identificador_interno` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `tipo_usuario_idx` (`id_tipo_usuario` ASC),
  CONSTRAINT `tipo_usuario`
    FOREIGN KEY (`id_tipo_usuario`)
    REFERENCES `mydb`.`tipo_usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`campus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`campus` ;

CREATE TABLE IF NOT EXISTS `mydb`.`campus` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` TEXT NOT NULL,
  `descripcion` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`edificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`edificio` ;

CREATE TABLE IF NOT EXISTS `mydb`.`edificio` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` TEXT NOT NULL,
  `descripcion` TEXT NULL,
  `id_campus` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `campus_fk_idx` (`id_campus` ASC),
  CONSTRAINT `campus_fk`
    FOREIGN KEY (`id_campus`)
    REFERENCES `mydb`.`campus` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`espacios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`espacios` ;

CREATE TABLE IF NOT EXISTS `mydb`.`espacios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` TEXT NOT NULL,
  `descripcion` TEXT NULL,
  `id_edificio` INT NOT NULL,
  `id_responsable` INT NULL,
  `capacidad` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `edificio_fk_idx` (`id_edificio` ASC),
  INDEX `responsable_fk_idx` (`id_responsable` ASC),
  CONSTRAINT `edificio_fk`
    FOREIGN KEY (`id_edificio`)
    REFERENCES `mydb`.`edificio` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `responsable_fk`
    FOREIGN KEY (`id_responsable`)
    REFERENCES `mydb`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`peticiones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`peticiones` ;

CREATE TABLE IF NOT EXISTS `mydb`.`peticiones` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `id_espacio` INT NOT NULL,
  `motivo` TEXT NOT NULL,
  `id_tipo` INT NOT NULL,
  `recurrente` TINYINT(1) NOT NULL DEFAULT 0,
  `por_bloque` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_peticion` TIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `usuario_fk_idx` (`id_usuario` ASC),
  INDEX `espacio_fk_idx` (`id_espacio` ASC),
  CONSTRAINT `usuario_fk`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `mydb`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `espacio_fk`
    FOREIGN KEY (`id_espacio`)
    REFERENCES `mydb`.`espacios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`implementos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`implementos` ;

CREATE TABLE IF NOT EXISTS `mydb`.`implementos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` TEXT NOT NULL,
  `descripcion` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`espacio_implemento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`espacio_implemento` ;

CREATE TABLE IF NOT EXISTS `mydb`.`espacio_implemento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_espacio` INT NOT NULL,
  `id_implemento` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `implemento_fk_idx` (`id_implemento` ASC),
  INDEX `espacio_fk_idx` (`id_espacio` ASC),
  CONSTRAINT `espacio_fk`
    FOREIGN KEY (`id_espacio`)
    REFERENCES `mydb`.`espacios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `implemento_fk`
    FOREIGN KEY (`id_implemento`)
    REFERENCES `mydb`.`implementos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bloque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`bloque` ;

CREATE TABLE IF NOT EXISTS `mydb`.`bloque` (
  `id` INT NOT NULL,
  `inicio` TIME NOT NULL,
  `final` TIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bloque_peticion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`bloque_peticion` ;

CREATE TABLE IF NOT EXISTS `mydb`.`bloque_peticion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_peticion` INT NOT NULL,
  `id_bloque` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `peticion_fk_idx` (`id_peticion` ASC),
  INDEX `bloque_fk_idx` (`id_bloque` ASC),
  CONSTRAINT `peticion_fk`
    FOREIGN KEY (`id_peticion`)
    REFERENCES `mydb`.`peticiones` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `bloque_fk`
    FOREIGN KEY (`id_bloque`)
    REFERENCES `mydb`.`bloque` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`intervalo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`intervalo` ;

CREATE TABLE IF NOT EXISTS `mydb`.`intervalo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `inicio` TIME NOT NULL,
  `final` TIME NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `peticion_fk`
    FOREIGN KEY (`id`)
    REFERENCES `mydb`.`peticiones` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`query`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`query` ;

CREATE TABLE IF NOT EXISTS `mydb`.`query` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descripción` TEXT NOT NULL,
  `nombre_corto` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`log` ;

CREATE TABLE IF NOT EXISTS `mydb`.`log` (
  `id` INT NOT NULL,
  `firma_temporal` TIME NOT NULL,
  `comando` TEXT NOT NULL,
  `depuracion` TEXT NULL,
  `resultado` TEXT NULL,
  `id_tipo` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `query_fk_idx` (`id_tipo` ASC),
  INDEX `usuario_fk_idx` (`id_usuario` ASC),
  CONSTRAINT `query_fk`
    FOREIGN KEY (`id_tipo`)
    REFERENCES `mydb`.`query` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `usuario_fk`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `mydb`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
