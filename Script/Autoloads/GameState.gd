extends Node

signal stats_updated
signal inventory_updated
signal item_lost_unintentionally(item_name: String, amount: int)
signal phase_changed(round_num: int, session: Session, phase: SessionPhase)
signal game_over(reason: String)
signal game_won(summary: String)

enum Session { PAGI, MALAM }
enum SessionPhase {
	MORNING_INTRO,
	MORNING_FREE,
	MORNING_EVENT,
	NIGHT_FREE,
	NIGHT_EVENT
}

# --- KONSTANTA ATURAN KARHUTLA (7 HARI) ---
const MAX_ROUNDS: int = 7
const TARGET_TRAVEL_POINTS: float = 15.0
const MAX_WEIGHT: float = 15.0
const BABY_WEIGHT: float = 4.4

# --- 1. STATUS RONDE, SESI & PERJALANAN ---
var current_round: int = 1
var current_session: Session = Session.PAGI
var current_phase: SessionPhase = SessionPhase.MORNING_INTRO
var travel_points: float = 0.0

# --- 2. STATUS KARAKTER UTAMA (0 - 100) ---
var health: int = 100
var hunger: int = 15
var stress: int = 10

# --- 3. KARAKTER PENDAMPING (Bayi = 4.4 kg) ---
var companions: Dictionary = {
	"bayi": true
}

# --- 4. DATABASE ITEM, EVENT & INVENTORY ---
var item_database: Dictionary = {}
var event_database: Array[EventData] = []
var used_event_ids: Array[String] = []

var inventory: Array[Dictionary] = []
var max_slots: int = 15
var last_lost_item_names: Array[String] = []

# --- 5. CATATAN DIARY ---
var diary_logs: Array[Dictionary] = []


func _ready() -> void:
	_scan_resources_folder("res://Resources/")
	print("[GameState] Item dimuat: ", item_database.size(), " | Event dimuat: ", event_database.size())


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


# Normalisasi ID item agar "baterai" dan "biskuit" selalu konsisten
func _normalize_item_id(raw_id: String) -> String:
	match raw_id:
		"batre": return "baterai"
		"biskuit_anak": return "biskuit"
		_: return raw_id


# ==============================================================================
# [UJI COBA / DEBUG] PAKET SIMULASI ITEM AWAL (13 Item)
# Hanya digunakan untuk kebutuhan testing prototype.
# Hapus fungsi ini beserta pemanggilannya di MainGate.gd saat rilis/produksi.
# ==============================================================================
func give_prototype_starting_items() -> void:
	add_item("air_mineral", 3)   # 1.50 kg
	add_item("biskuit", 4)       # 1.00 kg
	add_item("perban_coklat", 2) # 0.50 kg
	add_item("masker", 3)        # 0.30 kg
	add_item("payung", 1)        # 0.35 kg
	add_item("obat_obatan", 1)   # 0.50 kg
	add_item("tongkat", 1)       # 0.35 kg
	add_item("dokumen", 1)       # 0.10 kg
	add_item("senter", 1)        # 0.15 kg
	add_item("baterai", 2)       # 0.20 kg
	add_item("jaket", 1)         # 0.70 kg
	add_item("botol_susu", 3)    # 0.30 kg
	add_item("mainan_anak", 1)   # 0.30 kg


# --- KALKULASI BERAT & KATEGORI TAS ---
func get_total_weight() -> float:
	var total: float = 0.0
	if companions.get("bayi", false):
		total += BABY_WEIGHT
		
	for slot in inventory:
		var item_info := get_item_data(slot["id"])
		if item_info != null:
			total += item_info.weight * slot["quantity"]
			
	return snappedf(total, 0.01)


func get_weight_category() -> int:
	var w := get_total_weight()
	if w < 4.0:
		return 1
	elif w <= 10.0:
		return 2
	else:
		return 3


func get_daily_travel_gain() -> float:
	match get_weight_category():
		1: return 2.5
		2: return 2.0
		_: return 1.0


# --- MANAJEMEN INVENTORY ---
func add_item(raw_id: String, amount: int = 1, enforce_weight_limit: bool = true) -> bool:
	var item_id := _normalize_item_id(raw_id)
	var item_info := get_item_data(item_id)
	if item_info == null:
		push_warning("ID Item tidak terdaftar di database: " + item_id)
		return false
		
	if enforce_weight_limit:
		var added_weight := item_info.weight * amount
		if snappedf(get_total_weight() + added_weight, 0.01) > MAX_WEIGHT:
			return false
			
	for slot in inventory:
		if slot["id"] == item_id:
			if slot["quantity"] + amount > item_info.max_stack:
				return false
			slot["quantity"] += amount
			inventory_updated.emit()
			return true
			
	if inventory.size() < max_slots and amount <= item_info.max_stack:
		inventory.append({"id": item_id, "quantity": amount})
		inventory_updated.emit()
		return true
		
	return false


func remove_item(raw_id: String, amount: int = 1) -> bool:
	var item_id := _normalize_item_id(raw_id)
	for i in range(inventory.size()):
		if inventory[i]["id"] == item_id:
			inventory[i]["quantity"] -= amount
			if inventory[i]["quantity"] <= 0:
				inventory.remove_at(i)
			inventory_updated.emit()
			return true
	return false


func has_item(raw_id: String, min_amount: int = 1) -> bool:
	var item_id := _normalize_item_id(raw_id)
	for slot in inventory:
		if slot["id"] == item_id and slot["quantity"] >= min_amount:
			return true
	return false


func get_item_data(raw_id: String) -> ItemData:
	var item_id := _normalize_item_id(raw_id)
	return item_database.get(item_id, null)


func _get_item_display_name(raw_id: String) -> String:
	var info := get_item_data(raw_id)
	return info.display_name if info != null and info.display_name != "" else raw_id


# --- PEMILIHAN EVENT & SYARAT ---
func get_random_event_for_current_session() -> EventData:
	var target_session := EventData.SessionType.PAGI if current_session == Session.PAGI else EventData.SessionType.MALAM
	var candidates: Array[EventData] = []
	
	for ev in event_database:
		if ev.event_id in used_event_ids:
			continue
		if current_round < ev.min_day or current_round > ev.max_day:
			continue
		if ev.allowed_session != EventData.SessionType.KEDUANYA and ev.allowed_session != target_session:
			continue
		if not _has_required_companions(ev.required_companions):
			continue
		candidates.append(ev)
		
	# Cadangan 1: Reset riwayat event terpakai jika pool hari ini habis
	if candidates.is_empty():
		used_event_ids.clear()
		for ev in event_database:
			if current_round >= ev.min_day and current_round <= ev.max_day:
				if (ev.allowed_session == EventData.SessionType.KEDUANYA or ev.allowed_session == target_session) and _has_required_companions(ev.required_companions):
					candidates.append(ev)
					
	# Cadangan 2: Abaikan batas min_day/max_day jika masih kosong
	if candidates.is_empty():
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
		
	last_lost_item_names.clear()
	var is_heavy: bool = (get_weight_category() == 3)
	
	# 1. Konsumsi item yang sengaja dipakai untuk menyelesaikan event
	for used_id in choice.consumed_items:
		remove_item(used_id, 1)
		
	# 2. Kehilangan item spesifik secara paksa
	for spec_id in choice.specific_items_lost:
		if has_item(spec_id, 1):
			var disp := _get_item_display_name(spec_id)
			remove_item(spec_id, 1)
			last_lost_item_names.append(disp)
			item_lost_unintentionally.emit(disp, 1)
			
	# 3. Kehilangan item acak dari dalam tas
	for _i in range(choice.random_items_lost):
		if inventory.is_empty():
			break
		var random_slot: Dictionary = inventory.pick_random()
		var lost_id: String = random_slot["id"]
		var disp_name := _get_item_display_name(lost_id)
		remove_item(lost_id, 1)
		last_lost_item_names.append(disp_name)
		item_lost_unintentionally.emit(disp_name, 1)
		
	# 4. Hitung total perubahan status (termasuk penalti beban berat jika > 10.0 kg)
	var d_hunger: int = choice.hunger_change + (choice.heavy_load_extra_hunger if is_heavy else 0)
	var d_health: int = choice.health_change + (choice.heavy_load_extra_health if is_heavy else 0)
	var d_stress: int = choice.stress_change + (choice.heavy_load_extra_stress if is_heavy else 0)
	modify_stats(d_hunger, d_health, d_stress)
	
	# 5. Perubahan jarak tempuh
	if choice.travel_change != 0.0:
		travel_points = maxf(0.0, snappedf(travel_points + choice.travel_change, 0.05))
		
	# 6. Perubahan pendamping
	for lost_comp in choice.lost_companions:
		if companions.has(lost_comp):
			companions[lost_comp] = false
			inventory_updated.emit()
	for gained_comp in choice.gained_companions:
		companions[gained_comp] = true
		inventory_updated.emit()
		
	# 7. Catat ke Diary (sertakan daftar barang yang hilang jika ada)
	var log_text: String = choice.outcome_text
	if not last_lost_item_names.is_empty():
		var lost_summary := " [Barang hilang: %s]" % ", ".join(last_lost_item_names)
		log_text += lost_summary
	if log_text != "":
		add_diary_entry(log_text)
		
	# Langsung cek apakah progres jalan sudah tembus 15.0 atau status kritis 0/100
	_check_end_conditions()


func modify_stats(d_hunger: int, d_health: int, d_stress: int) -> void:
	var old_h := hunger
	var old_hp := health
	var old_s := stress
	
	hunger = clampi(hunger + d_hunger, 0, 100)
	health = clampi(health + d_health, 0, 100)
	stress = clampi(stress + d_stress, 0, 100)
	
	if hunger != old_h or health != old_hp or stress != old_s:
		stats_updated.emit()


# --- NARASI PEMBUKA HARI, DIARY & PERGANTIAN FASE ---
func get_daily_intro_text() -> String:
	var sisa_hari := MAX_ROUNDS - current_round + 1
	var kategori_list: Array[String] = ["Ringan", "Sedang", "Berat"]
	var berat_kat: String = kategori_list[get_weight_category() - 1]
	var intro := "Hari ke-%d (Sisa %d hari menuju batas waktu). Jarak tempuh: %.1f / %.1f km | Beban: %.2f kg (%s)." % [
		current_round, sisa_hari, travel_points, TARGET_TRAVEL_POINTS, get_total_weight(), berat_kat
	]
	add_diary_entry(intro)
	return intro


func add_diary_entry(entry_text: String) -> void:
	var session_label := "Pagi" if current_session == Session.PAGI else "Malam"
	diary_logs.append({
		"round": current_round,
		"session": session_label,
		"text": entry_text
	})


func _check_end_conditions() -> bool:
	if health <= 0:
		game_over.emit("Tubuhmu ambruk akibat luka dan kelelahan di jalur evakuasi.")
		return true
	if hunger >= 100:
		game_over.emit("Kamu kehabisan tenaga karena kelaparan ekstrem.")
		return true
	if stress >= 100:
		game_over.emit("Kepanikan dan kepulan asap membuatmu kehilangan kendali.")
		return true
	if travel_points >= TARGET_TRAVEL_POINTS:
		game_won.emit("Selamat! Kamu dan bayimu berhasil tiba di pos pengungsian pada Hari ke-%d!" % current_round)
		return true
	return false


func advance_session() -> void:
	if _check_end_conditions():
		return
		
	if current_phase == SessionPhase.MORNING_FREE:
		current_phase = SessionPhase.MORNING_EVENT
		phase_changed.emit(current_round, current_session, current_phase)
		
	elif current_phase == SessionPhase.NIGHT_FREE:
		current_phase = SessionPhase.NIGHT_EVENT
		phase_changed.emit(current_round, current_session, current_phase)


func on_popup_closed() -> void:
	if _check_end_conditions():
		return
		
	if current_phase == SessionPhase.MORNING_INTRO:
		current_phase = SessionPhase.MORNING_FREE
		phase_changed.emit(current_round, current_session, current_phase)
		
	elif current_phase == SessionPhase.MORNING_EVENT:
		current_session = Session.MALAM
		current_phase = SessionPhase.NIGHT_FREE
		phase_changed.emit(current_round, current_session, current_phase)
		
	elif current_phase == SessionPhase.NIGHT_EVENT:
		travel_points = snappedf(travel_points + get_daily_travel_gain(), 0.05)
		
		if _check_end_conditions():
			return
			
		if current_round >= MAX_ROUNDS:
			game_over.emit("Waktu habis! Api karhutla mengepung jalur evakuasi sebelum kamu sampai ke pengungsian.")
			return
			
		# Kelelahan bermalam berdasarkan beban tas yang dibawa seharian
		match get_weight_category():
			1: modify_stats(6, 0, 3)    # Ringan (< 4.0 kg): hemat energi
			2: modify_stats(9, 0, 6)    # Sedang (4.0 - 10.0 kg): kelelahan normal
			3: modify_stats(15, -3, 12) # Berat (> 10.0 kg): menguras tenaga & melukai bahu
			
		if _check_end_conditions():
			return
			
		current_session = Session.PAGI
		current_round += 1
		current_phase = SessionPhase.MORNING_INTRO
		phase_changed.emit(current_round, current_session, current_phase)


func reset_game() -> void:
	current_round = 1
	current_session = Session.PAGI
	current_phase = SessionPhase.MORNING_INTRO
	travel_points = 0.0
	health = 100
	hunger = 15
	stress = 10
	companions = {"bayi": true}
	inventory.clear()
	diary_logs.clear()
	used_event_ids.clear()
	last_lost_item_names.clear()
