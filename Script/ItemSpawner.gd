
extends Node2D

@export_enum("Kitchen", "Family Room", "Yard")
var room_name: String = "Kitchen"

@export var item_scene: PackedScene
@export var spawn_count: int = 5

@onready var spawn_area: CollisionShape2D = $Area2D/CollisionShape2D


func _ready():
	spawn_random_items()


func spawn_random_items():
	if item_scene == null:
		push_error("Item.tscn belum diatur!")
		return

	var rect := spawn_area.shape as RectangleShape2D

	if rect == null:
		push_error("SpawnArea harus RectangleShape2D!")
		return

	for i in range(spawn_count):
		var data = ItemDatabase.get_random_item(room_name)

		if data == null:
			continue

		var item = item_scene.instantiate()
		add_child(item)

		item.set_item_data(data)
		item.global_position = get_random_position(rect)


func get_random_position(rect: RectangleShape2D) -> Vector2:
	var half = rect.size / 2.0

	var offset = Vector2(
		randf_range(-half.x, half.x),
		randf_range(-half.y, half.y)
	)

	return spawn_area.global_position + offset
