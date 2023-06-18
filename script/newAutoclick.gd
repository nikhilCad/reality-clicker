extends Button


onready var autoclick=$"/root/Main".autoclick


var shop=preload("res://shop.tscn")

var numShops=0

onready var root=$"/root/Main"

#custom function called from Main when file is ready
func startUp():
	numShops=root.data["shop"]
	addOnLoad(numShops)
	if numShops<len(autoclick):
		text="AUTO : $"+str(root.formatter(autoclick[numShops][1]))
	else:
		text="ALL SHOPS BOUGHT"

func _on_newAutoclick_pressed():
	if numShops<len(autoclick):
		var curCost=autoclick[numShops][1]#array starts at 0
		if curCost<=root.money:
			root.money-=curCost
			numShops+=1
			add(numShops-1)#array starts at 0
			root.data["shop"]=numShops
			root.save()
			
			if numShops<len(autoclick):
				text="AUTO : $"+str(root.formatter(autoclick[numShops][1]))
			else:
				text="ALL SHOPS BOUGHT"

func add(i=0):
	var button=shop.instance()
	button.get_node("Label").text=str(autoclick[i][0])
	button.shopName=autoclick[i][0]
	button.time=autoclick[i][3]
	button.mpsMult=autoclick[i][4]
	button.costMult=autoclick[i][5]
	button.get_node("Button").text=str(autoclick[i][1])
	
	var autoClickNode=$"/root/Main/bottomButtons/autoclick/ScrollContainer/autoClick"
	
	#For some reason the las item was left out
	#This fixes the bug in a hacky way
	var lastItemBugHelper=autoClickNode.get_child(autoClickNode.get_child_count()-1)
	
	autoClickNode.add_child(button)
	
	autoClickNode.move_child(lastItemBugHelper,autoClickNode.get_child_count()-1)
	button.startUp()

func addOnLoad(i=0):
	for x in range(i):
		if x < len(autoclick):
			add(x)







