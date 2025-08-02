extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PinJoint2D.node_a = $player.body.get_path()
	$PinJoint2D.node_b = $chaine.maillons[0].get_path()
	$chaine.maillons[-1].global_position = $pillar.global_position

	$joint2.node_a = $chaine.maillons[-1].get_path()
	$joint2.node_b = $pillar.get_path()
	
	#$pillar.position = $chaine.maillons[-1].position
	#$joint2.position = $chaine.maillons[-1].position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
