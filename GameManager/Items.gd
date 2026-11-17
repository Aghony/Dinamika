extends Node

const ITEMS = [
	{
		"id": "air_mineral",
		"name": "Air Mineral",
		"weight": 0.5,
		"max_amount": 10,
		"effect": "Kehausan"
	},
	{
		"id": "makanan",
		"name": "Makanan",
		"weight": 0.3,
		"max_amount": 5,
		"effect": "Makanan"
	},
	{
		"id": "biskuit_anak",
		"name": "Biskuit Anak",
		"weight": 0.25,
		"max_amount": 15,
		"effect": "Makanan"
	},
	{
		"id": "perban_coklat",
		"name": "Perban Coklat",
		"weight": 0.25,
		"max_amount": 3,
		"effect": "Pegal"
	},
	{
		"id": "masker",
		"name": "Masker",
		"weight": 0.1,
		"max_amount": 5,
		"effect": "Asap berbahaya"
	},
	{
		"id": "payung",
		"name": "Payung",
		"weight": 0.35,
		"max_amount": 1,
		"effect": "Hujan"
	},
	{
		"id": "anak_kecil",
		"name": "Anak Kecil",
		"weight": 4.4,
		"max_amount": 1,
		"effect": ""
	},
	{
		"id": "obat_obatan",
		"name": "Obat-obatan",
		"weight": 0.5,
		"max_amount": 1,
		"effect": "Sakit"
	},
	{
		"id": "alat_setrum",
		"name": "Alat Setrum",
		"weight": 0.35,
		"max_amount": 1,
		"effect": "Pencuri"
	},
	{
		"id": "dokumen",
		"name": "Dokumen",
		"weight": 1.0,
		"max_amount": 1,
		"effect": "Pos pemeriksaan"
	},
	{
		"id": "senter",
		"name": "Senter",
		"weight": 0.15,
		"max_amount": 1,
		"effect": "Malam hari"
	},
	{
		"id": "baterai",
		"name": "Baterai",
		"weight": 0.1,
		"max_amount": 2,
		"effect": "Malam hari"
	},
	{
		"id": "jaket",
		"name": "Jaket",
		"weight": 0.7,
		"max_amount": 1,
		"effect": "Masuk angin"
	},
	{
		"id": "botol_susu",
		"name": "Botol Susu",
		"weight": 0.1,
		"max_amount": 5,
		"effect": "Untuk anak"
	},
	{
		"id": "mainan_anak",
		"name": "Mainan Anak",
		"weight": 0.3,
		"max_amount": 1,
		"effect": "Untuk anak"
	}
]

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


	#func get_random_item() -> Dictionary:
		#var random_index = randi_range(0, ItemData.ITEMS.size() - 1)
	#
		#return ItemData.ITEMS[random_index]
