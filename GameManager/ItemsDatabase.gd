extends Node

	# Menghubungkan ID dengan file Resource
const ITEM_RESOURCES = {
		"air_mineral": preload("res://Resources/Items/air_mineral.tres"),
		"biskuit_anak": preload("res://Resources/Items/biskuit.tres"),
		"perban_coklat": preload("res://Resources/Items/perban_coklat.tres"),
		"masker": preload("res://Resources/Items/masker.tres"),
		"payung": preload("res://Resources/Items/payung.tres"),
		"anak_kecil": preload("res://Resources/Items/bayi.tres"),
		"obat_obatan": preload("res://Resources/Items/obat_obatan.tres"),
		"dokumen": preload("res://Resources/Items/dokumen.tres"),
		"senter": preload("res://Resources/Items/senter.tres"),
		"baterai": preload("res://Resources/Items/baterai.tres"),
		"jaket": preload("res://Resources/Items/jaket.tres"),
		"botol_susu": preload("res://Resources/Items/botol_susu.tres"),
		"mainan_anak": preload("res://Resources/Items/mainan_anak.tres"),
		"tongkat": preload("res://Resources/Items/tongkat.tres")
	}

	# Data Rooms
const ROOM_ITEMS = {
		"Kitchen": [
			"air_mineral",
			"biskuit_anak",
			"payung",
			"tongkat",
			"senter",
			"baterai",
			"botol_susu",
	        "masker"
		],

		"Family Room": [
			"air_mineral",
			"perban_coklat",
			"masker",
			"anak_kecil",
			"obat_obatan",
			"dokumen",
			"jaket",
			"mainan_anak",
	        "botol_susu"
		],

		"Yard": [
			"perban_coklat",
			"payung",
			"obat_obatan",
			"tongkat",
			"senter",
			"baterai",
			"mainan_anak",
	        "jaket"
		]
	}


func get_random_item(room_name: String) -> ItemData:
		if not ROOM_ITEMS.has(room_name):
			push_warning("Room tidak ditemukan: " + room_name)
			return null

		var room_items = ROOM_ITEMS[room_name]

		if room_items.is_empty():
			return null

		var random_id = room_items.pick_random()

		if not ITEM_RESOURCES.has(random_id):
			push_warning("Resource tidak ditemukan: " + random_id)
			return null

		return ITEM_RESOURCES[random_id]
