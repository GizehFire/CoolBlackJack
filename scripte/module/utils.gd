# module/uitls.gd

extends Node

func ensure_enough_cards(_deck: Array[int]) -> Array[int]:
	
	if _deck.size() < 4:
		print(" - New Mix - ")
		return deck_shuffle()        # mischt ein neues 52-Karten-Deck
	return _deck

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
