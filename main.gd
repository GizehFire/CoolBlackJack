extends Node2D

func _ready():
	# Greife auf die SpriteFrames-Ressource des AnimatedSprite2D zu
	var anzahl = $Karten.sprite_frames.get_frame_count("defaults")
	print("Anzahl der Frames in der Animation: ", anzahl)
	
	$Karten.frame = 6
	$Karten2.frame = 25
