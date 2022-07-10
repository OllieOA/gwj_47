class_name LaneColumn extends Node2D
""" This class will manage the logic of connecting new columns, and generating
new ones
"""

var _chunks := []

onready var _chunker := preload("res://source/scenes/game_objects/lane_generator/lane_chunk.tscn")
onready var _debriser := preload("res://source/scenes/game_objects/debris/debris.tscn")
onready var num_chunks = floor(Global.view_size.y / Global.sprite_size.y) # Number of chunks is now determined by the sprite size and viewport size

const _DEBRIS_PROBABILITY = 0.95  # TODO: Refactor this to a global accelerating chance
const _DEBRIS_X_OFFSET = 100

# ENGINE CALLBACKS
func _ready() -> void:
	pass


# CUSTOM METHODS
func read_column_connections() -> Array:
	# This will return information about the chunk types (i.e. connectable or not)
	# ->DAVE<- I like this, but don't have time to implement it, sorry!
	var column_connectable = []
	for _chunk in _chunks:
		column_connectable.append(_chunk.connectable)
	return []

func generate_column(type : int = 999) -> void:
	# This generates the chunk, taking in parameters for type. 999 is random.
	for i in range(1, num_chunks-1):
		var new_chunk : LaneChunk = _chunker.instance(type)
		_chunks.push_back(new_chunk)
		new_chunk.position.y = ceil(Global.sprite_size.y / 2) + Global.sprite_size.y * i
		call_deferred("add_child", new_chunk)

	# Then place debris symmetrically
	for i in range(1, 4):
		# TODO REPLACE THIS WITH BETTER RANDOM LOGIC
		var _debris_roll = randf()
		if _debris_roll > _DEBRIS_PROBABILITY:
			var _new_debris: Debris = _debriser.instance(false)
			_new_debris.position.y = ceil(Global.sprite_size.y / 2) + Global.sprite_size.y * i
			_new_debris.position.x += 100

			var _new_debris_reflection: Debris = _debriser.instance(true)
			_new_debris_reflection.position.y = ceil(Global.sprite_size.y / 2) + Global.sprite_size.y * (7-i)
			_new_debris_reflection.position.x += 100

			call_deferred("add_child", _new_debris)
			call_deferred("add_child", _new_debris_reflection)