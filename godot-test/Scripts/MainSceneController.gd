extends Node2D

@export var _levels: Array[PackedScene]
@export var _actualLevel : int = 1
@export var _instantiatedLevel : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreateLevel(_actualLevel)

func CreateLevel(_levelID:int): 
	_instantiatedLevel = _levels[_levelID -1].instantiate()
	add_child(_instantiatedLevel)
	
	#var _children := get_tree().get_nodes_in_group("Players")
	#_children[0]._playerDead.connect(RestartLevel)
	var _children := _instantiatedLevel.get_children()
	for i in _children.size():
		if _children[i].is_in_group("Players"):
			_children[i].PlayerDead.connect(RestartLevel)
			break
	
func DeleteLevel():
	_instantiatedLevel.queue_free()

func RestartLevel():
	DeleteLevel()
	CreateLevel.call_deferred(_actualLevel)
