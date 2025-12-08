extends Control

var player = null

@onready var labels = [
	$Option1/OptionLabel1,
	$Option2/OptionLabel2,
	$Option3/OptionLabel3
]

@onready var buttons = [
	$Option1/OptionButton1,
	$Option2/OptionButton2,
	$Option3/OptionButton3
]

var all_stats := [
	"speed",
	"max_health",
	"attack_damage",
	"attack_speed"
]

var chosen_stats := []
var upgrade_name: String 
var upgrade_amount: int = 1

signal increase_stat(upgrade_name:String,upgrade_amount:int)

func _ready() -> void:
	#player = get_tree().get_first_node_in_group("Player")
	SceneManager.randomize_level_up.connect(show_overlay)

func _on_option_1_pressed() -> void:
	
	upgrade_name = labels[0].text
	emit_signal("increase_stat",upgrade_name,upgrade_amount)
	
	SceneManager.hide_top_overlay()
	get_tree().paused = false
	AudioManager.play_sfx("res://Sounds/taco_bell.mp3",20)

func _on_option_2_pressed() -> void:
	
	upgrade_name = labels[1].text
	emit_signal("increase_stat",upgrade_name,upgrade_amount)
	
	SceneManager.hide_top_overlay()
	get_tree().paused = false
	AudioManager.play_sfx("res://Sounds/taco_bell.mp3",20)

func _on_option_3_pressed() -> void:
	
	upgrade_name = labels[2].text
	emit_signal("increase_stat",upgrade_name,upgrade_amount)
	
	SceneManager.hide_top_overlay()
	get_tree().paused = false
	AudioManager.play_sfx("res://Sounds/taco_bell.mp3",20)

func show_overlay():
	var shuffled = all_stats.duplicate()
	shuffled.shuffle()
	
	chosen_stats = shuffled.slice(0,3)
	print(chosen_stats)
	
	for i in range(3):
		labels[i].text = chosen_stats[i]
		buttons[i].text = "Choose"
		buttons[i].disconnect("pressed") if buttons[i].is_connected("pressed", Callable(self, "_on_button_pressed")) else null
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(i))
		#disconnect callback to old stat upgrade, 
		#connect it to the new random stat upgrade
		#prevents previous upgrades chosen from stacking
		#holy fuck this is confusing
	print("inside show_overlay", chosen_stats)
	print("array of things", labels)
