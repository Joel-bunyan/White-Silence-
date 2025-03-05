class_name  Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var wood_count = 0
var near_fire: bool = false  

@onready var animation_player : AnimationPlayer= $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var health_bar = $HealthBar
@onready var wood_label = $"../CanvasLayer/WoodLabel"
@onready var sword_hitbox : Area2D = $SwordHitBox 
@onready var fire_scene = preload("res://Fire.tscn")

func update_wood_count():
	if wood_label:
		wood_label.text = "Wood: " + str(wood_count)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	pass # Replace with function body.
var health = 100
var max_health = 100

func take_damage(amount: float):
	health -= amount
	health = max(health, 0)  # Prevents negative health

	if health_bar:  # ✅ Avoids "null instance" error
		health_bar.value = health  # Update the health bar
	else:
		print("HealthBar is NULL!")  # Debugging
	
	
	
func heal(amount):
	health += amount
	health = min(health, max_health)  # Ensure health doesn't exceed max
	
func update_health_bar():
	$UI/HealthBar.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta ):
	
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")    
	direction = Vector2(
		 Input.get_axis("left", "right"),
		 Input.get_axis("up", "down")
	).normalized()
	update_sword_position()
	if Input.is_action_just_pressed("Fire"): 
		print("🔥 Fire button pressed!")
		place_fire()


func _physics_process( delta ):
	move_and_slide()


func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:		 return false
		
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction. x < 0 else Vector2.RIGHT
	elif direction.x ==0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN 
		
	if new_dir == cardinal_direction:		 return false   
		
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT  else 1
	return true
	

func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection())
	pass
	
func AnimDirection()-> String:
	if cardinal_direction == Vector2.DOWN:
		return"down"
	elif cardinal_direction == Vector2.UP:
		return"up"
	else:
		return"side"


func _on_cold_timer_timeout():
	if not near_fire: 
		take_damage(0.4)
	else: 
		health = min(health + 3, max_health)
		health_bar.value = health
		
func update_sword_position():
	if sword_hitbox:
		if cardinal_direction == Vector2.RIGHT:
			sword_hitbox.position = Vector2(20, 0)  # Move right
		elif cardinal_direction == Vector2.LEFT:
			sword_hitbox.position = Vector2(-20, 0)  # Move left
		elif cardinal_direction == Vector2.UP:
			sword_hitbox.position = Vector2(0, -20)  # Move up
		elif cardinal_direction == Vector2.DOWN:
			sword_hitbox.position = Vector2(0, 20)  # Move down
			
func place_fire():
	if wood_count >= 3:
		wood_count -= 3
		update_wood_count()

		var fire = fire_scene.instantiate()
		fire.position = position  # Place fire at player's position
		get_tree().current_scene.add_child(fire)
		
		print("🔥 Fire placed at:", fire.position)  # Debugging
	else:
		print("❌ Not enough wood!")
