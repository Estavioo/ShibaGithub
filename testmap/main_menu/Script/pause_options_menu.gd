class_name PauseOptionsMenu
extends Control

@onready var back = $MarginContainer/VBoxContainer/Back as Button

signal back_game

func _ready():
	back.button_down.connect(on_back_pressed)
	set_process(false)
	
	
func on_back_pressed() -> void:
	back_game.emit()
	set_process(false)
