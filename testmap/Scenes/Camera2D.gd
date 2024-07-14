extends Camera2D

var firstto2 = true

func _on_scene_12_connector_body_exited(body):
	if firstto2:
		limit_right = 2880
		limit_left = 960
		firstto2=false
	else:
		limit_right = 960
		limit_left = -960
		firstto2=true
