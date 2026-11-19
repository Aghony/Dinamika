extends Control

@onready var inventory_panel: Control = $InventoryPanel
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
var open_tween: Tween = null


func _ready() -> void:
	hide()
	close_btn.pressed.connect(close_popup)
	prev_btn.pressed.connect(_on_prev_pressed)
	next_btn.pressed.connect(_on_next_pressed)
	GameState.inventory_updated.connect(_refresh_slots)


func open_popup() -> void:
	scroll_index = 0
	_refresh_slots()
	_play_open_animation()


func close_popup() -> void:
	if open_tween != null and open_tween.is_valid():
		open_tween.kill()
	hide()


func _play_open_animation() -> void:
	if open_tween != null and open_tween.is_valid():
		open_tween.kill()
	show()
	if inventory_panel == null:
		return
	await get_tree().process_frame
	inventory_panel.pivot_offset = inventory_panel.size * 0.5
	inventory_panel.scale = Vector2(0.92, 0.92)
	inventory_panel.modulate.a = 0.0
	open_tween = create_tween().set_parallel(true)
	open_tween.tween_property(inventory_panel, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(inventory_panel, "modulate:a", 1.0, 0.16)


func _refresh_slots() -> void:
	var total_items := GameState.inventory.size()
	empty_label.visible = (total_items == 0)
	
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
