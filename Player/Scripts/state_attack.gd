class_name State_Attack extends State

var attacking : bool = false
@onready var sword_hitbox : Area2D = $"../../SwordHitBox"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"

func Enter():
	player.UpdateAnimation("attack")
	animation_player.animation_finished.connect( EndAttack )
	attacking = true
	
	sword_hitbox.monitoring = true  # Enable hit detection
		
		# First, disconnect the signal if it was already connected (to prevent duplicates)
		
		
		# Now, reconnect the signal
	sword_hitbox.body_entered.connect(_on_sword_hitbox_body_entered)
	attacking=true
	
	
## What happens when the player exits this state
func Exit() -> void:
	pass


func Process(_delta : float) -> State:
	player.velocity = Vector2.ZERO
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null 



func Physics(_delta : float) -> State:
	return null



func HandleInput(_event: InputEvent ) -> State:
	return null



func EndAttack(_newAniName: String) -> void:
	attacking = false
	if sword_hitbox:
		sword_hitbox.monitoring = false  
	
func _on_sword_hitbox_body_entered(body):
	if "Tree" in body.name:  # Make sure it’s a tree
		print("Tree hit! Collecting wood...")
		player.wood_count += 1  # Add wood to inventory
		print("Wood count : ", player.wood_count)
		body.queue_free()  # Remove the tree from the scene
		player.update_wood_count()
