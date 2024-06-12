extends Node3D
class_name Pickup

signal picked_up
@onready var area:Area3D = $PickupArea

func _ready():
	connect("picked_up", _picked_up)

func _physics_process(_delta):
	if area.overlaps_body(Global.player):
		emit_signal("picked_up")

func _picked_up():
	Global.ammo[0] += 10
	queue_free()
