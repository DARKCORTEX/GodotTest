extends CharacterBody2D
signal PlayerDead

@export var _animation: AnimatedSprite2D
@export var _velocidad: float = 5000.0
@export var _jumpPower: float = -11000.0
@export var _area_2d: Area2D
@export var _damageMaterial : ShaderMaterial
@export var _dead: bool

func _ready():
	add_to_group("Players")
	_area_2d.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta: float):
	if _dead:
		return
	else:
		Animations()
		Run(delta)
		Gravity(delta)
		Jump(delta)

#Player Movement <->
func Run(delta):
	if Input.is_action_pressed("Right"):
		velocity.x = _velocidad * delta
		_animation.flip_h = true
	elif Input.is_action_pressed("Left"):
		velocity.x = -_velocidad * delta
		_animation.flip_h = false
	else:
		velocity.x = 0
	move_and_slide()

func Animations():
	if !is_on_floor():
		_animation.play("Jump")
	elif velocity.x !=0:
		_animation.play("Run")
	else:
		_animation.play("Idle")

#Gets the gravity	
func Gravity(delta):
	velocity += get_gravity() * delta;

#Jump
func Jump(delta):
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = _jumpPower * delta


func _on_area_2d_body_entered(_body: Node2D) -> void:
	_dead = true;
	_animation.material = _damageMaterial
	_animation.stop()
	
	await get_tree().create_timer(0.5).timeout
	PlayerDead.emit()
