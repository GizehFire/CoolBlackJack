extends Node

@onready var buttons: Node = $buttons
@onready var cards: AnimatedSprite2D = $cards
@onready var first_card: Sprite2D = $PlayerHand/firstCard
@onready var second_card: Sprite2D = $PlayerHand/secondCard
@onready var up_card: Sprite2D = $DealerHand/up_card
@onready var hole_card: Sprite2D = $DealerHand/hole_card

var actions : Dictionary
var my_deck: Array[int] = []	# Persistentes, gemischtes Kartendeck
var Utils = preload("res://scripte/module/utils.gd").new()

func _ready() -> void:
	
	# Konstante zur Auswahl eines bestimmten Karten-Frames (z. B. für Tests oder gezielte Anzeige)
	const SELECT_CARDS: int = 7
	# Ermittelt die maximale Anzahl an Frames (Karten) in der aktuellen Animation des AnimatedSprite2D
	var maximal_cards: int = cards.sprite_frames.get_frame_count(cards.animation)	
	# Weist dem up_card-Sprite die Textur des Frame Nr. 7 zu (Index basiert auf SELECT_CARDS)
	up_card.texture = cards.sprite_frames.get_frame_texture(cards.animation, SELECT_CARDS)	
	# Gibt die Anzahl der verfügbaren Karten (Frames) im Terminal aus
	print("Anzahl der Karten: " + str(maximal_cards))

	
	my_deck = Utils.deck_shuffle() # Nur einmal mischen zu Beginn
	# start_new_round()
	
	actions = {
		"Exit":    get_tree().quit,
		"Start":   cards.play.bind("default"),
		"Stop":    cards.stop,
		"Shuffle": start_new_round
	}
		
	buttons.pressed_button.connect(Callable(_on_buttons_selected))
	
func set_shuffle_card(deck: Array[int]) -> Array[int]:
	# reine Logik
	
	var idx : Dictionary = Utils.get_card_indices(deck)
	var anim := cards.animation
	
	first_card.texture  = cards.sprite_frames.get_frame_texture(anim, idx["first"])
	second_card.texture = cards.sprite_frames.get_frame_texture(anim, idx["second"])
	up_card.texture     = cards.sprite_frames.get_frame_texture(anim, idx["up"])
	hole_card.texture   = cards.sprite_frames.get_frame_texture(anim, idx["hole"])

	print("%d : %d : %d : %d" % [idx["first"], idx["second"], idx["up"], idx["hole"]])
	return deck

func start_new_round() -> void:
	if my_deck.size() < 4:		
		my_deck = Utils.deck_shuffle()
		print(" - New Mix - ")
	set_shuffle_card(my_deck)
	

func _on_buttons_selected(item:String) -> void:	
	if actions.has(item):
		actions[item].call()      # eine Zeile statt vieler ifs
		
