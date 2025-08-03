class_name Mechant extends StaticBody2D

var y_start: float
var phi := randf_range(0., TAU)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	y_start = position.y
	$AnimatedSprite2D.frame = randi() % 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = y_start + 8. * sin(phi + .003 * Time.get_ticks_msec()) ** 2
