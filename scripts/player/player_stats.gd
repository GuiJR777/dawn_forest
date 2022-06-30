extends Node

class_name PlayerStats

export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var collision_area = get_node(collision_area) as Area2D
export(NodePath) onready var invencibility_timer = get_node("invencibility_timer")
export(PackedScene) var floating_text

const MAX_LEVEL: int = 10
const MIN_HEALTH_VALUE: int = 0


var is_blocking_the_attack: bool = false

var base_health_points: int = 15
var base_mana_points: int = 10
var base_attack_points: int = 1
var base_magic_attack_points: int = 3
var base_defense_points: int = 1

var bonus_health_points: int = 0
var bonus_mana_points: int = 0
var bonus_attack_points: int = 0
var bonus_magic_attack_points: int = 0
var bonus_defense_points: int = 0

var current_health: int
var current_mana: int

var max_health: int
var max_mana: int

var current_experience: int = 0
var level: int = 1

var experience_for_level_map: Dictionary = {
	1: 25,
	2: 58,
	3: 107,
	4: 173,
	5: 266,
	6: 401,
	7: 587,
	8: 838,
	9: 1194,
	10: 2089,
}

func _ready():
	__turn_hp_and_mp_max()

	max_health = current_health
	max_mana = current_mana
	
	get_tree().call_group("bar_container", "init_stats_bar", max_health, max_mana, experience_for_level_map[level])

func __turn_hp_and_mp_max() -> void:
	current_health = base_health_points + bonus_health_points
	current_mana = base_mana_points + bonus_mana_points
	get_tree().call_group("bar_container", "update_bar", "HP", current_health)
	get_tree().call_group("bar_container", "update_bar", "MP", current_mana)

func update_experience(value: int) -> void:
	current_experience += value
	spawn_floating_text("+", "XP", value)
	get_tree().call_group("bar_container", "update_bar", "XP", current_experience)
	if current_experience >= experience_for_level_map[level] and level < MAX_LEVEL:
		__level_up()
	elif current_experience >= experience_for_level_map[level] and level == MAX_LEVEL:
		current_experience = experience_for_level_map[level]

func __level_up() -> void:
	level += 1
	__turn_hp_and_mp_max()
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().call_group("bar_container", "update_debug_level_label", level)
	get_tree().call_group(
		"bar_container", "set_new_values", "XP", experience_for_level_map[level], current_experience, experience_for_level_map[level-1]
		)
	yield(get_tree().create_timer(1), "timeout")
	spawn_floating_text("", "LEVEL", 0)
	
func take_damage(value: int) -> void:
	var damage: int = __apply_defense(value)
	current_health -= damage
	spawn_floating_text("-", "DAMAGE", damage)
	if damage > 0 and current_health > MIN_HEALTH_VALUE:
		player.is_take_damage = true
		player.is_attacking = false
	if current_health <= MIN_HEALTH_VALUE:
		current_health = MIN_HEALTH_VALUE
		player.is_dead = true
	__update_bar("HP", current_health)
	
func __apply_defense(value: int) -> int:
	if is_blocking_the_attack:
		var total_defense = base_defense_points + base_defense_points
		if value > total_defense:
			return int(abs(total_defense - value))
		return 0
	return value
	
func healing(value: int) -> void:
	current_health += value
	spawn_floating_text("+", "HP", value)
	if current_health > max_health:
		current_health = max_health
	__update_bar("HP", current_health)

	
func consume_mana(value: int) -> void:
	current_mana -= value
	spawn_floating_text("-", "MP", value)
	__update_bar("MP", current_mana)
	
func recovery_mana(value: int) -> void:
	current_mana += value
	spawn_floating_text("+", "MP", value)
	if current_mana > max_mana:
		current_mana = max_mana
	__update_bar("MP", current_mana)

func __update_bar(bar_name: String, value: int) -> void:
	get_tree().call_group("bar_container", "update_bar", bar_name, value)

#testes
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print("Vida atual: " + str(current_health))
		take_damage(5)
		print("Vida apos dano: " + str(current_health))


func _on_CollisionArea_area_entered(area):
	if area.name == "EnemyAttackArea":
		var attack_enemy_value: int = area.attack_damage
		take_damage(attack_enemy_value)
		collision_area.set_deferred("monitoring", false)
		invencibility_timer.start(area.invencibility_time)


func _on_invencibility_timer_timeout():
	collision_area.set_deferred("monitoring", true)
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatingText = floating_text.instance()
	text.rect_global_position = player.global_position
	text.type = type
	text.type_sign = type_sign
	text.value = value
	
	get_tree().root.call_deferred("add_child", text)
