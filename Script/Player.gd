extends CharacterBody2D

signal game_over

@export var speed: float = 200.0

var current_weight: float = 0.0
var is_defeated: bool = false

@onready var face: AnimatedSprite2D = $Face

func _ready():
	update_player_condition()


func add_item_weight(item_weight: float) -> bool:
	if is_defeated or item_weight <= 0.0:
		return false

	current_weight += item_weight

	print("Current Weight: ", current_weight, " kg")

	update_player_condition()

	return not is_defeated


func remove_item_weight(item_weight: float):
	if is_defeated:
		return

	current_weight = maxf(0.0, current_weight - item_weight)

	print("Current Weight: ", current_weight, " kg")

	update_player_condition()


func update_player_condition():

	if current_weight > 15.0:
		face.play("defeated")
		trigger_game_over()

	elif current_weight > 10.0:
		face.play("worried")

	elif current_weight > 4.0:
		face.play("neutral")

	else:
		face.play("relaxed")


func trigger_game_over():
	if is_defeated:
		return

	is_defeated = true
	game_over.emit()
	print("GAME OVER!")
	
func _physics_process(_delta: float) -> void:
	if is_defeated:
		velocity = Vector2.ZERO
		return
		
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)
	print("Direction: ",direction)
	velocity = direction * speed
	move_and_slide()
	


func _on_door_to_yard_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_door_to_kitchen_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
