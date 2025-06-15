extends Node

@onready var buttons: Node = $buttons
@onready var cards: AnimatedSprite2D = $cards
@onready var first_card: Sprite2D = $firstCard
@onready var sec_card: Sprite2D = $secCard

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
	
	var frame_index_first := get_random_card_index()  # Erste Karte durch Zufallzahlen generieren
	var frame_index_second := get_random_card_index()  # Zweite Karte durch Zufallzahlen generieren
	var animation_name := cards.animation  # Aktuelle Animation (wichtig, falls du mehrere hast)	
	var texture_first: Texture2D = cards.sprite_frames.get_frame_texture(animation_name, frame_index_first)
	var texture_second: Texture2D = cards.sprite_frames.get_frame_texture(animation_name, frame_index_second)
	
	# Überprüfe ob doppelt vorhanden ist.
	while frame_index_second == frame_index_first:
		frame_index_second = get_random_card_index()
	
	first_card.texture = texture_first
	sec_card.texture = texture_second
	
	print(str(frame_index_first) +  " : " + str(frame_index_second))
	
func get_random_card_index() -> int:
	var rng := RandomNumberGenerator.new()
	rng.randomize()  # Wichtig! Macht den Zufall nicht vorhersehbar
	return rng.randi_range(0, 51)
