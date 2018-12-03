extends Node

var chosenDeity = null
var computerDeity = null
var computerFollowerCount = 10
var computerSacrificeCount = 0
var deitiesDefeated = 0
var deityOptions = [
	"Orifices",
	"Dodocan",
	"Neckbeards",
	"Bones",
	"Deals",
	"Hunger"
]
var playerFollowerCount = 10
var playerSacrificeCount = 0
var totalSacrified = 0

func _ready():
	pass

# reset
# Resets global game data for repaly
func reset():
	chosenDeity = null
	computerDeity = null
	computerFollowerCount = 10
	computerSacrificeCount = 0
	deitiesDefeated = 0
	deityOptions = [
		"Orifices",
		"Dodocan",
		"Neckbeards",
		"Bones",
		"Deals",
		"Hunger"
	]
	playerFollowerCount = 10
	playerSacrificeCount = 0
	totalSacrified = 0