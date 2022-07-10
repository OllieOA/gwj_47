class_name LaneGenerator extends YSort
"""
I would have called this a lane _manager_ ¬‿¬ - DAVE
"""

# DAVE NOTES:
# I now calculate

export var max_cols : int = 3

var _first_child_column
var _columns := []


onready var _lane_column : PackedScene = preload("res://source/scenes/game_objects/lane_generator/lane_column.tscn")
onready var _num_columns = ceil(Global.view_size.x / Global.sprite_size.x) + 1 # Calculated from the viewport size, in case we want to tweak later
onready var LEFT_CUTOFF := -ceil(Global.sprite_size.x * 1)  # x coord to queue free

func _ready() -> void:
	_initialize_columns()


func _physics_process(delta: float) -> void:
	# Check for the first column in the children
	# ->DAVE<- instead of checking for the first column, we now store the columns and pull the first one
	# Possible "time save" here by pre-genning the entire level?
	if _columns[0].position.x < LEFT_CUTOFF:
		_columns[0].queue_free()
		_columns.pop_front()
		_create_new_column()
	
	for column in _columns:
		column = column as KinematicBody2D
		# Not good, too jittery.
		column.move_and_slide(Vector2.LEFT * Global.scroll_speed) 


func _initialize_columns() -> void:
	# Create the initial run of columns
	for i in range(_num_columns):
		# Added a check into these creations, so that we can re-use the function for specific types
		_create_new_column(LaneChunk.Type.EMPTY)
		_columns[i].position.x = Global.sprite_size.x * i # This overrides the default position, to populate the screen.


func _create_new_column(type : int = 999) -> void: # 999 means randomly generate type
	# Generate a new column
	var new_column = _lane_column.instance()
	new_column.position.x = Global.sprite_size.x * (_num_columns - 1) # Position the column properly
	_columns.push_back(new_column)
	add_child(new_column)
#	new_column.generate_column(get_child(-1).read_column_connections()) # Not sure here?
	new_column.generate_column(type)
