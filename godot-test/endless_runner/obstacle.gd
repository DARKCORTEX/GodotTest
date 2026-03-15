extends Area2D

func _ready() -> void:
	# Obstacles move to the left relative to the player, but since the 
	# player is moving to the right, we'll just keep the obstacles static 
	# and the camera will move.
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		# Game Over - reload scene for now
		get_tree().reload_current_scene()
