extends ProgressBar


func health_damaged():
	pass

func health_regen(delta):
	if value < 100:
		await get_tree().create_timer(3.0).timeout
		value += 5
		print("Health: " + str(value))
