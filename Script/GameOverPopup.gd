extends Control

@onready var title_label: Label = $DimmerBackground/GameOverPanel/TitleLabel
@onready var reason_label: Label = $DimmerBackground/GameOverPanel/ReasonLabel
@onready var summary_label: Label = $DimmerBackground/GameOverPanel/SummaryLabel
@onready var restart_btn: Button = $DimmerBackground/GameOverPanel/RestartButton
@onready var menu_btn: Button = $DimmerBackground/GameOverPanel/MainMenuButton


func _ready() -> void:
	hide()
	restart_btn.pressed.connect(_on_restart_pressed)
	menu_btn.pressed.connect(_on_menu_pressed)


func show_ending(is_win: bool, message_text: String) -> void:
	title_label.text = "SELAMAT! TIBA DI PENGUNGSIAN" if is_win else "GAGAL EVAKUASI"
	reason_label.text = message_text
	summary_label.text = "Hari ke-%d | Jarak Tempuh: %.1f / %.1f poin" % [
		GameState.current_round,
		GameState.travel_points,
		GameState.TARGET_TRAVEL_POINTS
	]
	show()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Mainmenu.tscn")
