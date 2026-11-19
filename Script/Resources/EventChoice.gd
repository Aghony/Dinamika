class_name EventChoice
extends Resource

@export var choice_text: String = ""
@export var required_items: Array[String] = []
@export var required_companions: Array[String] = []
@export var consumed_items: Array[String] = []

@export_group("Konsekuensi Status & Jarak")
@export var hunger_change: int = 0
@export var health_change: int = 0
@export var stress_change: int = 0
@export var travel_change: float = 0.0

@export_group("Pendamping & Barang Hilang")
@export var lost_companions: Array[String] = []
@export var gained_companions: Array[String] = []
## Jumlah slot item acak dari tas yang terjatuh/hilang akibat pilihan ini.
@export var random_items_lost: int = 0
## ID item spesifik yang hilang secara paksa (tidak menjadi syarat tombol aktif).
@export var specific_items_lost: Array[String] = []

@export_group("Penalti Ekstra Beban Berat (> 8.5 kg)")
@export var heavy_load_extra_hunger: int = 0
@export var heavy_load_extra_stress: int = 0
@export var heavy_load_extra_health: int = 0

@export_multiline var outcome_text: String = ""
