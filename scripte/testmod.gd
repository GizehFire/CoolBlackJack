extends Node2D
@onready var label : Label = $Label

func _ready() -> void:
	
	var txt: String  = "76"
	var num: int     = txt as int        # → 123  (ok)
	
	var number: int = 2025
	# var num2txt: String = number as String
	
	print(num)
	# print(num2txt)
	label.text="Hi"
	print(hash(test_dic))
	print(test_dic)
	
func test_dic():
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
