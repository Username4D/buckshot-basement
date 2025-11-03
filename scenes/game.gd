extends Node3D

func _process(delta: float) -> void:
	$Label.text= "Enemys left: " + var_to_str(int(ui_handler.enemys))
	$Label2.text = "Wave: " + var_to_str(ui_handler.wave)
	$"enemys left".max_value = pow(2, ui_handler.wave)
	$"enemys left".value = ui_handler.enemys
	$health.value = ui_handler.hp
	
func _ready() -> void:
	ui_handler.death.connect(death)

func death():
	if ui_handler.hp == 0:
		ui_handler.hp = 10
		$death_screen/wave.text = "Wave: " + var_to_str(int(ui_handler.wave))
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		ui_handler.death.disconnect(death)
		await get_tree().process_frame
		$death_screen.visible = true
		$death_transition.start()
		while $death_transition.time_left != 0:
			$death_screen.modulate.a = 1 - $death_transition.time_left * 2
		
			await get_tree().process_frame

func _on_retry_pressed() -> void:
	var game = load("res://scenes/game.tscn").instantiate()
	self.get_parent().add_child(game)
	self.queue_free()
