extends Area2D

class_name EnemyHitbox

const MIN_HEALTH_VALUE: int = 0

onready var timer: Timer = get_node("Timer")
onready var debug_hp: Label = get_node("DebugHp")
export(NodePath) onready var enemy = get_node(enemy) as EnemyTemplate


export(int) var health_points
export(float) var invencible_time



func _process(_delta):
	debug_hp.text = str(health_points)


func take_damage(value: int) -> void:
	health_points -= value
	
	if health_points <= MIN_HEALTH_VALUE:
		health_points = MIN_HEALTH_VALUE
		enemy.is_dead = true
		return
	enemy.is_taking_damage = true


func _on_HitBox_area_entered(area):
	var parent = area.get_parent()
	if area.name == "AttackArea" and parent is Player:
		var player_stats: Node = parent.get_node("Stats")
		var player_attack: int = player_stats.base_attack_points + player_stats.bonus_attack_points
		take_damage(player_attack)
		
		if not enemy.player_reference:
			enemy.player_reference = parent
	elif area.name == "FireSpell":
		take_damage(area.damage)
