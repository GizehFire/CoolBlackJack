extends Node

signal pressed_button (item:String)

@onready var btn_start: Button = $HBoxContainer/btn_start
@onready var btn_stop: Button = $HBoxContainer/btn_stop
@onready var btn_exit: Button = $HBoxContainer/btn_exit
@onready var btn_shuffle: Button = $HBoxContainer/btn_shuffle
@onready var btn_select_card: Button = $HBoxContainer/btn_select_card
@onready var btn_hits: Button = $HBoxContainer/btn_hits

func _ready() -> void:
	
	btn_start.text="Start"
	btn_stop.text="Stop"
	btn_exit.text="Exit"
	btn_shuffle.text="Shuffle"
	btn_select_card.text="ShowSelectCard"
	btn_hits.text="Ziehen"
	
	# Button vorerst deaktivieren und ausblenden
	btn_select_card.disabled=true
	btn_select_card.visible=false

func _on_btn_exit_pressed() -> void:
	emit_signal("pressed_button", btn_exit.text)

func _on_btn_start_pressed() -> void:
	emit_signal("pressed_button", btn_start.text)

func _on_btn_stop_pressed() -> void:
	emit_signal("pressed_button", btn_stop.text)

func _on_btn_shuffle_pressed() -> void:
	emit_signal("pressed_button", btn_shuffle.text)

func _on_btn_select_card_pressed() -> void:
	emit_signal("pressed_button", btn_select_card.text)

func _on_btn_hits_pressed() -> void:
	emit_signal("pressed_button", btn_hits.text)
