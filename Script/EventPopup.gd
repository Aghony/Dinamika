extends Control

signal popup_closed

enum PopupMode { INTRO, EVENT_ACTIVE, OUTCOME }

@onready var book_panel: Control = $DimmerBackground/BookPanel
@onready var title_label: Label = $DimmerBackground/BookPanel/EventTitleLabel
@onready var story_label: RichTextLabel = $DimmerBackground/BookPanel/StoryTextLabel

@onready var yes_btn: Button = $DimmerBackground/BookPanel/YesButton
@onready var no_btn: Button = $DimmerBackground/BookPanel/NoButton

@onready var item_btn_1: TextureButton = $DimmerBackground/BookPanel/ItemSlotButton1
@onready var crossed_1: Control = $DimmerBackground/BookPanel/ItemSlotButton1/CrossedOverlay

@onready var item_btn_2: TextureButton = $DimmerBackground/BookPanel/ItemSlotButton2
@onready var crossed_2: Control = $DimmerBackground/BookPanel/ItemSlotButton2/CrossedOverlay

@onready var continue_btn: BaseButton = $DimmerBackground/BookPanel/ContinueButton

var current_event: EventData = null
var current_mode: PopupMode = PopupMode.INTRO
var selected_item_slot: String = ""

var highlight_frame_1: Panel = null
var highlight_frame_2: Panel = null
var pulse_tween: Tween = null
var text_tween: Tween = null
var is_typing: bool = false


func _ready() -> void:
	hide()
	
	# Pastikan teks tidak memblokir klik tombol & semua tombol berada di depan
	title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	story_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	_style_yesno_buttons()
	_setup_item_slot_visuals()
	
	if not yes_btn.pressed.is_connected(_on_yesno_clicked.bind("yes")):
		yes_btn.pressed.connect(_on_yesno_clicked.bind("yes"))
	if not no_btn.pressed.is_connected(_on_yesno_clicked.bind("no")):
		no_btn.pressed.connect(_on_yesno_clicked.bind("no"))
	if not item_btn_1.pressed.is_connected(_on_item_slot_toggled.bind("item_1")):
		item_btn_1.pressed.connect(_on_item_slot_toggled.bind("item_1"))
	if not item_btn_2.pressed.is_connected(_on_item_slot_toggled.bind("item_2")):
		item_btn_2.pressed.connect(_on_item_slot_toggled.bind("item_2"))
	if not continue_btn.pressed.is_connected(_on_continue_pressed):
		continue_btn.pressed.connect(_on_continue_pressed)


func _gui_input(event: InputEvent) -> void:
	if is_typing and event is InputEventMouseButton and event.pressed:
		_finish_typing_immediately()


func _style_yesno_buttons() -> void:
	yes_btn.text = "✓"
	no_btn.text = "✕"
	
	var black_bg := StyleBoxFlat.new()
	black_bg.bg_color = Color(0.10, 0.10, 0.10, 1.0)
	black_bg.set_corner_radius_all(8)
	
	var black_hover := black_bg.duplicate()
	black_hover.bg_color = Color(0.24, 0.24, 0.24, 1.0)
	
	for btn in [yes_btn, no_btn]:
		btn.add_theme_font_size_override("font_size", 40)
		btn.add_theme_color_override("font_color", Color.BLACK)
		btn.add_theme_color_override("font_hover_color", Color.BLACK)
		btn.add_theme_color_override("font_pressed_color", Color.BLACK)
		btn.add_theme_stylebox_override("normal", black_bg)
		btn.add_theme_stylebox_override("hover", black_hover)
		btn.add_theme_stylebox_override("pressed", black_bg)


func _setup_item_slot_visuals() -> void:
	item_btn_1.ignore_texture_size = true
	item_btn_1.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	item_btn_2.ignore_texture_size = true
	item_btn_2.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	
	crossed_1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crossed_2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	highlight_frame_1 = _create_selection_highlight(item_btn_1)
	highlight_frame_2 = _create_selection_highlight(item_btn_2)


func _create_selection_highlight(parent_btn: TextureButton) -> Panel:
	var frame := Panel.new()
	frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.visible = false
	
	var border := StyleBoxFlat.new()
	border.bg_color = Color(1.0, 0.85, 0.25, 0.20)
	border.border_color = Color(0.95, 0.72, 0.15, 1.0)
	border.set_border_width_all(4)
	border.set_corner_radius_all(8)
	frame.add_theme_stylebox_override("panel", border)
	
	parent_btn.add_child(frame)
	return frame


# --- 1. TAMPILAN NARASI PEMBUKA HARI (INTRO) ---
func show_daily_intro(round_num: int, intro_text: String) -> void:
	current_event = null
	current_mode = PopupMode.INTRO
	selected_item_slot = ""
	title_label.text = "Hari ke-%d" % round_num
	
	yes_btn.hide()
	no_btn.hide()
	item_btn_1.hide()
	item_btn_2.hide()
	continue_btn.disabled = false
	continue_btn.show()
	
	_open_with_animation()
	AudioManager.play_paper_turn()
	_play_typewriter_text(intro_text, true)


# --- 2. TAMPILAN KEJADIAN (PAGI / MALAM) ---
func show_event(event_data: EventData) -> void:
	if event_data == null:
		popup_closed.emit()
		return
		
	current_event = event_data
	current_mode = PopupMode.EVENT_ACTIVE
	selected_item_slot = ""
	
	var session_title: String = "Kejadian Pagi" if GameState.current_session == GameState.Session.PAGI else "Kejadian Malam"
	title_label.text = "%s — Hari ke-%d" % [session_title, GameState.current_round]
	
	if event_data.event_type == EventData.EventType.ITEM_CHOICE:
		yes_btn.hide()
		no_btn.hide()
		
		_setup_item_slot_button(item_btn_1, crossed_1, event_data.item_choice_1)
		_setup_item_slot_button(item_btn_2, crossed_2, event_data.item_choice_2)
		_update_item_selection_visuals()
		
		continue_btn.disabled = false
		continue_btn.show()
	else:
		item_btn_1.hide()
		item_btn_2.hide()
		continue_btn.hide()
		
		_setup_yesno_button(yes_btn, event_data.yes_choice, "✓")
		_setup_yesno_button(no_btn, event_data.no_choice, "✕")
		
	_open_with_animation()
	AudioManager.play_paper_turn()
	_play_typewriter_text(event_data.story_text, false)


func _setup_item_slot_button(btn: TextureButton, crossed_overlay: Control, choice: EventChoice) -> void:
	if choice == null:
		btn.hide()
		return
		
	btn.show()
	btn.move_to_front()
	btn.tooltip_text = choice.choice_text
	
	if not choice.required_items.is_empty():
		var primary_id: String = choice.required_items[0]
		var item_info: ItemData = GameState.get_item_data(primary_id)
		if item_info != null and item_info.icon != null:
			btn.texture_normal = item_info.icon
		else:
			var placeholder := PlaceholderTexture2D.new()
			placeholder.size = Vector2(64, 64)
			btn.texture_normal = placeholder
			
	var can_use: bool = GameState.can_select_choice(choice)
	btn.disabled = not can_use
	crossed_overlay.visible = not can_use
	btn.modulate.a = 1.0 if can_use else 0.65


func _setup_yesno_button(btn: Button, choice: EventChoice, symbol: String) -> void:
	if choice == null:
		btn.hide()
		return
		
	btn.show()
	btn.move_to_front()
	btn.text = symbol
	btn.tooltip_text = choice.choice_text
	var can_use: bool = GameState.can_select_choice(choice)
	btn.disabled = not can_use
	btn.modulate.a = 1.0 if can_use else 0.50


# --- MEKANIK 2-STEP ITEM SELECTION ---
func _on_item_slot_toggled(slot_key: String) -> void:
	if current_event == null or current_mode != PopupMode.EVENT_ACTIVE:
		return
		
	if selected_item_slot == slot_key:
		selected_item_slot = ""
	else:
		selected_item_slot = slot_key
		
	_update_item_selection_visuals()


func _update_item_selection_visuals() -> void:
	if pulse_tween != null and pulse_tween.is_valid():
		pulse_tween.kill()
		
	highlight_frame_1.visible = (selected_item_slot == "item_1")
	highlight_frame_2.visible = (selected_item_slot == "item_2")
	
	var active_frame: Panel = null
	if selected_item_slot == "item_1":
		active_frame = highlight_frame_1
	elif selected_item_slot == "item_2":
		active_frame = highlight_frame_2
		
	if active_frame != null:
		active_frame.modulate.a = 1.0
		pulse_tween = create_tween().set_loops()
		pulse_tween.tween_property(active_frame, "modulate:a", 0.45, 0.40).set_trans(Tween.TRANS_SINE)
		pulse_tween.tween_property(active_frame, "modulate:a", 1.0, 0.40).set_trans(Tween.TRANS_SINE)


func _on_yesno_clicked(slot_key: String) -> void:
	if current_event == null or current_mode != PopupMode.EVENT_ACTIVE:
		return
	var chosen: EventChoice = current_event.yes_choice if slot_key == "yes" else current_event.no_choice
	_execute_choice(chosen)


func _on_continue_pressed() -> void:
	if current_mode == PopupMode.EVENT_ACTIVE and current_event != null:
		var chosen: EventChoice = null
		if selected_item_slot == "item_1":
			chosen = current_event.item_choice_1
		elif selected_item_slot == "item_2":
			chosen = current_event.item_choice_2
		else:
			chosen = current_event.ignore_choice
			
		# Fallback jika event ITEM_CHOICE tidak memiliki resource ignore_choice
		if chosen == null:
			_show_outcome_panel("Kamu memilih mengabaikan situasi ini dan terus melangkah.")
			return
			
		_execute_choice(chosen)
		return
		
	_stop_typing_and_audio()
	AudioManager.play_paper_turn()
	hide()
	popup_closed.emit()


func _execute_choice(chosen: EventChoice) -> void:
	if chosen == null or not GameState.can_select_choice(chosen):
		return
		
	if pulse_tween != null and pulse_tween.is_valid():
		pulse_tween.kill()
		
	GameState.apply_choice_consequences(chosen)
	
	# Hentikan jika konsekuensi pilihan langsung memicu Game Over / Menang
	if not visible:
		_stop_typing_and_audio()
		return
		
	var result_text: String = chosen.outcome_text if chosen.outcome_text != "" else "Keputusan telah diambil. Kami bersiap melanjutkan langkah."
	_show_outcome_panel(result_text)


func _show_outcome_panel(result_text: String) -> void:
	current_mode = PopupMode.OUTCOME
	selected_item_slot = ""
	yes_btn.hide()
	no_btn.hide()
	item_btn_1.hide()
	item_btn_2.hide()
	continue_btn.disabled = false
	continue_btn.show()
	continue_btn.move_to_front()
	
	title_label.text = "Catatan Hasil"
	_play_typewriter_text(result_text, true)




# --- ANIMASI POP-UP & EFEK KETIK TEKS ---
func _open_with_animation() -> void:
	# Bawa EventPopup & ContinueButton ke urutan paling depan agar tidak tertutup node lain
	move_to_front()
	continue_btn.move_to_front()
	continue_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	show()
	
	book_panel.pivot_offset = book_panel.size * 0.5
	book_panel.scale = Vector2(0.92, 0.92)
	book_panel.modulate.a = 0.0
	
	var open_tween := create_tween().set_parallel(true)
	open_tween.tween_property(book_panel, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(book_panel, "modulate:a", 1.0, 0.18)


func _play_typewriter_text(full_text: String, play_writing_sfx: bool) -> void:
	_stop_typing_and_audio()
	story_label.text = full_text
	story_label.visible_ratio = 0.0
	is_typing = true
	
	if play_writing_sfx:
		AudioManager.play_writing()
		
	var duration: float = clampf(float(full_text.length()) * 0.018, 0.4, 2.2)
	text_tween = create_tween()
	text_tween.tween_property(story_label, "visible_ratio", 1.0, duration)
	text_tween.finished.connect(_on_typing_finished)


func _finish_typing_immediately() -> void:
	if text_tween != null and text_tween.is_valid():
		text_tween.kill()
	story_label.visible_ratio = 1.0
	_on_typing_finished()


func _on_typing_finished() -> void:
	is_typing = false
	AudioManager.stop_writing()


func _stop_typing_and_audio() -> void:
	if text_tween != null and text_tween.is_valid():
		text_tween.kill()
	is_typing = false
	AudioManager.stop_writing()
