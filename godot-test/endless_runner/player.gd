extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 1200.0

@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		# Squash and stretch while in air
		sprite.scale.y = lerp(sprite.scale.y, 1.2, 10 * delta)
		sprite.scale.x = lerp(sprite.scale.x, 0.8, 10 * delta)
	else:
		# Return to normal scale on floor
		sprite.scale.y = lerp(sprite.scale.y, 1.0, 15 * delta)
		sprite.scale.x = lerp(sprite.scale.x, 1.0, 15 * delta)

	# Handle Jump.
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		# Jump squash
		sprite.scale = Vector2(0.6, 1.4)

	# Auto-movement to the right
	velocity.x = SPEED

	var was_on_floor = is_on_floor()
	move_and_slide()
	
	# Land squash
	if not was_on_floor and is_on_floor():
		sprite.scale = Vector2(1.4, 0.6)

	# Game over if we fall too far
	if position.y > 1000:
		get_tree().reload_current_scene()
