extends Node2D

class_name EnemySpawner


onready var spawn_timer: Timer = get_node("Timer")

export(Array, Dictionary) var enemies
export(float) var spawn_cooldown
export(int) var max_enemy_amount
export(int) var max_spawn_position_to_leaft
export(int) var max_spawn_position_to_right
export(bool) var can_respawn = false


var enemy_count: int = 0

func _ready():
	randomize()
	__spawn_enemy()


func __spawn_enemy() -> void:
	enemy_count += 1
	var sorted_probility: int = randi() % 100 + 1
	
	for enemy in enemies:
		if __can_spawn(enemy, sorted_probility):
			var enemy_instance = load(enemy.get("scene_path")).instance()
			enemy_instance.connect("kill", self, "__on_enemy_killed")
			enemy_instance.global_position = Vector2(
				__get_spawn_position(),
				-enemy.get("floor_offset")
				)
			add_child(enemy_instance)
	
	if enemy_count < max_enemy_amount:
		spawn_timer.start(spawn_cooldown)


func __can_spawn(enemy: Dictionary, sorted_probility: int) -> bool:
	if (
		enemy.get("min_spawn_probability") <= sorted_probility and
		enemy.get("max_spawn_probability") > sorted_probility
		):
		return true
	return false


func __get_spawn_position() -> float:
	return rand_range(-max_spawn_position_to_leaft, max_spawn_position_to_right)


func __on_enemy_killed() -> void:
	enemy_count -= 1
	spawn_timer.start(spawn_cooldown)


func _on_Timer_timeout() -> void:
	if can_respawn:
		__spawn_enemy()
