class_name OptimizedPauseMenu
extends Control

@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var paused_options_menu = $PausedOptionsMenu as PauseOptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var resume = $MarginContainer/HBoxContainer/VBoxContainer/Resume as Button
@onready var quit = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button


var _is_paused:bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused
	
func _ready():
	handle_pause_signals()

func _unhandled_input(event: InputEvent) ->void:
	if event.is_action_pressed("Pause"):
		_is_paused = !_is_paused
	
func on_option_pressed() -> void:
	margin_container.visible = false
	paused_options_menu.set_process(true)
	paused_options_menu.visible = true
	
func on_back_options_menu() -> void:
	margin_container.visible = true
	paused_options_menu.visible = false

func _on_quit_pressed():
	_is_paused = false
	MainMenu.restart_music()
	get_tree().change_scene_to_file("res://JAMGAM/menu.tscn")

func _on_resume_pressed():
	_is_paused = false
	
func handle_pause_signals() -> void:
	options.button_down.connect(on_option_pressed)
	paused_options_menu.back_game.connect(on_back_options_menu)
