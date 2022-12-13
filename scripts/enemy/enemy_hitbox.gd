extends Area2D

class_name EnemyHitbox

const MIN_HEALTH_VALUE: int = 0

onready var timer: Timer = get_node("Timer")
export(NodePath) onready var enemy = get_node(enemy) as EnemyTemplate
export(NodePath) onready var enemy_bar = get_node(enemy_bar) as EnemyHealthBar


export(int) var health_points
export(float) var invencible_time


func _ready() -> void:
	enemy_bar.init_bar(health_points)

func take_damage(value: int) -> void:
	health_points -= value
	enemy_bar.update_bar(health_points)
	enemy.spawn_floating_text("-", "DAMAGE", value)
	
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
	elif area is FireSpell:
		take_damage(area.damage)
		set_deferred("monitoring", false)
		timer.start(invencible_time)


func _on_Timer_timeout():
	set_deferred("monitoring", true)
