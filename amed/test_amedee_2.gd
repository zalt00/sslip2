extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PinJoint2D.node_a = $player.body.get_path()
	$PinJoint2D.node_b = $chaine.maillons[0].get_path()
	
	$chaine.maillons[-1].global_position = $Pillar.global_position
	
	$joint2.node_a = $chaine.maillons[-1].get_path()
	$joint2.node_b = $Pillar.get_path()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and false:
		
		
		var gpos = $Pillar.global_position
		var dpos = (get_global_mouse_position() - gpos).normalized()
		
		$Pillar.apply_central_impulse(dpos * -3.0)

	
	#$pillar.position = $chaine.maillons[-1].position
	#$joint2.position = $chaine.maillons[-1].position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
