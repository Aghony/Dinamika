extends Control

@onready var reason_label: Label = $DimmerBackground/GameOverPanel/ReasonLabel
@onready var summary_label: Label = $DimmerBackground/GameOverPanel/SummaryLabel
@onready var restart_btn: Button = $DimmerBackground/GameOverPanel/RestartButton
@onready var menu_btn: Button = $DimmerBackground/GameOverPanel/MainMenuButton


func _ready() -> void:
	hide()
	restart_btn.pressed.connect(_on_restart_pressed)
	menu_btn.pressed.connect(_on_menu_pressed)


func show_game_over(reason_text: String) -> void:
	reason_label.text = reason_text
	summary_label.text = "Kamu bertahan selama %d ronde." % GameState.current_round
	show()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Mainmenu.tscn")
