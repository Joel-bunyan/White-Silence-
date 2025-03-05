extends Area2D

func _ready():
	print("🔥 Fire spawned!")  # Debugging
	$Timer.start()  # Start countdown to destroy fire

func _on_timer_timeout():
	queue_free()  # Fire disappears after 5 seconds

func _on_body_entered(body):
	if body is Player:
		print("🔥 Player is near fire!")
		body.near_fire = true  # Stop cold damage

func _on_body_exited(body):
	if body is Player:
		print("❄️ Player left the fire!")
		body.near_fire = false  # Cold damage resumes
