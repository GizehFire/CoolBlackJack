extends Node

@onready var buttons: Node = $buttons
@onready var cards: AnimatedSprite2D = $cards

@onready var first_card : Sprite2D = $PlayerHand/firstCard
@onready var second_card: Sprite2D = $PlayerHand/secondCard

@onready var up_card: Sprite2D = $DealerHand/up_card
@onready var hole_card: Sprite2D = $DealerHand/hole_card

var actions : Dictionary
var my_deck: Array[int] = [] # Persistentes, gemischtes Kartendeck

var Utils = preload("res://scripte/module/utils.gd").new()

func _ready() -> void:
	
	actions =   {
		
		"Exit":    get_tree().quit,
		"Start":   cards.play.bind("default"),
		"Stop":    cards.stop,
		"Shuffle": Utils._start_new_round.bind(first_card, second_card, up_card, hole_card, cards,my_deck),
		"ShowSelectCard": player_select_cards,
		"Ziehen": player_select_hits
		
	}
	
	# Exakt dieselbe Karte via Zahlen
	# Utils.show_card_idx(cards,4, 0)
	
	# Index-Variante (49 = Karo Bube)
	# Utils.show_card_flat(cards,49)
	
	Utils._show_card(cards, Utils.Suit.PIK, Utils.Rank.ZEHN)		# Herz Dame in Enum-Schreibweise	
	
	print("Maxmimale Kartenanzahl: " + str(Utils.Ermitteln_Anzahl_Kartendeck(cards)))	
	
	Utils.lege_karte(cards, up_card,22)
	Utils.lege_karte(cards, hole_card,45)	
	Utils.lege_karte(cards, first_card,25)
	Utils.lege_karte(cards, second_card,05)
	
	# Nur einmal mischen zu Beginn
	my_deck = Utils.deck_shuffle() 
	
	buttons.pressed_button.connect(Callable(_on_buttons_selected))
		
	Utils._karten_legen(self, up_card, cards, 25,200,37)

func player_select_hits() -> void:
	print("Player have pressed 'hits' button")

func player_select_cards():
	print("you pressed 'Select Button'")

func _on_buttons_selected(item:String) -> void:	
	if actions.has(item):
		actions[item].call()      # eine Zeile statt vieler ifs
