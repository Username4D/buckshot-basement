extends CharacterBody3D

const sens = -.0015
const speed = -3

var real_velocity = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotate(Vector3(0,1,0), sens  * event.relative.x)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x + sens * event.relative.y, -2, 2)
		print(event.relative.x)
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if Input.get_axis("ui_down","ui_up"):
		real_velocity.z = move_toward(real_velocity.z, speed* Input.get_axis("ui_down","ui_up"), 16 * delta )
	else:
		real_velocity.z = move_toward(real_velocity.z, 0, 32 * delta)
	
	if Input.get_axis("ui_left","ui_right"):
		real_velocity.x = move_toward(real_velocity.x, speed* Input.get_axis("ui_left","ui_right") * -1, 32 * delta)
	else:
		real_velocity.x = move_toward(real_velocity.x, 0, 32 * delta)
	
	velocity  =real_velocity.rotated(Vector3(0,1,0), self.rotation.y)
	self.move_and_slide()
