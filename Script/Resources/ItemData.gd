class_name ItemData
extends Resource

@export var id: String = ""                 # Contoh: "air_mineral" (huruf kecil, tanpa spasi)
@export var display_name: String = ""       # Contoh: "Air Mineral"
@export var icon: Texture2D                 # Gambar item untuk ditampilkan di pop-up tas
@export_multiline var description: String = ""
@export var is_consumable: bool = true      # True = habis dipakai, False = alat permanen
@export var weight: float = 0.5             # Berat per 1 unit barang (kg)
@export var max_stack: int = 1              # Batas maksimal jumlah bawaan per jenis item
