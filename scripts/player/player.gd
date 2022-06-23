extends KinematicBody2D

class_name Player

const MAX_JUMPS: int = 2

onready var sprite: Sprite = get_node("Texture")
onready var wall_ray: RayCast2D = get_node("WallRay")
onready var stats: Node = get_node("Stats")

export(int) var speed
export(int) var jump_speed
export(int) var wall_jump_speed
export(int) var gravity
export(int) var wall_friction
export(int) var wall_normal_speed

var velocity: Vector2
var normal_direction: int = 1
var jump_count: int = 0
var is_landing: bool = false
var is_on_wall: bool = false
var is_hanging: bool = false
var is_attacking: bool = false
var is_defending: bool = false
var is_crouching: bool = false
var is_dead: bool = false
var is_take_damage: bool = false
var can_track_input: bool = false


func _physics_process(delta: float):
	__horizontal_movement()
	__vertical_movement()
	__actions_movements()
	__apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	sprite.animate(velocity)


func __horizontal_movement() -> void:
	var input_direction: float = Input.get_action_strength("right_direction") - Input.get_action_strength("left_direction")
	if can_track_input == false or is_attacking:
		velocity.x = 0
		return
	velocity.x = input_direction * speed

func is_next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not is_hanging:
			velocity.y = 0
			is_hanging = true
		return true
	else:
		is_hanging = false
		return false


func __vertical_movement() -> void:
	if is_on_floor() or is_on_wall():
		jump_count = 0
	
	var can_jump: bool = jump_count < MAX_JUMPS and can_track_input and not is_attacking
	if Input.is_action_just_pressed("jump") and can_jump:
		jump_count += 1
		if is_next_to_wall() and not is_on_floor():
			velocity.y = jump_speed
			velocity.x += wall_normal_speed * normal_direction
			return
		velocity.y = jump_speed


func __actions_movements() -> void:
	__attack()
	__crouch()
	__defense()


func __can_attack() -> bool:
	return (
		not is_attacking and
		not is_crouching and
		not is_defending and
		is_on_floor()
		)


func __attack() -> void:
	if Input.is_action_just_pressed("attack") and __can_attack():
		is_attacking = true
		sprite.normal_attack = true


func __crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not is_defending:
		is_crouching = true
		can_track_input = false
		stats.is_blocking_the_attack = false
	elif not is_defending:
		is_crouching = false
		can_track_input = true
		sprite.crouch_off = true
		stats.is_blocking_the_attack = false


func __defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not is_crouching:
		is_defending = true
		stats.is_blocking_the_attack = true
		can_track_input = false
	elif not is_crouching:
		is_defending = false
		stats.is_blocking_the_attack = false
		can_track_input = true
		sprite.shield_off = true


func __apply_gravity(delta: float) -> void:
	var gravity_to_apply: int = gravity
	if is_next_to_wall():
		gravity_to_apply = gravity - wall_friction
	
	velocity.y += delta * gravity_to_apply
	if velocity.y >= gravity_to_apply:
		velocity.y = gravity_to_apply
