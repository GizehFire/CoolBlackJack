extends Node2D
var card_size = Vector2(106, 146)  # Vektor, der die Breite und Höhe jeder Karte im Sprite-Sheet definiert
var spacing = Vector2(14, 14)  # Vektor, der den Abstand zwischen den Karten im Sprite-Sheet definiert

func _ready():
	# Greife auf die SpriteFrames-Ressource des AnimatedSprite2D zu
	var anzahl = $Karten.sprite_frames.get_frame_count("defaults")
	print("Anzahl der Frames in der Animation: ", anzahl)
	
	$Karten.frame = 6
	$Karten2.frame = 25
