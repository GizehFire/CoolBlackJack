extends Node

signal pressed_button (item:String)


@onready var btn_start: Button = $HBoxContainer/btn_start
@onready var btn_stop: Button = $HBoxContainer/btn_stop
@onready var btn_exit: Button = $HBoxContainer/btn_exit
@onready var btn_shuffle: Button = $HBoxContainer/btn_shuffle


func _ready() -> void:
	
	btn_start.text="Start"
	btn_stop.text="Stop"
	btn_exit.text="Exit"
	btn_shuffle.text="Shuffle"

func _on_btn_exit_pressed() -> void:
	emit_signal("pressed_button", btn_exit.text)

func _on_btn_start_pressed() -> void:
	emit_signal("pressed_button", btn_start.text)

func _on_btn_stop_pressed() -> void:
	emit_signal("pressed_button", btn_stop.text)

func _on_btn_shuffle_pressed() -> void:
	emit_signal("pressed_button", btn_shuffle.text)
