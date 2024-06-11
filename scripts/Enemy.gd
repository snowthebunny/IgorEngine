extends CharacterBody3D
class_name Enemy

@onready var nav_agent:NavigationAgent3D = NavigationAgent3D.new()
@export var health:int = 3
@export var speed:int = 2

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.87)
signal shot

func _ready():
	connect("shot", _on_shot)
	add_child(nav_agent)

func _physics_process(delta):
	await get_tree().physics_frame
	nav_agent.set_target_position(Global.player.global_position)
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	
	velocity.x = (direction.x * speed)
	velocity.z = (direction.z * speed)
	
	if not is_on_floor():
		velocity.y -= (gravity * delta)
	move_and_slide()

func _on_shot():
	if health > 0:
		health -= 1
	elif health <= 0:
		queue_free()

func push_back(push_basis:Basis):
	var dir = (push_basis * Vector3(0,0,-1)).normalized()
	velocity.x = dir.x
	velocity.z = dir.z
	pass
