@tool
extends EditorScript

const OUTPUT_DIR := "res://Resources/Events/"


func _run() -> void:
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR)
	
	# =========================================================================
	# 18 EVENT SESI PAGI (session = 0) — 3–5 KONSEKUENSI & PENALTI BEBAN
	# =========================================================================
	
	# P1 (Hari 1-7): Asap Pekat
	_save_item_event(
		"evt_p1_asap_pekat", 0, 1, 7, [],
		"Angin berbalik arah membawa dinding asap hitam karhutla menutupi jalan. Bayimu terbatuk hebat menghirup udara beracun.",
		_make_choice("Pakai Masker", ["masker"], [], ["masker"], 4, 0, -8, 0.5,
			"Masker menyaring asap beracun, meski napasmu tetap terasa berat."),
		null,
		_make_choice("Tahan napas menerobos asap", [], [], [], 14, -22, 24, -0.5,
			"Asap pekat membakar paru-paru dan membuatmu terbatuk-batuk kehilangan arah.",
			1, [], 6, 8, -4)
	)
	
	# P2 (Hari 1-7): Hujan Abu Panas
	_save_item_event(
		"evt_p2_hujan_abu", 0, 1, 7, [],
		"Langit memerah gelap, disusul hujan abu panas dan gerimis keruh yang membasahi kain gendongan bayimu.",
		_make_choice("Buka Payung", ["payung"], [], [], 5, 0, -8, -0.5,
			"Payung menahan hujan abu panas, meski langkahmu melambat menahan terpaan angin."),
		null,
		_make_choice("Lari menerobos hujan abu", [], [], [], 15, -20, 22, 0.0,
			"Percikan abu panas membakar bahumu dan membuat satu barang terlepas saat berlari.",
			1, [], 6, 6, 0)
	)
	
	# P3 (Hari 1-5): Pos Pemeriksaan
	_save_item_event(
		"evt_p3_pos_periksa", 0, 1, 5, [],
		"Petugas menjaga pos pemeriksaan menuju jalur evakuasi lintas cepat. Mereka meminta bukti identitas warga terdampak karhutla.",
		_make_choice("Tunjukkan Dokumen", ["dokumen"], [], [], 5, 0, -12, 2.0,
			"Dokumen lengkap! Petugas membukakan jalur pintas prioritas menuju pengungsian."),
		null,
		_make_choice("Memutar jauh lewat jalur desa", [], [], [], 22, -8, 18, -1.0,
			"Tanpa dokumen, kamu terpaksa memutar jauh melewati semak berduri yang menguras tenaga.",
			0, [], 8, 8, -4)
	)
	
	# P4 (Hari 1-7): Dehidrasi Terik
	_save_item_event(
		"evt_p4_kehausan", 0, 1, 7, [],
		"Hawa panas dari hutan yang terbakar membuat udara kering kerontang. Tenggorokanmu terasa terbakar karena dehidrasi berat.",
		_make_choice("Minum Air Mineral", ["air_mineral"], [], ["air_mineral"], -15, 12, -10, 0.0,
			"Air mineral memulihkan cairan tubuh dan meringankan beban tas bawaanmu."),
		null,
		_make_choice("Hemat air & paksakan jalan", [], [], [], 25, -20, 18, -0.5,
			"Dehidrasi berat membuat langkah kakimu gontai dan melambat di bawah terik matahari.",
			0, [], 8, 8, -5)
	)
	
	# P5 (Hari 2-7): Kram Otot Betis
	_save_item_event(
		"evt_p5_kaki_pegal", 0, 2, 7, [],
		"Beban gendongan dan jalan berbatu membuat otot betismu kram parah. Setiap langkah terasa menyiksa.",
		_make_choice("Pasang Perban Coklat", ["perban_coklat"], [], ["perban_coklat"], 5, 10, -5, 1.0,
			"Perban coklat menopang otot kakimu sehingga langkah kembali mantap."),
		null,
		_make_choice("Paksakan berjalan tertatih", [], [], [], 15, -22, 18, -1.0,
			"Kram otot memaksamu berjalan lambat menahan nyeri luar biasa.",
			0, [], 6, 10, -5)
	)
	
	# P6 (Hari 1-7): Kelaparan Siang
	_save_item_event(
		"evt_p6_lapar_siang", 0, 1, 7, [],
		"Tenagamu terkuras habis di tengah terik siang. Pandanganmu mulai berkunang-kunang karena perut kosong.",
		_make_choice("Makan Biskuit", ["biskuit"], [], ["biskuit"], -32, 5, -10, 0.0,
			"Biskuit mengganjal rasa lapar dan mengembalikan tenagamu untuk menggendong bayi."),
		null,
		_make_choice("Tahan lapar hingga malam", [], [], [], 28, -12, 22, -0.5,
			"Perut melilit kelaparan membuat fokusmu buyar dan langkahmu goyah.",
			0, [], 6, 8, -4)
	)
	
	# P7 (Hari 3-7): Jalur Pintas Lahan Gambut
	_save_yesno_event(
		"evt_p7_jalur_gambut", 0, 3, 7, [],
		"Terlihat jalan pintas melewati lahan gambut kering yang mulai berasap tebal. Jarak ke pengungsian bisa terpangkas drastis, tapi tanahnya labil.",
		_make_choice("Terobos jalan pintas gambut", [], [], [], 18, -24, 24, 2.0,
			"Hawa panas tanah gambut membakar kakimu dan memaksamu membuang beban demi lolos!",
			1, [], 8, 10, -6),
		_make_choice("Ambil jalan aspal yang aman", [], [], [], 12, -5, 6, -0.5,
			"Kamu memutar lewat jalur aspal yang lebih jauh demi keselamatan bayimu.",
			0, [], 5, 5, 0)
	)
	
	# P8 (Hari 2-7): Jembatan Kayu Lapuk
	_save_item_event(
		"evt_p8_jembatan_lapuk", 0, 2, 7, [],
		"Jembatan kayu di atas parit gambut mulai rapuh dan berderit keras saat dipijak.",
		_make_choice("Topang pakai Tongkat", ["tongkat"], [], [], 5, 0, -8, 1.0,
			"Tongkat kayu membantumu menjaga keseimbangan hingga menyeberang dengan selamat."),
		_make_choice("Balut pegangan pakai Perban", ["perban_coklat"], [], ["perban_coklat"], 6, 5, -5, 0.5,
			"Perban melindungi tanganmu dari serpihan kayu tajam jembatan."),
		_make_choice("Seberangi terburu-buru tanpa alat", [], [], [], 15, -24, 22, -0.5,
			"Papan jembatan patah! Kakimu terperosok dan sebagian barang jatuh ke parit gambut!",
			2, [], 6, 10, -5)
	)
	
	# P9 (Hari 1-6): Posko Relawan
	_save_item_event(
		"evt_p9_posko_relawan", 0, 1, 6, [],
		"Kamu berpapasan dengan posko relawan kecil yang membagi logistik dan rute darurat bagi warga terdampak.",
		_make_choice("Tunjukkan Dokumen Warga", ["dokumen"], [], [], -18, 5, -12, 1.5,
			"Relawan memberimu ransum darurat dan menunjukkan jalur tercepat!"),
		_make_choice("Bagikan Mainan Anak", ["mainan_anak"], [], [], 5, 0, -20, 1.0,
			"Anak-anak pengungsi ceria bermain, suasanamu ikut tenang dan relawan memberi petunjuk jalan."),
		_make_choice("Lewat begitu saja tanpa melapor", [], [], [], 18, -6, 16, -0.5,
			"Kamu melewatkan bantuan logistik dan tersesat sebentar mencari arah.",
			0, [], 5, 5, 0)
	)
	
	# P10 (Hari 2-7): Sumur Keruh
	_save_item_event(
		"evt_p10_sumur_keruh", 0, 2, 7, [],
		"Menemukan sumur warga di pinggir jalan yang airnya keruh bercampur abu kebakaran.",
		_make_choice("Minum persediaan Air Mineral", ["air_mineral"], [], ["air_mineral"], -15, 12, -10, 0.0,
			"Kamu meminum air bersih dari tas tanpa mengambil risiko sakit perut."),
		_make_choice("Saring air pakai Masker", ["masker"], [], ["masker"], -10, 0, -6, -0.5,
			"Masker menyaring abu kasar sehingga air cukup aman untuk membasuh tenggorokan."),
		_make_choice("Minum air sumur keruh langsung", [], [], [], -5, -26, 20, -0.5,
			"Air berabu membuat perutmu mual hebat dan muntah-muntah sepanjang siang.",
			0, [], 5, 8, -4)
	)
	
	# P11 (Hari 1-7): Bayi Kepanasan
	_save_item_event(
		"evt_p11_bayi_kepanasan", 0, 1, 7, ["bayi"],
		"Terik matahari bercampur hawa panas kebakaran membuat bayimu dehidrasi dan menangis keras tanpa henti.",
		_make_choice("Beri Botol Susu", ["botol_susu"], ["bayi"], ["botol_susu"], 4, 8, -24, 0.0,
			"Bayimu minum dengan lahap dan kembali tertidur pulas di gendongan."),
		_make_choice("Teduhi memakai Payung", ["payung"], ["bayi"], [], 6, 4, -14, -0.5,
			"Payung menghalau sengatan matahari langsung sehingga bayimu lebih nyaman."),
		_make_choice("Terus berjalan tanpa pelindung", [], [], [], 18, -14, 28, -0.5,
			"Tangisan bayi yang kepanasan membuatmu panik dan kelelahan luar biasa.",
			0, [], 6, 10, -4)
	)
	
	# P12 (Hari 3-7): Warga Terjebak Dahan Terbakar
	_save_yesno_event(
		"evt_p12_warga_terjebak", 0, 3, 7, [],
		"Seorang lansia terjebak dahan pohon terbakar yang tumbang melintang di jalan setapak.",
		_make_choice("Bantu angkat dahan bersama", [], [], [], 22, -15, -10, -0.5,
			"Tenagamu terkuras mengangkat dahan berat dan barangmu tersangkut ranting terbakar!",
			1, [], 8, 6, -5),
		_make_choice("Segera menghindar lewat pinggir", [], [], [], 12, -5, 26, 0.5,
			"Kamu terus melangkah cepat, namun rasa bersalah terus menghantui pikiranmu.",
			0, [], 4, 6, 0)
	)
	
	# P13 (Hari 4-7): Truk Logistik & Rombongan Panik
	_save_yesno_event(
		"evt_p13_truk_logistik", 0, 4, 7, [],
		"Truk bak terbuka melintas cepat menuju arah kota dengan bak penuh pengungsi panik dan asap knalpot pekat.",
		_make_choice("Kejar & naik paksa ke bak truk", [], [], [], 18, -22, 20, 2.0,
			"Desak-desakan di bak truk menyiksa tubuhmu dan membuat barangmu terjatuh ke jalan!",
			2, [], 8, 10, -6),
		_make_choice("Tetap berjalan kaki di jalur aman", [], [], [], 16, -5, 8, 0.0,
			"Kamu memilih berjalan kaki dengan ritme stabil demi keamanan bayi.",
			0, [], 6, 6, 0)
	)
	
	# P14 (Hari 2-7): Parit Lumpur Gambut Panas [BARU]
	_save_item_event(
		"evt_p14_parit_lumpur", 0, 2, 7, [],
		"Jalan utama terputus kubangan lumpur gambut hangat yang dalam dan berbau belerang menyengat.",
		_make_choice("Ukur kedalaman pakai Tongkat", ["tongkat"], [], [], 6, 0, -8, 1.0,
			"Tongkat membantumu menemukan pijakan keras di tepi kubangan tanpa terperosok."),
		_make_choice("Bilas kaki & tangan pakai Air Mineral", ["air_mineral"], [], ["air_mineral"], 4, 8, -10, 0.5,
			"Kamu menyeberang hati-hati lalu membilas lumpur panas agar kulit tidak melepuh."),
		_make_choice("Menerjang lumpur tanpa alat bantu", [], [], [], 16, -20, 22, -0.5,
			"Kakimu terhisap lumpur panas! Saat menarik diri, satu barang terlepas dari tas.",
			1, [], 8, 10, -5)
	)
	
	# P15 (Hari 2-7): Bayi Ruam Panas & Debu Bara [BARU]
	_save_item_event(
		"evt_p15_bayi_ruam", 0, 2, 7, ["bayi"],
		"Keringat dan debu abu halus membuat kulit leher bayimu memerah iritasi, membuatnya merintih kesakitan.",
		_make_choice("Kompres dengan Air Mineral", ["air_mineral"], ["bayi"], ["air_mineral"], 4, 10, -22, 0.0,
			"Air bersih membasuh debu abu di kulit bayimu hingga ia kembali nyaman."),
		_make_choice("Alasi gendongan pakai Jaket", ["jaket"], ["bayi"], [], 6, 4, -14, -0.5,
			"Lapisan kain jaket melindungi kulit bayi dari gesekan kain kasar dan abu."),
		_make_choice("Biarkan iritasi & terus berjalan", [], [], [], 16, -15, 26, -0.5,
			"Bayi terus merintih kesakitan membuat konsentrasimu pecah dan tenaga terkuras.",
			0, [], 6, 8, -4)
	)
	
	# P16 (Hari 3-7): Reruntuhan Seng & Kayu Berpaku [BARU]
	_save_item_event(
		"evt_p16_barikade_seng", 0, 3, 7, [],
		"Puing atap seng berkarat dan balok kayu terbakar runtuh menutup gang sempit satu-satunya.",
		_make_choice("Ungkit puing memakai Tongkat", ["tongkat"], [], [], 8, -4, -8, 1.0,
			"Tongkat kayu cukup kuat menggeser seng panas sehingga kamu bisa melintas aman."),
		_make_choice("Lilit tangan pakai Perban Coklat", ["perban_coklat"], [], ["perban_coklat"], 10, 0, -6, 0.5,
			"Lapisan perban melindungi telapak tanganmu saat mengangkat seng tajam."),
		_make_choice("Singkirkan puing dengan tangan kosong", [], [], [], 16, -26, 22, -0.5,
			"Seng tajam menyayat lenganmu dan membuatmu menjatuhkan barang saat menghindar!",
			1, [], 6, 10, -5)
	)
	
	# P17 (Hari 2-6): Tenda Medis Darurat Kekurangan Stok [BARU]
	_save_item_event(
		"evt_p17_pos_kesehatan", 0, 2, 6, [],
		"Petugas medis lapangan kewalahan merawat korban luka bakar ringan dan memohon bantuan logistik medis.",
		_make_choice("Sumbangkan Obat-obatan", ["obat_obatan"], [], ["obat_obatan"], -10, 5, -20, 1.5,
			"Petugas sangat berterima kasih, memberimu makanan hangat dan peta jalur pintas aman!"),
		_make_choice("Berikan Perban Coklat", ["perban_coklat"], [], ["perban_coklat"], -5, 5, -14, 1.0,
			"Petugas membalas bantuanmu dengan petunjuk arah bebas asap sejauh 1 km."),
		_make_choice("Tolak & simpan untuk diri sendiri", [], [], [], 14, -5, 20, 0.0,
			"Kamu berjalan pergi di tengah tatapan putus asa para korban yang terluka.",
			0, [], 4, 6, 0)
	)
	
	# P18 (Hari 4-7): Pusaran Angin Pembawa Bara Api [BARU]
	_save_yesno_event(
		"evt_p18_angin_puting_bara", 0, 4, 7, [],
		"Angin kencang membentuk pusaran api dan hujan bara menyapu jalanan di depanmu secara tiba-tiba!",
		_make_choice("Lari menyamping menerjang hujan bara", [], [], [], 20, -26, 26, 1.5,
			"Bara api membakar punggungmu dan beberapa barang terjatuh saat kamu berlari membabi buta!",
			2, [], 10, 12, -6),
		_make_choice("Tiarap berlindung di parit kering", [], [], [], 16, -16, 22, -1.0,
			"Kamu selamat dari pusaran bara, namun asap pekat mencekik dan satu barang tertinggal.",
			1, [], 6, 8, -4)
	)
	
	# =========================================================================
	# 18 EVENT SESI MALAM (session = 1) — 3–5 KONSEKUENSI & PENALTI BEBAN
	# =========================================================================
	
	# M1 (Hari 1-7): Bayi Lapar Malam
	_save_item_event(
		"evt_m1_bayi_lapar", 1, 1, 7, ["bayi"],
		"Di tengah malam yang sunyi dan berbau asap, bayimu menangis kencang karena kelaparan.",
		_make_choice("Beri Botol Susu", ["botol_susu"], ["bayi"], ["botol_susu"], 4, 8, -26, 0.0,
			"Bayimu langsung tenang setelah minum susu dan tidur nyenyak hingga pagi."),
		null,
		_make_choice("Timang & tenangkan semalaman", [], [], [], 22, -12, 28, 0.0,
			"Kamu begadang penuh kepanikan menenangkan tangisan bayi tanpa susu.",
			0, [], 6, 8, -4)
	)
	
	# M2 (Hari 1-7): Bayi Rewel Ketakutan
	_save_item_event(
		"evt_m2_bayi_rewel", 1, 1, 7, ["bayi"],
		"Gemuruh pohon tumbang dan cahaya merah di kejauhan membuat bayimu ketakutan dan terus menjerit gelisah.",
		_make_choice("Hibur dengan Mainan Anak", ["mainan_anak"], ["bayi"], [], 4, 0, -20, 0.0,
			"Mainan anak mengalihkan perhatian bayimu hingga ia kembali tenang."),
		null,
		_make_choice("Bujuk perlahan tanpa alat", [], [], [], 18, -8, 28, 0.0,
			"Bayi terus menjerit ketakutan sepanjang malam hingga mental dan fisikmu terkuras.",
			0, [], 5, 8, -3)
	)
	
	# M3 (Hari 3-7): Perampas Malam
	_save_item_event(
		"evt_m3_pencuri_malam", 1, 3, 7, [],
		"Saat beristirahat di teras bangunan kosong, dua orang mengendap mendekat mencoba merampas tas perbekalanmu!",
		_make_choice("Halau dengan Tongkat", ["tongkat"], [], [], 8, -5, -10, 0.5,
			"Ayunan tongkatmu membuat para perampas itu mundur dan kabur ketakutan!"),
		null,
		_make_choice("Bertahan dengan tangan kosong", [], [], [], 18, -26, 28, -0.5,
			"Kamu babak belur dipukuli dan mereka berhasil merampas sebagian isi tasmu!",
			2, [], 6, 10, -5)
	)
	
	# M4 (Hari 1-7): Jalan Malam Gelap
	_save_item_event(
		"evt_m4_jalan_malam", 1, 1, 7, [],
		"Jalur evakuasi malam ini gelap gulita tertutup kabut asap. Dengan penerangan yang cukup, kamu bisa menyicil jarak tempuh malam ini.",
		_make_choice("Nyalakan Senter + Baterai", ["senter", "baterai"], [], ["baterai"], 12, 0, -12, 1.5,
			"Sinar senter menembus kabut asap, membantumu melangkah jauh di malam hari!"),
		null,
		_make_choice("Berhenti total dalam gelap", [], [], [], 16, -6, 22, 0.0,
			"Terjebak dalam gelap total membuat rasa cemasmu melonjak tajam.",
			0, [], 5, 6, 0)
	)
	
	# M5 (Hari 1-7): Udara Dingin Ekstrem
	_save_item_event(
		"evt_m5_udara_dingin", 1, 1, 7, [],
		"Angin malam bertiup kencang membawa hawa dingin ekstrem setelah seharian berkeringat.",
		_make_choice("Kenakan Jaket", ["jaket"], [], [], 4, 10, -12, 0.0,
			"Jaket tebal menjaga suhu tubuhmu tetap hangat dan mencegah hipotermia."),
		null,
		_make_choice("Tidur menggigil menahan dingin", [], [], [], 18, -24, 22, -0.5,
			"Hawa dingin menusuk tulang membuatmu demam dan menggigil hingga subuh.",
			0, [], 6, 8, -4)
	)
	
	# M6 (Hari 2-7): Demam Tinggi
	_save_item_event(
		"evt_m6_sakit_demam", 1, 2, 7, [],
		"Kelelahan fisik dan paparan asap membuat suhu tubuhmu naik tinggi. Kepalamu terasa berputar hebat.",
		_make_choice("Minum Obat-obatan", ["obat_obatan"], [], ["obat_obatan"], 5, 30, -12, 0.0,
			"Obat-obatan meredakan demammu sehingga tubuh kembali bugar saat bangun."),
		null,
		_make_choice("Paksakan tidur menahan demam", [], [], [], 18, -28, 18, -1.0,
			"Demam tinggi menguras daya tahan tubuhmu dan melumpuhkan langkah esok hari.",
			0, [], 6, 8, -5)
	)
	
	# M7 (Hari 3-7): Cahaya Sirine di Kejauhan
	_save_yesno_event(
		"evt_m7_cahaya_sirine", 1, 3, 7, [],
		"Dari atas bukit terlihat sorot lampu sirine pos pengungsian di kejauhan. Kamu bisa memaksakan diri berlari menuruni bukit malam ini.",
		_make_choice("Paksakan jalan terus malam ini", [], [], [], 25, -22, 18, 2.0,
			"Kaki terasa mati rasa dan satu barang jatuh saat menuruni bukit gelap, namun pos makin dekat!",
			1, [], 10, 10, -6),
		_make_choice("Istirahat penuh pulihkan tenaga", [], [], [], 12, 12, -12, 0.0,
			"Tidur nyenyak memulihkan kondisi fisik dan mentalmu untuk esok pagi.",
			0, [], 4, 4, 0)
	)
	
	# M8 (Hari 3-7): Gardu Listrik Konslet
	_save_item_event(
		"evt_m8_gardu_konslet", 1, 3, 7, [],
		"Kabel listrik tiang yang terbakar putus menjuntai dan memercikkan api di tengah jalan gelap.",
		_make_choice("Singkirkan kabel pakai Tongkat", ["tongkat"], [], [], 6, -4, -8, 1.0,
			"Tongkat kayu kering menggeser kabel dengan aman tanpa setruman."),
		_make_choice("Terangi jalur memutar pakai Senter", ["senter", "baterai"], [], ["baterai"], 12, 0, -10, 1.0,
			"Cahaya senter memandumu melewati jalur memutar tanpa menyentuh kabel."),
		_make_choice("Menerobos dalam gelap gulita", [], [], [], 14, -28, 26, -0.5,
			"Percikan listrik menyengat bahumu hingga terpental dan menjatuhkan barang!",
			1, [], 6, 10, -5)
	)
	
	# M9 (Hari 2-7): Badai Gerimis Abu Malam
	_save_item_event(
		"evt_m9_gerimis_malam", 1, 2, 7, [],
		"Hujan abu bercampur gerimis dingin turun deras disertai angin kencang saat kalian berteduh di emperan ruko terbuka.",
		_make_choice("Kenakan Jaket Tebal", ["jaket"], [], [], 5, 10, -12, 0.0,
			"Jaket melindungimu dari angin basah sehingga tidurmu tetap nyenyak."),
		_make_choice("Bentangkan Payung penahan angin", ["payung"], [], [], 6, 4, -10, 0.0,
			"Payung menahan tampias air dingin, meski rangkanya nyaris patah diterjang angin."),
		_make_choice("Kedinginan basah kuyup hingga subuh", [], [], [], 20, -24, 24, -0.5,
			"Baju basah membuatmu kedinginan hebat sepanjang malam.",
			0, [], 6, 8, -4)
	)
	
	# M10 (Hari 2-7): Luka Infeksi
	_save_item_event(
		"evt_m10_luka_infeksi", 1, 2, 7, [],
		"Luka gores di kakimu mulai berdenyut perih dan membengkak panas setelah seharian berjalan.",
		_make_choice("Konsumsi Obat-obatan", ["obat_obatan"], [], ["obat_obatan"], 4, 30, -10, 0.0,
			"Obat meredakan peradangan dengan cepat sehingga kakimu kembali ringan."),
		_make_choice("Bersihkan & balut Perban Coklat", ["perban_coklat"], [], ["perban_coklat"], 4, 18, -5, 0.5,
			"Perban melindungi luka dari debu asap dan mengurangi rasa nyeri."),
		_make_choice("Biarkan luka tanpa perawatan", [], [], [], 14, -26, 20, -0.5,
			"Infeksi menyebar membuat kakimu bengkak dan demam ringan.",
			0, [], 6, 8, -4)
	)
	
	# M11 (Hari 2-7): Ronda Warga
	_save_item_event(
		"evt_m11_ronda_warga", 1, 2, 7, [],
		"Warga yang berjaga malam menghadang dengan pentungan karena mencurigai pendatang asing di kampung mereka.",
		_make_choice("Tunjukkan Dokumen Identitas", ["dokumen"], [], [], 4, 0, -12, 1.5,
			"Warga percaya dan mengantarmu melewati jalan pintas kampung!"),
		_make_choice("Bagikan Biskuit sebagai itikad baik", ["biskuit"], [], ["biskuit"], 4, 0, -10, 1.0,
			"Warga melunak dan mempersilakanmu melintas dengan aman."),
		_make_choice("Diusir memutar keluar kampung", [], [], [], 22, -12, 24, -1.0,
			"Kamu terpaksa berlari memutar jauh di tengah malam dan menjatuhkan barang saat dikejar.",
			1, [], 8, 8, -4)
	)
	
	# M12 (Hari 1-7): Bayi Gelisah Sirine
	_save_item_event(
		"evt_m12_bayi_gelisah", 1, 1, 7, ["bayi"],
		"Suara sirine pemadam dan bau asap menyengat membuat bayimu terbangun dan menangis histeris.",
		_make_choice("Tenangkan dengan Botol Susu", ["botol_susu"], ["bayi"], ["botol_susu"], 4, 6, -24, 0.0,
			"Botol susu langsung meredakan tangis bayimu dalam hitungan menit."),
		_make_choice("Alihkan perhatian pakai Mainan Anak", ["mainan_anak"], ["bayi"], [], 4, 0, -18, 0.0,
			"Mainan anak membuat bayimu kembali tenang hingga tertidur."),
		_make_choice("Begadang menimang hingga kelelahan", [], [], [], 22, -12, 28, 0.0,
			"Kamu tidak tidur sama sekali dan kehabisan energi menghadapi esok hari.",
			0, [], 6, 8, -4)
	)
	
	# M13 (Hari 4-7): Kepungan Api Mendekat
	_save_yesno_event(
		"evt_m13_api_mendekat", 1, 4, 7, [],
		"Cahaya jingga kobaran api mengepung bukit di belakangmu disertai hujan bara dan angin panas!",
		_make_choice("Kemasi seadanya & lari menerobos bara", [], [], [], 24, -22, 24, 2.0,
			"Kamu berlari sekuat tenaga menjauhi kobaran api hingga beberapa barang terlepas dari tas!",
			2, [], 10, 12, -6),
		_make_choice("Bertahan di dalam bangunan tembok", [], [], [], 16, -20, 22, -0.5,
			"Asap masuk melalui celah ventilasi membuat dadamu sesak hingga pagi.",
			0, [], 6, 8, -4)
	)
	
	# M14 (Hari 2-7): Kawanan Anjing Liar Kelaparan [BARU]
	_save_item_event(
		"evt_m14_anjing_liar", 1, 2, 7, [],
		"Sekawanan anjing liar yang panik akibat kebakaran hutan menggeram mengepung tempatmu beristirahat.",
		_make_choice("Pukul tanah & halau pakai Tongkat", ["tongkat"], [], [], 8, -4, -10, 0.5,
			"Hentakan tongkat membuat kawanan anjing itu mundur perlahan ke dalam gelap."),
		_make_choice("Lemparkan Biskuit untuk mengalihkan", ["biskuit"], [], ["biskuit"], 6, 0, -12, 0.5,
			"Anjing-anjing itu berebut biskuit sementara kamu menyelinap pergi dengan tenang."),
		_make_choice("Bertahan tanpa alat & lari mundur", [], [], [], 18, -24, 26, -0.5,
			"Seekor anjing menggigit betismu dan merobek sisi tas hingga satu barang jatuh!",
			1, [], 6, 10, -5)
	)
	
	# M15 (Hari 3-7): Titian Bambu Licin di Atas Sungai Gelap [BARU]
	_save_item_event(
		"evt_m15_jembatan_darurat_malam", 1, 3, 7, [],
		"Satu-satunya jalur menuju desa seberang adalah titian bambu basah dan licin di atas aliran sungai gelap.",
		_make_choice("Sorot pijakan pakai Senter + Baterai", ["senter", "baterai"], [], ["baterai"], 10, 0, -10, 1.5,
			"Cahaya senter memperlihatkan ruas bambu yang retak sehingga kamu melintas aman."),
		_make_choice("Raba pijakan memakai Tongkat", ["tongkat"], [], [], 10, -4, -6, 1.0,
			"Tongkat membantumu menjaga titik berat badan hingga sampai ke seberang."),
		_make_choice("Menyeberang meraba-raba dalam gelap", [], [], [], 16, -20, 26, -1.0,
			"Kamu terpeleset hebat di tengah titian! Dua barang jatuh tenggelam ke sungai!",
			2, [], 8, 10, -5)
	)
	
	# M16 (Hari 3-7): Barak Pengungsi Sementara Penuh Sesak [BARU]
	_save_item_event(
		"evt_m16_tenda_pengungsi_penuh", 1, 3, 7, [],
		"Kamu menemukan barak darurat penuh sesak warga panik yang saling berebut tempat tidur dan logistik.",
		_make_choice("Daftar resmi pakai Dokumen", ["dokumen"], [], [], -10, 8, -14, 0.5,
			"Petugas mencatat namamu dan memberi sudut aman beserta jatah makan malam."),
		_make_choice("Bagikan Air Mineral agar diberi ruang", ["air_mineral"], [], ["air_mineral"], 6, 4, -10, 0.0,
			"Warga sekitar melunak dan memberimu ruang kecil untuk merebahkan badan."),
		_make_choice("Tidur berdesakan tanpa pengawasan", [], [], [], 16, -12, 24, 0.0,
			"Saat terlelap kelelahan, seseorang mengutil sebagian isi tasmu di tengah keramaian!",
			1, [], 6, 8, 0)
	)
	
	# M17 (Hari 1-7): Kabut Asap Rendah di Lembah [BARU]
	_save_item_event(
		"evt_m17_sesak_asap_malam", 1, 1, 7, [],
		"Suhu malam yang turun menekan kabut asap pekat mengendap rendah tepat di tempatmu bermalam.",
		_make_choice("Tidur memakai Masker", ["masker"], [], ["masker"], 6, 4, -12, 0.0,
			"Masker menjaga pernapasanmu tetap lega hingga fajar menyingsing."),
		_make_choice("Basahi kain pakai Air Mineral", ["air_mineral"], [], ["air_mineral"], 6, 0, -10, 0.0,
			"Kain basah menyaring partikel asap kasar meski udara tetap terasa pengap."),
		_make_choice("Tidur tanpa pelindung pernapasan", [], [], [], 16, -24, 22, -0.5,
			"Kamu terbangun berkali-kali karena sesak napas dan tenggorokan kering.",
			0, [], 6, 8, -4)
	)
	
	# M18 (Hari 3-7): Simpang Jalan Tanpa Rambu di Tengah Malam [BARU]
	_save_item_event(
		"evt_m18_persimpangan_gelap", 1, 3, 7, [],
		"Jalur bercabang tiga di tengah hutan yang hangus terbakar. Papan penunjuk arah sudah hangus menjadi arang.",
		_make_choice("Cari jejak ban pakai Senter + Baterai", ["senter", "baterai"], [], ["baterai"], 12, 0, -12, 2.0,
			"Sorot senter menemukan jejak ban truk evakuasi menuju jalan pintas utama!"),
		_make_choice("Susuri pinggir parit pakai Tongkat", ["tongkat"], [], [], 10, -4, -6, 1.0,
			"Tongkat memandumu menyusuri tepian parit hingga menemukan jalan desa yang benar."),
		_make_choice("Tebak arah & berjalan dalam gelap", [], [], [], 20, -16, 26, -1.5,
			"Kamu tersesat jauh ke jalur buntu dan terperosok semak hingga menjatuhkan barang!",
			1, [], 8, 10, -4)
	)
	
	EditorInterface.get_resource_filesystem().scan()
	print("SUKSES: 36 Event Karhutla (18 Pagi + 18 Malam) berhasil diperbarui di ", OUTPUT_DIR)


func _make_choice(
	text: String,
	req_items: Array[String],
	req_comps: Array[String],
	cons_items: Array[String],
	d_hunger: int,
	d_health: int,
	d_stress: int,
	d_travel: float,
	outcome: String,
	rand_lost: int = 0,
	spec_lost: Array[String] = [],
	heavy_hunger: int = 0,
	heavy_stress: int = 0,
	heavy_health: int = 0
) -> EventChoice:
	var c := EventChoice.new()
	c.choice_text = text
	c.required_items = req_items
	c.required_companions = req_comps
	c.consumed_items = cons_items
	c.hunger_change = d_hunger
	c.health_change = d_health
	c.stress_change = d_stress
	c.travel_change = d_travel
	c.random_items_lost = rand_lost
	c.specific_items_lost = spec_lost
	c.heavy_load_extra_hunger = heavy_hunger
	c.heavy_load_extra_stress = heavy_stress
	c.heavy_load_extra_health = heavy_health
	c.outcome_text = outcome
	return c


func _save_item_event(
	id: String,
	session_idx: int,
	min_d: int,
	max_d: int,
	req_comps: Array[String],
	story: String,
	choice1: EventChoice,
	choice2: EventChoice,
	ignore_c: EventChoice
) -> void:
	var ev := EventData.new()
	ev.event_id = id
	ev.allowed_session = session_idx as EventData.SessionType
	ev.min_day = min_d
	ev.max_day = max_d
	ev.event_type = EventData.EventType.ITEM_CHOICE
	ev.required_companions = req_comps
	ev.story_text = story
	ev.item_choice_1 = choice1
	ev.item_choice_2 = choice2
	ev.ignore_choice = ignore_c
	ResourceSaver.save(ev, OUTPUT_DIR + id + ".tres")


func _save_yesno_event(
	id: String,
	session_idx: int,
	min_d: int,
	max_d: int,
	req_comps: Array[String],
	story: String,
	yes_c: EventChoice,
	no_c: EventChoice
) -> void:
	var ev := EventData.new()
	ev.event_id = id
	ev.allowed_session = session_idx as EventData.SessionType
	ev.min_day = min_d
	ev.max_day = max_d
	ev.event_type = EventData.EventType.YES_NO
	ev.required_companions = req_comps
	ev.story_text = story
	ev.yes_choice = yes_c
	ev.no_choice = no_c
	ResourceSaver.save(ev, OUTPUT_DIR + id + ".tres")
