extends Node3D

func _process(delta: float) -> void:
	$Label.text= "Enemys left: " + var_to_str(int(ui_handler.enemys))
	$Label2.text = "Wave: " + var_to_str(ui_handler.wave)
	$"enemys left".max_value = pow(2, ui_handler.wave)
	$"enemys left".value = ui_handler.enemys
	$health.value = ui_handler.hp
