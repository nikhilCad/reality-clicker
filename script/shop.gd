extends Control

#Basically,the default data is taken from newAutoClick's autoclick variable.
#It is then added to scene and startUp() is called which sets data to saved
#data. After that, if the button is pressed, the data is also saved

const leastWaitTime=0.2#least time for shop work completion

var numShops=0
var cost=0
var shopName=""
var mps=0#money per second #mps is actually money on progress completes
var time=1#cooldown timer time taken from data of shops eg 1sec, 5sec, 100 sec etc.

var costBase=0
var mpsBase=0

var mpsMult=0
var costMult=0

var timerProgress=0

var wait_time=0
var hold=false

var initDelay=0

onready var root=$"/root/Main"

var autoclickString="bottomButtons/managers/ScrollContainer/autoClick/newAutoclick"

#not using ready because
#loading things take time
func startUp():
	
	cost=root.data["shopData"][shopName]["Cost"]
	mps=root.data["shopData"][shopName]["MPS"]
	numShops=root.data["shopData"][shopName]["Num"]
	time=root.data["shopData"][shopName]["Time"]
	
	$Button.text=root.formatter(cost)
	numShops+=1
	
	wait_time=time
	
	$Tween.repeat=true
	$Tween.interpolate_property($progress,"value",0,$progress.max_value,wait_time)
	$Tween.start()
	
	$Tween.playback_speed=1+int(numShops/10)
	
	$Label.text=shopName
	$progressLabel.text="Producing $"+root.formatter(mps)+" on completion"
	
	for z in root.get_node(autoclickString).autoclick:
		if z[0]==shopName:
			costBase=z[1]
			mpsBase=z[2]
	
	mps=mpsBase*mpsMult*numShops

func _on_Button_button_down():
	if cost<=$"/root/Main".money:
		addOnButton()
		hold=true

func _on_Tween_tween_completed(object, key):
	$"/root/Main".money+=mps

func addOnButton():
		$"/root/Main".money-=cost
		
		numShops+=1
		#mps = mpsBase * pow(mpsMult,numShops)
		mps=mpsBase*mpsMult*numShops
		cost = costBase * pow(costMult,numShops)
		
		if wait_time/(1+int(numShops/10))>leastWaitTime:
			$Tween.playback_speed=1+int(numShops/10)
		else:
			wait_time=leastWaitTime
		
		
		$Button.text=root.formatter(cost)#string formatting
		$Label.text=shopName
		$progressLabel.text="Producing $"+root.formatter(mps)+" on completion"
		
		root.data["shopData"][shopName]["Cost"]=cost
		root.data["shopData"][shopName]["MPS"]=mps
		root.data["shopData"][shopName]["Num"]=numShops
		root.data["shopData"][shopName]["Time"]=time
		
		root.save()

func _on_Button_button_up():
	hold=false
	initDelay=0
	
func _on_holdTimer_timeout():
	if cost<=$"/root/Main".money and $Button.pressed and hold:
		#0.1 * 10 = 1 extremely hacky, but works
		initDelay+=1
		if initDelay>=10:
			addOnButton()


