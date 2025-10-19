-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 19, 2025 at 09:38 AM
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
-- Database: `nutrisi_gizi`
--

-- --------------------------------------------------------

--
-- Table structure for table `aktivitas`
--

CREATE TABLE `aktivitas` (
  `id_aktivitas` int(11) NOT NULL,
  `nama_aktivitas` varchar(100) NOT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aktivitas`
--

INSERT INTO `aktivitas` (`id_aktivitas`, `nama_aktivitas`, `keterangan`) VALUES
(1, 'Olahraga', 'Aktivitas fisik yang dilakukan rutin.'),
(2, 'Tidur', 'Istirahat tubuh yang cukup 6–8 jam per hari.'),
(3, 'Kerja Malam', 'Aktivitas malam yang butuh pola makan khusus.'),
(4, 'Begadang', 'Kebiasaan tidur larut yang tidak disarankan.'),
(5, 'Jaga Imun', 'Kegiatan menjaga daya tahan tubuh.'),
(6, 'Tidur Nyenyak', 'Tidur berkualitas untuk pemulihan tubuh.'),
(7, 'Olahraga', 'Aktivitas fisik yang dilakukan rutin.'),
(8, 'Tidur', 'Istirahat tubuh yang cukup 6–8 jam per hari.'),
(9, 'Kerja Malam', 'Aktivitas malam yang butuh pola makan khusus.'),
(10, 'Begadang', 'Kebiasaan tidur larut yang tidak disarankan.'),
(11, 'Jaga Imun', 'Kegiatan menjaga daya tahan tubuh.'),
(12, 'Tidur Nyenyak', 'Tidur berkualitas untuk pemulihan tubuh.');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_pengguna`
--

CREATE TABLE `kategori_pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `nama_pengguna` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_pengguna`
--

INSERT INTO `kategori_pengguna` (`id_pengguna`, `nama_pengguna`, `deskripsi`) VALUES
(1, 'Pekerja Kantoran', 'Bekerja di lingkungan kantor, sering duduk lama.'),
(2, 'Mahasiswa', 'Aktif belajar dan beraktivitas.'),
(3, 'Anak Sekolah', 'Masih dalam masa pertumbuhan.'),
(4, 'Anak Kos', 'Cenderung makan tidak teratur.'),
(5, 'Pekerja Malam', 'Aktif di malam hari, perlu manajemen pola makan.'),
(6, 'Keluarga', 'Pola makan bersama di rumah.'),
(7, 'Siswa', 'Anak usia sekolah dasar atau menengah.'),
(8, 'Pekerja Kantoran', 'Bekerja di lingkungan kantor, sering duduk lama.'),
(9, 'Mahasiswa', 'Aktif belajar dan beraktivitas.'),
(10, 'Anak Sekolah', 'Masih dalam masa pertumbuhan.'),
(11, 'Anak Kos', 'Cenderung makan tidak teratur.'),
(12, 'Pekerja Malam', 'Aktif di malam hari, perlu manajemen pola makan.'),
(13, 'Keluarga', 'Pola makan bersama di rumah.'),
(14, 'Siswa', 'Anak usia sekolah dasar atau menengah.');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_tempat`
--

CREATE TABLE `kategori_tempat` (
  `id_tempat` int(11) NOT NULL,
  `nama_tempat` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_tempat`
--

INSERT INTO `kategori_tempat` (`id_tempat`, `nama_tempat`, `deskripsi`) VALUES
(1, 'Kantor', 'Tempat kerja dengan aktivitas duduk lama.'),
(2, 'Rumah', 'Lingkungan pribadi untuk beristirahat dan makan.'),
(3, 'Sekolah', 'Tempat belajar anak-anak.'),
(4, 'Kampus', 'Tempat aktivitas mahasiswa.'),
(5, 'Kantor', 'Tempat kerja dengan aktivitas duduk lama.'),
(6, 'Rumah', 'Lingkungan pribadi untuk beristirahat dan makan.'),
(7, 'Sekolah', 'Tempat belajar anak-anak.'),
(8, 'Kampus', 'Tempat aktivitas mahasiswa.');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_usia`
--

CREATE TABLE `kategori_usia` (
  `id_kategori` int(11) NOT NULL,
  `kategori_usia` varchar(100) NOT NULL,
  `kebutuhan_kalori` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_usia`
--

INSERT INTO `kategori_usia` (`id_kategori`, `kategori_usia`, `kebutuhan_kalori`, `keterangan`) VALUES
(1, 'Bayi 1 tahun', 900, 'Membutuhkan sekitar 900 kkal per hari'),
(2, 'Anak Sekolah', 1600, 'Usia 7–12 tahun, butuh 1600 kkal/hari'),
(3, 'Remaja', 2200, 'Remaja aktif 2000–2500 kkal/hari'),
(4, 'Dewasa', 2500, 'Rata-rata 2000–2500 kkal/hari'),
(5, 'Lansia', 1800, 'Usia lanjut butuh energi lebih sedikit'),
(6, 'Ibu Hamil', 2500, 'Tambahan 300–400 kkal per hari'),
(7, 'Ibu Menyusui', 2700, 'Tambahan 500 kkal/hari untuk ASI'),
(8, 'Pekerja Kantoran', 2000, 'Aktivitas sedang'),
(9, 'Pekerja Lapangan', 2800, 'Aktivitas berat'),
(10, 'Atlet', 3000, 'Butuh energi tinggi untuk latihan'),
(11, 'Bayi 1 tahun', 900, 'Membutuhkan sekitar 900 kkal per hari'),
(12, 'Anak Sekolah', 1600, 'Usia 7–12 tahun, butuh 1600 kkal/hari'),
(13, 'Remaja', 2200, 'Remaja aktif 2000–2500 kkal/hari'),
(14, 'Dewasa', 2500, 'Rata-rata 2000–2500 kkal/hari'),
(15, 'Lansia', 1800, 'Usia lanjut butuh energi lebih sedikit'),
(16, 'Ibu Hamil', 2500, 'Tambahan 300–400 kkal per hari'),
(17, 'Ibu Menyusui', 2700, 'Tambahan 500 kkal/hari untuk ASI'),
(18, 'Pekerja Kantoran', 2000, 'Aktivitas sedang'),
(19, 'Pekerja Lapangan', 2800, 'Aktivitas berat'),
(20, 'Atlet', 3000, 'Butuh energi tinggi untuk latihan');

-- --------------------------------------------------------

--
-- Table structure for table `kondisi`
--

CREATE TABLE `kondisi` (
  `id_kondisi` int(11) NOT NULL,
  `nama_kondisi` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kondisi`
--

INSERT INTO `kondisi` (`id_kondisi`, `nama_kondisi`, `deskripsi`) VALUES
(1, 'Puasa', 'Tidak makan dan minum di waktu tertentu.'),
(2, 'Lelah Kerja', 'Kondisi tubuh lelah setelah bekerja.'),
(3, 'Musim Hujan', 'Kondisi cuaca dingin dan lembab.'),
(4, 'Panas Terik', 'Cuaca panas yang menguras energi.'),
(5, 'Pasien Diabetes', 'Perlu kontrol gula darah.'),
(6, 'Pencernaan', 'Terkait sistem pencernaan tubuh.'),
(7, 'Tidur Nyenyak', 'Kebutuhan tidur berkualitas.'),
(8, 'Maag', 'Kondisi lambung sensitif terhadap asam.'),
(9, 'Anemia', 'Kekurangan zat besi dalam darah.'),
(10, 'Hipertensi', 'Tekanan darah tinggi.'),
(11, 'Puasa', 'Tidak makan dan minum di waktu tertentu.'),
(12, 'Lelah Kerja', 'Kondisi tubuh lelah setelah bekerja.'),
(13, 'Musim Hujan', 'Kondisi cuaca dingin dan lembab.'),
(14, 'Panas Terik', 'Cuaca panas yang menguras energi.'),
(15, 'Pasien Diabetes', 'Perlu kontrol gula darah.'),
(16, 'Pencernaan', 'Terkait sistem pencernaan tubuh.'),
(17, 'Tidur Nyenyak', 'Kebutuhan tidur berkualitas.'),
(18, 'Maag', 'Kondisi lambung sensitif terhadap asam.'),
(19, 'Anemia', 'Kekurangan zat besi dalam darah.'),
(20, 'Hipertensi', 'Tekanan darah tinggi.');

-- --------------------------------------------------------

--
-- Table structure for table `minuman`
--

CREATE TABLE `minuman` (
  `id_minuman` int(11) NOT NULL,
  `nama_minuman` varchar(100) NOT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `minuman`
--

INSERT INTO `minuman` (`id_minuman`, `nama_minuman`, `kategori`, `keterangan`) VALUES
(1, 'Susu', 'Minuman Sehat', 'Mengandung kalsium dan protein tinggi.'),
(2, 'Kopi', 'Minuman Kafein', 'Dapat meningkatkan fokus, jangan berlebihan.'),
(3, 'Teh', 'Minuman Herbal', 'Mengandung antioksidan.'),
(4, 'Air Putih', 'Minuman Utama', 'Menjaga hidrasi tubuh.'),
(5, 'Air Hangat', 'Minuman Sehat', 'Baik dikonsumsi pagi hari.'),
(6, 'Air Kelapa', 'Minuman Elektrolit', 'Mengandung kalium alami.'),
(7, 'Teh Hijau', 'Minuman Herbal', 'Meningkatkan metabolisme.'),
(8, 'Teh Chamomile', 'Minuman Herbal', 'Menenangkan sebelum tidur.'),
(9, 'Susu Rendah Lemak', 'Minuman Sehat', 'Rendah lemak dan kalori.'),
(10, 'Vitamin C', 'Suplemen', 'Meningkatkan daya tahan tubuh.'),
(11, 'Vitamin D', 'Suplemen', 'Baik untuk tulang dan imun.'),
(12, 'Suplemen Zat Besi', 'Suplemen', 'Menambah kadar hemoglobin.'),
(13, 'Susu', 'Minuman Sehat', 'Mengandung kalsium dan protein tinggi.'),
(14, 'Kopi', 'Minuman Kafein', 'Dapat meningkatkan fokus, jangan berlebihan.'),
(15, 'Teh', 'Minuman Herbal', 'Mengandung antioksidan.'),
(16, 'Air Putih', 'Minuman Utama', 'Menjaga hidrasi tubuh.'),
(17, 'Air Hangat', 'Minuman Sehat', 'Baik dikonsumsi pagi hari.'),
(18, 'Air Kelapa', 'Minuman Elektrolit', 'Mengandung kalium alami.'),
(19, 'Teh Hijau', 'Minuman Herbal', 'Meningkatkan metabolisme.'),
(20, 'Teh Chamomile', 'Minuman Herbal', 'Menenangkan sebelum tidur.'),
(21, 'Susu Rendah Lemak', 'Minuman Sehat', 'Rendah lemak dan kalori.'),
(22, 'Vitamin C', 'Suplemen', 'Meningkatkan daya tahan tubuh.'),
(23, 'Vitamin D', 'Suplemen', 'Baik untuk tulang dan imun.'),
(24, 'Suplemen Zat Besi', 'Suplemen', 'Menambah kadar hemoglobin.');

-- --------------------------------------------------------

--
-- Table structure for table `nama_diet`
--

CREATE TABLE `nama_diet` (
  `id_diet` int(11) NOT NULL,
  `nama_diet` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nama_diet`
--

INSERT INTO `nama_diet` (`id_diet`, `nama_diet`, `deskripsi`) VALUES
(1, 'Diet Rendah Garam', 'Membatasi konsumsi natrium untuk menjaga tekanan darah.'),
(2, 'Diet Rendah Gula', 'Mengurangi asupan gula untuk mengontrol kadar glukosa darah.'),
(3, 'Diet Rendah Lemak', 'Membatasi lemak jenuh dan trans untuk kesehatan jantung.'),
(4, 'Diet Tinggi Protein', 'Meningkatkan asupan protein untuk membangun massa otot.'),
(5, 'Diet Keto', 'Rendah karbohidrat, tinggi lemak, untuk pembakaran lemak optimal.'),
(6, 'Diet Vegetarian', 'Tanpa konsumsi daging, fokus pada protein nabati.'),
(7, 'Diet Vegan', 'Tanpa produk hewani sama sekali.'),
(8, 'Diet Mediterania', 'Berbasis sayur, buah, ikan, dan minyak zaitun.'),
(9, 'Diet DASH', 'Diet untuk menurunkan tekanan darah tinggi.'),
(10, 'Diet Kolesterol', 'Mengurangi lemak jenuh dan kolesterol makanan.'),
(11, 'Diet Menurunkan Berat Badan', 'Mengurangi kalori harian secara seimbang.'),
(12, 'Diet Menambah Berat Badan', 'Meningkatkan asupan kalori dengan gizi seimbang.'),
(13, 'Diet Tinggi Serat', 'Memperbanyak konsumsi serat dari buah dan sayur.'),
(14, 'Diet Rendah Karbohidrat', 'Mengurangi sumber karbohidrat sederhana.'),
(15, 'Diet Gluten Free', 'Bebas gluten untuk penderita celiac.'),
(16, 'Diet Lactose Free', 'Bebas laktosa untuk penderita intoleransi laktosa.'),
(17, 'Diet Paleo', 'Makanan alami tanpa olahan modern.'),
(18, 'Diet Flexitarian', 'Sebagian besar nabati tapi tetap konsumsi daging sesekali.'),
(19, 'Diet Raw Food', 'Makanan mentah tanpa dimasak.'),
(20, 'Diet Tinggi Energi', 'Untuk meningkatkan energi harian, cocok bagi atlet.'),
(21, 'Diet Rendah Garam', 'Membatasi konsumsi natrium untuk menjaga tekanan darah.'),
(22, 'Diet Rendah Gula', 'Mengurangi asupan gula untuk mengontrol kadar glukosa darah.'),
(23, 'Diet Rendah Lemak', 'Membatasi lemak jenuh dan trans untuk kesehatan jantung.'),
(24, 'Diet Tinggi Protein', 'Meningkatkan asupan protein untuk membangun massa otot.'),
(25, 'Diet Keto', 'Rendah karbohidrat, tinggi lemak, untuk pembakaran lemak optimal.'),
(26, 'Diet Vegetarian', 'Tanpa konsumsi daging, fokus pada protein nabati.'),
(27, 'Diet Vegan', 'Tanpa produk hewani sama sekali.'),
(28, 'Diet Mediterania', 'Berbasis sayur, buah, ikan, dan minyak zaitun.'),
(29, 'Diet DASH', 'Diet untuk menurunkan tekanan darah tinggi.'),
(30, 'Diet Kolesterol', 'Mengurangi lemak jenuh dan kolesterol makanan.'),
(31, 'Diet Menurunkan Berat Badan', 'Mengurangi kalori harian secara seimbang.'),
(32, 'Diet Menambah Berat Badan', 'Meningkatkan asupan kalori dengan gizi seimbang.'),
(33, 'Diet Tinggi Serat', 'Memperbanyak konsumsi serat dari buah dan sayur.'),
(34, 'Diet Rendah Karbohidrat', 'Mengurangi sumber karbohidrat sederhana.'),
(35, 'Diet Gluten Free', 'Bebas gluten untuk penderita celiac.'),
(36, 'Diet Lactose Free', 'Bebas laktosa untuk penderita intoleransi laktosa.'),
(37, 'Diet Paleo', 'Makanan alami tanpa olahan modern.'),
(38, 'Diet Flexitarian', 'Sebagian besar nabati tapi tetap konsumsi daging sesekali.'),
(39, 'Diet Raw Food', 'Makanan mentah tanpa dimasak.'),
(40, 'Diet Tinggi Energi', 'Untuk meningkatkan energi harian, cocok bagi atlet.');

-- --------------------------------------------------------

--
-- Table structure for table `nama_makanan`
--

CREATE TABLE `nama_makanan` (
  `id_makanan` int(11) NOT NULL,
  `nama_makanan` varchar(100) NOT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `kalori` float DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nama_makanan`
--

INSERT INTO `nama_makanan` (`id_makanan`, `nama_makanan`, `kategori`, `kalori`, `deskripsi`) VALUES
(1, 'Kopi', 'Minuman', 2, 'Mengandung kafein, bisa meningkatkan fokus.'),
(2, 'Gula Pasir', 'Pemanis', 387, 'Sumber kalori tinggi tanpa gizi.'),
(3, 'Mie Instan', 'Makanan Cepat Saji', 350, 'Tinggi natrium dan lemak.'),
(4, 'Nasi Putih', 'Karbohidrat', 175, 'Sumber energi utama.'),
(5, 'Susu Sapi', 'Minuman', 150, 'Sumber protein dan kalsium.'),
(6, 'Gorengan', 'Camilan', 250, 'Tinggi lemak jenuh.'),
(7, 'Es Krim', 'Dessert', 210, 'Mengandung gula dan lemak.'),
(8, 'Coklat', 'Camilan', 220, 'Mengandung antioksidan, tetapi tinggi gula.'),
(9, 'Keripik', 'Camilan', 180, 'Tinggi garam dan kalori.'),
(10, 'Teh Manis', 'Minuman', 120, 'Minuman manis dengan tambahan gula.'),
(11, 'Kopi', 'Minuman', 2, 'Mengandung kafein, bisa meningkatkan fokus.'),
(12, 'Gula Pasir', 'Pemanis', 387, 'Sumber kalori tinggi tanpa gizi.'),
(13, 'Mie Instan', 'Makanan Cepat Saji', 350, 'Tinggi natrium dan lemak.'),
(14, 'Nasi Putih', 'Karbohidrat', 175, 'Sumber energi utama.'),
(15, 'Susu Sapi', 'Minuman', 150, 'Sumber protein dan kalsium.'),
(16, 'Gorengan', 'Camilan', 250, 'Tinggi lemak jenuh.'),
(17, 'Es Krim', 'Dessert', 210, 'Mengandung gula dan lemak.'),
(18, 'Coklat', 'Camilan', 220, 'Mengandung antioksidan, tetapi tinggi gula.'),
(19, 'Keripik', 'Camilan', 180, 'Tinggi garam dan kalori.'),
(20, 'Teh Manis', 'Minuman', 120, 'Minuman manis dengan tambahan gula.');

-- --------------------------------------------------------

--
-- Table structure for table `nama_produk`
--

CREATE TABLE `nama_produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `kalori` float DEFAULT NULL,
  `protein` float DEFAULT NULL,
  `lemak` float DEFAULT NULL,
  `karbohidrat` float DEFAULT NULL,
  `gula` float DEFAULT NULL,
  `natrium` float DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nama_produk`
--

INSERT INTO `nama_produk` (`id_produk`, `nama_produk`, `kalori`, `protein`, `lemak`, `karbohidrat`, `gula`, `natrium`, `keterangan`) VALUES
(1, 'Teh Botol Sosro 350 ml', 90, 0, 0, 22, 22, 5, 'Minuman teh manis dalam botol'),
(2, 'Ultra Milk Strawberry 200 ml', 130, 6, 4, 18, 16, 100, 'Susu rasa stroberi tinggi kalsium'),
(3, 'Aqua 600 ml', 0, 0, 0, 0, 0, 0, 'Air mineral tanpa kalori'),
(4, 'Pop Mie Rasa Ayam', 330, 7, 14, 42, 4, 900, 'Mi instan cup rasa ayam'),
(5, 'Indomie Goreng', 350, 8, 16, 44, 5, 880, 'Mi instan goreng klasik'),
(6, 'Coca Cola 250 ml', 105, 0, 0, 26, 26, 8, 'Minuman berkarbonasi manis'),
(7, 'Silverqueen 25g', 130, 2, 8, 15, 12, 20, 'Cokelat susu padat'),
(8, 'Nutrisari Jeruk 1 sachet', 80, 0, 0, 20, 20, 10, 'Minuman serbuk tinggi vitamin C'),
(9, 'Yakult', 50, 1, 0, 12, 12, 15, 'Minuman probiotik baik untuk pencernaan'),
(10, 'Chitato 68g', 370, 4, 22, 38, 2, 300, 'Keripik kentang rasa sapi panggang'),
(11, 'Fanta 250 ml', 110, 0, 0, 27, 27, 8, 'Minuman soda rasa buah'),
(12, 'Sprite botol kecil', 105, 0, 0, 26, 26, 8, 'Minuman soda lemon-lime'),
(13, 'Floridina 350 ml', 90, 0, 0, 22, 22, 5, 'Minuman rasa jeruk dengan nata de coco'),
(14, 'Milo UHT 200 ml', 140, 5, 4, 20, 16, 100, 'Minuman coklat energi'),
(15, 'Beng Beng 20g', 160, 2, 8, 18, 10, 50, 'Wafer coklat karamel'),
(16, 'Bear Brand 189 ml', 120, 6, 7, 9, 9, 90, 'Susu steril putih'),
(17, 'Teh Botol Sosro 350 ml', 90, 0, 0, 22, 22, 5, 'Minuman teh manis dalam botol'),
(18, 'Ultra Milk Strawberry 200 ml', 130, 6, 4, 18, 16, 100, 'Susu rasa stroberi tinggi kalsium'),
(19, 'Aqua 600 ml', 0, 0, 0, 0, 0, 0, 'Air mineral tanpa kalori'),
(20, 'Pop Mie Rasa Ayam', 330, 7, 14, 42, 4, 900, 'Mi instan cup rasa ayam'),
(21, 'Indomie Goreng', 350, 8, 16, 44, 5, 880, 'Mi instan goreng klasik'),
(22, 'Coca Cola 250 ml', 105, 0, 0, 26, 26, 8, 'Minuman berkarbonasi manis'),
(23, 'Silverqueen 25g', 130, 2, 8, 15, 12, 20, 'Cokelat susu padat'),
(24, 'Oreo 3 keping', 160, 2, 7, 23, 12, 90, 'Biskuit sandwich rasa coklat'),
(25, 'Nutrisari Jeruk 1 sachet', 80, 0, 0, 20, 20, 10, 'Minuman serbuk tinggi vitamin C'),
(26, 'Yakult', 50, 1, 0, 12, 12, 15, 'Minuman probiotik baik untuk pencernaan'),
(27, 'Chitato 68g', 370, 4, 22, 38, 2, 300, 'Keripik kentang rasa sapi panggang'),
(28, 'Good Day Cappuccino', 150, 2, 4, 25, 18, 70, 'Minuman kopi susu kemasan'),
(29, 'Fruit Tea Apel 350 ml', 90, 0, 0, 22, 22, 5, 'Minuman teh rasa apel'),
(30, 'Frestea Green Tea 500 ml', 100, 0, 0, 25, 25, 10, 'Minuman teh hijau kemasan'),
(31, 'KFC Chicken 1 potong', 280, 25, 18, 6, 0, 500, 'Ayam goreng tepung'),
(32, 'Burger McD', 300, 16, 14, 30, 4, 800, 'Roti isi daging sapi'),
(33, 'Pizza Hut ukuran kecil', 250, 10, 12, 26, 3, 600, 'Pizza kecil topping keju'),
(34, 'Popcorn 50g', 200, 3, 9, 25, 2, 180, 'Camilan dari jagung meletup'),
(35, 'Sari Roti Coklat', 250, 6, 5, 40, 18, 200, 'Roti isi coklat'),
(36, 'Dancow Fortigro 200 ml', 120, 6, 3, 15, 12, 80, 'Susu cair bernutrisi'),
(37, 'Es Teh Pucuk 350 ml', 90, 0, 0, 22, 22, 5, 'Minuman teh dalam botol'),
(38, 'Fanta 250 ml', 110, 0, 0, 27, 27, 8, 'Minuman soda rasa buah'),
(39, 'Sprite botol kecil', 105, 0, 0, 26, 26, 8, 'Minuman soda lemon-lime'),
(40, 'Yakult Light', 45, 1, 0, 10, 10, 15, 'Varian rendah gula Yakult'),
(41, 'Beng Beng 20g', 160, 2, 8, 18, 10, 50, 'Wafer coklat karamel'),
(42, 'Energen 1 sachet', 140, 4, 3, 25, 12, 100, 'Minuman sereal instan'),
(43, 'Biskuat mini', 120, 2, 4, 18, 8, 60, 'Biskuit energi anak-anak'),
(44, 'Pringles 42g', 220, 2, 12, 25, 1, 180, 'Keripik kentang tipis'),
(45, 'Pocari Sweat 350 ml', 70, 0, 0, 17, 17, 60, 'Minuman isotonik'),
(46, 'Teh Gelas 350 ml', 85, 0, 0, 21, 21, 5, 'Minuman teh manis gelas plastik'),
(47, 'Teh Kotak Jasmine', 90, 0, 0, 22, 22, 5, 'Teh melati kemasan kotak'),
(48, 'Bear Brand 189 ml', 120, 6, 7, 9, 9, 90, 'Susu steril putih'),
(49, 'Milo UHT 200 ml', 140, 5, 4, 20, 16, 100, 'Minuman coklat energi'),
(50, 'Nutriboost Coklat', 160, 4, 5, 22, 18, 100, 'Susu rasa coklat siap minum'),
(51, 'Cimory Yogurt Drink', 120, 4, 3, 18, 15, 80, 'Minuman yogurt botol'),
(52, 'Fruit Tea Lemon 350 ml', 90, 0, 0, 22, 22, 5, 'Teh rasa lemon manis'),
(53, 'Mizone 500 ml', 80, 0, 0, 20, 20, 10, 'Minuman ion dengan vitamin B'),
(54, 'Floridina 350 ml', 90, 0, 0, 22, 22, 5, 'Minuman rasa jeruk dengan nata de coco'),
(55, 'Indomilk Kids 115 ml', 90, 4, 3, 10, 9, 70, 'Susu cair anak'),
(56, 'Cheetos 50g', 260, 3, 15, 28, 1, 300, 'Camilan jagung renyah'),
(57, 'Tango Wafer 20g', 110, 1, 6, 12, 8, 50, 'Wafer krim rasa coklat'),
(58, 'Sari Gandum 20g', 100, 2, 4, 14, 4, 60, 'Biskuit gandum manis'),
(59, 'Koko Krunch 30g', 115, 2, 3, 20, 6, 70, 'Sereal coklat renyah'),
(60, 'Milo Sachet 30g', 120, 3, 3, 18, 12, 60, 'Minuman energi coklat serbuk'),
(61, 'Ultra Milk Full Cream 200 ml', 130, 6, 7, 9, 9, 100, 'Susu full cream tinggi kalsium'),
(62, 'Good Time Cookies 30g', 160, 2, 8, 20, 10, 80, 'Kue kering coklat chip'),
(63, 'Taro Net 30g', 150, 2, 8, 18, 3, 200, 'Camilan ringan rasa rumput laut'),
(64, 'Twister 20g', 120, 1, 6, 14, 6, 70, 'Wafer stik isi krim'),
(65, 'Prenagen Velvety Choco 185ml', 140, 6, 4, 20, 14, 90, 'Susu ibu hamil rasa coklat');

-- --------------------------------------------------------

--
-- Table structure for table `nama_zat`
--

CREATE TABLE `nama_zat` (
  `id_zat` int(11) NOT NULL,
  `nama_zat` varchar(100) NOT NULL,
  `fungsi` text DEFAULT NULL,
  `sumber` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nama_zat`
--

INSERT INTO `nama_zat` (`id_zat`, `nama_zat`, `fungsi`, `sumber`) VALUES
(1, 'Protein', 'Membangun jaringan dan otot', 'Telur, ikan, ayam, tempe'),
(2, 'Karbohidrat', 'Sumber energi utama tubuh', 'Nasi, kentang, roti'),
(3, 'Lemak', 'Cadangan energi dan pelindung organ', 'Minyak, alpukat, kacang'),
(4, 'Vitamin C', 'Meningkatkan imun tubuh', 'Jeruk, jambu biji, paprika'),
(5, 'Gula', 'Sumber energi cepat', 'Madu, buah manis'),
(6, 'Natrium', 'Menjaga tekanan darah dan cairan', 'Garam, makanan olahan'),
(7, 'Protein', 'Membangun jaringan dan otot', 'Telur, ikan, ayam, tempe'),
(8, 'Karbohidrat', 'Sumber energi utama tubuh', 'Nasi, kentang, roti'),
(9, 'Lemak', 'Cadangan energi dan pelindung organ', 'Minyak, alpukat, kacang'),
(10, 'Serat', 'Melancarkan pencernaan', 'Sayuran, buah, gandum'),
(11, 'Vitamin C', 'Meningkatkan imun tubuh', 'Jeruk, jambu biji, paprika'),
(12, 'Kalsium', 'Menjaga tulang dan gigi', 'Susu, keju, ikan teri'),
(13, 'Zat Besi', 'Membentuk sel darah merah', 'Bayam, hati, kacang merah'),
(14, 'Gula', 'Sumber energi cepat', 'Madu, buah manis'),
(15, 'Natrium', 'Menjaga tekanan darah dan cairan', 'Garam, makanan olahan'),
(16, 'Vitamin D', 'Membantu penyerapan kalsium', 'Telur, ikan, sinar matahari'),
(17, 'Protein', 'Membangun jaringan dan otot', 'Telur, ikan, ayam, tempe'),
(18, 'Karbohidrat', 'Sumber energi utama tubuh', 'Nasi, kentang, roti'),
(19, 'Lemak', 'Cadangan energi dan pelindung organ', 'Minyak, alpukat, kacang'),
(20, 'Serat', 'Melancarkan pencernaan', 'Sayuran, buah, gandum'),
(21, 'Vitamin C', 'Meningkatkan imun tubuh', 'Jeruk, jambu biji, paprika'),
(22, 'Kalsium', 'Menjaga tulang dan gigi', 'Susu, keju, ikan teri'),
(23, 'Zat Besi', 'Membentuk sel darah merah', 'Bayam, hati, kacang merah'),
(24, 'Gula', 'Sumber energi cepat', 'Madu, buah manis'),
(25, 'Natrium', 'Menjaga tekanan darah dan cairan', 'Garam, makanan olahan'),
(26, 'Vitamin D', 'Membantu penyerapan kalsium', 'Telur, ikan, sinar matahari');

-- --------------------------------------------------------

--
-- Table structure for table `tanya_alternatif_makanan`
--

CREATE TABLE `tanya_alternatif_makanan` (
  `id_alternatif` int(11) NOT NULL,
  `id_makanan` int(11) DEFAULT NULL,
  `alternatif` text DEFAULT NULL,
  `alasan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_alternatif_makanan`
--

INSERT INTO `tanya_alternatif_makanan` (`id_alternatif`, `id_makanan`, `alternatif`, `alasan`) VALUES
(1, 4, 'Nasi merah atau quinoa', 'Lebih tinggi serat dan indeks glikemik rendah'),
(2, 2, 'Stevia atau madu alami', 'Rendah kalori dan alami'),
(3, 5, 'Susu almond atau oat milk', 'Cocok untuk vegan dan bebas laktosa'),
(4, 3, 'Mie shirataki atau bihun jagung', 'Lebih rendah kalori dan karbohidrat'),
(5, 6, 'Panggang atau kukus', 'Mengurangi kandungan minyak jenuh'),
(6, 7, 'Yoghurt beku rendah lemak', 'Lebih rendah gula dan tinggi probiotik'),
(7, 8, 'Dark chocolate 70%', 'Kaya antioksidan dan rendah gula'),
(8, 9, 'Keripik buah tanpa minyak', 'Lebih rendah lemak'),
(9, 10, 'Teh tawar atau infused water', 'Tanpa gula tambahan');

-- --------------------------------------------------------

--
-- Table structure for table `tanya_efek_kesehatan`
--

CREATE TABLE `tanya_efek_kesehatan` (
  `id_efek` int(11) NOT NULL,
  `id_makanan` int(11) DEFAULT NULL,
  `efek_positif` text DEFAULT NULL,
  `efek_negatif` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_efek_kesehatan`
--

INSERT INTO `tanya_efek_kesehatan` (`id_efek`, `id_makanan`, `efek_positif`, `efek_negatif`) VALUES
(1, 1, 'Meningkatkan konsentrasi', 'Insomnia, jantung berdebar'),
(2, 2, 'Memberi energi cepat', 'Menyebabkan obesitas dan diabetes'),
(3, 6, 'Mengenyangkan cepat', 'Meningkatkan kolesterol'),
(4, 7, 'Memberi rasa senang', 'Tinggi gula dan lemak'),
(5, 3, 'Praktis dan cepat disiapkan', 'Tinggi natrium, tidak bergizi seimbang'),
(6, 5, 'Sumber protein dan kalsium', 'Alergi laktosa pada beberapa orang'),
(7, 8, 'Mengandung antioksidan', 'Berpotensi meningkatkan berat badan'),
(8, 9, 'Camilan ringan', 'Tinggi lemak dan garam'),
(9, 10, 'Memberi energi cepat', 'Tinggi gula, meningkatkan risiko diabetes');

-- --------------------------------------------------------

--
-- Table structure for table `tanya_info_gizi_produk`
--

CREATE TABLE `tanya_info_gizi_produk` (
  `id_info` int(11) NOT NULL,
  `id_produk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_info_gizi_produk`
--

INSERT INTO `tanya_info_gizi_produk` (`id_info`, `id_produk`) VALUES
(1, 1),
(128, 1),
(2, 2),
(129, 2),
(3, 3),
(130, 3),
(4, 4),
(131, 4),
(5, 5),
(132, 5),
(6, 6),
(133, 6),
(7, 7),
(134, 7),
(8, 8),
(135, 8),
(9, 9),
(136, 9),
(10, 10),
(137, 10),
(11, 11),
(138, 11),
(12, 12),
(139, 12),
(13, 13),
(140, 13),
(14, 14),
(141, 14),
(15, 15),
(142, 15),
(16, 16),
(143, 16),
(17, 17),
(144, 17),
(18, 18),
(145, 18),
(19, 19),
(146, 19),
(20, 20),
(147, 20),
(21, 21),
(148, 21),
(22, 22),
(149, 22),
(23, 23),
(150, 23),
(24, 24),
(151, 24),
(25, 25),
(152, 25),
(26, 26),
(153, 26),
(27, 27),
(154, 27),
(28, 28),
(155, 28),
(29, 29),
(156, 29),
(30, 30),
(157, 30),
(31, 31),
(158, 31),
(32, 32),
(159, 32),
(33, 33),
(160, 33),
(34, 34),
(161, 34),
(35, 35),
(162, 35),
(36, 36),
(163, 36),
(37, 37),
(164, 37),
(38, 38),
(165, 38),
(39, 39),
(166, 39),
(40, 40),
(167, 40),
(41, 41),
(168, 41),
(42, 42),
(169, 42),
(43, 43),
(170, 43),
(44, 44),
(171, 44),
(45, 45),
(172, 45),
(46, 46),
(173, 46),
(47, 47),
(174, 47),
(48, 48),
(175, 48),
(49, 49),
(176, 49),
(50, 50),
(177, 50),
(51, 51),
(178, 51),
(52, 52),
(179, 52),
(53, 53),
(180, 53),
(54, 54),
(181, 54),
(55, 55),
(182, 55),
(56, 56),
(183, 56),
(57, 57),
(184, 57),
(58, 58),
(185, 58),
(59, 59),
(186, 59),
(60, 60),
(187, 60),
(61, 61),
(188, 61),
(62, 62),
(189, 62),
(63, 63),
(190, 63),
(64, 64),
(191, 64),
(65, 65),
(192, 65);

-- --------------------------------------------------------

--
-- Table structure for table `tanya_kalori_harian`
--

CREATE TABLE `tanya_kalori_harian` (
  `id_kalori` int(11) NOT NULL,
  `id_kategori` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_kalori_harian`
--

INSERT INTO `tanya_kalori_harian` (`id_kalori`, `id_kategori`) VALUES
(1, 1),
(16, 1),
(2, 2),
(17, 2),
(3, 3),
(18, 3),
(4, 4),
(19, 4),
(5, 5),
(20, 5),
(6, 6),
(21, 6),
(7, 7),
(22, 7),
(8, 8),
(23, 8),
(9, 9),
(24, 9),
(10, 10),
(25, 10),
(26, 11),
(27, 12),
(28, 13),
(29, 14),
(30, 15),
(31, 16),
(32, 17),
(33, 18),
(34, 19),
(35, 20);

-- --------------------------------------------------------

--
-- Table structure for table `tanya_kandungan_zat`
--

CREATE TABLE `tanya_kandungan_zat` (
  `id_kandungan` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `id_zat` int(11) NOT NULL,
  `jumlah` float DEFAULT NULL,
  `satuan` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_kandungan_zat`
--

INSERT INTO `tanya_kandungan_zat` (`id_kandungan`, `id_produk`, `id_zat`, `jumlah`, `satuan`) VALUES
(1, 6, 5, 26, 'gram'),
(2, 5, 6, 880, 'mg'),
(3, 7, 3, 8, 'gram'),
(4, 2, 1, 6, 'gram'),
(5, 4, 2, 42, 'gram'),
(6, 8, 4, 50, 'mg'),
(7, 10, 6, 300, 'mg'),
(8, 1, 5, 22, 'gram'),
(9, 9, 5, 12, 'gram'),
(10, 11, 5, 27, 'gram'),
(11, 12, 5, 26, 'gram'),
(12, 13, 5, 22, 'gram'),
(13, 14, 2, 20, 'gram'),
(14, 15, 3, 8, 'gram'),
(15, 16, 1, 6, 'gram');

-- --------------------------------------------------------

--
-- Table structure for table `tanya_label_gizi`
--

CREATE TABLE `tanya_label_gizi` (
  `id_label` int(11) NOT NULL,
  `nama_label` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_label_gizi`
--

INSERT INTO `tanya_label_gizi` (`id_label`, `nama_label`, `deskripsi`) VALUES
(1, '%AKG', 'Persentase Angka Kecukupan Gizi yang menunjukkan kontribusi zat gizi per sajian terhadap kebutuhan harian.'),
(2, 'Takaran Saji', 'Ukuran standar banyaknya makanan/minuman per konsumsi.'),
(3, 'Kalori', 'Energi total yang diperoleh dari setiap sajian.'),
(4, 'Lemak Trans', 'Jenis lemak tidak sehat yang meningkatkan risiko kolesterol tinggi.'),
(5, 'Gula', 'Menunjukkan jumlah gula per sajian produk.'),
(6, 'Energi Total', 'Jumlah energi yang dihasilkan oleh semua makronutrien dalam produk.'),
(7, 'Protein', 'Kandungan zat pembangun tubuh yang tertera per sajian.'),
(8, 'Natrium', 'Jumlah garam atau sodium per sajian.'),
(9, 'Lemak Jenuh', 'Lemak yang dapat meningkatkan kadar kolesterol jahat.'),
(10, 'Vitamin', 'Daftar vitamin yang terkandung dalam produk.'),
(11, 'Kalsium', 'Mineral penting untuk tulang dan gigi.'),
(12, 'Zat Besi', 'Mineral penting untuk pembentukan darah.'),
(13, 'Low Fat', 'Klaim produk rendah lemak.'),
(14, 'Sugar Free', 'Klaim produk tanpa tambahan gula.'),
(15, 'High Protein', 'Klaim produk tinggi protein.'),
(16, 'Gluten Free', 'Tidak mengandung gluten, aman untuk penderita celiac.'),
(17, 'Lactose Free', 'Tidak mengandung laktosa, aman untuk intoleransi laktosa.'),
(18, 'Trans Fat Free', 'Tidak mengandung lemak trans.'),
(19, 'Plant Based', 'Produk berbahan dasar nabati.'),
(20, 'No Added Sugar', 'Tanpa tambahan gula rafinasi.'),
(21, '%AKG', 'Persentase Angka Kecukupan Gizi yang menunjukkan kontribusi zat gizi per sajian terhadap kebutuhan harian.'),
(22, 'Takaran Saji', 'Ukuran standar banyaknya makanan/minuman per konsumsi.'),
(23, 'Kalori', 'Energi total yang diperoleh dari setiap sajian.'),
(24, 'Lemak Trans', 'Jenis lemak tidak sehat yang meningkatkan risiko kolesterol tinggi.'),
(25, 'Gula', 'Menunjukkan jumlah gula per sajian produk.'),
(26, 'Energi Total', 'Jumlah energi yang dihasilkan oleh semua makronutrien dalam produk.'),
(27, 'Protein', 'Kandungan zat pembangun tubuh yang tertera per sajian.'),
(28, 'Natrium', 'Jumlah garam atau sodium per sajian.'),
(29, 'Lemak Jenuh', 'Lemak yang dapat meningkatkan kadar kolesterol jahat.'),
(30, 'Vitamin', 'Daftar vitamin yang terkandung dalam produk.'),
(31, 'Kalsium', 'Mineral penting untuk tulang dan gigi.'),
(32, 'Zat Besi', 'Mineral penting untuk pembentukan darah.'),
(33, 'Low Fat', 'Klaim produk rendah lemak.'),
(34, 'Sugar Free', 'Klaim produk tanpa tambahan gula.'),
(35, 'High Protein', 'Klaim produk tinggi protein.'),
(36, 'Gluten Free', 'Tidak mengandung gluten, aman untuk penderita celiac.'),
(37, 'Lactose Free', 'Tidak mengandung laktosa, aman untuk intoleransi laktosa.'),
(38, 'Trans Fat Free', 'Tidak mengandung lemak trans.'),
(39, 'Plant Based', 'Produk berbahan dasar nabati.'),
(40, 'No Added Sugar', 'Tanpa tambahan gula rafinasi.');

-- --------------------------------------------------------

--
-- Table structure for table `tanya_makanan_diet`
--

CREATE TABLE `tanya_makanan_diet` (
  `id_makanan_diet` int(11) NOT NULL,
  `id_diet` int(11) DEFAULT NULL,
  `rekomendasi_makanan` text DEFAULT NULL,
  `pantangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_makanan_diet`
--

INSERT INTO `tanya_makanan_diet` (`id_makanan_diet`, `id_diet`, `rekomendasi_makanan`, `pantangan`) VALUES
(1, 1, 'Sayur kukus, buah segar, ikan tanpa garam', 'Makanan olahan dan keripik asin'),
(2, 2, 'Sayur, alpukat, ayam panggang', 'Minuman manis, kue, sirup'),
(3, 4, 'Telur, dada ayam, tahu, tempe', 'Makanan tinggi gula dan tepung'),
(4, 5, 'Telur, alpukat, keju, daging sapi', 'Nasi, roti, mie, kentang'),
(5, 8, 'Ikan, minyak zaitun, sayur, buah', 'Makanan cepat saji'),
(6, 7, 'Kacang, tahu, tempe, sayur', 'Produk hewani'),
(7, 9, 'Buah, susu rendah lemak, biji-bijian', 'Makanan tinggi garam'),
(8, 3, 'Ikan kukus, sayur rebus, buah segar', 'Gorengan, daging berlemak tinggi'),
(9, 13, 'Oatmeal, apel, sayur hijau', 'Daging olahan, nasi putih'),
(10, 20, 'Nasi merah, telur, ikan, kacang', 'Makanan rendah kalori');

-- --------------------------------------------------------

--
-- Table structure for table `tanya_porsi_makan`
--

CREATE TABLE `tanya_porsi_makan` (
  `id_porsi` int(11) NOT NULL,
  `id_produk` int(11) DEFAULT NULL,
  `id_kategori` int(11) DEFAULT NULL,
  `porsi_anjuran` varchar(50) DEFAULT NULL,
  `frekuensi` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tanya_rekomendasi_makanan`
--

CREATE TABLE `tanya_rekomendasi_makanan` (
  `id_rekomendasi` int(11) NOT NULL,
  `id_kategori` int(11) DEFAULT NULL,
  `id_zat` int(11) DEFAULT NULL,
  `rekomendasi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_rekomendasi_makanan`
--

INSERT INTO `tanya_rekomendasi_makanan` (`id_rekomendasi`, `id_kategori`, `id_zat`, `rekomendasi`) VALUES
(1, 4, 1, 'Ayam, tempe, tahu kukus'),
(2, 3, 5, 'Jeruk, jambu, kiwi'),
(3, 6, 7, 'Bayam, hati ayam, kacang merah'),
(4, 10, 2, 'Nasi merah, roti gandum'),
(5, 5, 6, 'Susu, yogurt, keju rendah lemak'),
(6, 2, 4, 'Buah apel, pepaya, sayur hijau'),
(7, 4, 3, 'Alpukat, ikan salmon, olive oil'),
(8, 8, 7, 'Salad sayur dan telur rebus'),
(9, 9, 1, 'Ikan, telur, daging tanpa lemak'),
(10, 7, 5, 'Buah segar tinggi vitamin C'),
(11, 4, 1, 'Ayam, tempe, tahu kukus'),
(12, 3, 5, 'Jeruk, jambu, kiwi'),
(13, 6, 7, 'Bayam, hati ayam, kacang merah'),
(14, 10, 2, 'Nasi merah, roti gandum'),
(15, 5, 6, 'Susu, yogurt, keju rendah lemak'),
(16, 2, 4, 'Buah apel, pepaya, sayur hijau'),
(17, 4, 3, 'Alpukat, ikan salmon, olive oil'),
(18, 8, 7, 'Salad sayur dan telur rebus'),
(19, 9, 1, 'Ikan, telur, daging tanpa lemak'),
(20, 7, 5, 'Buah segar tinggi vitamin C');

-- --------------------------------------------------------

--
-- Table structure for table `tanya_tips_hidup_sehat`
--

CREATE TABLE `tanya_tips_hidup_sehat` (
  `id_tips` int(11) NOT NULL,
  `id_tujuan` int(11) DEFAULT NULL,
  `id_pengguna` int(11) DEFAULT NULL,
  `id_tempat` int(11) DEFAULT NULL,
  `id_kondisi` int(11) DEFAULT NULL,
  `id_zat` int(11) DEFAULT NULL,
  `id_aktivitas` int(11) DEFAULT NULL,
  `tips` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tanya_waktu_makan`
--

CREATE TABLE `tanya_waktu_makan` (
  `id_waktu_makan` int(11) NOT NULL,
  `id_waktu` int(11) DEFAULT NULL,
  `id_minuman` int(11) DEFAULT NULL,
  `id_tujuan` int(11) DEFAULT NULL,
  `id_pengguna` int(11) DEFAULT NULL,
  `id_kondisi` int(11) DEFAULT NULL,
  `id_aktivitas` int(11) DEFAULT NULL,
  `saran` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tanya_waktu_makan`
--

INSERT INTO `tanya_waktu_makan` (`id_waktu_makan`, `id_waktu`, `id_minuman`, `id_tujuan`, `id_pengguna`, `id_kondisi`, `id_aktivitas`, `saran`) VALUES
(1, 1, NULL, NULL, NULL, NULL, NULL, 'Sarapan ideal antara pukul 06:00–08:00.'),
(2, 2, NULL, NULL, NULL, NULL, NULL, 'Makan siang terbaik pukul 12:00–13:00.'),
(3, 3, NULL, 1, NULL, NULL, NULL, 'Makan malam sebaiknya sebelum jam 20:00 untuk menjaga metabolisme.'),
(4, NULL, 2, NULL, NULL, NULL, NULL, 'Minum kopi sebaiknya antara pukul 09:00–11:00 pagi.'),
(5, NULL, 3, NULL, NULL, NULL, NULL, 'Teh dapat diminum pagi atau sore untuk relaksasi.'),
(6, NULL, 4, NULL, NULL, NULL, NULL, 'Minum air putih minimal 8 gelas sehari, terutama pagi dan sebelum tidur.'),
(7, NULL, 1, 4, NULL, NULL, NULL, 'Minum susu pagi atau malam untuk membantu pemulihan.');

-- --------------------------------------------------------

--
-- Table structure for table `tujuan`
--

CREATE TABLE `tujuan` (
  `id_tujuan` int(11) NOT NULL,
  `nama_tujuan` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tujuan`
--

INSERT INTO `tujuan` (`id_tujuan`, `nama_tujuan`, `deskripsi`) VALUES
(1, 'Diet', 'Tujuan menjaga berat badan dan kesehatan.'),
(2, 'Diet Keto', 'Pola makan rendah karbohidrat tinggi lemak.'),
(3, 'Diet Intermittent Fasting', 'Pola makan dengan jeda waktu tertentu.'),
(4, 'Diet Sehat', 'Menjaga gizi seimbang dan berat badan ideal.'),
(5, 'Menurunkan Berat Badan', 'Fokus mengurangi asupan kalori.'),
(6, 'Menambah Berat Badan', 'Fokus meningkatkan kalori dan protein.'),
(7, 'Jaga Imun', 'Menjaga daya tahan tubuh.'),
(8, 'Kulit Glowing', 'Menjaga kesehatan kulit dari makanan bergizi.'),
(9, 'Berat Badan Ideal', 'Menyeimbangkan massa tubuh dan energi.'),
(10, 'Diet', 'Tujuan menjaga berat badan dan kesehatan.'),
(11, 'Diet Keto', 'Pola makan rendah karbohidrat tinggi lemak.'),
(12, 'Diet Intermittent Fasting', 'Pola makan dengan jeda waktu tertentu.'),
(13, 'Diet Sehat', 'Menjaga gizi seimbang dan berat badan ideal.'),
(14, 'Menurunkan Berat Badan', 'Fokus mengurangi asupan kalori.'),
(15, 'Menambah Berat Badan', 'Fokus meningkatkan kalori dan protein.'),
(16, 'Jaga Imun', 'Menjaga daya tahan tubuh.'),
(17, 'Kulit Glowing', 'Menjaga kesehatan kulit dari makanan bergizi.'),
(18, 'Berat Badan Ideal', 'Menyeimbangkan massa tubuh dan energi.');

-- --------------------------------------------------------

--
-- Table structure for table `waktu_makan`
--

CREATE TABLE `waktu_makan` (
  `id_waktu` int(11) NOT NULL,
  `nama_waktu` varchar(50) NOT NULL,
  `jam_ideal` varchar(20) DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `waktu_makan`
--

INSERT INTO `waktu_makan` (`id_waktu`, `nama_waktu`, `jam_ideal`, `keterangan`) VALUES
(1, 'Sarapan', '06:00-08:00', 'Waktu ideal untuk mengisi energi pagi.'),
(2, 'Makan Siang', '12:00-13:30', 'Waktu untuk makan utama kedua.'),
(3, 'Makan Malam', '18:00-20:00', 'Sebaiknya tidak terlalu malam.'),
(4, 'Ngemil', '10:00 / 16:00', 'Camilan sehat di sela waktu makan utama.'),
(5, 'Sahur', '03:30-04:30', 'Waktu makan sebelum berpuasa.'),
(6, 'Berbuka Puasa', '18:00', 'Disarankan konsumsi air dan buah dahulu.'),
(7, 'Camilan Sore', '15:00-16:30', 'Camilan ringan menjelang sore.'),
(8, 'Makan Pagi', '07:00', 'Waktu umum untuk sarapan.'),
(9, 'Makan Malam Keluarga', '19:00', 'Waktu ideal makan bersama keluarga.'),
(10, 'Sarapan', '06:00-08:00', 'Waktu ideal untuk mengisi energi pagi.'),
(11, 'Makan Siang', '12:00-13:30', 'Waktu untuk makan utama kedua.'),
(12, 'Makan Malam', '18:00-20:00', 'Sebaiknya tidak terlalu malam.'),
(13, 'Ngemil', '10:00 / 16:00', 'Camilan sehat di sela waktu makan utama.'),
(14, 'Sahur', '03:30-04:30', 'Waktu makan sebelum berpuasa.'),
(15, 'Berbuka Puasa', '18:00', 'Disarankan konsumsi air dan buah dahulu.'),
(16, 'Camilan Sore', '15:00-16:30', 'Camilan ringan menjelang sore.'),
(17, 'Makan Pagi', '07:00', 'Waktu umum untuk sarapan.'),
(18, 'Makan Malam Keluarga', '19:00', 'Waktu ideal makan bersama keluarga.');

-- --------------------------------------------------------

--
-- Table structure for table `zat`
--

CREATE TABLE `zat` (
  `id_zat` int(11) NOT NULL,
  `nama_zat` varchar(100) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `fungsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zat`
--

INSERT INTO `zat` (`id_zat`, `nama_zat`, `kategori`, `fungsi`) VALUES
(1, 'Gula', 'Karbohidrat', 'Sumber energi cepat untuk tubuh.'),
(2, 'Garam', 'Mineral', 'Menjaga keseimbangan cairan tubuh.'),
(3, 'Lemak', 'Makronutrien', 'Sumber energi jangka panjang.'),
(4, 'Protein', 'Makronutrien', 'Membangun jaringan otot dan sel.'),
(5, 'Vitamin C', 'Vitamin', 'Meningkatkan daya tahan tubuh.'),
(6, 'Vitamin D', 'Vitamin', 'Mendukung kesehatan tulang.'),
(7, 'Zat Besi', 'Mineral', 'Membentuk hemoglobin darah.'),
(8, 'Kalsium', 'Mineral', 'Membentuk tulang dan gigi.'),
(9, 'Serat', 'Karbohidrat Kompleks', 'Melancarkan pencernaan.'),
(10, 'Kolesterol', 'Lipid', 'Perlu dijaga agar tidak berlebih.'),
(11, 'Gula', 'Karbohidrat', 'Sumber energi cepat untuk tubuh.'),
(12, 'Garam', 'Mineral', 'Menjaga keseimbangan cairan tubuh.'),
(13, 'Lemak', 'Makronutrien', 'Sumber energi jangka panjang.'),
(14, 'Protein', 'Makronutrien', 'Membangun jaringan otot dan sel.'),
(15, 'Vitamin C', 'Vitamin', 'Meningkatkan daya tahan tubuh.'),
(16, 'Vitamin D', 'Vitamin', 'Mendukung kesehatan tulang.'),
(17, 'Zat Besi', 'Mineral', 'Membentuk hemoglobin darah.'),
(18, 'Kalsium', 'Mineral', 'Membentuk tulang dan gigi.'),
(19, 'Serat', 'Karbohidrat Kompleks', 'Melancarkan pencernaan.'),
(20, 'Kolesterol', 'Lipid', 'Perlu dijaga agar tidak berlebih.');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aktivitas`
--
ALTER TABLE `aktivitas`
  ADD PRIMARY KEY (`id_aktivitas`);

--
-- Indexes for table `kategori_pengguna`
--
ALTER TABLE `kategori_pengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indexes for table `kategori_tempat`
--
ALTER TABLE `kategori_tempat`
  ADD PRIMARY KEY (`id_tempat`);

--
-- Indexes for table `kategori_usia`
--
ALTER TABLE `kategori_usia`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `kondisi`
--
ALTER TABLE `kondisi`
  ADD PRIMARY KEY (`id_kondisi`);

--
-- Indexes for table `minuman`
--
ALTER TABLE `minuman`
  ADD PRIMARY KEY (`id_minuman`);

--
-- Indexes for table `nama_diet`
--
ALTER TABLE `nama_diet`
  ADD PRIMARY KEY (`id_diet`);

--
-- Indexes for table `nama_makanan`
--
ALTER TABLE `nama_makanan`
  ADD PRIMARY KEY (`id_makanan`);

--
-- Indexes for table `nama_produk`
--
ALTER TABLE `nama_produk`
  ADD PRIMARY KEY (`id_produk`);

--
-- Indexes for table `nama_zat`
--
ALTER TABLE `nama_zat`
  ADD PRIMARY KEY (`id_zat`);

--
-- Indexes for table `tanya_alternatif_makanan`
--
ALTER TABLE `tanya_alternatif_makanan`
  ADD PRIMARY KEY (`id_alternatif`),
  ADD KEY `id_makanan` (`id_makanan`);

--
-- Indexes for table `tanya_efek_kesehatan`
--
ALTER TABLE `tanya_efek_kesehatan`
  ADD PRIMARY KEY (`id_efek`),
  ADD KEY `id_makanan` (`id_makanan`);

--
-- Indexes for table `tanya_info_gizi_produk`
--
ALTER TABLE `tanya_info_gizi_produk`
  ADD PRIMARY KEY (`id_info`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indexes for table `tanya_kalori_harian`
--
ALTER TABLE `tanya_kalori_harian`
  ADD PRIMARY KEY (`id_kalori`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `tanya_kandungan_zat`
--
ALTER TABLE `tanya_kandungan_zat`
  ADD PRIMARY KEY (`id_kandungan`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `id_zat` (`id_zat`);

--
-- Indexes for table `tanya_label_gizi`
--
ALTER TABLE `tanya_label_gizi`
  ADD PRIMARY KEY (`id_label`);

--
-- Indexes for table `tanya_makanan_diet`
--
ALTER TABLE `tanya_makanan_diet`
  ADD PRIMARY KEY (`id_makanan_diet`),
  ADD KEY `id_diet` (`id_diet`);

--
-- Indexes for table `tanya_porsi_makan`
--
ALTER TABLE `tanya_porsi_makan`
  ADD PRIMARY KEY (`id_porsi`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `tanya_rekomendasi_makanan`
--
ALTER TABLE `tanya_rekomendasi_makanan`
  ADD PRIMARY KEY (`id_rekomendasi`),
  ADD KEY `id_kategori` (`id_kategori`),
  ADD KEY `id_zat` (`id_zat`);

--
-- Indexes for table `tanya_tips_hidup_sehat`
--
ALTER TABLE `tanya_tips_hidup_sehat`
  ADD PRIMARY KEY (`id_tips`),
  ADD KEY `id_tujuan` (`id_tujuan`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_tempat` (`id_tempat`),
  ADD KEY `id_kondisi` (`id_kondisi`),
  ADD KEY `id_zat` (`id_zat`),
  ADD KEY `id_aktivitas` (`id_aktivitas`);

--
-- Indexes for table `tanya_waktu_makan`
--
ALTER TABLE `tanya_waktu_makan`
  ADD PRIMARY KEY (`id_waktu_makan`),
  ADD KEY `id_waktu` (`id_waktu`),
  ADD KEY `id_minuman` (`id_minuman`),
  ADD KEY `id_tujuan` (`id_tujuan`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_kondisi` (`id_kondisi`),
  ADD KEY `id_aktivitas` (`id_aktivitas`);

--
-- Indexes for table `tujuan`
--
ALTER TABLE `tujuan`
  ADD PRIMARY KEY (`id_tujuan`);

--
-- Indexes for table `waktu_makan`
--
ALTER TABLE `waktu_makan`
  ADD PRIMARY KEY (`id_waktu`);

--
-- Indexes for table `zat`
--
ALTER TABLE `zat`
  ADD PRIMARY KEY (`id_zat`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aktivitas`
--
ALTER TABLE `aktivitas`
  MODIFY `id_aktivitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `kategori_pengguna`
--
ALTER TABLE `kategori_pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `kategori_tempat`
--
ALTER TABLE `kategori_tempat`
  MODIFY `id_tempat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `kategori_usia`
--
ALTER TABLE `kategori_usia`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `kondisi`
--
ALTER TABLE `kondisi`
  MODIFY `id_kondisi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `minuman`
--
ALTER TABLE `minuman`
  MODIFY `id_minuman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `nama_diet`
--
ALTER TABLE `nama_diet`
  MODIFY `id_diet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `nama_makanan`
--
ALTER TABLE `nama_makanan`
  MODIFY `id_makanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `nama_produk`
--
ALTER TABLE `nama_produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `nama_zat`
--
ALTER TABLE `nama_zat`
  MODIFY `id_zat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `tanya_alternatif_makanan`
--
ALTER TABLE `tanya_alternatif_makanan`
  MODIFY `id_alternatif` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tanya_efek_kesehatan`
--
ALTER TABLE `tanya_efek_kesehatan`
  MODIFY `id_efek` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tanya_info_gizi_produk`
--
ALTER TABLE `tanya_info_gizi_produk`
  MODIFY `id_info` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=255;

--
-- AUTO_INCREMENT for table `tanya_kalori_harian`
--
ALTER TABLE `tanya_kalori_harian`
  MODIFY `id_kalori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `tanya_kandungan_zat`
--
ALTER TABLE `tanya_kandungan_zat`
  MODIFY `id_kandungan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tanya_label_gizi`
--
ALTER TABLE `tanya_label_gizi`
  MODIFY `id_label` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `tanya_makanan_diet`
--
ALTER TABLE `tanya_makanan_diet`
  MODIFY `id_makanan_diet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tanya_porsi_makan`
--
ALTER TABLE `tanya_porsi_makan`
  MODIFY `id_porsi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tanya_rekomendasi_makanan`
--
ALTER TABLE `tanya_rekomendasi_makanan`
  MODIFY `id_rekomendasi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tanya_tips_hidup_sehat`
--
ALTER TABLE `tanya_tips_hidup_sehat`
  MODIFY `id_tips` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tanya_waktu_makan`
--
ALTER TABLE `tanya_waktu_makan`
  MODIFY `id_waktu_makan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tujuan`
--
ALTER TABLE `tujuan`
  MODIFY `id_tujuan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `waktu_makan`
--
ALTER TABLE `waktu_makan`
  MODIFY `id_waktu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `zat`
--
ALTER TABLE `zat`
  MODIFY `id_zat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tanya_alternatif_makanan`
--
ALTER TABLE `tanya_alternatif_makanan`
  ADD CONSTRAINT `tanya_alternatif_makanan_ibfk_1` FOREIGN KEY (`id_makanan`) REFERENCES `nama_makanan` (`id_makanan`);

--
-- Constraints for table `tanya_efek_kesehatan`
--
ALTER TABLE `tanya_efek_kesehatan`
  ADD CONSTRAINT `tanya_efek_kesehatan_ibfk_1` FOREIGN KEY (`id_makanan`) REFERENCES `nama_makanan` (`id_makanan`);

--
-- Constraints for table `tanya_info_gizi_produk`
--
ALTER TABLE `tanya_info_gizi_produk`
  ADD CONSTRAINT `tanya_info_gizi_produk_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `nama_produk` (`id_produk`);

--
-- Constraints for table `tanya_kalori_harian`
--
ALTER TABLE `tanya_kalori_harian`
  ADD CONSTRAINT `tanya_kalori_harian_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_usia` (`id_kategori`);

--
-- Constraints for table `tanya_kandungan_zat`
--
ALTER TABLE `tanya_kandungan_zat`
  ADD CONSTRAINT `tanya_kandungan_zat_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `nama_produk` (`id_produk`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tanya_kandungan_zat_ibfk_2` FOREIGN KEY (`id_zat`) REFERENCES `nama_zat` (`id_zat`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tanya_makanan_diet`
--
ALTER TABLE `tanya_makanan_diet`
  ADD CONSTRAINT `tanya_makanan_diet_ibfk_1` FOREIGN KEY (`id_diet`) REFERENCES `nama_diet` (`id_diet`);

--
-- Constraints for table `tanya_porsi_makan`
--
ALTER TABLE `tanya_porsi_makan`
  ADD CONSTRAINT `tanya_porsi_makan_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `nama_produk` (`id_produk`),
  ADD CONSTRAINT `tanya_porsi_makan_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_usia` (`id_kategori`);

--
-- Constraints for table `tanya_rekomendasi_makanan`
--
ALTER TABLE `tanya_rekomendasi_makanan`
  ADD CONSTRAINT `tanya_rekomendasi_makanan_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_usia` (`id_kategori`),
  ADD CONSTRAINT `tanya_rekomendasi_makanan_ibfk_2` FOREIGN KEY (`id_zat`) REFERENCES `nama_zat` (`id_zat`);

--
-- Constraints for table `tanya_tips_hidup_sehat`
--
ALTER TABLE `tanya_tips_hidup_sehat`
  ADD CONSTRAINT `tanya_tips_hidup_sehat_ibfk_1` FOREIGN KEY (`id_tujuan`) REFERENCES `tujuan` (`id_tujuan`),
  ADD CONSTRAINT `tanya_tips_hidup_sehat_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `kategori_pengguna` (`id_pengguna`),
  ADD CONSTRAINT `tanya_tips_hidup_sehat_ibfk_3` FOREIGN KEY (`id_tempat`) REFERENCES `kategori_tempat` (`id_tempat`),
  ADD CONSTRAINT `tanya_tips_hidup_sehat_ibfk_4` FOREIGN KEY (`id_kondisi`) REFERENCES `kondisi` (`id_kondisi`),
  ADD CONSTRAINT `tanya_tips_hidup_sehat_ibfk_5` FOREIGN KEY (`id_zat`) REFERENCES `zat` (`id_zat`),
  ADD CONSTRAINT `tanya_tips_hidup_sehat_ibfk_6` FOREIGN KEY (`id_aktivitas`) REFERENCES `aktivitas` (`id_aktivitas`);

--
-- Constraints for table `tanya_waktu_makan`
--
ALTER TABLE `tanya_waktu_makan`
  ADD CONSTRAINT `tanya_waktu_makan_ibfk_1` FOREIGN KEY (`id_waktu`) REFERENCES `waktu_makan` (`id_waktu`),
  ADD CONSTRAINT `tanya_waktu_makan_ibfk_2` FOREIGN KEY (`id_minuman`) REFERENCES `minuman` (`id_minuman`),
  ADD CONSTRAINT `tanya_waktu_makan_ibfk_3` FOREIGN KEY (`id_tujuan`) REFERENCES `tujuan` (`id_tujuan`),
  ADD CONSTRAINT `tanya_waktu_makan_ibfk_4` FOREIGN KEY (`id_pengguna`) REFERENCES `kategori_pengguna` (`id_pengguna`),
  ADD CONSTRAINT `tanya_waktu_makan_ibfk_5` FOREIGN KEY (`id_kondisi`) REFERENCES `kondisi` (`id_kondisi`),
  ADD CONSTRAINT `tanya_waktu_makan_ibfk_6` FOREIGN KEY (`id_aktivitas`) REFERENCES `aktivitas` (`id_aktivitas`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
