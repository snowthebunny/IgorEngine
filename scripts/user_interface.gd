extends Control

@onready var ammo_label = $CanvasLayer/AmmoLabel

func _process(_delta):
	ammo_label.text = str(Global.ammo[Global.current_gun_index]) + "/10"
