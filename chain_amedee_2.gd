extends Node2D

@onready var maillon_scene = preload("res://maillon_amed.tscn")
@export var nombre_de_maillons = 20
func _ready() -> void:
	var maillons = []
	var joints = []

	var dx = 30
	for i in range(0, nombre_de_maillons):
		var maillon = maillon_scene.instantiate()
		maillon.position.x += i * dx
		maillons.append(maillon)
	for maillon in maillons:
		add_child(maillon)
		
	for i in range(1, nombre_de_maillons):
		var joint = PinJoint2D.new()
		var m1 = maillons[i-1]
		var m2 = maillons[i]
		joint.position.x += i * dx - dx/2
		joint.node_a = m1.get_path()
		joint.node_b = m2.get_path()
		joints.append(joint)		

	for joint in joints:
		add_child(joint)
	
	
	
	
