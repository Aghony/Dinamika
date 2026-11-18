extends Control

@onready var empty_label: Label = $InventoryPanel/EmptyLabel
@onready var prev_btn: Button = $InventoryPanel/PrevButton
@onready var next_btn: Button = $InventoryPanel/NextButton
@onready var close_btn: Button = $InventoryPanel/CloseButton

@onready var slot_nodes: Array[Control] = [
	$InventoryPanel/Slot1,
	$InventoryPanel/Slot2,
	$InventoryPanel/Slot3
]

var scroll_index: int = 0


func _ready() -> void:
	hide()
	close_btn.pressed.connect(hide)
	prev_btn.pressed.connect(_on_prev_pressed)
	next_btn.pressed.connect(_on_next_pressed)
	GameState.inventory_updated.connect(_refresh_slots)


func open_popup() -> void:
	scroll_index = 0
	_refresh_slots()
	show()


func _refresh_slots() -> void:
	var total_items := GameState.inventory.size()
	empty_label.visible = (total_items == 0)
	
	# Pastikan scroll_index tetap aman jika ada item yang baru saja habis
	if scroll_index > max(0, total_items - 3):
		scroll_index = max(0, total_items - 3)
		
	for i in range(3):
		var slot_panel := slot_nodes[i]
		var data_index := scroll_index + i
		
		if data_index < total_items:
			var slot_data := GameState.inventory[data_index]
			var item_info := GameState.get_item_data(slot_data["id"])
			
			var icon_rect: TextureRect = slot_panel.get_node("ItemIcon")
			var name_lbl: Label = slot_panel.get_node("ItemNameLabel")
			var qty_lbl: Label = slot_panel.get_node("QuantityLabel")
			
			if item_info != null:
				name_lbl.text = item_info.display_name
				if item_info.icon != null:
					icon_rect.texture = item_info.icon
				else:
					var placeholder := PlaceholderTexture2D.new()
					placeholder.size = Vector2(64, 64)
					icon_rect.texture = placeholder
			else:
				name_lbl.text = slot_data["id"]
				
			qty_lbl.text = "x%d" % slot_data["quantity"]
			slot_panel.show()
		else:
			slot_panel.hide()
			
	# Atur aktif/nonaktif tombol panah geser
	prev_btn.disabled = (scroll_index <= 0)
	next_btn.disabled = (scroll_index + 3 >= total_items)


func _on_prev_pressed() -> void:
	if scroll_index > 0:
		scroll_index -= 1
		_refresh_slots()


func _on_next_pressed() -> void:
	if scroll_index + 3 < GameState.inventory.size():
		scroll_index += 1
		_refresh_slots()
