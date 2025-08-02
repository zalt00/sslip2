class_name AmedChain extends Node2D
@export var amount: int
@onready var node_a = $RigidBody2D

func init_joint():
	if amount > 0:
		var instance = AmedChain.new()
		instance.amount = amount - 1
		$child.add_child(instance)
		$PinJoint2D.node_b = instance.node_a
		instance.init_joint()
