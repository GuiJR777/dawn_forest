extends EnemyTemplate

class_name PinkStar


func _ready() -> void:
	randomize()
	drops_map = {
		"Heal Potion" : [
			"res://assets/item/consumable/health_potion.png", # caminho da imagem
			25, # porcentagem de chance de drop
			"Health", # tipo de item
			5, # quantidade de stats proporcionado
			2, # valor de venda
		],
		"Mana Potion" : [
			"res://assets/item/consumable/mana_potion.png", # caminho da imagem
			12, # porcentagem de chance de drop
			"Mana", # tipo de item
			5, # quantidade de stats proporcionado
			5, # valor de venda
		],
		"Pink Star Mouth" : [
			"res://assets/item/resource/pink_star/pink_star_mouth.png", # caminho da imagem
			47, # porcentagem de chance de drop
			"Resource", # tipo de item
			{}, # Itens do tipo resource nao possuem valor de stats
			5, # valor de venda
		],
		"Pink Star Bow" : [
			"res://assets/item/equipment/pink_star_bow.png", # caminho da imagem
			1, # porcentagem de chance de drop
			"Weapon", # tipo de item
			{
				"Attack": 5,
			}, # Itens do tipo resource nao possuem valor de stats
			60, # valor de venda
		],
		"Pink Star Belt" : [
			"res://assets/item/equipment/pink_star_belt.png", # caminho da imagem
			3, # porcentagem de chance de drop
			"Equipment", # tipo de item
			{
				"Health": 5,
				"Mana": 5,
			}, # Itens do tipo resource nao possuem valor de stats
			40, # valor de venda
		],
		"Pink Star Shield" : [
			"res://assets/item/equipment/pink_star_shield.png", # caminho da imagem
			1, # porcentagem de chance de drop
			"Weapon", # tipo de item
			{
				"Health": 3,
				"Defense": 2,
			}, # Itens do tipo resource nao possuem valor de stats
			75, # valor de venda
		],
		
	}

