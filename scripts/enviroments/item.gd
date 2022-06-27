extends RigidBody2D

class_name PhysicItem


onready var 	texture: Sprite = get_node("Texture")
onready var label: Label = get_node("ItemName")

var player_reference: Player = null

var item_name: String
var item_infos: Array
var item_texture: StreamTexture


func _ready() -> void:
	randomize()
	apply_random_impulse()

func _process(delta):
	if player_reference and Input.is_action_just_pressed("interact"):
		# guardar no inventário
		player_reference.sprite.animation_player.play("pick_item")
		player_reference.set_physics_process(false)
		queue_free()

func apply_random_impulse() -> void:
	apply_impulse(
		Vector2.ZERO, # offset do impulso
		Vector2(rand_range(-30, 30), -90) # local do impulso
	)

func set_item_infos(item_name: String, item_texture: StreamTexture, item_infos: Array) -> void:
	yield(self, "ready")
	
	item_name = item_name
	item_texture = item_texture
	item_infos = item_infos
	
	label.text = item_name
	texture.texture = item_texture

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_InteractionArea_body_entered(body: Player):
	player_reference = body


func _on_InteractionArea_body_exited(_body: Player):
	player_reference = null
