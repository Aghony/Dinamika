extends Control

@export_group("Aset Ekspresi Wajah")
@export var tex_normal: Texture2D
@export var tex_lapar: Texture2D
@export var tex_stress: Texture2D
@export var tex_kritis: Texture2D

@onready var status_panel: Control = $StatusPanel
@onready var face_rect: TextureRect = $StatusPanel/FaceTextureRect
@onready var health_label: Label = get_node_or_null("StatusPanel/HealthLabel")
@onready var hunger_label: Label = get_node_or_null("StatusPanel/HungerLabel")
@onready var stress_label: Label = get_node_or_null("StatusPanel/StressLabel")
@onready var companion_label: Label = get_node_or_null("StatusPanel/CompanionLabel")
@onready var close_btn: Button = $StatusPanel/CloseButton

const INDIKATOR_DIR := "res://Assets/UI/Indikator/"

var open_tween: Tween = null


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
	_play_open_animation()


func close_popup() -> void:
	if open_tween != null and open_tween.is_valid():
		open_tween.kill()
	hide()


func _play_open_animation() -> void:
	if open_tween != null and open_tween.is_valid():
		open_tween.kill()
	show()
	if status_panel == null:
		return
	await get_tree().process_frame
	status_panel.pivot_offset = status_panel.size * 0.5
	status_panel.scale = Vector2(0.92, 0.92)
	status_panel.modulate.a = 0.0
	open_tween = create_tween().set_parallel(true)
	open_tween.tween_property(status_panel, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(status_panel, "modulate:a", 1.0, 0.16)


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
