extends Area2D

class_name VisionArea

export(NodePath) onready var enemy = get_node(enemy) as EnemyTemplate
export(NodePath) onready var texture = get_node(texture) as Sprite
export(float) var default_offset_of_vision


func _on_VisionArea_body_entered(body: Player) -> void:
	enemy.player_reference = body


func _on_VisionArea_body_exited(_body: Player) -> void:
	enemy.player_reference = null

func _process(_delta):
	if texture.flip_h:
		position.x = default_offset_of_vision
	else:
		position.x = default_offset_of_vision * -1
