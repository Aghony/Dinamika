extends Control

@onready var health_label: Label = $StatusPanel/HealthLabel
@onready var hunger_label: Label = $StatusPanel/HungerLabel
@onready var stress_label: Label = $StatusPanel/StressLabel
@onready var companion_label: Label = $StatusPanel/CompanionLabel
@onready var close_btn: Button = $StatusPanel/CloseButton


func _ready() -> void:
	hide()
	close_btn.pressed.connect(hide)
	GameState.stats_updated.connect(_refresh_display)


func open_popup() -> void:
	_refresh_display()
	show()


func _refresh_display() -> void:
	health_label.text = "Kesehatan : %d / 100" % GameState.health
	hunger_label.text = "Lapar     : %d / 100" % GameState.hunger
	stress_label.text = "Stress    : %d / 100" % GameState.stress
	
	var status_anak := "Ada" if GameState.companions.get("anak_kecil", false) else "Tidak Ada"
	var status_bayi := "Ada" if GameState.companions.get("bayi", false) else "Tidak Ada"
	companion_label.text = "Pendamping: Anak Kecil (%s) | Bayi (%s)" % [status_anak, status_bayi]
