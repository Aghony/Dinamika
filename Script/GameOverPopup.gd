extends Control

@onready var game_over_panel: Control = $DimmerBackground/GameOverPanel
@onready var title_label: Label = $DimmerBackground/GameOverPanel/TitleLabel
@onready var reason_label: Label = $DimmerBackground/GameOverPanel/ReasonLabel
@onready var summary_label: Label = $DimmerBackground/GameOverPanel/SummaryLabel
@onready var restart_btn: Button = $DimmerBackground/GameOverPanel/RestartButton
@onready var menu_btn: Button = $DimmerBackground/GameOverPanel/MainMenuButton

var open_tween: Tween = null


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
	_play_open_animation()


func _play_open_animation() -> void:
	if open_tween != null and open_tween.is_valid():
		open_tween.kill()
	show()
	if game_over_panel == null:
		return
	await get_tree().process_frame
	game_over_panel.pivot_offset = game_over_panel.size * 0.5
	game_over_panel.scale = Vector2(0.90, 0.90)
	game_over_panel.modulate.a = 0.0
	open_tween = create_tween().set_parallel(true)
	open_tween.tween_property(game_over_panel, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(game_over_panel, "modulate:a", 1.0, 0.20)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Mainmenu.tscn")
