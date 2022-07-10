class_name LaneColumn extends Node2D
""" This class will manage the logic of connecting new columns, and generating
new ones
"""

var _chunks := []

onready var _chunker := preload("res://source/scenes/game_objects/lane_generator/lane_chunk.tscn")
onready var num_chunks = floor(Global.view_size.y / Global.sprite_size.y) # Number of chunks is now determined by the sprite size and viewport size

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
	for i in range(num_chunks):
		var new_chunk : LaneChunk = _chunker.instance(type)
		_chunks.push_back(new_chunk)
		new_chunk.position.y = ceil(Global.sprite_size.y / 2) + Global.sprite_size.y * i
		self.call_deferred("add_child", new_chunk)
