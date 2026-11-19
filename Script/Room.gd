
extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var spawn_points: Node2D = $SpawnPoints

func _ready():
	if player == null:
		push_error("Player tidak ditemukan!")
		return

	if spawn_points == null:
		push_error("SpawnPoints tidak ditemukan!")
		return

	var spawn = spawn_points.get_node_or_null(
		RoomTransition.target_spawn
	)

	if spawn != null:
		player.global_position = spawn.global_position
	else:
		push_error(
            "Spawn point tidak ditemukan: "
			+ RoomTransition.target_spawn
		)
