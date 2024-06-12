extends CharacterBody3D
class_name Enemy

@onready var hurt_streams:Array = [
	preload("res://audio/sounds/enemies/example hurt1.ogg"),
	preload("res://audio/sounds/enemies/example hurt2.ogg"),
	preload("res://audio/sounds/enemies/example hurt3.ogg")
]
@onready var hurt_audio = $HurtAudio
@onready var nav_agent:NavigationAgent3D = NavigationAgent3D.new()
@export var health:int = 2
@export var speed:int = 2
@onready var animation_player = $AnimationPlayer
@onready var collision = $Collision
@onready var death_timer = $DeathTimer

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.87)
var dead = false
var last_stream_index = 0

signal shot

func _ready():
	connect("shot", _on_shot)
	add_child(nav_agent)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= (gravity * delta)
	
	if dead:
		velocity = Vector3.ZERO
		collision.disabled = true
		return
	
	await get_tree().physics_frame
	nav_agent.set_target_position(Global.player.global_position)
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	
	velocity.x = (direction.x * speed)
	velocity.z = (direction.z * speed)
	
	move_and_slide()

func _process(_delta):
	pass

func _on_shot():
	var select = randi_range(0, (len(hurt_streams) - 1))
	
	while last_stream_index == select:
		select = randi_range(0, (len(hurt_streams) - 1))
	
	hurt_audio.stream = hurt_streams[select]
	hurt_audio.play()
	if health > 0:
		health -= 1
	elif health <= 0:
		animation_player.play("dead")
		death_timer.start()
		dead = true

func _on_death_timer_timeout():
	queue_free()
