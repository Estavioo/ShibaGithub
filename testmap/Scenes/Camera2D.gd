extends Camera2D

var firstto2 = true
var secondto3 = true

func _on_scene_12_connector_body_exited(_body):
	if firstto2:
		limit_right = 2880
		limit_left = 960
		firstto2=false
	else:
		limit_right = 960
		limit_left = -960
		firstto2=true


func _on_scene_23_connector_body_exited(_body):
	if secondto3:
		limit_top = -1620
		limit_bottom = -540
		secondto3=false
	else:
		limit_top = -540
		limit_bottom = 540
		secondto3=true
