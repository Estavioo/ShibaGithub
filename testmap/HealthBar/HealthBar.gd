extends Control

@onready var Healthbar1 = $Healthbar1
@onready var Healthbar2 = $Healthbar2

func set_health_bar(health, maxHealth):
	max_value


func change_health(newValue):
	var oldValue = Healthbar2.value
	var stylebox : StyleBox = Healthbar1.get_theme_stylebox("fill")
	if newValue > 0 : 
		Healthbar1.value = oldValue + newValue
		stylebox.bg_color = Color("1a340b")
		_catch_up_change(Healthbar2, newValue)
	elif newValue < 0 :
		Healthbar2.value = oldValue + newValue
		stylebox.bg_color = Color("ca0020")
		_catch_up_change(Healthbar1, newValue)
	Healthbar1.add_theme_stylebox_override("fill", stylebox)

func _catch_up_change(Healthbar, changeValue):
	for i in abs(changeValue):
		await get_tree().create_timer(0.05).timeout
		if changeValue < 0 : Healthbar.value -= 1
		elif changeValue > 0 : Healthbar.value += 1
		

	
