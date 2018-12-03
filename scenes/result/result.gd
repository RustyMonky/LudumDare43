extends Container

onready var deity = $deity
onready var deitiesDefeated = $resultGrid/deitiesDefeatedCount
onready var resultHeader = $resultHeader
onready var resultGrid = $resultGrid
onready var sfx = $sfx
onready var totalSacrificed = $resultGrid/totalSacrificedCount
onready var totalRemaining = $resultGrid/totalRemainingCount

func _ready():
	deity.texture = load("res://assets/sprites/deities/" + gameData.chosenDeity + ".png")
	if gameData.deityOptions.empty():
		resultHeader.text = "You win!"
	elif gameData.playerFollowerCount == 0:
		resultHeader.text = "You lose!"

	deitiesDefeated.text = String(gameData.deitiesDefeated)
	totalSacrificed.text = String(gameData.totalSacrified)
	totalRemaining.text = String(gameData.playerFollowerCount)

func _on_restart_pressed():
	sfx.play()
	gameData.reset()
	fader.fade("res://scenes/title/title.tscn")
