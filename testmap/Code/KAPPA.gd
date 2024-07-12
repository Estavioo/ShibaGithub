extends CharacterBody2D

class_name enemies
enum enemy_type {KAPPA, BAKANEKO}


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var default_direction = -1


const damage = 50
var health = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var detection_range = $"Detection/Detection Area"
@onready var attack_range = $"Attack Range/Attack Range"
@onready var damage_range = $"Damage/Damage Trigger"
@onready var healthbar = $KAPPA_Health2

var player_attack = false
var player_chase = false
var target_position = Vector2.ZERO

func _ready():
	healthbar.value = health
	health_regen()

func _physics_process(delta):
	enemy_movement(delta)

func enemy_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = default_direction * SPEED
	if is_on_wall():
		# Flip the sprite horizontally based on the direction
		if velocity.x > 0:
			default_direction = -1
			detection_range.position.x = -175.75
			attack_range.position.x = -118.5
			damage_range.position.x = -80.5
			
		elif velocity.x < 0:
			default_direction = 1
			detection_range.position.x = 175.75
			attack_range.position.x = -10.5
			damage_range.position.x = 80.5
			
			
	velocity.x = default_direction * SPEED
	
	if player_chase:
		player_chasing(delta)
	elif player_attack:
		velocity = Vector2.ZERO

	move_and_slide()

func health_regen():
	while true:
		await(get_tree().create_timer(2.0).timeout)
		if health < 100 and player_chase == false:
			health += 5
			print("Enemy Current health: " + str(health))

func _on_detection_area_entered(area):
	if area.is_in_group("player_hitbox"):
		player_chase = true
		target_position = area.global_position

func _on_detection_area_exited(_area):
	player_chase = false

func _on_attack_area_entered(area):
	if area.is_in_group("player_body"):
		player_attack = true

func _on_attack_area_exited(_area):
	player_attack = false

func player_chasing(_delta):
	var direction = (target_position - global_position).normalized()
	var distance_to_target = target_position.distance_to(global_position)
	if distance_to_target < attack_range.scale.x / 2:
		# Player is within attack range, stay still and attack
		velocity = Vector2.ZERO
	else:
		# Player is outside attack range, chase the player
		velocity = direction * SPEED
	velocity.y = 0
	move_and_slide()

func _on_damage_area_entered(body):
	if "Player" in body.name:
		body.enemy_atk()
