extends Node2D

func _ready() -> void:
	
	var TPlayer : Dictionary = {
		"Player" 	: "Mike",
		"IsActive" 	: true,
		"Live"		: 10,
		"Score"		: 120,
		"Age"		: 14
	}
	TPlayer["Baum"] = "árbol" 
	print("Name : " + TPlayer["Player"])
	print("Existiert der Schluesselbegriff 'Live'? - " + str(TPlayer.has("Live")))
	print("Anzahl der Schluesseleintraege: " + str(TPlayer.size()))
	print(TPlayer.keys())
	print(TPlayer.values())
