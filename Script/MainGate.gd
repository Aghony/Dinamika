extends Control

@onready var round_label: Label = $RoundLabel
@onready var sun_icon: Control = $SunIcon
@onready var moon_icon: Control = $MoonIcon
@onready var diary_btn: Button = $DiaryButton
@onready var main_char_btn: Button = $MainCharButton
@onready var backpack_btn: Button = $BackpackButton
@onready var next_session_btn: Button = $NextSessionButton

@onready var event_popup: Control = $EventPopup
@onready var status_popup: Control = $StatusPopup
@onready var inventory_popup: Control = $InventoryPopup
@onready var diary_popup: Control = $DiaryPopup
@onready var game_over_popup: Control = $GameOverPopup


func _ready() -> void:
	GameState.reset_game()
	GameState.give_prototype_starting_items()
	
	GameState.phase_changed.connect(_on_phase_changed)
	GameState.game_over.connect(_on_game_over)
	
	next_session_btn.pressed.connect(_on_next_session_pressed)
	event_popup.popup_closed.connect(_on_event_popup_closed)
	
	main_char_btn.pressed.connect(status_popup.open_popup)
	backpack_btn.pressed.connect(inventory_popup.open_popup)
	diary_btn.pressed.connect(diary_popup.open_popup)
	
	_update_hud()
	_start_daily_intro_flow()


func _update_hud() -> void:
	round_label.text = "Ronde %d" % GameState.current_round
	
	if GameState.current_session == GameState.Session.PAGI:
		sun_icon.modulate.a = 1.0
		moon_icon.modulate.a = 0.3
	else:
		sun_icon.modulate.a = 0.3
		moon_icon.modulate.a = 1.0


func _start_daily_intro_flow() -> void:
	next_session_btn.disabled = true
	var intro_text := GameState.get_daily_intro_text()
	event_popup.show_daily_intro(GameState.current_round, intro_text)


func _start_event_flow() -> void:
	next_session_btn.disabled = true
	var session_event := GameState.get_random_event_for_current_session()
	event_popup.show_event(session_event)


func _on_event_popup_closed() -> void:
	next_session_btn.disabled = false


func _on_next_session_pressed() -> void:
	GameState.advance_session()


func _on_phase_changed(_round_num: int, _session: GameState.Session, phase: GameState.SessionPhase) -> void:
	_update_hud()
	if phase == GameState.SessionPhase.MORNING_INTRO:
		_start_daily_intro_flow()
	else:
		_start_event_flow()


func _on_game_over(reason: String) -> void:
	next_session_btn.disabled = true
	game_over_popup.show_game_over(reason)
