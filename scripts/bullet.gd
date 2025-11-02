extends Area3D

func _physics_process(delta: float) -> void:
	self.position += -transform.basis.z * delta * 15


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("zombie"):
		body.health -= 1
		self.queue_free()
	if body.is_in_group("wall"):
		self.queue_free()
	else:
		print(body)
