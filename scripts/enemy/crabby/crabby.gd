extends EnemyTemplate

class_name Crabby


func _ready() -> void:
	randomize()
	drops_map = {
		"Heal Potion" : [
			"res://assets/item/consumable/health_potion.png", # caminho da imagem
			15, # porcentagem de chance de drop
			"Health", # tipo de item
			5, # quantidade de stats proporcionado
			2, # valor de venda
		],
		"Mana Potion" : [
			"res://assets/item/consumable/mana_potion.png", # caminho da imagem
			8, # porcentagem de chance de drop
			"Mana", # tipo de item
			5, # quantidade de stats proporcionado
			5, # valor de venda
		],
		"Crabby Eye" : [
			"res://assets/item/resource/crabby/crab_eye.png", # caminho da imagem
			35, # porcentagem de chance de drop
			"Resource", # tipo de item
			{}, # Itens do tipo resource nao possuem valor de stats
			3, # valor de venda
		],
		"Crabby Pincers" : [
			"res://assets/item/resource/crabby/crab_pincers.png", # caminho da imagem
			10, # porcentagem de chance de drop
			"Resource", # tipo de item
			{}, # Itens do tipo resource nao possuem valor de stats
			7, # valor de venda
		],
		"Crabby Belt" : [
			"res://assets/item/equipment/crabby_belt.png", # caminho da imagem
			5, # porcentagem de chance de drop
			"Equipments", # tipo de item
			{
				"Health": 3,
				"Attack": 1,
			}, # Itens do tipo resource nao possuem valor de stats
			30, # valor de venda
		],
		"Crabby Axe" : [
			"res://assets/item/equipment/crabby_axe.png", # caminho da imagem
			2, # porcentagem de chance de drop
			"Weapon", # tipo de item
			{
				"Attack": 3,
				"Defense": 1,
			}, # Itens do tipo resource nao possuem valor de stats
			40, # valor de venda
		],
	}
