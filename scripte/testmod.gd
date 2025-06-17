extends Node2D
@onready var btn_okay: Button = $btn_okay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var user: Dictionary = {
	"Name":  "Falko",
	"Punkte": 120,   # Integer statt "120"
	"Leben":  10,
	"ZieheWurzel": sqrt(64)
}
	print("Name: " + user["Name"])
	print("Leben: " + str(user["Leben"]))
	print("Punkte: " + str(user["Punkte"]))
	print("Wurzel ziehen von 64: %0.1f" % user["ZieheWurzel"])
	


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

#func _close_modal (is_confirmed:bool) -> void:
	
	# Diese Funktion aktiviert oder deaktiviert, 
	# ob ein Node die Methode überhaupt empfangen darf.
	
#	set_process_unhandled_key_input(false)
	

func okay():
	wait_confirmation()
	print("This will be printed immediately, before the user press the button.")


func wait_confirmation():
	print("Prompting user")
	await btn_okay.button_down # Waits for the button_up signal from Button node.
	print("User confirmed")
	return true
