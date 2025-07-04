# module/uitls.gd
extends Node

const ANIM := "default"	# Name der Animation im SpriteFrames

enum Suit { PIK, HERZ, KREUZ, KARO }               # 0-3
enum Rank { AS, ZWEI, DREI, VIER, FUENF, SECHS,
			SIEBEN, ACHT, NEUN, ZEHN, BUBE, DAME, KOENIG }  # 0-12

func _build_actions(
	# Setze das dann in main.gd rein unter der Funktion
	#
	# func _ready() -> void:
	#
	# 	add_child(Utils)				# jetzt hat Utils einen Tree
	# 	actions = Utils.build_actions(
		
	#	self, first_card, second_card,
	#	up_card, hole_card,
	#	cards, my_deck)
	#	
	#	pass
	
		main_node: Node,
		first_C: Sprite2D,
		sec_C: Sprite2D,
		up_C: Sprite2D,
		hole_C: Sprite2D,
		cards_ani: AnimatedSprite2D,
		deck: Array[int]) -> Dictionary:
			
			return {
				
		"Exit": get_tree().quit,
		"Start": cards_ani.play.bind("default"),
		"Stop": cards_ani.stop,
		"Shuffle": _start_new_round.bind(
			first_C, sec_C, up_C, hole_C, cards_ani, deck),
		"ShowSelectCard": main_node.player_select_cards,
		"Ziehen": main_node.player_select_hits,
	}

func _start_new_round (first_C, sec_C,up_C,hole_C: Sprite2D, cards_ani: AnimatedSprite2D, _deck: Array[int]) ->void:
	if _deck.size() < 4:
		#_deck = Utils.deck_shuffle()
		_deck.clear()                              # alles raus
		_deck.append_array(deck_shuffle())
		print(" - New Mix - ")
	set_shuffle_card(first_C, sec_C, up_C, hole_C, cards_ani, _deck)

func Ermitteln_Anzahl_Kartendeck(Kartendeck: AnimatedSprite2D):
	
	# Ermittelt die maximale Anzahl an Frames (Karten) in der aktuellen Animation des AnimatedSprite2D
	var maximal_cards: int = Kartendeck.sprite_frames.get_frame_count(Kartendeck.animation)
	
	# Gibt die Anzahl der verfügbaren Karten (Frames) im Terminal aus	
	return maximal_cards

func lege_karte(Kartendeck: AnimatedSprite2D, Deck_Position:Sprite2D, Karten_Nummer:int) -> void:
	# Beschreibung:
	# 
	# Auswahl eines bestimmten Karten-Frames (z. B. für Tests oder gezielte Anzeige)
	#
	# Eingabe:
	#	1. = Kartendeck waehlen (AnimatedSprite2D)
	#	2. = Wo soll die gewaehlte Karte gelegt werden
	#	3. = Kartenwahl von As bis K	
	#
	# Ausgabe: Keine
	
	# Weist dem up_card-Sprite die Textur des Frame Nr. 7 zu (Index basiert auf SELECT_CARDS)	
	
	Deck_Position.texture = Kartendeck.sprite_frames.get_frame_texture(Kartendeck.animation, Karten_Nummer)

func _karten_legen(
	
	parent: Node,	# <- NEU
	kartendeck: Sprite2D,
	karten_ani: AnimatedSprite2D,
	position_x: int,
	position_y: int,
	anzahl: int
) -> Array[Sprite2D]:
	
	var neu: Array[Sprite2D] = []
	var deck_nr := 0
	const ABSTAND := 20

	for i in anzahl:
		var klon := kartendeck.duplicate() as Sprite2D
		klon.texture = karten_ani.sprite_frames.get_frame_texture(
			karten_ani.animation,
			deck_nr
		)
		deck_nr += 1
		klon.position = Vector2(position_x + (i + 1) * ABSTAND, position_y)
		parent.add_child(klon)	# <- NICHT Utils!
		neu.append(klon)

	return neu

func set_shuffle_card(first_C, sec_C,up_C,hole_C:Sprite2D, cards_ani: AnimatedSprite2D, _deck: Array[int]) -> Array[int]:
	# reine Logik
	
	var idx : Dictionary = get_card_indices(_deck)
	var anim := cards_ani.animation
	
	first_C.texture  = cards_ani.sprite_frames.get_frame_texture(anim, idx["first"])
	sec_C.texture = cards_ani.sprite_frames.get_frame_texture(anim, idx["second"])
	up_C.texture     = cards_ani.sprite_frames.get_frame_texture(anim, idx["up"])
	hole_C.texture   = cards_ani.sprite_frames.get_frame_texture(anim, idx["hole"])

	print("%d : %d : %d : %d" % [idx["first"], idx["second"], idx["up"], idx["hole"]])
	return _deck
	
func _show_card(cards_ani: AnimatedSprite2D, suit: Suit, rank: Rank) -> void:
	cards_ani.animation = ANIM
	if cards_ani.is_playing():
		cards_ani.playing	= false			# oder stop(), je nach Bedarf
	cards_ani.frame		= suit * 13 + rank

# Variante B: Integer-Aufruf 
# (z. B@onready var btn_select_card: 
# Button = $HBoxContainer/btn_select_cardva. show_card_idx(3, 11))
func show_card_idx(cards_ani: AnimatedSprite2D, suit_i: int, rank_i: int) -> void:
	var suit: Suit = suit_i as Suit		# Cast zwingend!
	var rank: Rank = rank_i as Rank
	_show_card(cards_ani, suit, rank)

# Variante C: Einzelner Kartenindex 0-51
func show_card_flat(cards_ani: AnimatedSprite2D, i: int) -> void:
	var suit: Suit = (i / 13) as Suit
	var rank: Rank = (i % 13) as Rank
	_show_card(cards_ani, suit, rank)

func get_card_indices(_deck: Array[int]) -> Dictionary:
	# zieht 4 Karten nacheinander und liefert ihre Indizes
	return {
		"first": _deck.pop_front(),
		"second": _deck.pop_front(),
		"up": _deck.pop_front(),
		"hole": _deck.pop_front()
	}

func deck_shuffle () -> Array[int]:
	
	var _deck:Array[int] = []
	
	for i in 52:
		_deck.append(i)
	_deck.shuffle()
	return _deck

func get_random_card_index() -> int:
	
	var rng := RandomNumberGenerator.new()
	rng.randomize()  # Wichtig! Macht den Zufall nicht vorhersehbar
	return rng.randi_range(0, 51)
