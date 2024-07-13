extends CharacterBody2D

class_name GameData
enum State {HAYAI, TSUYOI}

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

var SPEED = 49870
var SPEED_HAYAI = SPEED
var SPEED_TSUYOI = 60000
const JUMP_VELOCITY = -500.0

const SPEED_DASH = 149610
var dashing = false
var can_dash = true
var current_state = State.HAYAI

var damage = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Store the player's facing direction
var facing_direction = Vector2.RIGHT
var health = 100
var regen = false
@onready var healthbar = $Player_Health
@onready var kappa_health_2 = $"../Kappa/KAPPA_Health2"

var enemy_inrange = false
var enemy_cooldown = true
var player_alive = true

func _ready():
	verify_save_directory(save_file_path)
	health = healthbar.value
	healthbar.value = health
	
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	
func load_data():
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	on_start_load()
	print("loaded")
	
func on_start_load():
	self.position = playerData.SavePos

func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("saved")	

func _physics_process(delta):
	save_progress()
	player_movement(delta)
	player_health()
	player_attack()
	
	if regen and enemy_inrange == false:
		healthbar.health_regen()
	
	#test Player Healthbar
	#if Input.is_action_just_pressed("Left"):
	#	healthbar.value -= 50
	

func player_attack():
	switch_state()
	if Input.is_action_just_pressed("Attack"):
		print(str(damage))
		if enemy_inrange:
			print("attacked")
			kappa_health_2.health_damaged()

func switch_state():
	if Input.is_action_just_pressed("switch_state"):
		if current_state == State.HAYAI:
			print("Switched to TSUYOI")
			current_state = State.TSUYOI
			SPEED = SPEED_TSUYOI
			damage = 20
		else:
			current_state = State.HAYAI
			print("Switched to HAYAI")
			SPEED = SPEED_HAYAI
			damage = 30

func player_health():
	if healthbar.value < 100:
		regen = true
	else:
		regen = false
		
func save_progress():
	if Input.is_action_just_pressed("Save"):
		save()
	if Input.is_action_just_pressed("Load"):
		load_data()
	playerData.UpdatePos(self.position)
	
func player_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#$AnimatedSprite2D.play("Jump")

	# Handle dash.
	if Input.is_action_just_pressed("Dash") and can_dash:
		dashing = true 
		can_dash = false
		$Dash.start()
		$CanDash.start()
		print("dashing")

	var direction = Vector2(Input.get_action_strength("Right") - Input.get_action_strength("Left"), 0)
	if direction.x != 0:
		facing_direction = direction

	if dashing:
		velocity.y = 0
		velocity.x = facing_direction.x * SPEED_DASH * delta
		print("dashering")
	else:
		if direction.x != 0:
			velocity.x = direction.x * SPEED * delta
			#$AnimatedSprite2D.play("Run")
			#$AnimatedSprite2D.flip_h = facing_direction.x < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			#$AnimatedSprite2D.play("default")
	move_and_slide()

func _on_dash_timeout():
	dashing = false
	
func _on_can_dash_timeout():
	can_dash = true

func _on_atk_cool_timeout():
	enemy_cooldown = true

func _on_attack_defense_area_entered(area):
	if area.is_in_group("enemy_body"):
		enemy_inrange = true

func _on_attack_defense_area_exited(area):
	if area.is_in_group("enemy_body"):
		enemy_inrange = false

func enemy_atk():
	if enemy_inrange and enemy_cooldown == true:
		health -= 5
		enemy_cooldown = false
		$atk_cool.start()
		print(health)
func _on_body_area_entered(area):
	if area.is_in_group("enemy attackrange"):
		pass
func _on_body_area_exited(area):
	if area.is_in_group("enemy attackrange"):
		pass
