extends CharacterBody3D

const sens = -.0015
const speed = -1.4

var on_cooldown = false
var real_velocity = Vector3.ZERO
var Camera_accel = 0

var bullet = preload("res://scenes/bullet.tscn")
var health = 10

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotate(Vector3(0,1,0), sens  * event.relative.x)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x + sens * event.relative.y, -1.5, 2)

	if Input.is_action_just_pressed("ui_shoot") and not on_cooldown:
		shoot()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	ui_handler.hp = health
	if health <= 0:
		ui_handler.death.emit()
	if Input.get_axis("ui_down","ui_up"):
		real_velocity.z = move_toward(real_velocity.z, speed* Input.get_axis("ui_down","ui_up"), 16 * delta )
	else:
		real_velocity.z = move_toward(real_velocity.z, 0, 32 * delta)
	
	if Input.get_axis("ui_left","ui_right"):
		real_velocity.x = move_toward(real_velocity.x, speed* Input.get_axis("ui_left","ui_right") * -1, 32 * delta)
	else:
		real_velocity.x = move_toward(real_velocity.x, 0, 32 * delta)
	
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		real_velocity.y = 1.5
	real_velocity.y -= 0.06
	velocity  =real_velocity.rotated(Vector3(0,1,0), self.rotation.y)
	self.move_and_slide()
	if Camera_accel > 0:
		Camera_accel -= 3 * delta
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x + 3 * delta, -1.5, 2)
func shoot():
	on_cooldown = true
	Camera_accel = .2
	var new_bullet = bullet.instantiate()
	new_bullet.position = $Camera3D/Node3D/aim.global_position
	new_bullet.rotation = $Camera3D.global_rotation
	print(new_bullet.rotation)
	self.get_parent().add_child(new_bullet)
	await get_tree().create_timer(0.25).timeout
	on_cooldown = false
