extends Label

var time = 0.0
@export var score_label: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !score_label.win:
		time += delta
		var txt = "%0.2f" % time
		if len(txt) > 5:
			txt = txt.erase(5, 100)
		text = txt
