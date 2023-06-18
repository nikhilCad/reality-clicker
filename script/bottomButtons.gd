extends Control

var colour=Color.cyan

func _ready():
	make_all_invisible()
	make_all_white()
	$autoclick/ScrollContainer.visible=true
	$autoclick.self_modulate=colour

func _on_autoclick_pressed():
	make_all_invisible()
	make_all_white()
	$autoclick/ScrollContainer.visible=true
	$autoclick.self_modulate=colour


func _on_managers_pressed():
	make_all_invisible()
	make_all_white()
	$managers/ScrollContainer.visible=true
	$managers.self_modulate=colour


func _on_premium_pressed():
	make_all_invisible()
	make_all_white()
	$premium/ScrollContainer.visible=true
	$premium.self_modulate=colour


func _on_setttings_pressed():
	make_all_invisible()
	make_all_white()
	$setttings/ScrollContainer.visible=true
	$setttings.self_modulate=colour

func make_all_invisible():
	for i in get_children():
		if not i.name=="Panel":
			i.get_node("ScrollContainer").visible=false
			
func make_all_white():
	for i in get_children():
		i.self_modulate=Color.white














