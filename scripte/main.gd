extends Node

@onready var buttons: Node = $buttons
@onready var cards: AnimatedSprite2D = $cards
@onready var first_card: Sprite2D = $PlayerHand/firstCard
@onready var second_card: Sprite2D = $PlayerHand/secondCard
@onready var up_card: Sprite2D = $DealerHand/up_card
@onready var hole_card: Sprite2D = $DealerHand/hole_card

@export_category("Test Variablen")
@export var test:int=25

var actions : Dictionary
var my_deck: Array[int] = []	# Persistentes, gemischtes Kartendeck
var Utils = preload("res://scripte/module/utils.gd").new()

enum Suit { PIK, HERZ, KREUZ, KARO }               # 0-3
enum Rank { AS, ZWEI, DREI, VIER, FUENF, SECHS,
			SIEBEN, ACHT, NEUN, ZEHN, BUBE, DAME, KOENIG }  # 0-12

const ANIM := "default"                            # Name der Animation im SpriteFrames
# ─────────────────────────────────────────────────────────────
# 1) Kernfunktion → arbeitet streng typisiert mit Enums
func _show_card(suit: Suit, rank: Rank) -> void:
	cards.animation = ANIM
	if cards.is_playing():
		cards.playing	= false			# oder stop(), je nach Bedarf
	cards.frame		= suit * 13 + rank

func show_card(suit: Suit, rank: Rank) -> void:
	_show_card(suit, rank)

# Variante B: Integer-Aufruf (z. B. show_card_idx(3, 11))
func show_card_idx(suit_i: int, rank_i: int) -> void:
	var suit: Suit = suit_i as Suit		# Cast zwingend!
	var rank: Rank = rank_i as Rank
	_show_card(suit, rank)

# Variante C: Einzelner Kartenindex 0-51
func show_card_flat(i: int) -> void:
	var suit: Suit = (i / 13) as Suit
	var rank: Rank = (i % 13) as Rank
	_show_card(suit, rank)	
		
func _ready() -> void:
	
	show_card(Suit.PIK, Rank.AS)		# Herz Dame in Enum-Schreibweise
	#show_card_idx(0, 0)				# exakt dieselbe Karte via Zahlen
	#show_card_flat(0)					# Index-Variante (49 = Karo Bube)
	
	print("Maxmimale Kartenanzahl: " + str(Ermitteln_Anzahl_Kartendeck()))	
	
	#lege_karte(up_card,0)
	#lege_karte(hole_card,45)
	
	# Nur einmal mischen zu Beginn
	my_deck = Utils.deck_shuffle() 
	
	actions =   {
		
		"Exit":    get_tree().quit,
		"Start":   cards.play.bind("default"),
		"Stop":    cards.stop,
		"Shuffle": start_new_round,
		"ShowSelectCard": player_select_cards
		
	}
		
	buttons.pressed_button.connect(Callable(_on_buttons_selected))

func player_select_cards():
	print("you pressed 'Select Button'")


func set_shuffle_card(deck: Array[int]) -> Array[int]:
	# reine Logik
	
	var idx : Dictionary = Utils.get_card_indices(my_deck)
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

func lege_karte(Deck_Position:Sprite2D, Karten_Nummer:int) -> void:
	# Beschreibung:
	# 
	# Auswahl eines bestimmten Karten-Frames (z. B. für Tests oder gezielte Anzeige)
	#
	# Eingabe:
	#	
	#	1. = Wo soll die gewaehlte Karte gelegt werden
	#	2. = Kartenwahl von As bis K	
	#
	# Ausgabe: Keine
	
	# Weist dem up_card-Sprite die Textur des Frame Nr. 7 zu (Index basiert auf SELECT_CARDS)	
	
	Deck_Position.texture = cards.sprite_frames.get_frame_texture(cards.animation, Karten_Nummer)

func Ermitteln_Anzahl_Kartendeck():
	
	# Ermittelt die maximale Anzahl an Frames (Karten) in der aktuellen Animation des AnimatedSprite2D
	var maximal_cards: int = cards.sprite_frames.get_frame_count(cards.animation)
	
	# Gibt die Anzahl der verfügbaren Karten (Frames) im Terminal aus	
	return maximal_cards

func Karten_legen(position_x:int, position_y:int, anzahl_karte:int) -> void:
	
	# Beschreibung:
	#	
	#	Bestimmte Anzahl von Karten auf dem Tisch legen 
	#	
	# Eingabe:
	#	
	#	1. = X-Kooridnaten
	#	2. = Y-Kooridnaten
	#	3. = maxmale Kartenanzahl
	#
	# Ausgabe: Keine
	
	var neue_karten: Array[Sprite2D]	= []
	
	# Fange bei der ersten Karte an
	var deck_number: int = 0
	
	# Abstandpostion zwischen den Karten
	var abstand_karte: int = 20
	
	for i in range(anzahl_karte):
	
		var klon: Sprite2D = up_card.duplicate() as Sprite2D
		
		# Textur aus SpriteFrames holen
		klon.texture = cards.sprite_frames.get_frame_texture(cards.animation, deck_number)
		
		# nächste Karte
		deck_number += 1
		
		# Position berechnen (Start + Versatz)
		klon.position = Vector2(position_x + (i + 1) * abstand_karte, position_y)
		
		# sichtbar machen
		add_child(klon)
		
		# im Array speichern
		neue_karten.append(klon)
	
	# Für Debug:
	# print("Es wurden ", neue_karten.size(), " Karten erzeugt.")
	# print(neue_karten)
