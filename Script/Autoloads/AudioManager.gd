extends Node

const SFX_DIR := "res://Assets/Audios/"

var sfx_player: AudioStreamPlayer
var writing_player: AudioStreamPlayer

var stream_select: AudioStream
var stream_paper_turn: AudioStream
var stream_writing: AudioStream


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Master"
	add_child(sfx_player)
	
	writing_player = AudioStreamPlayer.new()
	writing_player.bus = "Master"
	add_child(writing_player)
	
	_load_sfx_streams()
	
	get_tree().node_added.connect(_on_node_added)
	_connect_buttons_recursive(get_tree().root)


func _load_sfx_streams() -> void:
	stream_select = _find_audio_file("select.wav")
	stream_paper_turn = _find_audio_file("paper_turn.wav")
	if stream_paper_turn == null:
		stream_paper_turn = _find_audio_file("paper turn .wav")
	stream_writing = _find_audio_file("writing.wav")


func _find_audio_file(file_name: String) -> AudioStream:
	var primary_path: String = SFX_DIR + file_name
	if ResourceLoader.exists(primary_path):
		return load(primary_path)
	var fallback_path: String = "res://Assets/" + file_name
	if ResourceLoader.exists(fallback_path):
		return load(fallback_path)
	return null


func _connect_buttons_recursive(node: Node) -> void:
	_on_node_added(node)
	for child in node.get_children():
		_connect_buttons_recursive(child)


func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		var btn := node as BaseButton
		if not btn.pressed.is_connected(_on_any_button_pressed.bind(btn)):
			btn.pressed.connect(_on_any_button_pressed.bind(btn))
			
		# Animasi hover & press berbasis kecerahan (aman untuk semua ukuran & skala tombol)
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
