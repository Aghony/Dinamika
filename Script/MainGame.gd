extends Control

@export_group("Sprite Kombinasi Karakter")
@export var tex_bayi_ringan: Texture2D
@export var tex_bayi_sedang: Texture2D
@export var tex_bayi_berat: Texture2D
@export var tex_solo_ringan: Texture2D
@export var tex_solo_sedang: Texture2D
@export var tex_solo_berat: Texture2D
@export_group("Audio Gameplay")
@export var gameplay_bgm: AudioStream

@export_group("Debug & Uji Coba")
## [UJI COBA] Matikan centang ini atau hapus pemanggilannya saat mekanik item awal sudah final.
@export var debug_give_starting_items: bool = true

@onready var char_root: Control = $Layer1_Character
@onready var character_sprite: TextureRect = $Layer1_Character/CharacterSprite
@onready var main_char_btn: Button = $Layer1_Character/MainCharButton
@onready var backpack_btn: Button = $Layer1_Character/BackpackButton

@onready var diary_btn: Button = $DiaryButton
@onready var next_session_btn: Button = $NextSessionButton

@onready var event_popup: Control = $EventPopup
@onready var status_popup: Control = $StatusPopup
@onready var inventory_popup: Control = $InventoryPopup
@onready var diary_popup: Control = $DiaryPopup
@onready var game_over_popup: Control = $GameOverPopup


var world_env: Control = null
var managed_popups: Array[Control] = []
var flash_overlay: ColorRect = null

var char_base_y: float = 0.0
var walk_time: float = 0.0
var critical_pulse_time: float = 0.0
var is_any_popup_open: bool = false
var active_floating_labels: Array[Label] = []
var floating_stagger_index: int = 0

# Pelacak perubahan nilai untuk memicu Floating Text & Screen Shake
var prev_health: int = 100
var prev_hunger: int = 15
var prev_stress: int = 10
var prev_travel: float = 0.0
var prev_weight_cat: int = -1


func _ready() -> void:
	world_env = get_node_or_null("WorldEnvironmentLayer")
	if world_env == null:
		world_env = get_node_or_null("WorldEnvironment")
		
	char_base_y = char_root.position.y
	_setup_flash_overlay()
	
	GameState.reset_game()
	
	# ==========================================================================
	# [UJI COBA / DEBUG] Pemberian 13 item awal otomatis untuk kebutuhan testing.
	# Hapus blok ini jika fitur persiapan/pemilihan barang awal sudah diimplementasikan.
	# ==========================================================================
	if debug_give_starting_items:
		GameState.give_prototype_starting_items()
	
	prev_health = GameState.health
	prev_hunger = GameState.hunger
	prev_stress = GameState.stress
	prev_travel = GameState.travel_points
	prev_weight_cat = GameState.get_weight_category()
	
	GameState.phase_changed.connect(_on_phase_changed)
	GameState.stats_updated.connect(_on_stats_updated)
	GameState.inventory_updated.connect(_update_character_visuals)
	GameState.item_lost_unintentionally.connect(_on_item_lost_unintentionally)
	GameState.game_over.connect(_on_game_over)
	GameState.game_won.connect(_on_game_won)
	
	next_session_btn.pressed.connect(_on_next_session_pressed)
	event_popup.popup_closed.connect(_on_event_popup_closed)
	
	main_char_btn.pressed.connect(_try_open_popup.bind(status_popup))
	backpack_btn.pressed.connect(_try_open_popup.bind(inventory_popup))
	diary_btn.pressed.connect(_try_open_popup.bind(diary_popup))
	
	# Umpan balik hover halus saat kursor menyentuh karakter atau tas
	for hit_btn in [main_char_btn, backpack_btn]:
		hit_btn.mouse_entered.connect(_on_character_hovered.bind(true))
		hit_btn.mouse_exited.connect(_on_character_hovered.bind(false))
		
	_register_exclusive_popups()
	
	if world_env != null:
		world_env.generate_for_day(GameState.current_round)
	_update_hud()
	_update_character_visuals()
	_start_daily_intro_flow()
	AudioManager.play_bgm(gameplay_bgm)


func _process(delta: float) -> void:
	if not is_any_popup_open:
		var walk_speed: float = 3.8 if GameState.get_weight_category() == 3 else 6.0
		var walk_amp: float = 2.8 if GameState.get_weight_category() == 3 else 4.0
		walk_time += delta * walk_speed
		char_root.position.y = char_base_y + sin(walk_time) * walk_amp
	else:
		char_root.position.y = char_base_y
		
	# Efek denyut ketegangan halus saat kondisi kritis (HP rendah atau Stres tinggi)
	_update_critical_tension(delta)
		
	if not is_equal_approx(GameState.travel_points, prev_travel):
		var d_travel: float = snappedf(GameState.travel_points - prev_travel, 0.05)
		prev_travel = GameState.travel_points
		if absf(d_travel) >= 0.05:
			var sign_str: String = "+" if d_travel > 0.0 else ""
			var col: Color = Color(1.0, 0.85, 0.25) if d_travel > 0.0 else Color(1.0, 0.45, 0.35)
			_spawn_floating_text("%s%.1f km Jarak" % [sign_str, d_travel], col)


func _update_critical_tension(delta: float) -> void:
	if flash_overlay == null:
		return
	var is_critical: bool = (GameState.health <= 35 or GameState.stress >= 75)
	if not is_critical:
		critical_pulse_time = 0.0
		if flash_overlay.color.a > 0.0 and not is_any_popup_open:
			flash_overlay.color.a = move_toward(flash_overlay.color.a, 0.0, delta * 0.6)
		return
		
	critical_pulse_time += delta * 2.4
	var pulse_alpha: float = (0.5 + 0.5 * sin(critical_pulse_time)) * 0.11
	if not is_any_popup_open and flash_overlay.color.a <= pulse_alpha + 0.02:
		if GameState.health <= 35:
			flash_overlay.color = Color(0.95, 0.15, 0.15, pulse_alpha)
		else:
			flash_overlay.color = Color(0.65, 0.20, 0.85, pulse_alpha)


func _setup_flash_overlay() -> void:
	flash_overlay = ColorRect.new()
	flash_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	flash_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash_overlay.color = Color(1.0, 0.15, 0.15, 0.0)
	flash_overlay.z_index = 40
	add_child(flash_overlay)


# --- UMPAN BALIK PERUBAHAN STATUS & KEHILANGAN BARANG ---
func _on_stats_updated() -> void:
	floating_stagger_index = 0
	
	var d_hp: int = GameState.health - prev_health
	var d_hgr: int = GameState.hunger - prev_hunger
	var d_str: int = GameState.stress - prev_stress
	
	prev_health = GameState.health
	prev_hunger = GameState.hunger
	prev_stress = GameState.stress
	
	if d_hp != 0:
		var sign_hp: String = "+" if d_hp > 0 else ""
		var col_hp: Color = Color(0.35, 0.95, 0.45) if d_hp > 0 else Color(1.0, 0.30, 0.30)
		_spawn_floating_text("%s%d Kesehatan" % [sign_hp, d_hp], col_hp)
		
	if d_hgr != 0:
		var sign_hgr: String = "+" if d_hgr > 0 else ""
		var col_hgr: Color = Color(0.35, 0.95, 0.45) if d_hgr < 0 else Color(1.0, 0.65, 0.25)
		_spawn_floating_text("%s%d Lapar" % [sign_hgr, d_hgr], col_hgr)
		
	if d_str != 0:
		var sign_str: String = "+" if d_str > 0 else ""
		var col_str: Color = Color(0.40, 0.90, 1.0) if d_str < 0 else Color(0.90, 0.40, 1.0)
		_spawn_floating_text("%s%d Stres" % [sign_str, d_str], col_str)
		
	if d_hp <= -15:
		_trigger_screen_shake(9.0, 0.35)
		_trigger_vignette_flash(Color(0.95, 0.15, 0.15, 0.28))
	elif d_str >= 20:
		_trigger_screen_shake(5.0, 0.25)
		_trigger_vignette_flash(Color(0.65, 0.20, 0.85, 0.24))


func _on_item_lost_unintentionally(item_name: String, amount: int) -> void:
	_spawn_floating_text("-%d %s (Hilang!)" % [amount, item_name], Color(1.0, 0.45, 0.15))
	_trigger_screen_shake(6.0, 0.25)
	_trigger_vignette_flash(Color(1.0, 0.45, 0.10, 0.24))
	if AudioManager.has_method("play_item_drop"):
		AudioManager.play_item_drop()


func _spawn_floating_text(msg: String, text_color: Color) -> void:
	active_floating_labels = active_floating_labels.filter(func(l: Label) -> bool: return is_instance_valid(l))
	
	for existing_lbl in active_floating_labels:
		existing_lbl.global_position.y -= 34.0
		
	var lbl := Label.new()
	lbl.text = msg
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lbl.z_index = 50
	lbl.modulate.a = 0.0
	lbl.add_theme_font_size_override("font_size", 22)
	lbl.add_theme_color_override("font_color", text_color)
	lbl.add_theme_color_override("font_outline_color", Color(0.08, 0.06, 0.05, 1.0))
	lbl.add_theme_constant_override("outline_size", 5)
	
	var start_pos: Vector2 = char_root.global_position + Vector2(-24.0, -45.0)
	lbl.global_position = start_pos
	add_child(lbl)
	active_floating_labels.append(lbl)
	
	var delay_sec: float = float(floating_stagger_index) * 0.16
	floating_stagger_index += 1
	
	var tw: Tween = create_tween().set_parallel(true)
	tw.tween_property(lbl, "modulate:a", 1.0, 0.14).set_delay(delay_sec)
	tw.tween_property(lbl, "global_position:y", -78.0, 1.45).set_delay(delay_sec).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).as_relative()
	tw.tween_property(lbl, "modulate:a", 0.0, 1.0).set_delay(delay_sec + 0.55)
	tw.chain().tween_callback(func() -> void:
		active_floating_labels.erase(lbl)
		if is_instance_valid(lbl):
			lbl.queue_free()
	)


func _trigger_screen_shake(intensity: float, duration: float) -> void:
	var base_pos: Vector2 = position
	var steps: int = 7
	var step_time: float = duration / float(steps)
	var shake_tw: Tween = create_tween()
	for i in range(steps):
		var damper: float = 1.0 - (float(i) / float(steps))
		var offset := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity)) * damper
		shake_tw.tween_property(self, "position", base_pos + offset, step_time)
	shake_tw.tween_property(self, "position", base_pos, step_time)


func _trigger_vignette_flash(flash_color: Color) -> void:
	if flash_overlay == null:
		return
	flash_overlay.color = flash_color
	var flash_tw: Tween = create_tween()
	flash_tw.tween_property(flash_overlay, "color:a", 0.0, 0.48).set_trans(Tween.TRANS_SINE)


# --- SISTEM KUNCI EKSKLUSIF POP-UP ---
func _register_exclusive_popups() -> void:
	var candidates: Array[Node] = [
		event_popup,
		status_popup,
		inventory_popup,
		diary_popup,
		game_over_popup,
		get_node_or_null("PauseMenu")
	]
	for node in candidates:
		if node is Control:
			var ctrl := node as Control
			managed_popups.append(ctrl)
			if not ctrl.visibility_changed.is_connected(_refresh_popup_lock):
				ctrl.visibility_changed.connect(_refresh_popup_lock)


func _try_open_popup(target_popup: Control) -> void:
	if is_any_popup_open or target_popup == null:
		return
	if target_popup.has_method("open_popup"):
		target_popup.open_popup()
	else:
		target_popup.show()


func _refresh_popup_lock() -> void:
	var active_found: bool = false
	for p in managed_popups:
		if p != null and p.visible:
			active_found = true
			break
			
	is_any_popup_open = active_found
	
	main_char_btn.disabled = active_found
	backpack_btn.disabled = active_found
	diary_btn.disabled = active_found
	
	var is_free_phase: bool = (
		GameState.current_phase == GameState.SessionPhase.MORNING_FREE
		or GameState.current_phase == GameState.SessionPhase.NIGHT_FREE
	)
	next_session_btn.disabled = active_found or not is_free_phase


# --- SINKRONISASI LINGKUNGAN & VISUAL KARAKTER ---
func _update_hud() -> void:
	var is_morning: bool = (GameState.current_session == GameState.Session.PAGI)
	if world_env != null:
		world_env.update_time_of_day(is_morning)


func _on_character_hovered(is_hovering: bool) -> void:
	if is_any_popup_open:
		return
	char_root.pivot_offset = char_root.size * 0.5
	var target: Vector2 = Vector2(1.05, 1.05) if is_hovering else Vector2.ONE
	var tw: Tween = create_tween()
	tw.tween_property(char_root, "scale", target, 0.14).set_trans(Tween.TRANS_SINE)


func _update_character_visuals() -> void:
	var has_baby: bool = GameState.companions.get("bayi", false)
	var category: int = GameState.get_weight_category()
	var selected_tex: Texture2D = null
	var placeholder_color: Color = Color.WHITE
	
	if has_baby:
		match category:
			1:
				selected_tex = tex_bayi_ringan
				placeholder_color = Color(0.35, 0.85, 0.45)
			2:
				selected_tex = tex_bayi_sedang
				placeholder_color = Color(0.95, 0.75, 0.25)
			3:
				selected_tex = tex_bayi_berat
				placeholder_color = Color(0.90, 0.35, 0.30)
	else:
		match category:
			1:
				selected_tex = tex_solo_ringan
				placeholder_color = Color(0.30, 0.75, 0.90)
			2:
				selected_tex = tex_solo_sedang
				placeholder_color = Color(0.35, 0.50, 0.90)
			3:
				selected_tex = tex_solo_berat
				placeholder_color = Color(0.65, 0.35, 0.85)
				
	if selected_tex != null:
		character_sprite.texture = selected_tex
		character_sprite.modulate = Color(0.88, 0.86, 0.86, 1.0) if category == 3 else Color.WHITE
	else:
		var placeholder := PlaceholderTexture2D.new()
		placeholder.size = character_sprite.size if character_sprite.size != Vector2.ZERO else Vector2(96, 160)
		character_sprite.texture = placeholder
		character_sprite.modulate = placeholder_color
		
	# Efek membal kenyal (squash & stretch) saat kategori berat tas berubah
	if prev_weight_cat != -1 and category != prev_weight_cat:
		char_root.pivot_offset = char_root.size * 0.5
		var bounce_tw: Tween = create_tween()
		bounce_tw.tween_property(char_root, "scale", Vector2(1.16, 0.86), 0.10).set_trans(Tween.TRANS_SINE)
		bounce_tw.tween_property(char_root, "scale", Vector2(0.94, 1.08), 0.12).set_trans(Tween.TRANS_SINE)
		bounce_tw.tween_property(char_root, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	prev_weight_cat = category


func _start_daily_intro_flow() -> void:
	var intro_text := GameState.get_daily_intro_text()
	event_popup.show_daily_intro(GameState.current_round, intro_text)


func _start_event_flow() -> void:
	var session_event := GameState.get_random_event_for_current_session()
	if session_event == null:
		push_warning("Tidak ada event tersedia untuk sesi ini, melewati event.")
		GameState.on_popup_closed()
		return
	event_popup.show_event(session_event)


func _on_event_popup_closed() -> void:
	GameState.on_popup_closed()


func _on_next_session_pressed() -> void:
	if is_any_popup_open:
		return
	GameState.advance_session()


func _on_phase_changed(round_num: int, _session: GameState.Session, phase: GameState.SessionPhase) -> void:
	_update_hud()
	
	match phase:
		GameState.SessionPhase.MORNING_INTRO:
			if world_env != null:
				world_env.generate_for_day(round_num)
			_start_daily_intro_flow()
		GameState.SessionPhase.MORNING_FREE, GameState.SessionPhase.NIGHT_FREE:
			_refresh_popup_lock()
		GameState.SessionPhase.MORNING_EVENT, GameState.SessionPhase.NIGHT_EVENT:
			_start_event_flow()


func _on_game_over(reason: String) -> void:
	AudioManager.stop_writing()
	event_popup.hide()
	game_over_popup.show_ending(false, reason)


func _on_game_won(summary: String) -> void:
	AudioManager.stop_writing()
	event_popup.hide()
	game_over_popup.show_ending(true, summary)
