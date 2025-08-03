extends Camera2D

func _ready() -> void:
	limit_left = Global.limit_left
	limit_right = Global.limit_right
	limit_top = Global.limit_up
	limit_bottom = Global.limit_down + 100.
