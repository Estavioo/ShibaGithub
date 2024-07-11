extends ProgressBar


func set_health_bar(health, maxHealth):
	max_value = maxHealth
	value = health

func change_health(newValue):
	value += newValue
	
