extends Node

class_name DropItensDice


const D20_FACES: int = 20

const HUNDREAD_PERCENT: int = 100
const BAD_DICE_RESULT: int = 6
const GOOD_DICE_RESULT: int = 13

const TEXTURE: int = 0
const PROBABILITY_TO_DROP: int = 1
const TYPE: int = 2
const BONUS_VALUES: int = 3
const SALE_VALUE: int = 4

var drop_bonus: int = 1


func __roll_D20() -> int:
	return randi() % (D20_FACES + 1)

func spawn_item_probability(drops_map: Dictionary) -> Array:
	var dice_result: int = __roll_D20()
	
	if dice_result <= BAD_DICE_RESULT:
		drop_bonus = 1
	elif dice_result > BAD_DICE_RESULT and dice_result <= GOOD_DICE_RESULT:
		drop_bonus = 2
	else:
		drop_bonus = 3
	
	var itens_to_drop: Array = []
	for item in drops_map.keys():
		var sorted_percent: int = randi() % HUNDREAD_PERCENT + 1
		var amount_of_items_to_drop: int = 1
		
		if sorted_percent <= drops_map[item][PROBABILITY_TO_DROP] * drop_bonus:
			var item_texture: StreamTexture = load(drops_map[item][TEXTURE])
			var item_infos: Array = [
				drops_map[item][TEXTURE],
				drops_map[item][TYPE],
				drops_map[item][BONUS_VALUES],
				drops_map[item][SALE_VALUE],
				amount_of_items_to_drop,
			]
			itens_to_drop.append([item, item_texture, item_infos])
	
	return itens_to_drop
