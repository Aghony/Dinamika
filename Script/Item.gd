extends Area2D

var item_data: ItemData


func set_item_data(data: ItemData):
	item_data = data

	$Sprite2D.texture = data.icon
	$Sprite2D.scale = Vector2(0.05, 0.05)

	print("Item: ", data.display_name)
	print("Berat: ", data.weight)
