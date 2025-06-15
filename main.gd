extends Node

@onready var buttons: Node = $buttons
@onready var cards: AnimatedSprite2D = $cards
@onready var first_card: Sprite2D = $PlayerHand/firstCard
@onready var second_card: Sprite2D = $PlayerHand/secondCard
@onready var up_card: Sprite2D = $DealerHand/up_card
@onready var hole_card: Sprite2D = $DealerHand/hole_card

var actions : Dictionary
var my_deck: Array[int] = []	# Persistentes, gemischtes Kartendeck

func _ready() -> void:
	
	my_deck = deck_shuffle()  # Nur einmal mischen zu Beginn
	# start_new_round()
	
	actions = {
		"Exit":    get_tree().quit,
		"Start":   cards.play.bind("default"),
		"Stop":    cards.stop,
		"Shuffle": start_new_round
	}
		
	buttons.pressed_button.connect(Callable(_on_buttons_selected))
	
func start_new_round() -> void:
	if my_deck.size() < 4:
		my_deck = deck_shuffle()
		print(" - New Mix - ")
	set_shuffle_card()

func _on_buttons_selected(item:String) -> void:	
	if actions.has(item):
		actions[item].call()      # eine Zeile statt vieler ifs
		
func set_shuffle_card() -> void:
	
	var frame_index_first : int = my_deck.pop_front() # Erste Karte für Spieler
	var frame_index_second : int = my_deck.pop_front() # Zweite Karte für Spieler
	var frame_index_up_card : int = my_deck.pop_front() # Dealer-Upcard
	var frame_index_hole_card : int = my_deck.pop_front() # Dealer-Upcard
	
	# Überprüfe ob doppelt vorhanden ist.
	
	var animation_name := cards.animation  # Aktuelle Animation (wichtig, falls du mehrere hast)	
	
	var texture_first: Texture2D = cards.sprite_frames.get_frame_texture(animation_name, frame_index_first)
	var texture_second: Texture2D = cards.sprite_frames.get_frame_texture(animation_name, frame_index_second)
	var texture_up_card: Texture2D = cards.sprite_frames.get_frame_texture(animation_name, frame_index_up_card)
	var texture_hole_card: Texture2D = cards.sprite_frames.get_frame_texture(animation_name, frame_index_hole_card)
	
	first_card.texture = texture_first
	second_card.texture = texture_second
	up_card.texture = texture_up_card
	hole_card.texture = texture_hole_card
	
	print(str(frame_index_first) +  " : " + str(frame_index_second) + " : " + str(frame_index_up_card) + " : " + str(frame_index_hole_card))
	
func deck_shuffle () -> Array[int]:
	var new_deck:Array[int] = []
	
	for i in 52:
		new_deck.append(i)
	new_deck.shuffle()
	return new_deck

func get_random_card_index() -> int:
	var rng := RandomNumberGenerator.new()
	rng.randomize()  # Wichtig! Macht den Zufall nicht vorhersehbar
	return rng.randi_range(0, 51)
