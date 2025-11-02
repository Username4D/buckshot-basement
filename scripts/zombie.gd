extends CharacterBody3D

var state = "idle"
@export var health = 10
func _physics_process(delta: float) -> void:
	if state == "idle":
		if self.position.distance_to(self.get_parent().get_node("player").position) < 40.0:
			state = "walking"
			$AnimationPlayer.play("walk", -1, 0.5)
		
		
	if state == "walking":
		var next_path_position: Vector3 = $NavigationAgent3D.get_next_path_position()
		var new_velocity: Vector3 = global_position.direction_to(next_path_position) * 60 * delta
		
		if $NavigationAgent3D.avoidance_enabled:
			$NavigationAgent3D.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)
		
		self.look_at(self.get_parent().get_node("player").position)

		if self.position.distance_to(self.get_parent().get_node("player").position) < 1.0:
			attack()
	
	if health <= 0 and state != "dying":
		state = "dying"
		die()
func attack():
	state = "attack"
	$AnimationPlayer.play("step")
	await get_tree().create_timer(0.4).timeout
	for i in $attack_part.get_overlapping_bodies():
		if i.is_in_group("player"):
			print(i)
	await $AnimationPlayer.animation_finished
	state = "idle"

func die():
	$CollisionShape3D.queue_free()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished

func update_pos():
	$NavigationAgent3D.target_position = self.get_parent().get_node("player").position
	get_tree().create_timer(0.2).timeout.connect(update_pos)
	
func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	if state == "walking":
		move_and_slide()
	
func _ready() -> void:
	update_pos()
	$NavigationAgent3D.velocity_computed.connect(Callable(_on_velocity_computed))
