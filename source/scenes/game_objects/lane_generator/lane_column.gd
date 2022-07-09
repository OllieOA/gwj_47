class_name LaneColumn extends Node2D
""" This class will manage the logic of connecting new columns, and generating
new ones
"""

var _chunks := []

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
