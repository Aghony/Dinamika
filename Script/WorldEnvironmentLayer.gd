extends Control

@onready var sky_bg: ColorRect = $SkyBackground
@onready var layer3_far: Control = $Layer3_FarBuildings
@onready var road_ground: ColorRect = $RoadGround
@onready var layer2_props: Control = $Layer2_Props

var layer2_buildings: Control = null
var time_tween: Tween = null

const RESIDENTIAL_BUILDINGS: Array[String] = ["rumah_hijau.png", "rumah_biru.png"]
const COMMERCIAL_BUILDINGS: Array[String] = ["ruko.png", "warung.png", "rumah_biru.png"]
const EVAC_ZONE_BUILDINGS: Array[String] = ["pos_ronda.png", "ruko.png", "warung.png"]

const LAYER2_PROPS_ITEMS: Array[String] = [
	"pohon_beringin.png",
	"motor_honda.png",
	"motor_astrea.png",
	"motor_vespa.png",
	"motor_supra.png",
	"gerobak_kopi.png",
	"gerobak_bakso.png",
	"dekorasi_tumbuhan.png"
]

const SKY_MORNING_COLOR := Color(0.86, 0.76, 0.65, 1.0)
const SKY_NIGHT_COLOR := Color(0.14, 0.17, 0.28, 1.0)

var texture_cache: Dictionary = {}


func _ready() -> void:
	layer2_buildings = get_node_or_null("Layer2_NearBuildings")
	if layer2_buildings == null:
		layer2_buildings = get_node_or_null("Layer2_NearBuilding")
		
	_scan_and_trim_assets("res://Assets/")


# Memindai seluruh gambar dan memotong margin transparan agar pijakan bawah 100% akurat
func _scan_and_trim_assets(folder_path: String) -> void:
	var dir := DirAccess.open(folder_path)
	if dir == null:
		return
		
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
			
		var full_path: String = folder_path.path_join(file_name)
		if dir.current_is_dir():
			_scan_and_trim_assets(full_path)
		else:
			var clean_name: String = file_name.trim_suffix(".import")
			if clean_name.ends_with(".png") or clean_name.ends_with(".webp"):
				var clean_path: String = folder_path.path_join(clean_name)
				if ResourceLoader.exists(clean_path) and not texture_cache.has(clean_name):
					var raw_tex: Texture2D = load(clean_path)
					texture_cache[clean_name] = _create_tight_texture(raw_tex)
		file_name = dir.get_next()
	dir.list_dir_end()


func _create_tight_texture(raw_tex: Texture2D) -> Texture2D:
	var img: Image = raw_tex.get_image()
	if img == null:
		return raw_tex
		
	img.convert(Image.FORMAT_RGBA8)
	
	# Jika sudut kiri atas gambar tidak transparan (misal kotak abu-abu pada motor), buat transparan
	var corner_color: Color = img.get_pixel(0, 0)
	if corner_color.a > 0.9:
		for y in range(img.get_height()):
			for x in range(img.get_width()):
				var px: Color = img.get_pixel(x, y)
				if px.is_equal_approx(corner_color) or (absf(px.r - corner_color.r) < 0.04 and absf(px.g - corner_color.g) < 0.04 and absf(px.b - corner_color.b) < 0.04):
					img.set_pixel(x, y, Color(0, 0, 0, 0))
					
	var used_rect: Rect2i = img.get_used_rect()
	if used_rect.size.x <= 0 or used_rect.size.y <= 0:
		return raw_tex
		
	var clean_tex := ImageTexture.create_from_image(img)
	var atlas := AtlasTexture.new()
	atlas.atlas = clean_tex
	atlas.region = Rect2(used_rect)
	return atlas


func generate_for_day(round_num: int) -> void:
	if texture_cache.is_empty():
		_scan_and_trim_assets("res://Assets/")
		
	_clear_children(layer3_far)
	if layer2_buildings != null:
		_clear_children(layer2_buildings)
	_clear_children(layer2_props)
	
	var view_width: float = get_viewport_rect().size.x
	if view_width <= 0.0:
		view_width = 1152.0
		
	# Satu patokan garis tanah untuk semua layer (bagian atas RoadGround)
	var ground_y: float = road_ground.position.y
	if ground_y <= 0.0:
		ground_y = 550.0
		
	# --- 1. LAYER 3: GEDUNG TINGGI LATAR (Menjulang di belakang) ---
	var far_heights: Array[float] = [330.0, 440.0, 310.0, 410.0, 340.0]
	var far_count: int = far_heights.size()
	for i in range(far_count):
		var slot_x: float = (view_width / float(far_count)) * (i + 0.5)
		var far_tint: Color = Color(0.85, 0.82, 0.80, 0.42)
		_spawn_on_ground(layer3_far, "hotel_1.png", slot_x, ground_y, far_heights[i], far_tint)
		
	# --- 2. LAYER 2A: DERETAN BANGUNAN DEKAT (Satu garis lurus & sejajar) ---
	if layer2_buildings != null:
		var building_pool: Array[String] = _get_building_pool_for_day(round_num)
		var near_count: int = 5
		var last_building: String = ""
		var building_height: float = 215.0 # Tinggi seragam agar atap & pintu sejajar rapi
		
		for i in range(near_count):
			var slot_x: float = (view_width / float(near_count)) * (i + 0.5)
			var chosen_b: String = _pick_non_repeating(building_pool, last_building)
			last_building = chosen_b
			_spawn_on_ground(layer2_buildings, chosen_b, slot_x, ground_y, building_height, Color.WHITE)
		
	# --- 3. LAYER 2B: POHON, KENDARAAN & GEROBAK (Sejajar di trotoar depan bangunan) ---
	var prop_slots: Array[float] = [
		view_width * 0.14,
		view_width * 0.36,
		view_width * 0.64,
		view_width * 0.86
	]
	var last_prop: String = ""
	var sidewalk_y: float = ground_y + 4.0 # Sedikit lebih depan dari bangunan
	
	for prop_x in prop_slots:
		var chosen_p: String = _pick_non_repeating(LAYER2_PROPS_ITEMS, last_prop)
		last_prop = chosen_p
		var item_height: float = _get_prop_height(chosen_p)
		_spawn_on_ground(layer2_props, chosen_p, prop_x, sidewalk_y, item_height, Color.WHITE)


func _get_prop_height(file_name: String) -> float:
	if file_name == "pohon_beringin.png":
		return 265.0 # Lebih tinggi dari rumah 1 lantai
	elif file_name.begins_with("gerobak"):
		return 135.0 # Setinggi bahu/kepala karakter
	elif file_name == "dekorasi_tumbuhan.png":
		return 45.0  # Semak kecil setinggi lutut
	else:
		return 75.0  # Motor setinggi pinggang karakter


func update_time_of_day(is_morning: bool) -> void:
	if time_tween != null and time_tween.is_valid():
		time_tween.kill()
		
	var target_sky: Color = SKY_MORNING_COLOR if is_morning else SKY_NIGHT_COLOR
	var target_far: Color = Color(1.0, 0.95, 0.90, 1.0) if is_morning else Color(0.45, 0.50, 0.65, 1.0)
	var target_near: Color = Color(1.0, 0.97, 0.94, 1.0) if is_morning else Color(0.55, 0.60, 0.75, 1.0)
	var target_props: Color = Color.WHITE if is_morning else Color(0.60, 0.65, 0.80, 1.0)
	
	time_tween = create_tween().set_parallel(true)
	time_tween.tween_property(sky_bg, "color", target_sky, 0.65).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	time_tween.tween_property(layer3_far, "modulate", target_far, 0.65).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if layer2_buildings != null:
		time_tween.tween_property(layer2_buildings, "modulate", target_near, 0.65).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	time_tween.tween_property(layer2_props, "modulate", target_props, 0.65).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _get_building_pool_for_day(round_num: int) -> Array[String]:
	if round_num <= 2:
		return RESIDENTIAL_BUILDINGS
	elif round_num <= 5:
		return COMMERCIAL_BUILDINGS
	else:
		return EVAC_ZONE_BUILDINGS


func _pick_non_repeating(pool: Array[String], exclude: String) -> String:
	if pool.is_empty():
		return ""
	if pool.size() == 1:
		return pool[0]
	var candidate: String = pool.pick_random()
	while candidate == exclude:
		candidate = pool.pick_random()
	return candidate


func _spawn_on_ground(parent: Control, file_name: String, center_x: float, bottom_y: float, target_height: float, tint: Color) -> void:
	var tex_rect := TextureRect.new()
	tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex_rect.stretch_mode = TextureRect.STRETCH_SCALE
	tex_rect.modulate = tint
	
	var target_width: float = target_height
	if texture_cache.has(file_name):
		var tex: Texture2D = texture_cache[file_name]
		tex_rect.texture = tex
		var tex_size: Vector2 = tex.get_size()
		if tex_size.y > 0.0:
			target_width = target_height * (tex_size.x / tex_size.y)
	else:
		var placeholder := PlaceholderTexture2D.new()
		placeholder.size = Vector2(target_width, target_height)
		tex_rect.texture = placeholder
		
	tex_rect.size = Vector2(target_width, target_height)
	tex_rect.position = Vector2(
		center_x - (target_width * 0.5),
		bottom_y - target_height
	)
	
	parent.add_child(tex_rect)


func _clear_children(container: Control) -> void:
	for child in container.get_children():
		child.queue_free()
