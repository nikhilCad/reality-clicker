extends Button

var clickEarn =1

func _on_mainClick_pressed():
	$"/root/Main".money+=clickEarn
	pass # Replace with function body.
