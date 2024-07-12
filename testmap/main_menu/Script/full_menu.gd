class_name OptimizedMenu
extends Control


@onready var start = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button
@onready var load_data = $MarginContainer/HBoxContainer/VBoxContainer/Load as Button
@onready var option = $MarginContainer/HBoxContainer/VBoxContainer/Option as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button
@onready var optimized_options_menu = $OptimizedOptionsMenu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer

@onready var start_level = preload("res://Scenes/main.tscn") as PackedScene

var gameData = GameData.new()

func _ready():
	handle_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_load_pressed() -> void:
	if not FileAccess.file_exists("user://save/PlayerSave.tres"):
		print("does not exist")
	else:
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
		gameData.on_start_load()
		print("exist")
		
func on_option_pressed() -> void:
	margin_container.visible = false
	optimized_options_menu.set_process(true)
	optimized_options_menu.visible = true

func on_exit_pressed() -> void:
	get_tree().quit()
	
	
func on_back_options_menu() -> void:
	margin_container.visible = true
	optimized_options_menu.visible = false

	
func handle_signals() -> void:
	start.button_down.connect(on_start_pressed)
	load_data.button_down.connect(on_load_pressed)
	option.button_down.connect(on_option_pressed)
	exit.button_down.connect(on_exit_pressed)
	optimized_options_menu.back_options_menu.connect(on_back_options_menu)


