extends CanvasLayer

@onready var animation_player = $SubViewportContainer/SubViewport/GunCam/Guns/AnimationPlayer
@onready var reload_timer = $SubViewportContainer/SubViewport/GunCam/Guns/ReloadTimer
@onready var guns_node = $SubViewportContainer/SubViewport/GunCam/Guns
@onready var shoot_ray = $SubViewportContainer/SubViewport/GunCam/ShootRay
@onready var gun_cam = $SubViewportContainer/SubViewport/GunCam
@onready var shoot_audio = $SubViewportContainer/SubViewport/GunCam/Guns/Shotgun/ShootAudio
@onready var reload_audio = $SubViewportContainer/SubViewport/GunCam/Guns/Shotgun/ReloadAudio

var rotate_speed = 32
var can_shoot = true

func _ready():
	reload_timer.connect("timeout", reload_timeout)
	animation_player.play(Global.current_gun + "_idle")

func _process(delta):
	guns_node.rotation = lerp(guns_node.rotation, Vector3(0, 0, 0), (delta * rotate_speed))

func _on_animation_player_animation_finished(anim_name:String):
	if anim_name.ends_with("shoot"):
		animation_player.play(Global.current_gun + "_reload")
	elif anim_name.ends_with("reload"):
		animation_player.play(Global.current_gun + "_idle")

func shoot():
	if can_shoot:
		if shoot_ray.is_colliding():
			var col = shoot_ray.get_collider()
			if col.is_in_group("enemies"):
				col.emit_signal("shot")
		shoot_audio.play(0.02)
		animation_player.play(Global.current_gun + "_shoot")
		can_shoot = false
		reload_timer.start()

func reload_timeout():
	can_shoot = true
