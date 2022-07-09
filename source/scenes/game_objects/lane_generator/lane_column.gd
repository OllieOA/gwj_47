class_name LaneColumn extends Node2D
""" This class will manage the logic of connecting new columns, and generating
new ones
"""

var _chunks := []

onready var _chunker := preload("res://source/scenes/game_objects/lane_generator/lane_chunk.tscn")

# ENGINE CALLBACKS
func _ready() -> void:
	pass


# CUSTOM METHODS
func read_column_connections() -> Array:
	# This will return information about the chunk types (i.e. connectable or not)
	var column_connectable = []
	for _chunk in _chunks:
		column_connectable.append(_chunk.connectable)
	return []

func generate_column(type : int = 999) -> void:
	for i in range(1, 6):
		var new_chunk : LaneChunk = _chunker.instance(type)
		_chunks.push_back(new_chunk)
		self.call_deferred("add_child", new_chunk)
