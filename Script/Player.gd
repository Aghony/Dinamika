extends CharacterBody2D

signal game_over

@export var speed: float = 200.0

var current_weight: float = 0.0
var is_defeated: bool = false
var nearby_item: Area2D = null
var last_direction = "down"
var total_weight: float = 0.0
@onready var body_sprite: AnimatedSprite2D = $Body
@onready var interaction_area: Area2D = $InteractionArea
@onready var face: AnimatedSprite2D = $Face


func _ready():
	update_player_condition()
	interaction_area.area_entered.connect(_on_area_entered)
	interaction_area.area_exited.connect(_on_area_exited)

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		pickup_item()

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
	
func _physics_process(_delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	velocity = direction * speed
	move_and_slide()

	if direction == Vector2.ZERO:
		body_sprite.stop()
		body_sprite.frame = 0
		return

	if abs(direction.x) > abs(direction.y):
		body_sprite.play("Side ")
		body_sprite.flip_h = direction.x < 0

	elif direction.y > 0:
		body_sprite.play("Front")
		body_sprite.flip_h = false

	else:
		body_sprite.play("Back")
		body_sprite.flip_h = false
	


func _on_door_to_yard_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_door_to_kitchen_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	
func _on_area_entered(area: Area2D):
	if area.is_in_group("items"):
		nearby_item = area
		print("Tekan E untuk mengambil: ", area.item_data.display_name)


func _on_area_exited(area: Area2D):
	if area == nearby_item:
		nearby_item = null


func pickup_item():
	if nearby_item == null:
		return

	var item_data = nearby_item.item_data

	total_weight += item_data.weight

	print("Berhasil mengambil: ", item_data.display_name)
	print("Total berat: ", total_weight, " kg")

	nearby_item.queue_free()
	nearby_item = null
	
