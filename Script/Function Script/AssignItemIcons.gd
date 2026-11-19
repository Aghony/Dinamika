@tool
extends EditorScript

const ITEMS_RES_DIR := "res://Resources/Items/"
const ITEMS_ICON_DIR := "res://Assets/Items/"


func _run() -> void:
	var dir := DirAccess.open(ITEMS_RES_DIR)
	if dir == null:
		push_error("Folder tidak ditemukan: " + ITEMS_RES_DIR)
		return
		
	var updated_count: int = 0
	var placeholder_count: int = 0
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var res_path: String = ITEMS_RES_DIR.path_join(file_name)
			var item_res: Resource = load(res_path)
			
			if item_res is ItemData and item_res.id != "":
				var icon_path: String = ITEMS_ICON_DIR.path_join(item_res.id + ".png")
				
				if ResourceLoader.exists(icon_path):
					item_res.icon = load(icon_path)
					updated_count += 1
					print("[OK] Ikon terpasang untuk: ", item_res.id)
				else:
					var placeholder := PlaceholderTexture2D.new()
					placeholder.size = Vector2(64, 64)
					item_res.icon = placeholder
					placeholder_count += 1
					print("[PLACEHOLDER] Gambar belum ada untuk: ", item_res.id)
					
				ResourceSaver.save(item_res, res_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	EditorInterface.get_resource_filesystem().scan()
	print("SELESAI: %d ikon terpasang, %d memakai placeholder." % [updated_count, placeholder_count])
