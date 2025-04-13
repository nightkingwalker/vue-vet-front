-- --------------------------------------------------------
-- Host:                         31.220.82.97
-- Server version:               8.0.39-0ubuntu0.22.04.1 - (Ubuntu)
-- Server OS:                    Linux
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for vet_app_db
CREATE DATABASE IF NOT EXISTS `vet_app_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vet_app_db`;

-- Dumping structure for table vet_app_db.appointments
CREATE TABLE IF NOT EXISTS `appointments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_id` bigint unsigned NOT NULL,
  `pet_id` bigint unsigned NOT NULL,
  `branch_id` bigint unsigned NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` enum('Emergency','Non-Emergency','Regular','FollowUp','Surgery','Grooming') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Regular' COMMENT 'Emergency\r\nRegular\r\nFollowUp\r\nSurgery\r\nGrooming',
  `start` datetime NOT NULL,
  `end` datetime NOT NULL,
  `status` enum('Scheduled','Walkin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Scheduled',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `appointments_client_id_foreign` (`client_id`),
  KEY `appointments_pet_id_foreign` (`pet_id`),
  KEY `appointments_branch_id_foreign` (`branch_id`),
  CONSTRAINT `appointments_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `appointments_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `owners` (`id`) ON DELETE CASCADE,
  CONSTRAINT `appointments_pet_id_foreign` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.branches
CREATE TABLE IF NOT EXISTS `branches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clinic_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `branches_clinic_id_foreign` (`clinic_id`),
  CONSTRAINT `branches_clinic_id_foreign` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.branch_user
CREATE TABLE IF NOT EXISTS `branch_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'staff' COMMENT 'manager, vet, receptionist, etc.',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `branch_user_unique` (`branch_id`,`user_id`),
  KEY `fk_branch_user_user` (`user_id`),
  CONSTRAINT `fk_branch_user_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_branch_user_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.clinics
CREATE TABLE IF NOT EXISTS `clinics` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clinics_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.clinic_user
CREATE TABLE IF NOT EXISTS `clinic_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clinic_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'staff' COMMENT 'admin, manager, vet, staff, etc.',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clinic_user_unique` (`clinic_id`,`user_id`),
  KEY `fk_clinic_user_user` (`user_id`),
  CONSTRAINT `fk_clinic_user_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_clinic_user_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.credit_applications
CREATE TABLE IF NOT EXISTS `credit_applications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `credit_note_id` bigint unsigned NOT NULL,
  `invoice_id` bigint unsigned DEFAULT NULL,
  `payment_id` bigint unsigned DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `applied_by` bigint unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_credit` (`credit_note_id`),
  KEY `idx_invoice` (`invoice_id`),
  KEY `idx_payment` (`payment_id`),
  CONSTRAINT `fk_creditapps_credit` FOREIGN KEY (`credit_note_id`) REFERENCES `credit_notes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_creditapps_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_creditapps_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.credit_notes
CREATE TABLE IF NOT EXISTS `credit_notes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint unsigned NOT NULL,
  `credit_number` varchar(20) NOT NULL,
  `original_amount` decimal(12,2) NOT NULL,
  `remaining_amount` decimal(12,2) NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `reason` enum('refund','overpayment','adjustment','promotional') NOT NULL,
  `notes` text,
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_credit_number` (`credit_number`),
  KEY `idx_client` (`client_id`),
  CONSTRAINT `fk_credits_client` FOREIGN KEY (`client_id`) REFERENCES `owners` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.currencies
CREATE TABLE IF NOT EXISTS `currencies` (
  `code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exchange_rate` decimal(10,4) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.dietary_habits
CREATE TABLE IF NOT EXISTS `dietary_habits` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `food_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meals_per_day` int DEFAULT NULL,
  `quantity_per_meal` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `appetite_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recent_food_change` tinyint(1) DEFAULT '0',
  `change_description` text COLLATE utf8mb4_unicode_ci,
  `water_intake_per_day` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `medical_record_id` (`medical_record_id`),
  CONSTRAINT `dietary_habits_ibfk_1` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.doctors
CREATE TABLE IF NOT EXISTS `doctors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `specialization` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `doctors_email_unique` (`email`),
  KEY `doctors_branch_id_foreign` (`branch_id`),
  CONSTRAINT `doctors_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.grooming_appointments
CREATE TABLE IF NOT EXISTS `grooming_appointments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pet_id` bigint unsigned NOT NULL,
  `branch_id` bigint unsigned NOT NULL,
  `appointment_date` datetime NOT NULL,
  `services` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JSON-encoded list of grooming services requested',
  `groomer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `grooming_appointments_pet_id_foreign` (`pet_id`),
  KEY `grooming_appointments_branch_id_foreign` (`branch_id`),
  CONSTRAINT `grooming_appointments_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grooming_appointments_pet_id_foreign` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.inventory_items
CREATE TABLE IF NOT EXISTS `inventory_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `category` enum('food','pharmaceutical','miscellaneous','toy','Grooming','Surgery','Treatment','examination') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `expiry_date` date DEFAULT NULL,
  `quantity` double NOT NULL DEFAULT '0',
  `cost_price` decimal(10,2) NOT NULL,
  `base_cost_price` decimal(10,2) NOT NULL,
  `last_purchase_price` decimal(10,2) DEFAULT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `base_selling_price` decimal(10,2) NOT NULL,
  `minimum_stock_level` double DEFAULT NULL,
  `barcode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `base_currency` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  PRIMARY KEY (`id`),
  KEY `idx_branch` (`branch_id`),
  KEY `idx_category` (`category`),
  KEY `idx_type` (`type`),
  KEY `idx_expiry` (`expiry_date`),
  CONSTRAINT `fk_inventory_items_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.invoices
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `invoice_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_id` bigint unsigned DEFAULT NULL,
  `pet_id` bigint unsigned DEFAULT NULL,
  `medical_record_id` bigint unsigned DEFAULT NULL,
  `date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `payment_due_date` date DEFAULT NULL,
  `payment_terms` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'due_on_receipt',
  `status` enum('draft','pending','partially_paid','paid','cancelled','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `subtotal` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL,
  `deposit_required` decimal(10,2) DEFAULT NULL,
  `deposit_paid` decimal(10,2) DEFAULT '0.00',
  `amount_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `balance_due` decimal(10,2) GENERATED ALWAYS AS ((`total_amount` - `amount_paid`)) STORED,
  `last_payment_date` datetime DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `exchange_rate` decimal(10,4) NOT NULL DEFAULT '1.0000',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_invoice_number` (`invoice_number`),
  KEY `idx_branch` (`branch_id`),
  KEY `idx_client` (`client_id`),
  KEY `idx_status` (`status`),
  KEY `idx_date` (`date`),
  KEY `idx_payment_status` (`status`),
  KEY `idx_balance_due` (`balance_due`),
  KEY `idx_payment_due` (`payment_due_date`),
  KEY `fk_invoices_currency` (`currency_code`),
  CONSTRAINT `fk_invoices_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_invoices_currency` FOREIGN KEY (`currency_code`) REFERENCES `currencies` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.invoice_items
CREATE TABLE IF NOT EXISTS `invoice_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `inventory_item_id` bigint unsigned DEFAULT NULL,
  `cost_price` decimal(10,2) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `quantity` double NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `unit_price_usd` decimal(10,2) DEFAULT NULL,
  `tax_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_price` decimal(10,2) NOT NULL,
  `total_price_usd` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  `exchange_rate` decimal(10,4) NOT NULL DEFAULT '1.0000',
  PRIMARY KEY (`id`),
  KEY `idx_invoice` (`invoice_id`),
  KEY `idx_item` (`inventory_item_id`),
  CONSTRAINT `fk_invoice_items_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_invoice_items_item` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_items` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.late_fees
CREATE TABLE IF NOT EXISTS `late_fees` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_plan_id` bigint unsigned NOT NULL,
  `installment_id` bigint unsigned DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `applied_date` date NOT NULL,
  `waived_by` bigint unsigned DEFAULT NULL COMMENT 'If fee was waived',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_plan` (`payment_plan_id`),
  CONSTRAINT `fk_latefees_plan` FOREIGN KEY (`payment_plan_id`) REFERENCES `payment_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.medical_case_history
CREATE TABLE IF NOT EXISTS `medical_case_history` (
  `h_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `weight` double DEFAULT NULL,
  `behaviour` mediumtext,
  `examination_time` timestamp NULL DEFAULT NULL,
  `latest_vaccine` mediumtext,
  `latest_vaccine_date` date DEFAULT NULL,
  `owner_complaint` mediumtext COMMENT 'شكوى المربي',
  PRIMARY KEY (`h_id`),
  KEY `medical_record_history_medical` (`medical_record_id`),
  CONSTRAINT `medical_record_history_medical` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.medical_examination
CREATE TABLE IF NOT EXISTS `medical_examination` (
  `ex_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `examination_date` datetime NOT NULL,
  `animal_weight` decimal(5,2) DEFAULT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `animal_behavior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `eyes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `eye_sunkenness` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `nose` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `nasal_discharge` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `mouth` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `teeth` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `gums` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `tongue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `mucous_membranes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ears` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `pulse_rate` int DEFAULT NULL,
  `respiratory_rate` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `breathing_pattern` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `breath_sound` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `oxygenation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `nervous_system` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `skin` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `skin_lumps_or_infections` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `skin_coat_condition` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `abdominal_palpation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `lymph_nodes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `body_condition_score` int DEFAULT NULL,
  `hydration_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `capillary_refill_time` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `preliminary_diagnosis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `recommendations` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` timestamp NULL DEFAULT (now()),
  `updated_at` timestamp NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ex_id`) USING BTREE,
  KEY `medical_examination_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `medical_examination_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.medical_images
CREATE TABLE IF NOT EXISTS `medical_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `type` enum('Ultrasound','X-ray') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `organ` text COLLATE utf8mb4_unicode_ci,
  `measurements` tinytext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `abnormalities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_date` date DEFAULT NULL,
  `ref_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `medical_images_medical_record_id_foreign` (`medical_record_id`),
  CONSTRAINT `medical_images_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.medical_records
CREATE TABLE IF NOT EXISTS `medical_records` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pet_id` bigint unsigned NOT NULL,
  `branch_id` bigint unsigned NOT NULL,
  `visit_date` bigint unsigned DEFAULT NULL,
  `diagnosis` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `medical_records_pet_id_foreign` (`pet_id`),
  KEY `medical_records_branch_id_foreign` (`branch_id`),
  KEY `medical_records_appointment_id_forieg` (`visit_date`),
  CONSTRAINT `medical_records_appointment_id_forieg` FOREIGN KEY (`visit_date`) REFERENCES `appointments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `medical_records_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `medical_records_pet_id_foreign` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_additional_notes
CREATE TABLE IF NOT EXISTS `mh_additional_notes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `additional_notes_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `additional_notes_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_antiparasitic_treatment
CREATE TABLE IF NOT EXISTS `mh_antiparasitic_treatment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `treatment_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `treatment_type` enum('flea','tick','worm','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dosage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `administration_date` date DEFAULT NULL,
  `next_due_date` date DEFAULT NULL,
  `administered_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `antiparasitic_treatment_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `antiparasitic_treatment_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_current_symptoms
CREATE TABLE IF NOT EXISTS `mh_current_symptoms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `symptom_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date DEFAULT NULL,
  `symptom_progression` enum('increasing','decreasing','constant') COLLATE utf8mb4_unicode_ci NOT NULL,
  `medication_given` tinyint(1) NOT NULL DEFAULT '0',
  `medication_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `medication_dosage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prescribed_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `current_symptoms_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `current_symptoms_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_diet_water_intake
CREATE TABLE IF NOT EXISTS `mh_diet_water_intake` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `diet_type` enum('dry','canned','home_cooked','raw','mixed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `diet_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `number_of_meals` int unsigned DEFAULT NULL,
  `meal_quantity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `appetite` enum('good','leaves_meal','no_appetite') COLLATE utf8mb4_unicode_ci NOT NULL,
  `recent_diet_change` tinyint(1) NOT NULL DEFAULT '0',
  `diet_change_type` enum('sudden','gradual') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `water_intake` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `diet_water_intake_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `diet_water_intake_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_gastrointestinal_symptoms
CREATE TABLE IF NOT EXISTS `mh_gastrointestinal_symptoms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `vomiting` tinyint(1) NOT NULL DEFAULT '0',
  `vomit_color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vomit_contents` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `vomit_smell` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vomiting_frequency` int unsigned DEFAULT NULL,
  `vomiting_related_to_food` tinyint(1) NOT NULL DEFAULT '0',
  `vomiting_related_to_diarrhea` tinyint(1) NOT NULL DEFAULT '0',
  `diarrhea_started_first` tinyint(1) NOT NULL DEFAULT '0',
  `stool_consistency` enum('normal','soft','watery','hard') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stool_color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stool_frequency` int unsigned DEFAULT NULL,
  `abnormal_stool_contents` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `excessive_licking_of_anus` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `gastrointestinal_symptoms_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `gastrointestinal_symptoms_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_general_health
CREATE TABLE IF NOT EXISTS `mh_general_health` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `activity_level` enum('active','lethargic','sometimes_active','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `vaccination_status` enum('complete','incomplete') COLLATE utf8mb4_unicode_ci NOT NULL,
  `care_location` enum('home','home_garden','street','indoor_outdoor') COLLATE utf8mb4_unicode_ci NOT NULL,
  `other_animals_in_household` tinyint(1) NOT NULL DEFAULT '0',
  `number_of_other_animals` int unsigned DEFAULT NULL,
  `types_of_other_animals` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `previous_diseases_in_other_animals` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `general_health_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `general_health_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_itching_skin_conditions
CREATE TABLE IF NOT EXISTS `mh_itching_skin_conditions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `itching_present` tinyint(1) NOT NULL DEFAULT '0',
  `itching_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `itching_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `skin_condition_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `itching_skin_conditions_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `itching_skin_conditions_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_medical_history
CREATE TABLE IF NOT EXISTS `mh_medical_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `previous_conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `previous_treatments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `surgical_history` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `medical_record_id` (`medical_record_id`) USING BTREE,
  CONSTRAINT `medical_history_ibfk_1` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_medication_history
CREATE TABLE IF NOT EXISTS `mh_medication_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `medication_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `medication_type` enum('antibiotic','painkiller','anti-inflammatory','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dosage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `frequency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `prescribed_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `medication_history_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `medication_history_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_neurological_symptoms
CREATE TABLE IF NOT EXISTS `mh_neurological_symptoms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `neurological_signs` enum('seizures','fainting','nystagmus','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `neurological_signs_frequency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `associated_symptoms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `sudden_onset` tinyint(1) NOT NULL DEFAULT '0',
  `related_to_eating_or_activity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `additional_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `neurological_symptoms_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `neurological_symptoms_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_reproductive_history
CREATE TABLE IF NOT EXISTS `mh_reproductive_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `last_reproductive_cycle_date` date DEFAULT NULL,
  `cycle_length` int unsigned DEFAULT NULL,
  `notable_signs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `other_discharges` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `reproductive_history_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `reproductive_history_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_respiratory_symptoms
CREATE TABLE IF NOT EXISTS `mh_respiratory_symptoms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `cough` tinyint(1) NOT NULL DEFAULT '0',
  `cough_start_date` date DEFAULT NULL,
  `cough_frequency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cough_type` enum('dry','productive') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `breathing_difficulty` tinyint(1) NOT NULL DEFAULT '0',
  `sneezing` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `respiratory_symptoms_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `respiratory_symptoms_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_urinary_symptoms
CREATE TABLE IF NOT EXISTS `mh_urinary_symptoms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `urination_frequency` int unsigned DEFAULT NULL,
  `frequent_litter_box_visits` tinyint(1) NOT NULL DEFAULT '0',
  `urine_volume` enum('large','small','medium') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `urine_color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `urination_type` enum('continuous','intermittent') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `blood_in_urine` tinyint(1) NOT NULL DEFAULT '0',
  `blood_location` enum('beginning','end','throughout') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `abnormal_urinary_discharge` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `genital_discharge` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `excessive_licking_of_genital_area` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `urinary_symptoms_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `urinary_symptoms_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.mh_vaccination_history
CREATE TABLE IF NOT EXISTS `mh_vaccination_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `vaccine_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vaccine_date` date NOT NULL,
  `next_due_date` date DEFAULT NULL,
  `administered_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `vaccination_history_medical_record_id_foreign` (`medical_record_id`) USING BTREE,
  CONSTRAINT `vaccination_history_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.owners
CREATE TABLE IF NOT EXISTS `owners` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `landline` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `birth_date` date DEFAULT NULL,
  `facebook_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instagram_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referral` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'كيف تعرف على العيادة',
  `clinic_notes` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `owners_email_unique` (`email`),
  KEY `owners_branch_id_foreign` (`branch_id`),
  CONSTRAINT `owners_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.owner_complaints
CREATE TABLE IF NOT EXISTS `owner_complaints` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `complaint_detail` text COLLATE utf8mb4_unicode_ci,
  `observation_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `medical_record_id` (`medical_record_id`),
  CONSTRAINT `owner_complaints_ibfk_1` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payments
CREATE TABLE IF NOT EXISTS `payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `payment_method_id` bigint unsigned NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `received_by` bigint unsigned NOT NULL COMMENT 'Employee who processed payment',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `notes` text,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'For manager approval if needed',
  `verified_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_invoice` (`invoice_id`),
  KEY `idx_method` (`payment_method_id`),
  KEY `idx_date` (`payment_date`),
  CONSTRAINT `fk_payments_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payments_method` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_allocations
CREATE TABLE IF NOT EXISTS `payment_allocations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned DEFAULT NULL COMMENT 'Optional: if paying specific line items',
  `amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_payment` (`payment_id`),
  KEY `idx_item` (`invoice_item_id`),
  CONSTRAINT `fk_allocations_item` FOREIGN KEY (`invoice_item_id`) REFERENCES `invoice_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_allocations_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_gateway_transactions
CREATE TABLE IF NOT EXISTS `payment_gateway_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` bigint unsigned NOT NULL,
  `gateway_name` varchar(50) NOT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `raw_response` text,
  `status` varchar(50) NOT NULL,
  `fee_amount` decimal(10,2) DEFAULT NULL,
  `settlement_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_transaction` (`gateway_name`,`transaction_id`),
  KEY `idx_payment` (`payment_id`),
  CONSTRAINT `fk_gateway_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_methods
CREATE TABLE IF NOT EXISTS `payment_methods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'Cash, Credit Card, etc.',
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `requires_validation` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'For methods needing verification',
  `sort_order` tinyint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_plans
CREATE TABLE IF NOT EXISTS `payment_plans` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `client_id` bigint unsigned NOT NULL,
  `plan_number` varchar(20) NOT NULL COMMENT 'PP-2025-001 format',
  `total_amount` decimal(12,2) NOT NULL,
  `deposit_paid` decimal(12,2) NOT NULL DEFAULT '0.00',
  `installment_count` smallint unsigned NOT NULL,
  `installment_amount` decimal(12,2) NOT NULL,
  `frequency` enum('weekly','biweekly','monthly','custom') NOT NULL DEFAULT 'monthly',
  `custom_frequency_days` smallint unsigned DEFAULT NULL COMMENT 'For custom frequency',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('draft','active','completed','defaulted','cancelled') NOT NULL DEFAULT 'draft',
  `late_fee_percentage` decimal(5,2) DEFAULT NULL,
  `notes` text,
  `created_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plan_number` (`plan_number`),
  KEY `idx_invoice` (`invoice_id`),
  KEY `idx_client` (`client_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_plans_client` FOREIGN KEY (`client_id`) REFERENCES `owners` (`id`),
  CONSTRAINT `fk_plans_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_plan_installments
CREATE TABLE IF NOT EXISTS `payment_plan_installments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_plan_id` bigint unsigned NOT NULL,
  `due_date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL COMMENT 'Current amount (may be adjusted)',
  `original_amount` decimal(10,2) NOT NULL COMMENT 'Original installment amount',
  `status` enum('pending','paid','late','partial','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_id` bigint unsigned DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_plan` (`payment_plan_id`),
  KEY `idx_status` (`status`),
  KEY `idx_due_date` (`due_date`),
  KEY `idx_payment` (`payment_id`),
  CONSTRAINT `fk_installment_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_installment_plan` FOREIGN KEY (`payment_plan_id`) REFERENCES `payment_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_reminders
CREATE TABLE IF NOT EXISTS `payment_reminders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `reminder_type` enum('email','sms','letter','call') NOT NULL,
  `sent_date` datetime NOT NULL,
  `sent_by` bigint unsigned DEFAULT NULL,
  `response_notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_invoice` (`invoice_id`),
  CONSTRAINT `fk_reminders_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_reversals
CREATE TABLE IF NOT EXISTS `payment_reversals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `original_payment_id` bigint unsigned NOT NULL,
  `reversal_amount` decimal(10,2) NOT NULL,
  `reason` enum('duplicate','error','fraud','refund') NOT NULL,
  `processed_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_payment` (`original_payment_id`),
  CONSTRAINT `fk_reversals_payment` FOREIGN KEY (`original_payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.payment_terms
CREATE TABLE IF NOT EXISTS `payment_terms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'NET 30, 50% Upfront, etc.',
  `description` varchar(255) DEFAULT NULL,
  `days_due` smallint unsigned DEFAULT NULL COMMENT 'For terms like NET 30',
  `percent_due` decimal(5,2) DEFAULT NULL COMMENT 'For partial payment terms',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.personal_access_tokens
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.pets
CREATE TABLE IF NOT EXISTS `pets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `owner_id` bigint unsigned NOT NULL,
  `microchip_num` bigint DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `species` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `breed` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('Male','Female') COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distinctive_marks` text COLLATE utf8mb4_unicode_ci,
  `behaviour` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `neutered` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N',
  `deceased` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N',
  `allergies` text COLLATE utf8mb4_unicode_ci,
  `date_of_birth` date NOT NULL,
  `date_of_morta` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `microchip_num` (`microchip_num`),
  KEY `pets_branch_id_foreign` (`branch_id`),
  KEY `pets_owner_id_foreign` (`owner_id`),
  CONSTRAINT `pets_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pets_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `owners` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.pet_symptoms
CREATE TABLE IF NOT EXISTS `pet_symptoms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `symptom` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `since` timestamp NULL DEFAULT NULL,
  `change` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `medication_given` tinyint(1) DEFAULT '0',
  `medication_detail` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `medical_record_id` (`medical_record_id`),
  CONSTRAINT `pet_symptoms_ibfk_1` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.refunds
CREATE TABLE IF NOT EXISTS `refunds` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reason` text,
  `processed_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `refund_method_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_invoice` (`invoice_id`),
  CONSTRAINT `fk_refunds_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.stock_movements
CREATE TABLE IF NOT EXISTS `stock_movements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `inventory_item_id` bigint unsigned NOT NULL,
  `movement_type` enum('purchase','sale','adjustment','transfer','expired') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` double NOT NULL,
  `source_branch_id` bigint unsigned DEFAULT NULL,
  `destination_branch_id` bigint unsigned DEFAULT NULL,
  `reference_id` bigint unsigned DEFAULT NULL,
  `reference_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  `effective_quantity` double GENERATED ALWAYS AS ((case when (`movement_type` in (_utf8mb4'purchase',_utf8mb4'transfer')) then `quantity` when (`movement_type` = _utf8mb4'sale') then -(`quantity`) when (`movement_type` = _utf8mb4'expired') then -(`quantity`) when (`movement_type` = _utf8mb4'adjustment') then (case when (`quantity` >= 0) then `quantity` else `quantity` end) end)) STORED,
  PRIMARY KEY (`id`),
  KEY `idx_branch` (`branch_id`),
  KEY `idx_item` (`inventory_item_id`),
  KEY `idx_movement_type` (`movement_type`),
  KEY `idx_reference` (`reference_id`,`reference_type`),
  KEY `fk_stock_movements_source_branch` (`source_branch_id`),
  KEY `fk_stock_movements_dest_branch` (`destination_branch_id`),
  CONSTRAINT `fk_stock_movements_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stock_movements_dest_branch` FOREIGN KEY (`destination_branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_stock_movements_item` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stock_movements_source_branch` FOREIGN KEY (`source_branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.test_results
CREATE TABLE IF NOT EXISTS `test_results` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `test_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `test_results_medical_record_id_foreign` (`medical_record_id`),
  CONSTRAINT `test_results_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.treatments
CREATE TABLE IF NOT EXISTS `treatments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `medical_record_id` bigint unsigned NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dosage` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `administration` enum('Oral','Subcutaneous','Intramuscular','Intravenous','Topical','Transdermal','Ophthalmic','Otic','Inhalation','Rectal','Sublingual','Intranasal','Intraosseous') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '  "Oral (Pills, Tablets, Capsules, Syrups, Suspensions)",\r\n  "Subcutaneous Injection (Under the Skin)",\r\n  "Intramuscular Injection (Into the Muscle)",\r\n  "Intravenous Injection (Into the Vein)",\r\n  "Topical (Creams, Ointments, Gels)",\r\n  "Transdermal (Patches, Absorption through Skin)",\r\n  "Ophthalmic (Eye Drops, Ointments)",\r\n  "Otic (Ear Drops, Medications)",\r\n  "Inhalation (Nebulizers, Inhalers)",\r\n  "Rectal (Suppositories, Enemas)",\r\n  "Sublingual (Under the Tongue)",\r\n  "Intranasal (Nasal Sprays, Drops)",\r\n  "Intraosseous (Into the Bone, Emergency Use)"',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `treatment_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `treatments_medical_record_id_foreign` (`medical_record_id`),
  CONSTRAINT `treatments_medical_record_id_foreign` FOREIGN KEY (`medical_record_id`) REFERENCES `medical_records` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_enabled` tinyint NOT NULL DEFAULT '0',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table vet_app_db.vaccinations
CREATE TABLE IF NOT EXISTS `vaccinations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pet_id` bigint unsigned NOT NULL,
  `branch_id` bigint unsigned NOT NULL,
  `vaccine_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dose` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `administered_date` date NOT NULL,
  `next_due_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `vaccinations_pet_id_foreign` (`pet_id`),
  KEY `vaccinations_branch_id_foreign` (`branch_id`),
  CONSTRAINT `vaccinations_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vaccinations_pet_id_foreign` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for trigger vet_app_db.set_microchip_num
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `set_microchip_num` BEFORE INSERT ON `pets` FOR EACH ROW BEGIN
   IF NEW.microchip_num IS NULL THEN
      SET NEW.microchip_num = RPAD(FLOOR(UNIX_TIMESTAMP() * RAND() * 100000), 15, '0');
   END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
