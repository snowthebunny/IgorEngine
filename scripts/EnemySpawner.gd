extends Node3D
class_name EnemySpawner

var timer:Timer
var enemy = preload("res://scenes/objs/enemy.tscn")
var enemies:Node3D

func _ready():
	if get_tree().current_scene.get_node_or_null("Enemies") == null:
		enemies = Node3D.new()
		enemies.name = "Enemies"
		get_tree().current_scene.add_child.call_deferred(enemies)
	else:
		enemies = get_tree().current_scene.get_node("Enemies")
	
	timer = Timer.new()
	timer.connect("timeout", _spawn_enemy)
	timer.wait_time = 2
	add_child(timer)
	timer.start()
	

func _spawn_enemy():
	if enemies.get_child_count() == 0:
		var en = enemy.instantiate()
		en.position = position
		enemies.add_child(en)
