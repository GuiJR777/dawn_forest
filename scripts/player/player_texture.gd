extends Sprite

class_name PlayerTexture

signal game_over

const STOP_VALUE: int = 0
const RIGHT_DIRECTION: String = "_right"
const LEFT_DIRECTION: String = "_left"
const DEFAULT_OFFSET_FOR_WALL_JUMP = Vector2(-2, 0)
const LOOK_RIGHT_RAY_CAST_POSITION = Vector2(5.5, 0)
const LOOK_LEFT_RAY_CAST_POSITION = Vector2(-7.5, 0)

export(NodePath) onready var attack_collision = get_node(attack_collision) as CollisionShape2D
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D

var face_direction_is_left: bool = false
var normal_attack: bool = false
var shield_off: bool = false
var crouch_off: bool = false

var direction_name: String = RIGHT_DIRECTION


func animate(direction: Vector2) -> void:
	__set_face_direction(direction.x)
	if player.is_take_damage or player.is_dead:
		__damage_behavior()
	elif player.is_attacking or player.is_crouching or player.is_defending or player.is_next_to_wall():
		__action_behavior()
	elif direction.y != STOP_VALUE:
		__vertical_behavior(direction.y)
	elif player.is_landing:
		animation_player.play("landing")
		player.set_physics_process(false)
	else:
		__horizontal_behavior(direction.x)


func __set_face_direction(direction_in_x: float) -> void:
	flip_h = face_direction_is_left
	
	if face_direction_is_left:
		direction_name = LEFT_DIRECTION
		position = DEFAULT_OFFSET_FOR_WALL_JUMP
		player.normal_direction = 1
		player.wall_ray.cast_to = LOOK_LEFT_RAY_CAST_POSITION
	else:
		direction_name = RIGHT_DIRECTION
		position = Vector2.ZERO
		player.normal_direction = -1
		player.wall_ray.cast_to = LOOK_RIGHT_RAY_CAST_POSITION
	
	if direction_in_x != STOP_VALUE:
		face_direction_is_left = direction_in_x < STOP_VALUE

func __damage_behavior() -> void:
	attack_collision.set_deferred("disabled", true)
	player.set_physics_process(false)
	if player.is_take_damage:
		animation_player.play("take_damage")
	elif player.is_dead:
		animation_player.play("dead")

func __action_behavior():
	if player.is_next_to_wall():
		animation_player.play("wall_slide")
	elif player.is_attacking and normal_attack:
		animation_player.play("attack" + direction_name)
	elif player.is_defending and shield_off:
		animation_player.play("defend")
		shield_off = false
	elif player.is_crouching and crouch_off:
		animation_player.play("crouch")
		crouch_off = false


func __vertical_behavior(direction_in_y: float) -> void:
	if direction_in_y > STOP_VALUE:
		animation_player.play("fall")
		player.is_landing = true
	elif direction_in_y < STOP_VALUE:
		animation_player.play("jump")


func __horizontal_behavior(direction_in_x: float) -> void:
	if direction_in_x != STOP_VALUE:
		animation_player.play("run")
	else:
		animation_player.play("idle")



func _on_animation_finished(animation_name: String) -> void:
	match animation_name:
		"landing":
			player.is_landing = false
			player.set_physics_process(true)
		"pick_item":
			player.set_physics_process(true)
		"attack_left":
			player.is_attacking = false
			normal_attack = false
			
		"attack_right":
			player.is_attacking = false
			normal_attack = false
		"take_damage":
			player.set_physics_process(true)
			player.is_take_damage = false
			
			if player.is_defending:
				animation_player.play("defend")
			if player.is_crouching:
				animation_player.play("crouch")
		"dead":
			emit_signal("game_over")
