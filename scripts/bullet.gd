extends Area3D

func _physics_process(delta: float) -> void:
	self.position += -transform.basis.z * delta * 10
