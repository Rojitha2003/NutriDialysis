-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 14, 2024 at 09:12 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nutrition`
--

-- --------------------------------------------------------

--
-- Table structure for table `add_patient`
--

CREATE TABLE `add_patient` (
  `s_no` int(10) NOT NULL,
  `patient_id` varchar(255) NOT NULL,
  `patient_name` varchar(255) DEFAULT NULL,
  `age` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `height` varchar(255) DEFAULT NULL,
  `weight` varchar(255) DEFAULT NULL,
  `body_mass_index` varchar(255) DEFAULT NULL,
  `date_of_initiation` varchar(255) DEFAULT NULL,
  `dialysis_vintage` varchar(255) DEFAULT NULL,
  `vegetarian` varchar(255) DEFAULT NULL,
  `non_vegetarian` varchar(255) DEFAULT NULL,
  `both_food` varchar(255) DEFAULT NULL,
  `mobile_number` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `add_patient`
--

INSERT INTO `add_patient` (`s_no`, `patient_id`, `patient_name`, `age`, `gender`, `height`, `weight`, `body_mass_index`, `date_of_initiation`, `dialysis_vintage`, `vegetarian`, `non_vegetarian`, `both_food`, `mobile_number`, `password`, `time_stamp`) VALUES
(1, '2409161018', 'Mansoor ', '25', 'Male', '180', '50', '20 .7', '2022-12-15', '2 years ', 'no', 'yes', 'no', '7095679323', '1234', '2024-12-12 08:32:29'),
(2, '2409231049', 'Harshitha', '20', 'Female', '160', '45', '15.6', '2021-11-12', '3 years', 'no', 'no', 'yes', '9441774401', 'harshi123', '2024-11-24 06:35:00'),
(3, '2410250523', 'Kavya', '16', 'Female', '150', '42', '18.7', '2023-10-07', '1 year', 'yes', 'no', 'no', '9550638913', 'kavya123', '2024-10-24 21:54:40'),
(4, '2410250526', 'Suneel', '24', 'male', '180', '62', '19.1', '2022-05-15', '2 year', 'yes', 'no', 'no', '8897261313', 'suneel123', '2024-10-24 21:57:31'),
(8, '2411201025', 'Roji', '21', 'Female', '165', '50', '18.4', '2021-09-07', '3 years', 'no', 'no', 'yes', '9876543210', 'roji123', '2024-11-20 10:53:17'),
(9, '2411201318', 'Chinnu ', '21', 'Male', '178', '79', '24.9', '2023-11-15', '1 years', 'no', 'no', 'yes', '8143926134', 'rajesh13', '2024-11-25 08:09:27'),
(10, '2411210933', 'Jansi', '45', 'Feale', '160', '52', '24.2', '2022-11-21', '2 years', 'yes', 'no', 'no', '8897261343', 'jansi123', '2024-11-21 08:33:59'),
(11, '2411211019', 'Sruthi', '24', 'Female', '175', '70', '21.4', '2020-11-21', '4 years', 'no', 'no', 'yes', '8897261343', 'sru', '2024-11-21 09:19:07'),
(12, '2411211045', 'Somu', '45', 'Male', '180', '75', '25.7', '2020-10-20', '3 years', 'no', 'no', 'yes', '9666800993', 'somu', '2024-11-21 09:45:09'),
(13, '2411211052', 'Sanju', '17', 'Male', '160', '45', '19.4', '2023-07-11', '1 year', 'no', 'no', 'yes', '8897261343', 'sanju', '2024-11-21 09:52:36'),
(14, '2412060048', 'Likhi', '21', 'Female', '160', '45', '19.5', '2023-12-14', '1 year', 'yes', 'no', 'no', '1236987545', 'likhi', '2024-12-05 23:48:59'),
(15, '2412121115', 'Raju', '45', 'Male', '160', '52', '24.2', '2022-11-21', '2 years', 'yes', 'no', 'no', '', 'ramu123', '2024-12-12 10:15:11');

-- --------------------------------------------------------

--
-- Table structure for table `case_sheet`
--

CREATE TABLE `case_sheet` (
  `s_no` int(10) NOT NULL,
  `patient_id` varchar(255) NOT NULL,
  `t2dm` varchar(255) DEFAULT NULL,
  `htn` varchar(255) DEFAULT NULL,
  `cva` varchar(255) DEFAULT NULL,
  `cvd` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ivj` varchar(255) DEFAULT NULL,
  `left_ivj` varchar(255) DEFAULT NULL,
  `right_ivj` varchar(255) DEFAULT NULL,
  `femoral` varchar(255) DEFAULT NULL,
  `left_femoral` varchar(255) DEFAULT NULL,
  `right_femoral` varchar(255) DEFAULT NULL,
  `radiocephalic_fistula` varchar(255) DEFAULT NULL,
  `left_radiocephalic_fistula` varchar(255) DEFAULT NULL,
  `right_radiocephalic_fistula` varchar(255) DEFAULT NULL,
  `brachiocephalic_fistula` varchar(255) DEFAULT NULL,
  `left_brachiocephalic_fistula` varchar(255) DEFAULT NULL,
  `right_brachiocephalic_fistula` varchar(255) DEFAULT NULL,
  `avg` varchar(255) DEFAULT NULL,
  `left_avg` varchar(255) DEFAULT NULL,
  `right_avg` varchar(255) DEFAULT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `case_sheet`
--

INSERT INTO `case_sheet` (`s_no`, `patient_id`, `t2dm`, `htn`, `cva`, `cvd`, `description`, `ivj`, `left_ivj`, `right_ivj`, `femoral`, `left_femoral`, `right_femoral`, `radiocephalic_fistula`, `left_radiocephalic_fistula`, `right_radiocephalic_fistula`, `brachiocephalic_fistula`, `left_brachiocephalic_fistula`, `right_brachiocephalic_fistula`, `avg`, `left_avg`, `right_avg`, `time_stamp`) VALUES
(2, '2409161018', 'yes', 'no', 'yes', 'no', 'Patient has a history of diabetes and stroke.', 'yes', 'yes', 'no', 'no', 'no', 'no', 'yes', 'no', 'yes', 'no', 'no', 'no', 'yes', 'yes', 'no', '2024-09-23 01:00:59'),
(4, '2409161018', 'yes', 'no', 'yes', 'no', 'Patient is on insulin ', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', '2024-12-03 17:16:47'),
(9, '2409231049', 'yes', 'no', 'yes', 'no', 'patient got fits recently ', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'yes', 'no', 'yes', 'yes', 'no', 'yes', '2024-12-03 23:51:31'),
(10, '2410250523', 'yes', 'no', 'no', 'yes', 'no major complaints', 'yes', 'no', 'yes', 'no', 'no', 'no', 'yes', 'no', 'yes', 'no', 'no', 'no', 'yes', 'yes', 'no', '2024-12-04 00:00:30'),
(11, '2411201025', 'yes', 'no', 'yes', 'no', 'Patient is a little fatigue ', 'yes', 'no', 'yes', 'yes', 'yes', 'no', 'no', 'no', 'no', 'yes', 'no', 'yes', 'yes', 'yes', 'no', '2024-12-05 07:13:04'),
(12, '2409161018', 'yes', 'yes', 'yes', 'yes', '', 'yes', 'yes', 'no', 'yes', 'no', 'yes', 'yes', 'yes', 'no', 'yes', 'no', 'yes', 'yes', 'yes', 'no', '2024-12-05 12:42:54');

-- --------------------------------------------------------

--
-- Table structure for table `dialysis_data`
--

CREATE TABLE `dialysis_data` (
  `s_no` int(10) NOT NULL,
  `patient_id` varchar(255) NOT NULL,
  `weight` varchar(255) DEFAULT NULL,
  `weight_gain` varchar(255) DEFAULT NULL,
  `pre_bp` varchar(255) DEFAULT NULL,
  `post_bp` varchar(255) DEFAULT NULL,
  `urine_output` varchar(255) DEFAULT NULL,
  `tricep_skinfold_thickness` varchar(255) DEFAULT NULL,
  `hand_grip` varchar(255) DEFAULT NULL,
  `time_stamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dialysis_data`
--

INSERT INTO `dialysis_data` (`s_no`, `patient_id`, `weight`, `weight_gain`, `pre_bp`, `post_bp`, `urine_output`, `tricep_skinfold_thickness`, `hand_grip`, `time_stamp`) VALUES
(1, '2409161018', '70', '1.5', '120/80', '115/75', '500', '15', '40', '2024-12-10 00:45:23.087770'),
(14, '2409161018', '70', '1.5', '120/80', '115/75', '500', '15', '40', '2024-12-10 01:17:07.658779'),
(15, '2409161018', '70', '1.5', '120/80', '115/75', '500', '15', '40', '2024-12-10 01:22:21.387577'),
(16, '2409161018', '75', '77', '75/110', '80/120', '20', '50', '20', '2024-12-10 02:54:40.722261'),
(17, '2409161018', '70 kgs', '77 kgs', '120/80', '110/70', '20', '50', '20', '2024-12-10 05:50:05.301398'),
(18, '2409161018', '70 kgs', '77 kgs', '120/80', '110/70', '20', '50', '20', '2024-12-10 05:56:49.401092'),
(19, '2409231049', '65.5', '2.0', '120/80', '110/70', '800', '12.5', '25.0', '2024-12-11 06:07:46.970788'),
(20, '2409231049', '60', '62', '120/80', '110/75', '20', '60', '20', '2024-12-11 06:54:37.824576'),
(21, '2409231049', '67', '80', '120/70', '120/80', '50', '45', '20', '2024-12-11 07:16:51.894752'),
(22, '2409161018', '60', '66', '120/80', '120/70', '50', '20', '35', '2024-12-11 16:13:07.956188');

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

CREATE TABLE `doctor` (
  `s_no` int(11) NOT NULL,
  `doctor_id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `specialization` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `mobile_number` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`s_no`, `doctor_id`, `name`, `specialization`, `password`, `mobile_number`) VALUES
(1, 'dr2375', 'Dr.Rasathi', 'Nutritionist', '123', '9876543210'),
(2, 'dr5924', 'Dr.Bharath', 'Nutritionist', 'bharath19', '9092066305'),
(3, 'dr8243', 'Dr.Arun', 'Nutritionist', 'Arun', '8667519043'),
(4, 'dr9394', 'Dr.Yash', 'Nutritionist', 'yash123', '9876543210'),
(5, 'dr8428', 'Rojitha', 'Admin', 'roji', '9550638913');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_login`
--

CREATE TABLE `doctor_login` (
  `s_no` int(10) NOT NULL,
  `doctor_id` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `food_items`
--

CREATE TABLE `food_items` (
  `s_no` int(10) NOT NULL,
  `food` varchar(255) DEFAULT NULL,
  `quantity` varchar(255) DEFAULT NULL,
  `carbohydrate` varchar(255) DEFAULT NULL,
  `calorie` varchar(255) DEFAULT NULL,
  `protein` varchar(255) DEFAULT NULL,
  `sodium` varchar(255) DEFAULT NULL,
  `potassium` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `food_items`
--

INSERT INTO `food_items` (`s_no`, `food`, `quantity`, `carbohydrate`, `calorie`, `protein`, `sodium`, `potassium`) VALUES
(1, 'Apple', '1 medium(182g)', '25 g', '95 kcal', '0.5 g', '2 mg', '195 mg'),
(4, 'Almonds', '1 almond', '0.24 g', '6 kcal', '0.26 g', '1 mg', '0.7 mg'),
(5, 'Almonds', '1 g', '0.20 g', '6 kcal', '0.21 g', '1 mg', '0.7 mg'),
(6, 'Almonds', '1 cup(whole)', '28.37 g', '829 kcal', '30.89 g', '130 mg', '385 mg'),
(8, 'Banana', '1 extra small (81 g)', '18.50 g', '72 kcal', '0.88 g', '1 mg', '240 mg'),
(9, 'Banana', '1 small (101 g)', '23.07 g', '90 kcal', '1.10 g', '1 mg', '290 mg'),
(10, 'Banana', '1 medium (118 g)', '26.95 g', '105 kcal', '1.29 g', '1 mg', '360 mg'),
(11, 'Banana', '1 large (136 g)', '31.06 g', '121 kcal', '1.48 g', '2 mg', '410 mg'),
(12, 'Banana', '100 g', '22.84 g', '89 kcal', '1.09 g', '1 mg', '358 mg'),
(13, 'Chapati', '1 small (30 g)', '12.00 g', '60 kcal', '2.00 g', '100 mg', '50 mg'),
(14, 'Boiled Egg', '1 small', '0.41 g', '57 kcal', '4.64 g', '62 mg', '63 mg'),
(15, 'Boiled Egg', '1 medium', '0.49 g', '68 kcal', '5.51 g', '73 mg', '78 mg'),
(16, 'Boiled Egg', '1 large', '0.56 g', '77 kcal', '6.26 g', '80 mg', '95 mg'),
(17, 'Boiled Egg', '100 g', '1.12 g', '154 kcal', '12.53 g', '150 mg', '190 mg'),
(18, 'Boiled Egg', '1 serving (50 g)', '0.56 g', '77 kcal', '6.26 g', '80 mg', '95 mg'),
(19, 'Rice (Cooked)', '1 cup (150 g)', '38.56 g', '206 kcal', '4.25 g', '1 mg', '55 mg'),
(20, 'Rice (Cooked)', '100 g', '25.71 g', '130 kcal', '2.83 g', '1 mg', '37 mg'),
(21, 'Rice (Cooked)', '1 small bowl (80 g)', '20.57 g', '104 kcal', '2.26 g', '0 mg', '30 mg'),
(22, 'Dosa (Plain) with sambar', '100 g', '30.00 g', '140 kcal', '3.00 g', '130 mg', '90 mg'),
(23, 'Dosa (Plain) with sambar', '1 small (80 g)', '22.00 g', '112 kcal', '2.00 g', '100 mg', '60 mg'),
(24, 'Dosa (Plain) with sambar', '1 regular (120 g)', '36.00 g', '168 kcal', '3.89 g', '190 mg', '120 mg'),
(25, 'Dosa (Plain) with sambar', '1 large (160 g)', '48.00 g', '224 kcal', '5.00 g', '250 mg', '160 mg'),
(26, 'Dosa (Masala) with sambar', '1 small(90 g)', '27.00 g', '126 kcal', '3.00 g', '140 mg', '90 mg'),
(27, 'Dosa (Masala) with sambar', '1 regular(130 g)', '39.00 g', '182 kcal', '4.50 g', '210 mg', '130 mg'),
(28, 'Dosa (Masala) with sambar', '1 large(180 g)', '54.00 g', '252 kcal', '6.00 g', '280 mg', '180 mg'),
(29, 'Dosa (Onion) with sambar', '1 small(100 g)', '30.00 g', '140 kcal', '3.50 g', '160 mg', '100 mg'),
(30, 'Dosa (Onion) with sambar', '1 regular(140 g)', '42.00 g', '196 kcal', '5.00 g', '230 mg', '140 mg'),
(31, 'Dosa (Onion) with sambar', '1 large(180 g)', '54.00 g', '252 kcal', '6.50 g', '290 mg', '180 mg'),
(33, 'Dosa (Podi) with sambar', '1 small(90 g)', '28.00 g', '126 kcal', '3.00 g', '140 mg', '95 mg'),
(34, 'Dosa (Podi) with sambar', '1 regular(130 g)', '39.00 g', '182 kcal', '4.00 g', '210 mg', '130 mg'),
(35, 'Dosa (Podi) with sambar', '1 large(160 g)', '48.00 g', '224 kcal', '5.50 g', '270 mg', '170 mg'),
(36, 'Dosa (Egg) with sambar', '1 small (100 g)', '28.00 g', '140 kcal', '5.00 g', '160 mg', '110 mg'),
(37, 'Dosa (Egg) with sambar', '1 regular(150 g)', '42.00 g', '210 kcal', '7.00 g', '240 mg', '150 mg'),
(38, 'Dosa (Egg) with sambar', '1 large(200 g)', '56.00 g', '280 kcal', '9.00 g', '320 mg', '200 mg'),
(39, 'Plain Idly with sambar', '1 small(30 g)', '7.00 g', '39 kcal', '1.00 g', '120 mg', '60 mg'),
(40, 'Plain Idly with sambar', '1 large (100 g)', '25.00 g', '130 kcal', '3.50 g', '400 mg', '200 mg'),
(41, 'Podi Idly with sambar', '1 medium(40 g)', '12.00 g', '58 kcal', '1.50 g', '180 mg', '90 mg'),
(42, 'Podi Idly with sambar', '2 pieces(80 g)', '24.00 g', '116 kcal', '3.00 g', '360 mg', '180 mg'),
(43, 'Sambar Idly', '1 idly with sambar', '22.00 g', '120 kcal', '5.00 g', '300 mg', '200 mg'),
(44, 'Thatte idly', '1 regular(150 g)', '36.00 g', '210 kcal', '6.50 g', '300 mg', '250 mg'),
(46, 'Ghee podi idly', '1 regular(100 g)', '28.00 g', '260 kcal', '5.50 g', '350 mg', '220 mg'),
(47, 'Idly Upma', '1 serving(150 g)', '30.00 g', '150 kcal', '4.00 g', '450 mg', '250 mg'),
(48, 'Mysore Bonda', '1 small (40 g)', '14.00 g', '70 kcal', '2.00 g', '150 mg', '80 mg'),
(49, 'Mangalore Bonda', '1 small(40 g)', '15.00 g', '80 kcal', '2.50 g', '180 mg', '85 mg'),
(50, 'Onion Bonda', '1 small (50 g)', '18.00 g', '100 kcal', '3.00 g', '220 mg', '100 mg'),
(51, 'Upma', '1 small bowl(100 g)', '22.00 g', '150 kcal', '4.00 g', '250 mg', '120 mg'),
(52, 'Poori', '1 medium(25 g)', '9.00 g', '80 kcal', '1.50 g', '100 mg', '50 mg'),
(53, 'Chole Bhature', '1 piece(250 g)', '45.00 g', '320 kcal', '12.00 g', '900 mg', '500 mg'),
(54, 'Plain Vada', '1 medium(40 g)', '12.00 g', '120 kcal', '3.00 g', '150 mg', '70 mg'),
(55, 'Masala Vada', '1 medium(50 g)', '14.00 g', '130 kcal', '3.50 g', '180 mg', '80 mg'),
(56, 'Dahi Vada', '1 medium(60 g)', '18.00 g', '160 kcal', '5.00 g', '200 mg', '100 mg'),
(57, 'Plain Uttapam', '1 medium (120 g)', '35.00 g', '160 kcal', '3.00 g', '150 mg', '90 mg'),
(58, 'Onion Uttapam', '1 medium (130 g)', '38.00 g', '180 kcal', '3.50 g', '180 mg', '100 mg'),
(59, 'Masala Uttapam', '1 medium(140 g)', '40.00 g', '200 kcal', '4.00 g', '200 mg', '110 mg'),
(60, 'Paneer Uttapam', '1 medium (150 g)', '42.00 g', '250 kcal', '8.00 g', '230 mg', '130 mg'),
(61, 'Pongal', '1 medium(150 g)', '30.00 g', '170 kcal', '4.00 g', '300 mg', '150 mg'),
(62, 'Tomato Rice', '1 medium(150 g)', '40.00 g', '180 kcal', '4.00 g', '300 mg', '150 mg'),
(63, 'Tomato Rice', '1 large(200 g)', '53.00 g', '240 kcal', '5.00 g', '400 mg', '200 mg'),
(64, 'Lemon Rice', '1 medium (150 g)', '42.00 g', '190 kcal', '4.00 g', '320 mg', '160 mg'),
(65, 'Lemon Rice', '1 large(200 g)', '56.00 g', '250 kcal', '5.50 g', '400 mg', '210 mg'),
(66, 'Tamarind Rice', '1 medium(150 g)', '43.00 g', '200 kcal', '4.50 g', '350 mg', '160 mg'),
(67, 'Tamarind Rice', '1 large(200 g)', '57.00 g', '270 kcal', '6.00 g', '450 mg', '210 mg'),
(68, 'Curd Rice', '1 medium (150 g)', '38.00 g', '170 kcal', '5.00 g', '350 mg', '200 mg'),
(69, 'Curd Rice', '1 large (200 g)', '50.00 g', '220 kcal', '6.50 g', '450 mg', '260 mg'),
(70, 'Chicken Biryani', '1 bowl(300 g)', '75.00 g', '450 kcal', '22.00 g', '1000 mg', '600 mg'),
(71, 'Veg Biryani', '1 bowl(300 g)', '82.00 g', '375 kcal', '12.00 g', '900 mg', '450 mg'),
(72, 'Egg Biryani', '1 large(300 g)', '78.00 g', '420 kcal', '15.00 g', '950 mg', '520 mg'),
(73, 'Mutton Biryani', '1 bowl(300 g)', '72.00 g', '480 kcal', '30.00 g', '1200 mg', '650 mg'),
(74, 'Chicken Fried Rice', '1 serving(300 g)', '68.00 g', '375 kcal', '18.00 g', '900 mg', '450 mg'),
(75, 'Paneer Fried Rice', '1 serving(300 g)', '72.00 g', '420 kcal', '15.00 g', '850 mg', '380 mg'),
(78, 'Gobi Fried Rice', '1 serving(300 g)', '75.00 g', '390 kcal', '14.00 g', '900 mg', '420 mg'),
(79, 'Chicken Noodles', '1 serving(300 g)', '68.00 g', '405 kcal', '18.00 g', '850 mg', '450 mg'),
(80, 'Paneer Noodles', '1 serving(300 g)', '72.00 g', '450 kcal', '15.00 g', '750 mg', '380 mg'),
(81, 'Veg Meals', '1 full plate(350 g)', '90.00 g', '450 kcal', '12.00 g', '800 mg', '400 mg'),
(82, 'Non-Veg Meals', '1 full plate(350 g)', '85.00 g', '550 kcal', '22.00 g', '1000 mg', '600 mg'),
(83, 'Parotta', '1 piece(50 g)', '24.00 g', '150 kcal', '3.00 g', '300 mg', '100 mg'),
(84, 'Kothu Parotta', '1 serving(200 g)', '58.00 g', '400 kcal', '10.00 g', '800 mg', '400 mg'),
(85, 'Khichdi', '1 serving(200 g)', '38.00 g', '250 kcal', '7.00 g', '300 mg', '180 mg'),
(86, 'Rasam Rice', '1 medium(200 g)', '44.00 g', '210 kcal', '5.00 g', '400 mg', '200 mg'),
(87, 'Rasam Rice', '1 large(300 g)', '66.00 g', '315 kcal', '7.50 g', '600 mg', '300 mg'),
(88, 'Dhokla', '1 piece(150 g)', '30.00 g', '150 kcal', '6.00 g', '200 mg', '100 mg'),
(89, 'Coconut Rice', '1 medium(200 g)', '38.00 g', '220 kcal', '4.00 g', '350 mg', '150 mg'),
(90, 'Coconut Rice', '1 large(300 g)', '57.00 g', '330 kcal', '6.00 g', '525 mg', '230 mg'),
(91, 'Dal Makhani', '1 serving(250 g)', '42.00 g', '320 kcal', '13.00 g', '660 mg', '580 mg'),
(92, 'Paneer Butter Masala', '1 serving(250 g)', '25.00 g', '460 kcal', '13.00 g', '750 mg', '400 mg'),
(93, 'Rajma', '1 serving(300 g)', '68.00 g', '450 kcal', '15.00 g', '525 mg', '380 mg'),
(94, 'Aloo Gobi', '1 serving(250 g)', '30.00 g', '185 kcal', '5.00 g', '330 mg', '300 mg'),
(95, 'Tandoori Roti/Naan', '1 piece(60 g)', '30.00 g', '170 kcal', '4.00 g', '230 mg', '80 mg'),
(96, 'Pulao', '1 medium(200 g)', '42.00 g', '240 kcal', '5.00 g', '400 mg', '200 mg'),
(97, 'Pulao', '1 large(300 g)', '63.00 g', '360 kcal', '7.50 g', '600 mg', '300 mg'),
(98, 'Palak Paneer', '1 serving(250 g)', '20.00 g', '330 kcal', '13.00 g', '575 mg', '300 mg'),
(99, 'Butter Chicken', '1 serving(250 g)', '13.00 g', '465 kcal', '33.00 g', '800 mg', '400 mg'),
(100, 'Poha', '1 serving(250 g)', '50.00 g', '330 kcal', '6.00 g', '500 mg', '250 mg'),
(101, 'Roasted Makhana', '1 bowl(100 g)', '44.00 g', '240 kcal', '10.00 g', '200 mg', '300 mg'),
(102, 'Sprouts Salad', '1 bowl(150 g)', '18.00 g', '80 kcal', '8.00 g', '150 mg', '180 mg'),
(103, 'Bhel Puri', '1 plate(100 g)', '40.00 g', '160 kcal', '6.00 g', '400 mg', '180 mg'),
(104, 'Ragi Biscuits', '1 piece(20 g)', '10.00 g', '50 kcal', '1.50 g', '50 mg', '40 mg'),
(105, 'Pani Puri', '1 serving(60 g)', '25.00 g', '120 kcal', '3.00 g', '500 mg', '100 mg'),
(106, 'Pizza', '1 slice(100 g)', '35.00 g', '250 kcal', '10.00 g', '600 mg', '200 mg'),
(107, 'Burger', '1 small(150 g)', '32.00 g', '280 kcal', '12.00 g', '700 mg', '200 mg'),
(108, 'Burger', '1 large(250 g)', '53.00 g', '470 kcal', '20.00 g', '1100 mg', '330 mg'),
(109, 'French Fries', '1  serving(100 g)', '30.00 g', '220 kcal', '3.00 g', '350 mg', '300 mg'),
(110, 'French Fries', '1 large serving(150 g)', '45.00 g', '330 kcal', '4.50 g', '520 mg', '450 mg'),
(111, 'Samosa', '1 piece(100 g)', '24.00 g', '260 kcal', '5.00 g', '300 mg', '160 mg'),
(112, 'Egg Puff', '1 piece(100 g)', '26.00 g', '270 kcal', '9.00 g', '350 mg', '180 mg'),
(113, 'Veg Puff', '1 piece(100 g)', '28.00 g', '250 kcal', '5.00 g', '300 mg', '160 mg'),
(114, 'Chicken Puff', '1 piece(100 g)', '24.00 g', '260 kcal', '11.00 g', '350 mg', '200 mg'),
(115, 'Tea', '1 cup(240 ml)', '0.00 g', '2 kcal', '0.00 g', '7 mg', '87 mg'),
(116, 'Tea', '1 large cup(350 ml)', '0.00 g', '3 kcal', '0.00 g', '10 mg', '120 mg'),
(117, 'Coffee', '1 cup(240 ml)', '0.00 g', '2 kcal', '0.00 g', '5 mg', '116 mg'),
(118, 'Coffee', '1 large cup(350 ml)', '0.00 g', '3 kcal', '0.00 g', '8 mg', '170 mg'),
(119, 'Lemon Juice', '1 glass(200 ml)', '6.00 g', '25 kcal', '0.50 g', '5 mg', '40 mg'),
(120, 'Sugarcane Juice', '1 glass(200 ml)', '60.00 g', '240 kcal', '0.50 g', '35 mg', '410 mg'),
(121, 'Badam Milk', '1 cup(200 ml)', '22.00 g', '160 kcal', '8.00 g', '150 mg', '180 mg'),
(123, 'Cool Drinks', '1 can(330 ml)', '39.00 g', '140 kcal', '0.00 g', '45 mg', '0 mg'),
(124, 'Cool Drinks', '1 bottle(500 ml)', '58.00 g', '210 kcal', '0.00 g', '70 mg', '0 mg'),
(125, 'Orange Juice', '1 glass(200 ml)', '24.00 g', '90 kcal', '1.00 g', '2 mg', '400 mg'),
(127, 'Khichdi', '1 bowl (300 g)', '74.00 g', '150 kcal', '7.00 g', '12 mg', '300 mg'),
(128, 'Masoor Dal', '1 serving(300 g)', '57.00 g', '240 kcal', '18.00 g', '7 mg', '600 mg'),
(129, 'Mixed Vegetable Curry', '1 serving(300 g)', '48.00 g', '150 kcal', '5.00 g', '10 mg', '450 mg'),
(130, 'Aloo Gobi', '1 serving(300 g)', '64.00 g', '150 kcal', '4.00 g', '30 mg', '650 mg'),
(131, 'Butter milk', '1 glass(200 ml)', '5.00 g', '45 kcal', '3.5 g', '80 mg', '150 mg'),
(133, 'corn syrup', '1 cup (320 g)', '247 g', '836 kcal', '1.0 g', '60 mg', '150 mg'),
(134, 'Banana stem ', '1 cup (320 g)', '5 g', '25 kcal', '1.6 g', '60 mg', '560 mg'),
(135, 'Avacado', '1 medium (150 g)', '12 g', '234 kcal', '3 g', '10 mg', '975 mg'),
(136, 'Sweet Potato', '1 medium (130 g)', '24 g', '103 kcal', '2.3 g', '41 mg', '438 mg'),
(137, 'Lentil curry', '1 cup (200 g)', '18 g', '150 kcal', '9 g', '400 mg', '700 mg'),
(138, 'Appam', '1 appam (60 g)', '17.5 g', '75 kcal', '2 g', '60 mg', '200 mg'),
(139, 'Millet pongal', '1 plate (200 g)', '38 g', '180 kcal', '6 g', '170 mg', '480 mg'),
(140, 'Mango Lassi', '1 cup (200 g)', '30 g', '180 kcal', '5 g', '50 mg', '500 mg'),
(141, 'Vermicelli Upma', '1 plate (200 g)', '35 g', '180 kcal', '6 g', '250 mg', '300 mg'),
(142, 'Pesarattu', '1 pieces (150 g)', '30 g', '180 kcal', '7 g', '300 mg', '500 mg'),
(143, 'Cucumber salad', '1 cup (150 g)', '8 g', '40 kcal', '1 g', '40 mg', '200 mg'),
(144, 'Vegetable Kurma', '1 cup (150 g)', '18 g', '150 kcal', '5 g', '300 mg', '500 mg'),
(145, 'Payasam', '1 cup (200 g)', '40 g', '200 kcal', '5 g', '50 mg', '200 mg'),
(146, 'Chickpea salad', '1 cup (150 g)', '25 g', '180 kcal', '10 g', '200 mg', '500 mg'),
(147, 'Kesar pudding', '1 cup (200 g)', '35 g', '200 kcal', '5 g', '50 mg', '150 mg'),
(148, 'Tomata soup', '1 cup (200 ml)', '8 g', '70 kcal', '12 g', '150 mg', '400 mg'),
(149, 'Carrot Salad', '1 cup (150 g)', '10 g', '60 kcal', '2 g', '50 mg', '300 mg'),
(150, 'Ragi Balls', '1 ball (100 g)', '20 g', '100 kcal', '3.5 g', '30 mg', '650 mg'),
(151, 'Dosa (Plain) with Chutney', '100 g', '30 g', '135 kcal', '28 g', '120 mg', '80 mg'),
(152, 'Dosa (Plain) with Chutney', '1 small (80g)', '24 g', '108 kcal', '20 g', '90 mg', '50 mg'),
(153, 'Dosa (Plain) with Chutney', '1 regular (120g)', '36 g', '162 kcal', '34 g', '180 mg', '110 mg'),
(154, 'Dosa (Plain) with Chutney', '1 large (160g)', '48 g', '216 kcal', '46 g', '240 mg', '150 mg'),
(155, 'Dosa (Masala) with Chutney', '1 small (90g)', '27 g', '120 kcal', '25 g', '130 mg', '80 mg'),
(156, 'Dosa (Masala) with Chutney', '1 regular (130g)', '39 g', '176 kcal', '37 g', '200 mg', '120 mg'),
(157, 'Dosa (Masala) with Chutney', '1 large (180g)', '54 g', '244 kcal', '52 g', '270 mg', '170 mg'),
(158, 'Dosa (Onion) with Chutney', '1 small (100g)', '30 g', '135 kcal', '28 g', '150 mg', '90 mg'),
(159, 'Dosa (Onion) with Chutney', '1 regular (140g)', '42 g', '190 kcal', '40 g', '220 mg', '130 mg'),
(160, 'Dosa (Onion) with Chutney', '1 large (180g)', '54 g', '245 kcal', '52 g', '280 mg', '170 mg'),
(161, 'Dosa (Podi) with Chutney', '1 small (90g)', '28 g', '120 kcal', '26 g', '130 mg', '85 mg'),
(162, 'Dosa (Podi) with Chutney', '1 regular (130g)', '39 g', '176 kcal', '37 g', '200 mg', '120 mg'),
(163, 'Dosa (Podi) with Chutney', '1 large (160g)', '48 g', '218 kcal', '46 g', '260 mg', '160 mg'),
(164, 'Dosa (Egg) with Chutney', '1 small (100g)', '28 g', '135 kcal', '26 g', '150 mg', '100 mg'),
(165, 'Dosa (Egg) with Chutney', '1 regular (150g)', '42 g', '202 kcal', '40 g', '230 mg', '140 mg'),
(166, 'Dosa (Egg) with Chutney', '1 large (200g)', '56 g', '270 kcal', '54 g', '310 mg', '190 mg'),
(167, 'Plain Idly with Chutney', '1 small (30g)', '7 g', '36 kcal', '6 g', '110 mg', '50 mg'),
(168, 'Plain Idly with Chutney', '1 large (100g)', '25 g', '125 kcal', '22 g', '390 mg', '180 mg'),
(169, 'Podi Idly with Chutney', '1 medium (40g)', '12 g', '55 kcal', '10 g', '170 mg', '80 mg'),
(170, 'Podi Idly with Chutney', '2 pieces (80 g)', '24 g', '110 kcal', '20 g', '340 mg', '160 mg'),
(171, 'Chana Sundal', '1 cup (100 g)', '27 g', '164 kcal', '8.90 g', '300 mg', '240 mg'),
(172, 'Chana Sundal', '1 large bowl (200 g)', '54 g', '328 kcal', '17.80 g', '600 mg', '480 mg'),
(173, 'Moong Sundal', '1 cup (100 g)', '18 g', '124 kcal', '6.20 g', '240 mg', '260 mg'),
(174, 'Moong Sundal', '1 large bowl (200 g)', '36 g', '248 kcal', '12.40 g', '480 mg', '520 mg'),
(175, 'Peanut Sundal', '1 cup (100 g)', '21 g', '214 kcal', '9 g', '280 mg', '320 mg'),
(176, 'Peanut Sundal', '1 large bowl (200 g)', '42 g', '428 kcal', '18 g', '560 mg', '640 mg'),
(177, 'Corn Sundal', '1 cup (100 g)', '19 g', '132 kcal', '4 g', '250 mg', '210 mg'),
(178, 'Corn Sundal', '1 large bowl (200 g)', '38 g', '264 kcal', '8 g', '500 mg', '420 mg');

-- --------------------------------------------------------

--
-- Table structure for table `investigations`
--

CREATE TABLE `investigations` (
  `s_no` int(10) NOT NULL,
  `patient_id` varchar(255) NOT NULL,
  `hemoglobin` varchar(255) DEFAULT NULL,
  `pcv` varchar(255) DEFAULT NULL,
  `total_wbc_count` varchar(255) DEFAULT NULL,
  `creatinine` varchar(255) DEFAULT NULL,
  `potassium` varchar(255) DEFAULT NULL,
  `serum_cholesterol` varchar(255) DEFAULT NULL,
  `serum_albumin` varchar(255) DEFAULT NULL,
  `bicarbonate` varchar(255) DEFAULT NULL,
  `ejection_fraction` varchar(255) DEFAULT NULL,
  `time_stamp` timestamp(4) NOT NULL DEFAULT current_timestamp(4) ON UPDATE current_timestamp(4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `investigations`
--

INSERT INTO `investigations` (`s_no`, `patient_id`, `hemoglobin`, `pcv`, `total_wbc_count`, `creatinine`, `potassium`, `serum_cholesterol`, `serum_albumin`, `bicarbonate`, `ejection_fraction`, `time_stamp`) VALUES
(1, '2409231049', '13.5', '40', '7000', '1.2', '4.5', '180', '4.2', '22', '55', '2024-12-10 03:41:32.0552'),
(2, '2409161018', '13.5', '40', '7000', '1.2', '4.5', '180', '4.2', '22', '55', '2024-12-10 03:48:58.9225'),
(3, '2409161018', '20', '50', '50', '58', '23', '23', '23', '25', '24', '2024-12-11 16:13:37.9028');

-- --------------------------------------------------------

--
-- Table structure for table `nutrition_display`
--

CREATE TABLE `nutrition_display` (
  `s_no` int(255) NOT NULL,
  `patient_id` varchar(255) NOT NULL,
  `food` varchar(255) NOT NULL,
  `quantity_number` varchar(255) NOT NULL,
  `quantity_unit` varchar(255) NOT NULL,
  `carbohydrate` varchar(255) DEFAULT NULL,
  `calorie` varchar(255) NOT NULL,
  `protein` varchar(255) DEFAULT NULL,
  `sodium` varchar(255) DEFAULT NULL,
  `potassium` varchar(255) DEFAULT NULL,
  `food_time` varchar(255) NOT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nutrition_display`
--

INSERT INTO `nutrition_display` (`s_no`, `patient_id`, `food`, `quantity_number`, `quantity_unit`, `carbohydrate`, `calorie`, `protein`, `sodium`, `potassium`, `food_time`, `time_stamp`) VALUES
(15, '2409161018', 'Apple', '2', 'medium(182g)', '50', '190', '1', '4', '390', 'Breakfast', '2024-12-03 14:46:38'),
(17, '2409161018', 'Dosa (Plain)', '200', 'g', '60', '280', '6', '260', '180', 'Breakfast', '2024-12-04 14:49:52'),
(20, '2409161018', 'Banana', '1', 'extra small (81 g)', '18.5', '72', '0.88', '1', '240', 'Lunch', '2024-12-04 16:07:58'),
(21, '2409161018', 'Rice (Cooked)', '2', 'small bowl (80 g)', '77.12', '412', '8.5', '2', '110', 'Dinner', '2024-12-04 17:05:52'),
(22, '2409161018', 'Pani Puri', '2', 'serving(60 g)', '50', '240', '6', '1000', '200', 'Snacks', '2024-12-04 17:43:10'),
(23, '2409161018', 'Curd Rice', '1', 'large (200 g)', '38', '170', '5', '350', '200', 'Dinner', '2024-12-04 18:22:05'),
(24, '2409161018', 'Coconut Water', '1', 'glass(200 ml)', '9', '45', '1', '30', '600', 'Fluids', '2024-12-03 18:55:11'),
(25, '2409161018', 'Samosa', '2', 'piece(100 g)', '48', '520', '10', '600', '320', 'Snacks', '2024-12-03 19:01:10'),
(28, '2409161018', 'Sugarcane Juice', '1', 'glass(200 ml)', '60', '240', '0.5', '35', '410', 'Fluids', '2024-12-03 19:31:03'),
(29, '2409161018', 'Boiled Egg', '1', 'large', '0.41', '57', '4.64', '62', '63', 'Early Morning', '2024-12-04 20:14:19'),
(30, '2409161018', 'Almonds', '2', 'cup(whole)', '0.48', '12', '0.52', '2', '1.4', 'Early Morning', '2024-12-05 07:04:06'),
(35, '2409161018', 'Apple', '1', 'medium(182g)', '25', '95', '0.5', '2', '195', 'Lunch', '2024-12-05 11:35:37'),
(43, '2409231049', 'Apple', '2', 'medium(182g)', '50', '190', '1', '4', '390', 'Early Morning', '2024-12-05 11:52:23'),
(44, '2409231049', 'Almonds', '5', 'almond', '1.2', '30', '1.3', '5', '3.5', 'Early Morning', '2024-12-05 11:52:23'),
(45, '2409231049', 'Plain Idly', '2', 'large (100 g)', '14', '78', '2', '240', '120', 'Breakfast', '2024-12-05 11:53:36'),
(46, '2409231049', 'Plain Vada', '2', 'medium(40 g)', '24', '240', '6', '300', '140', 'Breakfast', '2024-12-05 11:53:54'),
(47, '2409231049', 'Boiled Egg', '2', 'large', '0.82', '114', '9.28', '124', '126', 'Early Morning', '2024-12-05 12:06:37'),
(48, '2409161018', 'Dosa (Onion)', '1', 'regular(140 g)', '30', '140', '3.5', '160', '100', 'Breakfast', '2024-12-05 14:15:11'),
(49, '2409161018', 'Masala Uttapam', '2', 'medium(140 g)', '80', '400', '8', '400', '220', 'Breakfast', '2024-12-05 14:15:41'),
(51, '2409161018', 'Rasam Rice', '1', 'medium(200 g)', '44', '210', '5', '400', '200', 'Dinner', '2024-12-05 14:16:17'),
(52, '2409161018', 'Lemon Juice', '1', 'glass(200 ml)', '6', '25', '0.5', '5', '40', 'Fluids', '2024-12-05 14:16:38'),
(62, '2409231049', 'Apple', '2', 'medium(182g)', '50', '190', '1', '4', '390', 'Early Morning', '2024-12-05 23:36:42'),
(63, '2409231049', 'Almonds', '5', 'almond', '1.2', '30', '1.3', '5', '3.5', 'Early Morning', '2024-12-05 23:36:53'),
(64, '2409231049', 'Masala Vada', '2', 'medium(50 g)', '28', '260', '7', '360', '160', 'Breakfast', '2024-12-05 23:37:12'),
(65, '2409231049', 'Poori', '3', 'medium(25 g)', '27', '240', '4.5', '300', '150', 'Breakfast', '2024-12-05 23:37:27'),
(66, '2409231049', 'Chapati', '2', 'small (30 g)', '24', '120', '4', '200', '100', 'Lunch', '2024-12-05 23:38:12'),
(67, '2409231049', 'Veg Biryani', '1', 'bowl(300 g)', '82', '375', '12', '900', '450', 'Lunch', '2024-12-05 23:38:33'),
(68, '2409231049', 'Samosa', '3', 'piece(100 g)', '72', '780', '15', '900', '480', 'Snacks', '2024-12-05 23:38:55'),
(69, '2409231049', 'Curd Rice', '2', 'medium (150 g)', '76', '340', '10', '700', '400', 'Dinner', '2024-12-05 23:39:13'),
(70, '2409231049', 'Lemon Juice', '1', 'glass(200 ml)', '6', '25', '0.5', '5', '40', 'Fluids', '2024-12-05 23:39:31'),
(72, '2409161018', 'Masala Uttapam', '1', 'medium(140 g)', '40', '200', '4', '200', '110', 'Breakfast', '2024-12-06 04:15:40'),
(73, '2409161018', 'Paneer Uttapam', '1', 'medium (150 g)', '42', '250', '8', '230', '130', 'Breakfast', '2024-12-06 04:16:15'),
(74, '2409161018', 'Almonds', '1', 'almond', '0.24', '6', '0.26', '1', '0.7', 'Lunch', '2024-12-06 04:16:26'),
(75, '2409161018', 'Almonds', '1', 'almond', '0.24', '6', '0.26', '1', '0.7', 'Lunch', '2024-12-06 04:16:26'),
(77, '2409161018', 'Almonds', '1', 'cup(whole)', '0.24', '6', '0.26', '1', '0.7', 'Early Morning', '2024-12-09 12:22:41'),
(78, '2409161018', 'Dosa (Plain)', '1', 'regular (120 g)', '30', '140', '3', '130', '90', 'Breakfast', '2024-12-09 12:23:23'),
(79, '2409161018', 'Onion Uttapam', '1', 'medium (130 g)', '38', '180', '3.5', '180', '100', 'Breakfast', '2024-12-09 12:23:44'),
(80, '2409161018', 'Chicken Biryani', '1', 'bowl(300 g)', '75', '450', '22', '1000', '600', 'Lunch', '2024-12-09 12:24:02'),
(81, '2409161018', 'Pani Puri', '2', 'serving(60 g)', '50', '240', '6', '1000', '200', 'Snacks', '2024-12-09 12:24:15'),
(82, '2409161018', 'Rasam Rice', '2', 'large(300 g)', '88', '420', '10', '800', '400', 'Dinner', '2024-12-09 12:24:31'),
(83, '2409161018', 'Butter milk', '2', 'glass(200 ml)', '10', '90', '7', '160', '300', 'Fluids', '2024-12-09 12:24:50'),
(126, '2409161018', 'Almonds', '1', 'almond', '0.24', '6', '0.26', '1', '0.7', 'Early Morning', '2024-12-10 23:09:21'),
(127, '2409161018', 'Boiled Egg', '1', 'small', '0.41', '57', '4.64', '62', '63', 'Breakfast', '2024-12-10 23:09:47'),
(128, '2409161018', 'Rice (Cooked)', '1', 'cup (150 g)', '38.56', '206', '4.25', '1', '55', 'Breakfast', '2024-12-10 23:09:47'),
(129, '2409161018', 'Dosa (Plain)', '100', 'g', '30', '140', '3', '130', '90', 'Breakfast', '2024-12-10 23:09:47'),
(130, '2409161018', 'Dosa (Podi)', '1', 'small(90 g)', '28', '126', '3', '140', '95', 'Lunch', '2024-12-10 23:10:27'),
(131, '2409161018', 'Dosa (Egg)', '1', 'small (100 g)', '28', '140', '5', '160', '110', 'Lunch', '2024-12-10 23:10:27'),
(132, '2409161018', 'Paneer Uttapam', '1', 'medium (150 g)', '42', '250', '8', '230', '130', 'Snacks', '2024-12-10 23:11:16'),
(133, '2409161018', 'Pongal', '1', 'medium(150 g)', '30', '170', '4', '300', '150', 'Snacks', '2024-12-10 23:11:16'),
(134, '2409161018', 'Tomato Rice', '1', 'medium(150 g)', '40', '180', '4', '300', '150', 'Dinner', '2024-12-10 23:11:35'),
(135, '2409161018', 'Lemon Rice', '1', 'medium (150 g)', '42', '190', '4', '320', '160', 'Dinner', '2024-12-10 23:11:35'),
(138, '2409161018', 'Almonds', '1', 'almond', '0.24', '6', '0.26', '1', '0.7', 'Early Morning', '2024-12-12 07:19:32'),
(140, '2409161018', 'Banana', '5', 'small (101 g)', '92.5', '360', '4.4', '5', '1200', 'Early Morning', '2024-12-12 07:44:37'),
(141, '2409161018', 'Banana', '50', 'g', '9.25', '36', '0.44', '0.5', '120', 'Early Morning', '2024-12-12 07:46:38'),
(142, '2409161018', 'Dosa (Plain)', '2', 'small (80 g)', '60', '280', '6', '260', '180', 'Breakfast', '2024-12-12 07:48:07'),
(143, '2409161018', 'Pani Puri', '1', 'serving(60 g)', '25', '120', '3', '500', '100', 'Snacks', '2024-12-12 07:55:08'),
(144, '2409161018', 'Chicken Biryani', '1', 'bowl(300 g)', '75', '450', '22', '1000', '600', 'Lunch', '2024-12-12 07:55:25'),
(145, '2409161018', 'Curd Rice', '1', 'large (200 g)', '38', '170', '5', '350', '200', 'Dinner', '2024-12-12 07:55:40'),
(146, '2409161018', 'Sambar Idly', '2', 'idly with sambar', '44', '240', '10', '600', '400', 'Lunch', '2024-12-12 08:13:18'),
(147, '2409161018', 'Watermelon juice', '2', 'glass(200 ml)', '23', '100', '2', '4', '560', 'Fluids', '2024-12-12 08:13:58'),
(148, '2409161018', 'Mutton Biryani', '2', 'bowl(300 g)', '144', '960', '60', '2400', '1300', 'Lunch', '2024-12-12 08:31:46'),
(149, '2409161018', 'Chapati', '1', 'small(30g)', '12', '60', '2', '100', '50', 'Breakfast', '2024-12-13 03:49:33'),
(150, '2409161018', 'Chapati', '1', 'small(30g)', '12', '60', '2', '100', '50', 'Breakfast', '2024-12-13 03:50:00'),
(151, '2409161018', 'Dosa (Plain) with sambar', '200', 'g', '60', '280', '6', '260', '180', 'Breakfast', '2024-12-13 03:50:00');

-- --------------------------------------------------------

--
-- Table structure for table `patient_login`
--

CREATE TABLE `patient_login` (
  `s_no` int(10) NOT NULL,
  `patient_id` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `schedule_frequency`
--

CREATE TABLE `schedule_frequency` (
  `s_no` int(10) NOT NULL,
  `patient_id` varchar(255) NOT NULL,
  `sunday` varchar(255) DEFAULT NULL,
  `monday` varchar(255) DEFAULT NULL,
  `tuesday` varchar(255) DEFAULT NULL,
  `wednesday` varchar(255) DEFAULT NULL,
  `thursday` varchar(255) DEFAULT NULL,
  `friday` varchar(255) DEFAULT NULL,
  `saturday` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedule_frequency`
--

INSERT INTO `schedule_frequency` (`s_no`, `patient_id`, `sunday`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`) VALUES
(1, '2409161018', 'no', 'no', 'yes', 'yes', 'yes', 'no', 'yes'),
(2, '2409231049', 'no', 'no', 'no', 'yes', 'yes', 'yes', 'no'),
(3, '2410250523', 'no', 'no', 'no', 'yes', 'no', 'no', 'yes'),
(5, '2411210933', 'no', 'yes', 'no', 'yes', 'yes', 'no', 'no'),
(6, '2410250526', 'no', 'no', 'yes', 'yes', 'no', 'yes', 'no'),
(7, '2411201025', 'no', 'yes', 'no', 'yes', 'yes', 'yes', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `upload_videos`
--

CREATE TABLE `upload_videos` (
  `video_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `youtube_url` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `upload_videos`
--

INSERT INTO `upload_videos` (`video_id`, `title`, `youtube_url`, `status`) VALUES
('6531', 'Nutrition for healthy life', 'https://www.youtube.com/watch?v=c06dTj0v0sM', 'yes'),
('7246', 'Fit facts', 'https://www.youtube.com/watch?v=zJgHbifIx-Q', ''),
('7451', 'Nutrition and Feeding', 'https://www.youtube.com/watch?v=KBZNv5-6Vp0', 'yes');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `add_patient`
--
ALTER TABLE `add_patient`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `case_sheet`
--
ALTER TABLE `case_sheet`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `dialysis_data`
--
ALTER TABLE `dialysis_data`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `doctor_login`
--
ALTER TABLE `doctor_login`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `food_items`
--
ALTER TABLE `food_items`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `investigations`
--
ALTER TABLE `investigations`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `nutrition_display`
--
ALTER TABLE `nutrition_display`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `patient_login`
--
ALTER TABLE `patient_login`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `schedule_frequency`
--
ALTER TABLE `schedule_frequency`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `upload_videos`
--
ALTER TABLE `upload_videos`
  ADD PRIMARY KEY (`video_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `add_patient`
--
ALTER TABLE `add_patient`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `case_sheet`
--
ALTER TABLE `case_sheet`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `dialysis_data`
--
ALTER TABLE `dialysis_data`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `doctor`
--
ALTER TABLE `doctor`
  MODIFY `s_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `doctor_login`
--
ALTER TABLE `doctor_login`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `food_items`
--
ALTER TABLE `food_items`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=179;

--
-- AUTO_INCREMENT for table `investigations`
--
ALTER TABLE `investigations`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `nutrition_display`
--
ALTER TABLE `nutrition_display`
  MODIFY `s_no` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT for table `patient_login`
--
ALTER TABLE `patient_login`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `schedule_frequency`
--
ALTER TABLE `schedule_frequency`
  MODIFY `s_no` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
