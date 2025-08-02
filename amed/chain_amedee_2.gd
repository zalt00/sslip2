extends Node2D

@onready var maillon_scene = preload("res://amed/maillon_amed.tscn")
@export var nombre_de_maillons = 20
@export var physics_material: PhysicsMaterial
@export var gravity_maillon: float = 1.0
@export var mass_maillon: float = 0.05
@export var joint_softness: float = 0.0
var maillons = []
var joints = []
func _ready() -> void:


	var dx = 30
	for i in range(0, nombre_de_maillons):
		var maillon: MaillonAmed = maillon_scene.instantiate()
		maillon.position.x += i * dx
		maillon.physics_material_override = physics_material.duplicate()
		maillon.gravity_scale = gravity_maillon
		maillon.mass = mass_maillon
		maillon.linear_damp = 1.0
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
		joint.softness = joint_softness
		joints.append(joint)		

	for joint in joints:
		add_child(joint)
	
	
	
	
