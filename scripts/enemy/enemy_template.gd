extends KinematicBody2D

class_name EnemyTemplate

const MIN_DISTANCE_TO_TARGET: int = 5
const SPAWNABLE_ITEM_SCENE_PATH: String = "res://scenes/enviroments/item.tscn"

signal kill

onready var texture: Sprite = get_node("Texture")
onready var floor_ray: RayCast2D = get_node("FloorRay")
onready var drop_dice: DropItensDice = get_node("DropItensDice")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

export(int) var speed
export(int) var xp_reward
export(int) var gravity
export(bool) var can_patrol
export(int) var proximity_threshold
export(int) var raycast_default_position
export(PackedScene) var floating_text

var start_position: Vector2
var end_position: Vector2
var target: Vector2

var is_dead: bool = false
var is_taking_damage: bool = false
var can_attack: bool = false

var velocity: Vector2
var face_direction: int = -1
var player_reference: Player = null
var drops_map: Dictionary


func _ready():
	randomize()
	var spawner: EnemySpawner = get_parent()
	
	if spawner:
		start_position = Vector2(spawner.global_position.x + spawner.max_spawn_position_to_right, global_position.y)
		end_position = Vector2(spawner.global_position.x - spawner.max_spawn_position_to_leaft, global_position.y)
		target = end_position
		can_patrol = bool(rand_range(0, 1))
		

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
	var distance: Vector2 = target - global_position
	var direction: Vector2 = distance.normalized()
	
	face_direction = sign(target.x - global_position.x)
	
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
	get_tree().call_group("player_stats", "update_experience", xp_reward)
	animation_player.play("kill")
	emit_signal("kill")
	var sorted_itens: Array = drop_dice.spawn_item_probability(drops_map)
	for  sorted_item in sorted_itens:
		spawn_item(sorted_item[0], sorted_item[1], sorted_item[2])

func spawn_item(item: String, item_texture: StreamTexture, item_infos: Array) -> void:
	var item_scene = load(SPAWNABLE_ITEM_SCENE_PATH)
	var physic_item: PhysicItem = item_scene.instance()
	get_tree().root.call_deferred("add_child", physic_item)
	physic_item.global_position = global_position
	physic_item.set_item_infos(item, item_texture, item_infos)
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatingText = floating_text.instance()
	text.rect_global_position = global_position
	text.type = type
	text.type_sign = type_sign
	text.value = value
	
	get_tree().root.call_deferred("add_child", text)

