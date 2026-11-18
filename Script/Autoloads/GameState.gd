extends Node

signal stats_updated
signal inventory_updated
signal phase_changed(round_num: int, session: Session, phase: SessionPhase)
signal game_over(reason: String)

enum Session { PAGI, MALAM }
enum SessionPhase { MORNING_INTRO, MORNING_EVENT, NIGHT_EVENT }

# --- 1. STATUS RONDE, SESI & FASE ---
var current_round: int = 1
var current_session: Session = Session.PAGI
var current_phase: SessionPhase = SessionPhase.MORNING_INTRO

# --- 2. STATUS KARAKTER UTAMA (0 - 100) ---
var health: int = 100
var hunger: int = 20
var stress: int = 10

# --- 3. KARAKTER PENDAMPING ---
var companions: Dictionary = {
	"anak_kecil": true,
	"bayi": true
}

# --- 4. DATABASE ITEM, EVENT & INVENTORY ---
var item_database: Dictionary = {}
var event_database: Array[EventData] = []
var used_event_ids: Array[String] = []

var inventory: Array[Dictionary] = []
var max_slots: int = 12

# --- 5. CATATAN DIARY ---
var diary_logs: Array[Dictionary] = []


func _ready() -> void:
	_scan_resources_folder("res://Resources/")


func _scan_resources_folder(folder_path: String) -> void:
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_warning("Folder tidak ditemukan: " + folder_path)
		return
		
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
			
		var full_path := folder_path.path_join(file_name)
		if dir.current_is_dir():
			_scan_resources_folder(full_path)
		else:
			var clean_path := full_path.trim_suffix(".remap")
			if clean_path.ends_with(".tres"):
				var res := load(clean_path)
				if res is ItemData and res.id != "":
					item_database[res.id] = res
				elif res is EventData and res.event_id != "":
					event_database.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()


# --- PAKET ITEM SIMULASI PROTOTIPE ---
func give_prototype_starting_items() -> void:
	add_item("air_mineral", 2)
	add_item("biskuit", 2)
	add_item("botol_susu", 1)
	add_item("baterai", 1)
	add_item("senter", 1)
	add_item("payung", 1)
	add_item("masker", 1)
	add_item("tongkat", 1)


# --- MANAJEMEN INVENTORY ---
func add_item(item_id: String, amount: int = 1) -> bool:
	if not item_database.has(item_id):
		push_warning("ID Item tidak terdaftar di database: " + item_id)
		return false
		
	for slot in inventory:
		if slot["id"] == item_id:
			slot["quantity"] += amount
			inventory_updated.emit()
			return true
			
	if inventory.size() < max_slots:
		inventory.append({"id": item_id, "quantity": amount})
		inventory_updated.emit()
		return true
		
	return false


func remove_item(item_id: String, amount: int = 1) -> bool:
	for i in range(inventory.size()):
		if inventory[i]["id"] == item_id:
			inventory[i]["quantity"] -= amount
			if inventory[i]["quantity"] <= 0:
				inventory.remove_at(i)
			inventory_updated.emit()
			return true
	return false


func has_item(item_id: String, min_amount: int = 1) -> bool:
	for slot in inventory:
		if slot["id"] == item_id and slot["quantity"] >= min_amount:
			return true
	return false


func get_item_data(item_id: String) -> ItemData:
	return item_database.get(item_id, null)


# --- PEMILIHAN EVENT & SYARAT ---
func get_random_event_for_current_session() -> EventData:
	var target_session := EventData.SessionType.PAGI if current_session == Session.PAGI else EventData.SessionType.MALAM
	var candidates: Array[EventData] = []
	
	for ev in event_database:
		if ev.event_id in used_event_ids:
			continue
		if ev.allowed_session != EventData.SessionType.KEDUANYA and ev.allowed_session != target_session:
			continue
		if not _has_required_companions(ev.required_companions):
			continue
		candidates.append(ev)
		
	if candidates.is_empty():
		used_event_ids.clear()
		for ev in event_database:
			if (ev.allowed_session == EventData.SessionType.KEDUANYA or ev.allowed_session == target_session) and _has_required_companions(ev.required_companions):
				candidates.append(ev)
				
	if candidates.is_empty():
		return null
		
	var chosen: EventData = candidates.pick_random()
	used_event_ids.append(chosen.event_id)
	return chosen


func _has_required_companions(req_list: Array[String]) -> bool:
	for comp_id in req_list:
		if not companions.get(comp_id, false):
			return false
	return true


func can_select_choice(choice: EventChoice) -> bool:
	if choice == null:
		return false
	for req_id in choice.required_items:
		if not has_item(req_id):
			return false
	if not _has_required_companions(choice.required_companions):
		return false
	return true


func apply_choice_consequences(choice: EventChoice) -> void:
	if choice == null:
		return
	for used_id in choice.consumed_items:
		remove_item(used_id, 1)
		
	modify_stats(choice.hunger_change, choice.health_change, choice.stress_change)
	
	for lost_comp in choice.lost_companions:
		if companions.has(lost_comp):
			companions[lost_comp] = false
	for gained_comp in choice.gained_companions:
		companions[gained_comp] = true
		
	if choice.outcome_text != "":
		add_diary_entry(choice.outcome_text)


func modify_stats(d_hunger: int, d_health: int, d_stress: int) -> void:
	hunger = clampi(hunger + d_hunger, 0, 100)
	health = clampi(health + d_health, 0, 100)
	stress = clampi(stress + d_stress, 0, 100)
	stats_updated.emit()


# --- NARASI PEMBUKA HARI, DIARY & PERGANTIAN FASE ---
func get_daily_intro_text() -> String:
	var intro := "Hari ke-%d dimulai. Matahari mulai menyinari tempat berlindung. Kami harus memeriksa keadaan sekitar dan bertahan hidup hari ini." % current_round
	add_diary_entry(intro)
	return intro


func add_diary_entry(entry_text: String) -> void:
	var session_label := "Pagi" if current_session == Session.PAGI else "Malam"
	diary_logs.append({
		"round": current_round,
		"session": session_label,
		"text": entry_text
	})


func _check_game_over() -> bool:
	if health <= 0:
		game_over.emit("Kesehatanmu habis.")
		return true
	if hunger >= 100:
		game_over.emit("Kamu kehabisan tenaga karena kelaparan.")
		return true
	if stress >= 100:
		game_over.emit("Tingkat stresmu mencapai batas maksimal.")
		return true
	return false


func advance_session() -> void:
	if _check_game_over():
		return
		
	if current_phase == SessionPhase.MORNING_INTRO:
		# Selesai fase bebas persiapan pagi -> masuk ke Event Pagi (masih sesi Pagi)
		current_phase = SessionPhase.MORNING_EVENT
		phase_changed.emit(current_round, current_session, current_phase)
		
	elif current_phase == SessionPhase.MORNING_EVENT:
		# Selesai Event Pagi & fase bebas -> pindah ke Sesi Malam (Event Malam)
		modify_stats(10, 0, 0)
		if _check_game_over():
			return
		current_session = Session.MALAM
		current_phase = SessionPhase.NIGHT_EVENT
		phase_changed.emit(current_round, current_session, current_phase)
		
	elif current_phase == SessionPhase.NIGHT_EVENT:
		# Selesai Event Malam & fase bebas -> naik ke Ronde berikutnya (Narasi Pagi)
		modify_stats(10, 0, 0)
		if _check_game_over():
			return
		current_session = Session.PAGI
		current_round += 1
		current_phase = SessionPhase.MORNING_INTRO
		phase_changed.emit(current_round, current_session, current_phase)


func reset_game() -> void:
	current_round = 1
	current_session = Session.PAGI
	current_phase = SessionPhase.MORNING_INTRO
	health = 100
	hunger = 10
	stress = 10
	companions = {"anak_kecil": true, "bayi": true}
	inventory.clear()
	diary_logs.clear()
	used_event_ids.clear()
