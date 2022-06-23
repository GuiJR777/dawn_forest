extends KinematicBody2D

class_name EnemyTemplate

const MIN_DISTANCE_TO_TARGET: int = 5


onready var texture: Sprite = get_node("Texture")
onready var floor_ray: RayCast2D = get_node("FloorRay")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

export(int) var speed
export(int) var gravity
export(bool) var can_patrol
export(int) var proximity_threshold
export(int) var raycast_default_position

export(NodePath) onready var start_position = get_node(start_position) as Position2D
export(NodePath) onready var end_position = get_node(end_position) as Position2D
onready var target: Position2D = end_position

var is_dead: bool = false
var is_taking_damage: bool = false
var can_attack: bool = false

var velocity: Vector2
var face_direction: int = -1
var player_reference: Player = null


func _physics_process(delta):
	__apply_gravity(delta)
	__verify_player_position()
	__move_behaviour()
	texture.animate(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	

func __apply_gravity(delta: float) -> void:
	var gravity_to_apply: int = gravity
	
	velocity.y += delta * gravity_to_apply
	if velocity.y >= gravity_to_apply:
		velocity.y = gravity_to_apply


func __move_behaviour() -> void:
	if player_reference != null:
		__pursuit_player()
	else:
		can_attack = false
		if can_patrol:
			__patrol()
		else:
			velocity.x = 0
	
func __patrol() -> void:
	var arrived_on_target: bool = __is_walking_to_target()
	if arrived_on_target:
		__change_target()

func __change_target() -> void:
	if target == start_position:
		target = end_position
	elif target == end_position:
		target = start_position

func __is_walking_to_target() -> bool:
	var distance: Vector2 = target.global_position - global_position
	var direction: Vector2 = distance.normalized()
	
	face_direction = sign(target.global_position.x - global_position.x)
	
	if face_direction > 0:
		__turn_to_right()
	elif face_direction < 0:
		__turn_to_left()
	
	if abs(distance.x) <= MIN_DISTANCE_TO_TARGET:
		return true
	elif __have_floor_colision() and not can_attack:
		velocity.x = direction.x * speed
	return false

func __pursuit_player() -> void:
	var distance: Vector2 = player_reference.global_position - global_position
	var direction: Vector2 = distance.normalized()
	
	if abs(distance.x) <= proximity_threshold:
		velocity.x = 0
		can_attack = true
	elif __have_floor_colision() and not can_attack:
		velocity.x = direction.x * speed
	else:
		velocity.x = 0
		
func __have_floor_colision() -> bool:
	return floor_ray.is_colliding()

func __verify_player_position() -> void:
	if player_reference != null:
		face_direction = sign(player_reference.global_position.x - global_position.x)
		
		if face_direction > 0:
			__turn_to_right()
		elif face_direction < 0:
			__turn_to_left()

func __turn_to_right() -> void:
	texture.flip_h = true
	floor_ray.position.x = abs(raycast_default_position)
	face_direction = 1

func __turn_to_left() -> void:
	texture.flip_h = false
	floor_ray.position.x = raycast_default_position
	face_direction = -1
	
func kill_enemy():
	animation_player.play("kill")

