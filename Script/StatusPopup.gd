extends Control

@export_group("Aset Ekspresi Wajah")
@export var tex_normal: Texture2D
@export var tex_lapar: Texture2D
@export var tex_stress: Texture2D
@export var tex_kritis: Texture2D

@onready var face_rect: TextureRect = $StatusPanel/FaceTextureRect
@onready var health_label: Label = get_node_or_null("StatusPanel/HealthLabel")
@onready var hunger_label: Label = get_node_or_null("StatusPanel/HungerLabel")
@onready var stress_label: Label = get_node_or_null("StatusPanel/StressLabel")
@onready var companion_label: Label = get_node_or_null("StatusPanel/CompanionLabel")
@onready var close_btn: Button = $StatusPanel/CloseButton

const INDIKATOR_DIR := "res://Assets/UI/Indikator/"


func _ready() -> void:
	hide()
	_load_default_faces()
	
	close_btn.pressed.connect(close_popup)
	GameState.stats_updated.connect(_refresh_display)


func _load_default_faces() -> void:
	if tex_normal == null and ResourceLoader.exists(INDIKATOR_DIR + "face_normal.png"):
		tex_normal = load(INDIKATOR_DIR + "face_normal.png")
	if tex_lapar == null and ResourceLoader.exists(INDIKATOR_DIR + "face_lapar.png"):
		tex_lapar = load(INDIKATOR_DIR + "face_lapar.png")
	if tex_stress == null and ResourceLoader.exists(INDIKATOR_DIR + "face_stress.png"):
		tex_stress = load(INDIKATOR_DIR + "face_stress.png")
	if tex_kritis == null and ResourceLoader.exists(INDIKATOR_DIR + "face_kritis.png"):
		tex_kritis = load(INDIKATOR_DIR + "face_kritis.png")


func open_popup() -> void:
	_refresh_display()
	show()


func close_popup() -> void:
	hide()


func _refresh_display() -> void:
	var hp: int = GameState.health
	var hgr: int = GameState.hunger
	var str_val: int = GameState.stress
	
	if health_label != null:
		health_label.text = "Kesehatan: %d / 100" % hp
	if hunger_label != null:
		hunger_label.text = "Kelaparan: %d / 100" % hgr
	if stress_label != null:
		stress_label.text = "Stres: %d / 100" % str_val
	if companion_label != null:
		var has_baby: bool = GameState.companions.get("bayi", false)
		companion_label.text = "Pendamping: Bayi" if has_baby else "Pendamping: Tidak ada"
		
	# Pemetaan wajah sesuai kondisi spesifik:
	# - face_kritis: Kesehatan rendah (<= 40)
	# - face_lapar: Kelaparan tinggi (>= 60)
	# - face_stress: Stres tinggi (>= 60)
	var chosen_face: Texture2D = tex_normal
	
	if hp <= 40:
		chosen_face = tex_kritis if tex_kritis != null else tex_normal
	elif hgr >= 60 or str_val >= 60:
		if hgr >= str_val:
			chosen_face = tex_lapar if tex_lapar != null else tex_normal
		else:
			chosen_face = tex_stress if tex_stress != null else tex_normal
			
	if chosen_face != null:
		face_rect.texture = chosen_face
