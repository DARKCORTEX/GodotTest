extends Node2D

@export var ground_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var player: CharacterBody2D

@export var score_label: Label

var last_spawn_x = 0
var score = 0
const SPAWN_DISTANCE = 1200
const CHUNK_SIZE = 600

func _process(_delta: float) -> void:
	# Update Score
	score = int(player.position.x / 100)
	if score_label:
		score_label.text = "Score: " + str(score)
		
	if player.position.x + SPAWN_DISTANCE > last_spawn_x:
		spawn_chunk(last_spawn_x)
		last_spawn_x += CHUNK_SIZE

func spawn_chunk(x_pos: float) -> void:
	# Spawn Ground
	var ground = StaticBody2D.new()
	var collision = CollisionShape2D.new()
	var shape = WorldBoundaryShape2D.new()
	shape.normal = Vector2.UP
	collision.shape = shape
	ground.add_child(collision)
	
	# Visual for ground (simple ColorRect)
	var rect = ColorRect.new()
	rect.size = Vector2(CHUNK_SIZE, 200)
	rect.position = Vector2(0, 0)
	rect.color = Color.MEDIUM_AQUAMARINE
	ground.add_child(rect)
	
	ground.position = Vector2(x_pos, 500)
	add_child(ground)
	
	# Randomly spawn an obstacle
	if randf() > 0.6:
		var obs = obstacle_scene.instantiate()
		obs.position = Vector2(x_pos + randf_range(50, CHUNK_SIZE - 50), 480)
		add_child(obs)
	
	# Cleanup far behind
	for child in get_children():
		if child is Node2D and child.position.x < player.position.x - 2000:
			child.queue_free()
