extends Button

var cost = 10
var costBase=2
var clickNum
onready var root=$"/root/Main"
onready var mainClick=$"/root/Main/button/mainClick"

func startUp():
	cost=root.data["clickRewardCost"]
	mainClick.clickEarn=root.data["clickReward"]
	clickNum=root.data["clickRewardNum"]
	
	mainClick.text = "GET $"+str(mainClick.clickEarn)
	text = "PRICE : $" + root.formatter(cost)

func _on_clickReward_pressed():
	if cost<=root.money:
		
		mainClick.clickEarn+=1
		
		clickNum+=1
		mainClick.text="GET $"+str(mainClick.clickEarn)
		root.money-=cost
		cost*=costBase*pow(1.07,clickNum+0.1)
		
		root.data["clickRewardCost"]=cost
		root.data["clickReward"]=mainClick.clickEarn
		root.data["clickRewardNum"]=clickNum
		
		root.save()
		
		text = "PRICE : $" + root.formatter(cost)
