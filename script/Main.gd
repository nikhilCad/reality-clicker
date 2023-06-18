extends Control

var autoclick=[
#time is in seconds
#mps is actually money on progress complete
#   [ Name        Cost       MPS             time     mpsMult  costMult]
	["Lemonade",  1.00,      0.50,           5,       1.07,    1.14],
	["Burger",    50.00,     12.00,          15,      1.06,    1.15],
	["Car wash",  600.00,    120.27,         30,      1.09,    1.15],
	["Newspaper", 1300.00,   600.22,         60,      1.10,    1.16],
	["Donut",     15000.00,  8000.32,        110,     1.11,    1.17],
	["Game Dev",  38*ttp(4), 12.42*ttp(4),   610,     1.09,    1.18],
	["NGO",       76*ttp(5), 32.16*ttp(5),   1350,    1.09,    1.14],
	["Stocks",    20*ttp(6), 9.70*ttp(6),    5230,    1.07,    1.16],
	["Politics",  98*ttp(7), 41.22*ttp(7),   15230,   1.08,    1.14],
	["Religion",  27*ttp(8), 11.23*ttp(8),   36420,   1.07,    1.18]
]


var money = 0.00  setget money_set

var debug_money=0.00 #0.00

var path="user://data.json"

#default data on startup
var default_data={}

#use and manipulate DATA variable
#THEN CALL save()
var data={}

onready var autoNode=$bottomButtons/managers/ScrollContainer/autoClick/newAutoclick

onready var admob = $AdMob

func _ready():
	changeDefaultData()
	#Uncomment when you make changes to save system
	#newEmptyFile()
	_load()
	loadAds()

func money_set(new_money):
	money=new_money
	$moneyLabel.text="MONEY : $"+formatter(money)
	data["money"]=money
	save()

func save():
	var file=File.new()
	file.open(path,file.WRITE)
	file.store_string(to_json(data))
	file.close()

func _load():
	var file=File.new()
	
	if not file.file_exists(path):
		newEmptyFile()
	
	file.open(path,file.READ)
	
	#data is a dictionary  data["money"]
	data=parse_json(file.get_as_text())
	file.close()
	
	money=data["money"]
	$moneyLabel.text="MONEY : $" + formatter(money)
	
	autoNode.startUp()
	$bottomButtons/managers/ScrollContainer/autoClick/clickReward.startUp()

func newEmptyFile():
	data =default_data.duplicate(true)
	save()

func changeDefaultData():
	#changing default data here
	default_data["money"]=debug_money
	default_data["shop"]=0
	default_data["clickReward"]=1
	default_data["clickRewardCost"]=10
	default_data["clickRewardNum"]=0
	var shopData={}
	var source=autoNode.autoclick
	for i in range(len(source)):
		var insideInsideData={}
		insideInsideData["Cost"]=source[i][1]
		insideInsideData["MPS"]=source[i][2]
		insideInsideData["Num"]=0#0 for all
		insideInsideData["Time"]=source[i][3]
		shopData[source[i][0]]=insideInsideData
	default_data["shopData"]=shopData

func formatter(num):
	#1000 should return "1.00k", 1100 "1.10k" and so on
	if num<ttp(3):
		return "%.2f"%(num)
	elif num>=ttp(3) and num<ttp(6):
		return "%.2f"%(num/ttp(3))+" K"
	elif num>=ttp(6) and num<ttp(9):
		return "%.2f"%(num/ttp(6))+" M"
	elif num>=ttp(9) and num<ttp(12):
		return "%.2f"%(num/ttp(9))+" B"
	elif num>=ttp(12) and num<ttp(15):
		return "%.2f"%(num/ttp(12))+" T"
	elif num>=ttp(15) and num<ttp(18):
		return "%.2f"%(num/ttp(15))+" Q"
	elif num>=ttp(18) and num<ttp(21):
		return "%.2f"%(num/ttp(18))+" P"
	elif num>=ttp(21) and num<ttp(23):
		return "%.2f"%(num/ttp(21))+" Q"
	else:
		return "infinity"

func ttp(n):#tenToPow
	return pow(10,n)

func _on_resetButton_pressed():
	newEmptyFile()
	get_tree().reload_current_scene()

func loadAds() -> void:
	admob.load_interstitial()

func show_interstitial_ad():
	admob.show_interstitial()

func _on_adTimer_timeout():
	show_interstitial_ad()
	loadAds()
