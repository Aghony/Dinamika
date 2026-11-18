extends Control

signal popup_closed

enum PopupMode { DAILY_INTRO, EVENT_ACTIVE, OUTCOME }

@onready var title_label: Label = $DimmerBackground/BookPanel/EventTitleLabel
@onready var story_label: RichTextLabel = $DimmerBackground/BookPanel/StoryTextLabel
@onready var yes_btn: Button = $DimmerBackground/BookPanel/YesButton
@onready var no_btn: Button = $DimmerBackground/BookPanel/NoButton
@onready var item_slot_1: TextureButton = $DimmerBackground/BookPanel/ItemSlotButton1
@onready var cross_1: Control = $DimmerBackground/BookPanel/ItemSlotButton1/CrossedOverlay
@onready var item_slot_2: TextureButton = $DimmerBackground/BookPanel/ItemSlotButton2
@onready var cross_2: Control = $DimmerBackground/BookPanel/ItemSlotButton2/CrossedOverlay
@onready var continue_btn: Button = $DimmerBackground/BookPanel/ContinueButton

var current_mode: PopupMode = PopupMode.DAILY_INTRO
var current_event: EventData = null
var selected_item_slot: int = 0
var slot_1_owned: bool = false
var slot_2_owned: bool = false


func _ready() -> void:
	hide()
	yes_btn.pressed.connect(_on_yes_pressed)
	no_btn.pressed.connect(_on_no_pressed)
	item_slot_1.pressed.connect(_on_item_slot_1_pressed)
	item_slot_2.pressed.connect(_on_item_slot_2_pressed)
	continue_btn.pressed.connect(_on_continue_pressed)


func _hide_all_controls() -> void:
	yes_btn.hide()
	no_btn.hide()
	item_slot_1.hide()
	item_slot_2.hide()
	continue_btn.hide()


# 1. TAMPILKAN NARASI PEMBUKA AWAL RONDE
func show_daily_intro(round_num: int, intro_text: String) -> void:
	current_mode = PopupMode.DAILY_INTRO
	_hide_all_controls()
	
	title_label.text = "HARI %d" % round_num
	story_label.text = intro_text
	continue_btn.show()
	show()


# 2. TAMPILKAN KEJADIAN SESI (PAGI / MALAM)
func show_event(event_data: EventData) -> void:
	if event_data == null:
		hide()
		popup_closed.emit()
		return
		
	current_mode = PopupMode.EVENT_ACTIVE
	current_event = event_data
	selected_item_slot = 0
	_hide_all_controls()
	
	var session_str := "PAGI" if GameState.current_session == GameState.Session.PAGI else "MALAM"
	title_label.text = "HARI %d - %s" % [GameState.current_round, session_str]
	story_label.text = event_data.story_text
	
	if event_data.event_type == EventData.EventType.YES_NO:
		yes_btn.show()
		no_btn.show()
		yes_btn.disabled = not GameState.can_select_choice(event_data.yes_choice)
		no_btn.disabled = not GameState.can_select_choice(event_data.no_choice)
		
	elif event_data.event_type == EventData.EventType.ITEM_CHOICE:
		if event_data.item_choice_1 != null:
			slot_1_owned = _setup_item_slot(item_slot_1, cross_1, event_data.item_choice_1)
			item_slot_1.show()
			
		if event_data.item_choice_2 != null:
			slot_2_owned = _setup_item_slot(item_slot_2, cross_2, event_data.item_choice_2)
			item_slot_2.show()
			
		continue_btn.show()
		
	show()


func _setup_item_slot(btn: TextureButton, cross_node: Control, choice: EventChoice) -> bool:
	if not choice.required_items.is_empty():
		var item_info := GameState.get_item_data(choice.required_items[0])
		if item_info != null and item_info.icon != null:
			btn.texture_normal = item_info.icon
		else:
			var placeholder := PlaceholderTexture2D.new()
			placeholder.size = Vector2(64, 64)
			btn.texture_normal = placeholder
			
	var is_owned := GameState.can_select_choice(choice)
	if is_owned:
		btn.disabled = false
		btn.mouse_filter = Control.MOUSE_FILTER_STOP
		cross_node.hide()
		btn.modulate.a = 0.5
	else:
		btn.disabled = true
		btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cross_node.show()
		btn.modulate.a = 0.85
		
	return is_owned


# --- INTERAKSI TOMBOL ---
func _on_yes_pressed() -> void:
	_execute_and_show_outcome(current_event.yes_choice)


func _on_no_pressed() -> void:
	_execute_and_show_outcome(current_event.no_choice)


func _on_item_slot_1_pressed() -> void:
	if not slot_1_owned:
		return
	if selected_item_slot == 1:
		selected_item_slot = 0
		item_slot_1.modulate.a = 0.5
	else:
		selected_item_slot = 1
		item_slot_1.modulate.a = 1.0
		if slot_2_owned:
			item_slot_2.modulate.a = 0.5


func _on_item_slot_2_pressed() -> void:
	if not slot_2_owned:
		return
	if selected_item_slot == 2:
		selected_item_slot = 0
		item_slot_2.modulate.a = 0.5
	else:
		selected_item_slot = 2
		item_slot_2.modulate.a = 1.0
		if slot_1_owned:
			item_slot_1.modulate.a = 0.5


func _on_continue_pressed() -> void:
	if current_mode == PopupMode.DAILY_INTRO:
		# Tutup buku setelah narasi hari agar pemain masuk ke Fase Bebas sebelum Event Pagi
		hide()
		popup_closed.emit()
		
	elif current_mode == PopupMode.EVENT_ACTIVE:
		if selected_item_slot == 1:
			_execute_and_show_outcome(current_event.item_choice_1)
		elif selected_item_slot == 2:
			_execute_and_show_outcome(current_event.item_choice_2)
		else:
			_execute_and_show_outcome(current_event.ignore_choice)
			
	elif current_mode == PopupMode.OUTCOME:
		hide()
		popup_closed.emit()


func _execute_and_show_outcome(choice: EventChoice) -> void:
	current_mode = PopupMode.OUTCOME
	_hide_all_controls()
	
	if choice != null:
		GameState.apply_choice_consequences(choice)
		story_label.text = choice.outcome_text
	else:
		story_label.text = "Tidak ada hal berarti yang terjadi."
		
	continue_btn.show()
