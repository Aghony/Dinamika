extends Node

const SFX_DIR := "res://Assets/Audios/"

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var writing_player: AudioStreamPlayer

var stream_gameplay_bgm: AudioStream
var stream_select: AudioStream
var stream_paper_turn: AudioStream
var stream_writing: AudioStream
var stream_item_drop: AudioStream

var bgm_tween: Tween = null
var default_bgm_volume_db: float = -6.0



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music" if AudioServer.get_bus_index("Music") != -1 else "Master"
	bgm_player.volume_db = default_bgm_volume_db
	bgm_player.finished.connect(_on_bgm_finished)
	add_child(bgm_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX" if AudioServer.get_bus_index("SFX") != -1 else "Master"
	add_child(sfx_player)
	
	writing_player = AudioStreamPlayer.new()
	writing_player.bus = "SFX" if AudioServer.get_bus_index("SFX") != -1 else "Master"
	add_child(writing_player)
	
	_load_audio_streams()
	
	get_tree().node_added.connect(_on_node_added)
	_connect_buttons_recursive(get_tree().root)


func _load_audio_streams() -> void:
	stream_select = _find_audio_file("select.wav")
	stream_paper_turn = _find_audio_file("paper_turn.wav")
	if stream_paper_turn == null:
		stream_paper_turn = _find_audio_file("paper turn .wav")
	stream_writing = _find_audio_file("writing.wav")
	stream_item_drop = _find_audio_file("item_drop.wav")
	
	for bgm_name in ["bgm_gameplay.ogg", "bgm_gameplay.mp3", "bgm_gameplay.wav"]:
		stream_gameplay_bgm = _find_audio_file(bgm_name)
		if stream_gameplay_bgm != null:
			break


func _find_audio_file(file_name: String) -> AudioStream:
	var primary_path: String = SFX_DIR + file_name
	if ResourceLoader.exists(primary_path):
		return load(primary_path)
	var fallback_path: String = "res://Assets/" + file_name
	if ResourceLoader.exists(fallback_path):
		return load(fallback_path)
	return null


# --- KONTROL BGM ---
func play_bgm(custom_stream: AudioStream = null, fade_duration: float = 0.8) -> void:
	var target_stream: AudioStream = custom_stream if custom_stream != null else stream_gameplay_bgm
	if target_stream == null:
		return
		
	if bgm_player.stream == target_stream and bgm_player.playing:
		return
		
	if "loop" in target_stream:
		target_stream.loop = true
		
	if bgm_tween != null and bgm_tween.is_valid():
		bgm_tween.kill()
		
	bgm_player.stream = target_stream
	bgm_player.volume_db = -30.0 if fade_duration > 0.0 else default_bgm_volume_db
	bgm_player.play()
	
	if fade_duration > 0.0:
		bgm_tween = create_tween()
		bgm_tween.tween_property(bgm_player, "volume_db", default_bgm_volume_db, fade_duration).set_trans(Tween.TRANS_SINE)


func stop_bgm(fade_duration: float = 0.6) -> void:
	if not bgm_player.playing:
		return
	if bgm_tween != null and bgm_tween.is_valid():
		bgm_tween.kill()
		
	if fade_duration > 0.0:
		bgm_tween = create_tween()
		bgm_tween.tween_property(bgm_player, "volume_db", -35.0, fade_duration).set_trans(Tween.TRANS_SINE)
		bgm_tween.tween_callback(bgm_player.stop)
	else:
		bgm_player.stop()


func _on_bgm_finished() -> void:
	if bgm_player.stream != null:
		bgm_player.play()


# --- KONEKSI OTOMATIS TOMBOL & SFX ---
func _connect_buttons_recursive(node: Node) -> void:
	_on_node_added(node)
	for child in node.get_children():
		_connect_buttons_recursive(child)


func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		var btn := node as BaseButton
		if not btn.pressed.is_connected(_on_any_button_pressed.bind(btn)):
			btn.pressed.connect(_on_any_button_pressed.bind(btn))
			
		if btn.name != "MainCharButton" and btn.name != "BackpackButton":
			if not btn.mouse_entered.is_connected(_on_btn_hover.bind(btn, true)):
				btn.mouse_entered.connect(_on_btn_hover.bind(btn, true))
				btn.mouse_exited.connect(_on_btn_hover.bind(btn, false))
				btn.button_down.connect(_on_btn_press.bind(btn, true))
				btn.button_up.connect(_on_btn_press.bind(btn, false))


func _on_btn_hover(btn: BaseButton, is_hovering: bool) -> void:
	if not is_instance_valid(btn) or btn.disabled:
		return
	var target_tint: Color = Color(1.18, 1.18, 1.18, 1.0) if is_hovering else Color.WHITE
	_tween_button_tint(btn, target_tint, 0.10)


func _on_btn_press(btn: BaseButton, is_down: bool) -> void:
	if not is_instance_valid(btn) or btn.disabled:
		return
	var target_tint: Color = Color(0.82, 0.82, 0.82, 1.0) if is_down else Color(1.18, 1.18, 1.18, 1.0)
	_tween_button_tint(btn, target_tint, 0.06)


func _tween_button_tint(btn: BaseButton, target: Color, duration: float) -> void:
	if btn.has_meta("_juice_tween"):
		var old_tw: Tween = btn.get_meta("_juice_tween")
		if old_tw != null and old_tw.is_valid():
			old_tw.kill()
	var tw: Tween = btn.create_tween()
	tw.tween_property(btn, "self_modulate", target, duration).set_trans(Tween.TRANS_SINE)
	btn.set_meta("_juice_tween", tw)


func _on_any_button_pressed(btn: BaseButton) -> void:
	if btn.name == "PrevPageButton" or btn.name == "NextPageButton":
		play_paper_turn()
	else:
		play_select()


func play_select() -> void:
	if stream_select == null:
		return
	sfx_player.stream = stream_select
	sfx_player.pitch_scale = randf_range(0.96, 1.04)
	sfx_player.play()


func play_paper_turn() -> void:
	if stream_paper_turn == null:
		return
	sfx_player.stream = stream_paper_turn
	sfx_player.pitch_scale = randf_range(0.95, 1.05)
	sfx_player.play()


func play_writing() -> void:
	if stream_writing == null:
		return
	writing_player.stream = stream_writing
	writing_player.pitch_scale = 1.0
	writing_player.play()


func stop_writing() -> void:
	if writing_player.playing:
		writing_player.stop()


func play_item_drop() -> void:
	if stream_item_drop == null:
		return
	sfx_player.stream = stream_item_drop
	sfx_player.pitch_scale = randf_range(0.92, 1.06)
	sfx_player.play()
