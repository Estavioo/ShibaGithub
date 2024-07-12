class_name OptionsMenu
extends Control

@onready var back = $MarginContainer/VBoxContainer/Back as Button

signal back_options_menu

func _ready():
	back.button_down.connect(on_back_pressed)
	set_process(false)
	
	
func on_back_pressed() -> void:
	back_options_menu.emit()
	set_process(false)
