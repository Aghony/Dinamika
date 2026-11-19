extends Area2D

@export_file("*.tscn") var next_room: String
@export var target_spawn: String

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if not body.is_in_group("player"):
		return

	if next_room.is_empty() or target_spawn.is_empty():
		return

	RoomTransition.change_room(next_room, target_spawn)
