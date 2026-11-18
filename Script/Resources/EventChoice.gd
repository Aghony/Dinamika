class_name EventChoice
extends Resource

@export var choice_text: String = ""

@export_group("Persyaratan Tombol")
@export var required_items: Array[String] = []       # Daftar ID item yang wajib ada di tas
@export var required_companions: Array[String] = []  # Contoh: ["anak_kecil"], ["bayi"]

@export_group("Konsekuensi Pilihan")
@export var consumed_items: Array[String] = []       # Daftar ID item yang berkurang 1 saat dipilih
@export var hunger_change: int = 0                   # Negatif (-) mengurangi lapar, Positif (+) menambah lapar
@export var health_change: int = 0                   # Positif (+) menyembuhkan, Negatif (-) melukai
@export var stress_change: int = 0                   # Negatif (-) menenangkan, Positif (+) menambah stres

@export_group("Perubahan Pendamping & Catatan")
@export var lost_companions: Array[String] = []      # Isi jika pilihan ini membuat pendamping hilang/terpisah
@export var gained_companions: Array[String] = []    # Isi jika mendapat pendamping baru
@export_multiline var outcome_text: String = ""      # Teks hasil yang muncul & dicatat ke Diary
