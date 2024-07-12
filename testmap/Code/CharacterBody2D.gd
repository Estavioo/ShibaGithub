extends CharacterBody2D

class_name GameData


var save_file_path = "user://save/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

const SPEED = 49870
const JUMP_VELOCITY = -500.0

const SPEED_DASH = 149610
var dashing = false
var can_dash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Store the player's facing direction
var facing_direction = Vector2.RIGHT

var health = 100

func _ready():
	verify_save_directory(save_file_path)

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
	
	if Input.is_action_just_pressed("Save"):
		save()
	if Input.is_action_just_pressed("Load"):
		load_data()
	playerData.UpdatePos(self.position)

func _on_dash_timeout():
	dashing = false
func _on_can_dash_timeout():
	can_dash = true
