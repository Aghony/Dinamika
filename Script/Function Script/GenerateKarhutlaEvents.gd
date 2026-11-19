@tool
extends EditorScript

const OUTPUT_DIR := "res://Resources/Events/"


func _run() -> void:
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR)
	
	# =========================================================================
	# 13 EVENT SESI PAGI (session = 0) — KONSEKUENSI BERAT & IMPACTFUL
	# =========================================================================
	_save_item_event(
		"evt_p1_asap_pekat", 0, [],
		"Angin berbalik arah membawa dinding asap hitam karhutla menutupi jalan. Bayimu terbatuk hebat menghirup udara beracun.",
		_make_choice("Pakai Masker", ["masker"], [], ["masker"], 0, 0, -10, 0.5, "Masker menyaring asap beracun. Kalian terus melangkah tanpa terhambat."),
		null,
		_make_choice("Tahan napas menerobos asap", [], [], [], 10, -25, 25, -0.5, "Asap pekat membakar paru-paru dan membuat kepalamu pusing sepanjang pagi.")
	)
	
	_save_item_event(
		"evt_p2_hujan_abu", 0, [],
		"Langit memerah gelap, disusul hujan abu panas dan gerimis keruh yang membasahi kain gendongan bayimu.",
		_make_choice("Buka Payung", ["payung"], [], [], 0, 0, -10, 0.0, "Payung menahan hujan abu panas dan menjaga bayimu tetap kering."),
		null,
		_make_choice("Lari menerobos hujan abu", [], [], [], 12, -22, 20, 0.0, "Percikan abu panas dan air keruh membuat bahumu melepuh perih.")
	)
	
	_save_item_event(
		"evt_p3_pos_periksa", 0, [],
		"Petugas menjaga pos pemeriksaan menuju jalur evakuasi lintas cepat. Mereka meminta bukti identitas warga terdampak karhutla.",
		_make_choice("Tunjukkan Dokumen", ["dokumen"], [], [], 0, 0, -15, 2.5, "Dokumen lengkap! Petugas membukakan jalur pintas prioritas menuju pengungsian."),
		null,
		_make_choice("Memutar jauh lewat jalur desa", [], [], [], 22, 0, 15, -1.0, "Tanpa dokumen, kamu terpaksa memutar jauh menguras tenaga dan perbekalan.")
	)
	
	_save_item_event(
		"evt_p4_kehausan", 0, [],
		"Hawa panas dari hutan yang terbakar membuat udara kering kerontang. Tenggorokanmu terasa terbakar karena dehidrasi berat.",
		_make_choice("Minum Air Mineral", ["air_mineral"], [], ["air_mineral"], -15, 15, -12, 0.0, "Air mineral memulihkan cairan tubuh dan meringankan beban tas bawaanmu."),
		null,
		_make_choice("Hemat air & paksakan jalan", [], [], [], 25, -20, 15, 0.0, "Dehidrasi berat membuat langkah kakimu gontai di bawah terik matahari.")
	)
	
	_save_item_event(
		"evt_p5_kaki_pegal", 0, [],
		"Beban gendongan dan jalan berbatu membuat otot betismu kram parah. Setiap langkah terasa menyiksa.",
		_make_choice("Pasang Perban Coklat", ["perban_coklat"], [], ["perban_coklat"], 0, 10, 0, 1.5, "Perban coklat menopang otot kakimu sehingga langkah kembali mantap dan cepat."),
		null,
		_make_choice("Paksakan berjalan tertatih", [], [], [], 12, -20, 15, -1.0, "Kram otot memaksamu berjalan lambat menahan nyeri luar biasa.")
	)
	
	_save_item_event(
		"evt_p6_lapar_siang", 0, [],
		"Tenagamu terkuras habis di tengah terik siang. Pandanganmu mulai berkunang-kunang karena perut kosong.",
		_make_choice("Makan Biskuit", ["biskuit"], [], ["biskuit"], -35, 5, -10, 0.0, "Biskuit mengganjal rasa lapar dan mengembalikan tenagamu untuk menggendong bayi."),
		null,
		_make_choice("Tahan lapar hingga malam", [], [], [], 30, -10, 20, 0.0, "Perut melilit kelaparan membuat fokusmu buyar dan tubuh gemetar.")
	)
	
	_save_yesno_event(
		"evt_p7_jalur_gambut", 0, [],
		"Terlihat jalan pintas melewati lahan gambut kering yang mulai berasap tebal. Jarak ke pengungsian bisa terpangkas drastis.",
		_make_choice("Terobos jalan pintas gambut", [], [], [], 15, -24, 22, 2.5, "Hawa panas tanah gambut membakar kakimu, namun jarak tempuh maju pesat!"),
		_make_choice("Ambil jalan aspal yang aman", [], [], [], 10, 0, -5, 0.0, "Kamu memilih jalur aspal yang aman demi keselamatan bayimu.")
	)
	
	_save_item_event(
		"evt_p8_jembatan_lapuk", 0, [],
		"Jembatan kayu di atas parit gambut mulai rapuh dan berderit keras saat dipijak.",
		_make_choice("Topang pakai Tongkat", ["tongkat"], [], [], 0, 0, -10, 1.5, "Tongkat kayu membantumu menjaga keseimbangan hingga menyeberang dengan selamat."),
		_make_choice("Balut pegangan pakai Perban", ["perban_coklat"], [], ["perban_coklat"], 0, 8, -5, 1.0, "Perban melindungi tanganmu dari serpihan kayu tajam jembatan."),
		_make_choice("Seberangi terburu-buru tanpa alat", [], [], [], 12, -25, 20, -0.5, "Papan jembatan patah! Kakimu terperosok dan terluka cukup dalam.")
	)
	
	_save_item_event(
		"evt_p9_posko_relawan", 0, [],
		"Kamu berpapasan dengan posko relawan kecil yang membagi logistik dan rute darurat bagi warga terdampak.",
		_make_choice("Tunjukkan Dokumen Warga", ["dokumen"], [], [], -20, 5, -15, 1.5, "Relawan memberimu ransum darurat dan menunjukkan jalur tercepat!"),
		_make_choice("Bagikan Mainan Anak", ["mainan_anak"], [], [], 0, 0, -25, 1.0, "Anak-anak pengungsi ceria bermain, suasanamu ikut tenang dan relawan memberi petunjuk jalan."),
		_make_choice("Lewat begitu saja tanpa melapor", [], [], [], 18, 0, 15, 0.0, "Kamu melewatkan bantuan logistik dan harus menebak arah jalur sendiri.")
	)
	
	_save_item_event(
		"evt_p10_sumur_keruh", 0, [],
		"Menemukan sumur warga di pinggir jalan yang airnya keruh bercampur abu kebakaran.",
		_make_choice("Minum persediaan Air Mineral", ["air_mineral"], [], ["air_mineral"], -15, 15, -10, 0.0, "Kamu meminum air bersih dari tas tanpa mengambil risiko sakit perut."),
		_make_choice("Saring air pakai Masker", ["masker"], [], ["masker"], -10, 0, -8, 0.0, "Masker menyaring abu kasar sehingga air cukup aman untuk membasuh wajah dan tenggorokan."),
		_make_choice("Minum air sumur keruh langsung", [], [], [], -5, -28, 18, 0.0, "Air berabu membuat perutmu mual hebat dan tubuh lemas sepanjang siang.")
	)
	
	_save_item_event(
		"evt_p11_bayi_kepanasan", 0, ["bayi"],
		"Terik matahari bercampur hawa panas kebakaran membuat bayimu dehidrasi dan menangis keras tanpa henti.",
		_make_choice("Beri Botol Susu", ["botol_susu"], ["bayi"], ["botol_susu"], 0, 10, -28, 0.0, "Bayimu minum dengan lahap dan kembali tertidur pulas di gendongan."),
		_make_choice("Teduhi memakai Payung", ["payung"], ["bayi"], [], 0, 5, -18, 0.0, "Payung menghalau sengatan matahari langsung sehingga bayimu lebih nyaman."),
		_make_choice("Terus berjalan tanpa pelindung", [], [], [], 15, -12, 30, -0.5, "Tangisan bayi yang kepanasan membuatmu sangat panik dan kelelahan.")
	)
	
	_save_yesno_event(
		"evt_p12_warga_terjebak", 0, [],
		"Seorang lansia terjebak dahan pohon terbakar yang tumbang melintang di jalan setapak.",
		_make_choice("Bantu angkat dahan bersama", [], [], [], 20, -12, -15, -0.5, "Tenagamu terkuras mengangkat dahan berat, tetapi hati tenang berhasil menyelamatkan nyawa."),
		_make_choice("Segera menghindar lewat pinggir", [], [], [], 10, 0, 25, 0.5, "Kamu terus melangkah, namun rasa bersalah terus menghantui pikiranmu.")
	)
	
	_save_yesno_event(
		"evt_p13_truk_logistik", 0, [],
		"Truk bak terbuka melintas cepat menuju arah kota dengan bak penuh barang dan asap knalpot pekat.",
		_make_choice("Kejar & menumpang di bak truk", [], [], [], 15, -20, 18, 2.5, "Guncangan bak truk dan asap knalpot menyiksa tubuhmu, tapi jarak terpangkas jauh!"),
		_make_choice("Tetap berjalan kaki di jalur aman", [], [], [], 15, 0, -5, 0.0, "Kamu memilih berjalan kaki dengan ritme stabil demi keamanan bayi.")
	)
	
	# =========================================================================
	# 13 EVENT SESI MALAM (session = 1) — KONSEKUENSI BERAT & IMPACTFUL
	# =========================================================================
	_save_item_event(
		"evt_m1_bayi_lapar", 1, ["bayi"],
		"Di tengah malam yang sunyi dan berbau asap, bayimu menangis kencang karena kelaparan.",
		_make_choice("Beri Botol Susu", ["botol_susu"], ["bayi"], ["botol_susu"], 0, 10, -30, 0.0, "Bayimu langsung tenang setelah minum susu dan tidur nyenyak hingga pagi."),
		null,
		_make_choice("Timang & tenangkan semalaman", [], [], [], 20, -10, 30, 0.0, "Kamu begadang penuh kepanikan menenangkan tangisan bayi tanpa susu.")
	)
	
	_save_item_event(
		"evt_m2_bayi_rewel", 1, ["bayi"],
		"Gemuruh pohon tumbang dan cahaya merah di kejauhan membuat bayimu ketakutan dan terus menjerit gelisah.",
		_make_choice("Hibur dengan Mainan Anak", ["mainan_anak"], ["bayi"], [], 0, 0, -22, 0.0, "Mainan anak mengalihkan perhatian bayimu hingga ia kembali tenang."),
		null,
		_make_choice("Bujuk perlahan tanpa alat", [], [], [], 15, 0, 28, 0.0, "Bayi terus menjerit ketakutan sepanjang malam hingga mentalmu terkuras.")
	)
	
	_save_item_event(
		"evt_m3_pencuri_malam", 1, [],
		"Saat beristirahat di teras bangunan kosong, dua orang mengendap mendekat mencoba merampas tas perbekalanmu!",
		_make_choice("Halau dengan Tongkat", ["tongkat"], [], [], 0, 0, -15, 1.0, "Ayunan tongkatmu membuat para perampas itu mundur dan kabur ketakutan!"),
		null,
		_make_choice("Bertahan dengan tangan kosong", [], [], [], 15, -28, 28, 0.0, "Kamu berhasil mempertahankan tas, tetapi tubuhmu babak belur dipukuli.")
	)
	
	_save_item_event(
		"evt_m4_jalan_malam", 1, [],
		"Jalur evakuasi malam ini gelap gulita tertutup kabut asap. Dengan penerangan yang cukup, kamu bisa menyicil jarak tempuh malam ini.",
		_make_choice("Nyalakan Senter + Baterai", ["senter", "baterai"], [], ["baterai"], 10, 0, -15, 2.0, "Sinar senter menembus kabut asap, membantumu melangkah jauh di malam hari!"),
		null,
		_make_choice("Berhenti total dalam gelap", [], [], [], 15, 0, 20, 0.0, "Terjebak dalam gelap total membuat rasa cemasmu melonjak tajam.")
	)
	
	_save_item_event(
		"evt_m5_udara_dingin", 1, [],
		"Angin malam bertiup kencang membawa hawa dingin ekstrem setelah seharian berkeringat.",
		_make_choice("Kenakan Jaket", ["jaket"], [], [], 0, 12, -15, 0.0, "Jaket tebal menjaga suhu tubuhmu tetap hangat dan mencegah hipotermia."),
		null,
		_make_choice("Tidur menggigil menahan dingin", [], [], [], 15, -24, 20, 0.0, "Hawa dingin menusuk tulang membuatmu demam dan menggigil hingga subuh.")
	)
	
	_save_item_event(
		"evt_m6_sakit_demam", 1, [],
		"Kelelahan fisik dan paparan asap membuat suhu tubuhmu naik tinggi. Kepalamu terasa berputar hebat.",
		_make_choice("Minum Obat-obatan", ["obat_obatan"], [], ["obat_obatan"], 0, 35, -15, 0.0, "Obat-obatan meredakan demammu sehingga tubuh kembali bugar saat bangun."),
		null,
		_make_choice("Paksakan tidur menahan demam", [], [], [], 15, -28, 15, -1.0, "Demam tinggi menguras daya tahan tubuhmu dan melumpuhkan langkah esok hari.")
	)
	
	_save_yesno_event(
		"evt_m7_cahaya_sirine", 1, [],
		"Dari atas bukit terlihat sorot lampu sirine pos pengungsian di kejauhan. Kamu bisa memaksakan diri berlari malam ini.",
		_make_choice("Paksakan jalan terus malam ini", [], [], [], 25, -20, 15, 2.5, "Kaki terasa mati rasa dan perut keroncongan, namun pos pengungsian makin dekat!"),
		_make_choice("Istirahat penuh pulihkan tenaga", [], [], [], 10, 15, -15, 0.0, "Tidur nyenyak memulihkan kondisi fisik dan mentalmu untuk esok pagi.")
	)
	
	_save_item_event(
		"evt_m8_gardu_konslet", 1, [],
		"Kabel listrik tiang yang terbakar putus menjuntai dan memercikkan api di tengah jalan gelap.",
		_make_choice("Singkirkan kabel pakai Tongkat", ["tongkat"], [], [], 0, 0, -10, 1.5, "Tongkat kayu kering menggeser kabel dengan aman tanpa setruman."),
		_make_choice("Terangi jalur memutar pakai Senter", ["senter", "baterai"], [], ["baterai"], 10, 0, -12, 1.5, "Cahaya senter memandumu melewati jalur memutar tanpa menyentuh kabel."),
		_make_choice("Menerobos dalam gelap gulita", [], [], [], 10, -30, 25, 0.0, "Percikan listrik menyengat bahumu dan membuatmu terpental jatuh!")
	)
	
	_save_item_event(
		"evt_m9_gerimis_malam", 1, [],
		"Hujan abu bercampur gerimis dingin turun deras saat kalian berteduh di emperan ruko terbuka.",
		_make_choice("Kenakan Jaket Tebal", ["jaket"], [], [], 0, 12, -15, 0.0, "Jaket melindungimu dari angin basah sehingga tidurmu tetap nyenyak."),
		_make_choice("Bentangkan Payung penahan angin", ["payung"], [], [], 0, 5, -15, 0.0, "Payung menahan tampias air dingin agar tidak membasahi tubuh dan bayimu."),
		_make_choice("Kedinginan basah kuyup hingga subuh", [], [], [], 18, -24, 22, 0.0, "Baju basah membuatmu kedinginan hebat sepanjang malam.")
	)
	
	_save_item_event(
		"evt_m10_luka_infeksi", 1, [],
		"Luka gores di kakimu mulai berdenyut perih dan membengkak panas setelah seharian berjalan.",
		_make_choice("Konsumsi Obat-obatan", ["obat_obatan"], [], ["obat_obatan"], 0, 35, -10, 0.0, "Obat meredakan peradangan dengan cepat sehingga kakimu kembali ringan."),
		_make_choice("Bersihkan & balut Perban Coklat", ["perban_coklat"], [], ["perban_coklat"], 0, 20, -5, 0.5, "Perban melindungi luka dari debu asap dan mengurangi rasa nyeri."),
		_make_choice("Biarkan luka tanpa perawatan", [], [], [], 12, -26, 18, -0.5, "Infeksi menyebar membuat kakimu bengkak dan demam ringan.")
	)
	
	_save_item_event(
		"evt_m11_ronda_warga", 1, [],
		"Warga yang berjaga malam menghadang dengan pentungan karena mencurigai pendatang asing di kampung mereka.",
		_make_choice("Tunjukkan Dokumen Identitas", ["dokumen"], [], [], 0, 0, -15, 2.0, "Warga percaya dan mengantarmu melewati jalan pintas kampung!"),
		_make_choice("Bagikan Biskuit sebagai itikad baik", ["biskuit"], [], ["biskuit"], 0, 0, -12, 1.5, "Warga melunak dan mempersilakanmu melintas dengan aman."),
		_make_choice("Diusir memutar keluar kampung", [], [], [], 20, -10, 22, -1.0, "Kamu terpaksa berjalan memutar jauh di tengah malam dalam keadaan lapar.")
	)
	
	_save_item_event(
		"evt_m12_bayi_gelisah", 1, ["bayi"],
		"Suara sirine pemadam dan bau asap menyengat membuat bayimu terbangun dan menangis histeris.",
		_make_choice("Tenangkan dengan Botol Susu", ["botol_susu"], ["bayi"], ["botol_susu"], 0, 8, -28, 0.0, "Botol susu langsung meredakan tangis bayimu dalam hitungan menit."),
		_make_choice("Alihkan perhatian pakai Mainan Anak", ["mainan_anak"], ["bayi"], [], 0, 0, -20, 0.0, "Mainan anak membuat bayimu kembali tenang hingga tertidur."),
		_make_choice("Begadang menimang hingga kelelahan", [], [], [], 20, -10, 28, 0.0, "Kamu tidak tidur sama sekali dan kehabisan energi menghadapi esok hari.")
	)
	
	_save_yesno_event(
		"evt_m13_api_mendekat", 1, [],
		"Cahaya jingga kobaran api terlihat semakin dekat di balik bukit malam ini disertai hawa panas.",
		_make_choice("Kemasi tas & paksakan lari malam", [], [], [], 25, -18, 20, 2.5, "Kamu berlari sekuat tenaga menjauhi kobaran api dan mencetak jarak jauh!"),
		_make_choice("Bertahan di dalam bangunan tembok", [], [], [], 12, -15, 18, 0.0, "Asap masuk melalui celah ventilasi membuat dadamu sesak hingga pagi.")
	)
	
	EditorInterface.get_resource_filesystem().scan()
	print("SUKSES: 26 Event Karhutla (13 Pagi + 13 Malam) berhasil dibuat di ", OUTPUT_DIR)


func _make_choice(
	text: String,
	req_items: Array[String],
	req_comps: Array[String],
	cons_items: Array[String],
	d_hunger: int,
	d_health: int,
	d_stress: int,
	d_travel: float,
	outcome: String
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
	c.outcome_text = outcome
	return c


func _save_item_event(
	id: String,
	session_idx: int,
	req_comps: Array[String],
	story: String,
	choice1: EventChoice,
	choice2: EventChoice,
	ignore_c: EventChoice
) -> void:
	var ev := EventData.new()
	ev.event_id = id
	ev.allowed_session = session_idx as EventData.SessionType
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
	req_comps: Array[String],
	story: String,
	yes_c: EventChoice,
	no_c: EventChoice
) -> void:
	var ev := EventData.new()
	ev.event_id = id
	ev.allowed_session = session_idx as EventData.SessionType
	ev.event_type = EventData.EventType.YES_NO
	ev.required_companions = req_comps
	ev.story_text = story
	ev.yes_choice = yes_c
	ev.no_choice = no_c
	ResourceSaver.save(ev, OUTPUT_DIR + id + ".tres")
