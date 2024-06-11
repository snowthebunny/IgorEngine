extends CharacterBody3D
class_name PlayerCharacter

@onready var camera:Camera3D = $Camera
@export_category("")
@export var speed:float = 5.0
@export var acceleration:float = 16.0
@export var deacceleration:float = 16.0
@export var mouse_sens:float = 1.0
@onready var guncam:Camera3D = $GunHolder/SubViewportContainer/SubViewport/GunCam
@onready var gun_holder:CanvasLayer = $GunHolder
@onready var guns_node:Node3D = $GunHolder/SubViewportContainer/SubViewport/GunCam/Guns

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.87)

func _ready():
	Global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-(event.relative.x * deg_to_rad(mouse_sens)))
		camera.rotate_x(-(event.relative.y * deg_to_rad(mouse_sens)))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		guns_node.rotate_y((event.relative.x * deg_to_rad(mouse_sens)))
		guns_node.rotate_x((event.relative.y * deg_to_rad(mouse_sens)))

func _process(_delta):
	guncam.set_global_transform(camera.global_transform)
	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("shoot"):
		gun_holder.shoot()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= (gravity * delta)
	else:
		velocity.y = 0
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, (direction.x * speed), (delta * acceleration))
		velocity.z = lerp(velocity.z, (direction.z * speed), (delta * acceleration))
	else:
		velocity.x = lerp(velocity.x, 0.0, (delta * deacceleration))
		velocity.z = lerp(velocity.z, 0.0, (delta * deacceleration))
	
	move_and_slide()
