extends Node3D

var wave = 1
var zombie = preload("res://scenes/zombie.tscn")

func check_wave():
	var alive = $enemies.get_child_count()
	for  i in $enemies.get_children():
		if i.health <= 0:
			alive -= 1
	print(alive)
	if alive == 0:
		wave += 1
		for i in range(0, pow(2, wave)):
			var nzombie = zombie.instantiate()
			nzombie.scale = Vector3(0.02,0.02,0.02)
			nzombie.position = $spawn_locations.get_children()[randi_range(0, $spawn_locations.get_child_count() - 1)].position
			$enemies.add_child(nzombie)
		print(wave)
