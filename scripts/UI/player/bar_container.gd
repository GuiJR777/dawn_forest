extends Control

class_name BarContainer


onready var tween: Tween = get_node("Tween")
onready var hp_bar: TextureProgress = get_node("HealthBar/Bar")
onready var mp_bar: TextureProgress = get_node("ManahBar/Bar")
onready var xp_bar: TextureProgress = get_node("ExperienceBar/Bar")

onready var stats_bars_map: Dictionary = {
	"HP": hp_bar,
	"MP": mp_bar,
	"XP": xp_bar,
}

var current_values: Dictionary = {
	"HP": 0,
	"MP": 0,
	"XP": 0,
}


func init_stats_bar(
	hp_initial_value: int, mp_initial_value: int, max_xp_initial_value: int
	) -> void:
	set_new_values("HP", hp_initial_value, hp_initial_value)
	set_new_values("MP", mp_initial_value, mp_initial_value)
	set_new_values("XP", max_xp_initial_value, 0)

func set_new_values(stats_name: String, max_value: int, value: int, min_value: int = 0) -> void:
	stats_bars_map[stats_name].max_value = max_value
	stats_bars_map[stats_name].min_value = min_value
	stats_bars_map[stats_name].value = value
	current_values[stats_name] = value
	
func update_bar(stats_name: String, new_value: int) -> void:
	call_tween(stats_bars_map[stats_name], current_values[stats_name], new_value)
	current_values[stats_name] = new_value

func call_tween(stats_bar: TextureProgress, current_value: int, new_value: int) -> void:
	var _config_tween: bool = tween.interpolate_property(
		stats_bar,
		"value",
		current_value,
		new_value,
		0.2, # interpolation duration
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	var _start_interpolate: bool = tween.start()
	
func update_debug_level_label(value: int) -> void:
	$ExperienceBar/Label2.text = str(value)
