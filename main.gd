extends Node

@onready var buttons: Node = $buttons
@onready var cards: AnimatedSprite2D = $cards
@onready var first_card: Sprite2D = $firstCard

var actions : Dictionary

func _ready() -> void:
	
	actions = {
		"Exit":    get_tree().quit,
		"Start":   cards.play.bind("default"),
		"Stop":    cards.stop,
		"Shuffle": set_shuffle_card
	}	
	var my_name = create_greeting("Simmer")
	
	#buttons.pressed_button.connect(_on_buttons_selected)
	buttons.pressed_button.connect(Callable(_on_buttons_selected))
	
	print(my_name)

func create_greeting(person:String):
	return "Hello " + person + "!"

func _on_buttons_selected(item:String) -> void:	
	if actions.has(item):
		actions[item].call()      # eine Zeile statt vieler ifs
		
func set_shuffle_card () -> void:
	printt("Shuffle")
