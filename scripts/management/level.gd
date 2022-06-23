extends Node2D

class_name Level

onready var player: KinematicBody2D = get_node("Player")


func _ready():
	var _game_over_signal = player.get_node("Texture").connect("game_over", self, "on_game_over")


func on_game_over() -> void:
	var _reload_scene = get_tree().reload_current_scene()
