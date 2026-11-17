extends CanvasLayer

@onready var inventory_panel = $InventoryPanel

var inventory = []
var max_slots = 12

func _ready():
	inventory_panel.hide()

func toggle_inventory():
	inventory_panel.visible = !inventory_panel.visible

func add_item(item_name: String):
	# Cek apakah barang sudah ada
	for item in inventory:
		if item["name"] == item_name:
			item["quantity"] += 1
			print(inventory)
			return

	# Jika barang belum ada
	if inventory.size() < max_slots:
		inventory.append({
			"name": item_name,
			"quantity": 1
		})
		print(inventory)
	else:
		print("Inventory penuh!")
