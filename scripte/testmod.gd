extends Node2D

@onready var btn_okay: Button = $btn_okay

# Modernes Property-Schema (Godot 4.x, GDScript 2)
var _punkte: int = 0

@export var punkte: int:
	
	set(value):
		# keine negativen Punkte
		_punkte = clamp(value, 10, 100)		
		print("Neuer Punktestand:", _punkte)
		
	get:
		
		return _punkte

func _ready() -> void:
	
	#punkte=-125
	
	# var messwerte = [22, 65, 1012, 400, 37, 60, 1120, 350]
	
	# print("[VOR]Messwerte: " + str(messwerte))
	# var struktur = verarbeite_daten(messwerte)
	# print(struktur)
	# print("[NACHER]Messwerte: " + str(messwerte))
	pass
	
func verarbeite_daten(_daten: Array) -> Dictionary:
	
	return {
		"Temperatur": _daten.pop_front(),   # z. B. 22
		"Luftfeuchtigkeit": _daten.pop_front(), # 65
		"Luftdruck": _daten.pop_front(),     # 1012
		"CO2": _daten.pop_front()            # 400
	}


func _on_btn_okay_pressed() -> void:
	pass
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():                # nur bei Key-Down
		match event.keycode:
			KEY_ESCAPE:
				
				print("Pressed 'ESC' Key")				
				get_viewport().set_input_as_handled()
				
			KEY_F5:
				
				print("Pressed 'F5' Key")
	
func okay():
	wait_confirmation()
	print("This will be printed immediately, before the user press the button.")


func wait_confirmation():
	
	print("Prompting user")
	await btn_okay.button_down # Waits for the button_up signal from Button node.
	print("User confirmed")
	return true
