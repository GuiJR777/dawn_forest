extends EnemyTemplate

class_name Whale


func _ready() -> void:
	randomize()
	drops_map = {
		"Heal Potion" : [
			"res://assets/item/consumable/health_potion.png", # caminho da imagem
			20, # porcentagem de chance de drop
			"Health", # tipo de item
			5, # quantidade de stats proporcionado
			2, # valor de venda
		],
		"Mana Potion" : [
			"res://assets/item/consumable/mana_potion.png", # caminho da imagem
			15, # porcentagem de chance de drop
			"Mana", # tipo de item
			5, # quantidade de stats proporcionado
			5, # valor de venda
		],
		"Whale Mouth" : [
			"res://assets/item/resource/whale/whale_mouth.png", # caminho da imagem
			45, # porcentagem de chance de drop
			"Resource", # tipo de item
			{}, # Itens do tipo resource nao possuem valor de stats
			2, # valor de venda
		],
		"Whale Eye" : [
			"res://assets/item/resource/whale/whale_eye.png", # caminho da imagem
			15, # porcentagem de chance de drop
			"Resource", # tipo de item
			{}, # Itens do tipo resource nao possuem valor de stats
			6, # valor de venda
		],
		"Whale Tail" : [
			"res://assets/item/resource/whale/whale_tail.png", # caminho da imagem
			3, # porcentagem de chance de drop
			"Resource", # tipo de item
			{}, # Itens do tipo resource nao possuem valor de stats
			25, # valor de venda
		],
		"Whale Mask" : [
			"res://assets/item/equipment/whale_mask.png", # caminho da imagem
			2, # porcentagem de chance de drop
			"Equipment", # tipo de item
			{
				"Mana": 5,
				"Magic Attack": 3,
			}, # Itens do tipo equipment possuem dicionario de atributos a serem aumentados no player
			30, # valor de venda
		],
		
	}
