extends Node2D

# Kartenwerte und Symbole
var card_values = ["Ass", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Bube", "Dame", "König"]  # Liste der Kartenwerte
var card_suits = ["Pik", "Herz", "Kreuz", "Karo"]  # Liste der Kartensymbole in der richtigen Reihenfolge


func _ready():
	# Greife auf die SpriteFrames-Ressource des AnimatedSprite2D zu
	var anzahl = $Karten.sprite_frames.get_frame_count("defaults")
	print("Anzahl der Frames in der Animation: ", anzahl)
	
	$Karten.frame = 6
	$Karten2.frame = 25
