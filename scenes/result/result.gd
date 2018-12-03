extends Container

onready var deitiesDefeated = $resultVbox/deitiesDefeatedCount
onready var resultHeader = $resultHeader
onready var totalSacrificed = $resultVbox/totalSacrificedCount
onready var totalRemaining = $resultVbox/totalRemainingCount

func _ready():
	if gameData.deityOptions.empty():
		resultHeader.text = "You win!"
	elif gameData.playerFollowerCount == 0:
		resultHeader.text = "You lose!"

	deitiesDefeated.text = String(gameData.deitiesDefeated)
	totalSacrificed.text = String(gameData.totalSacrified)
	totalRemaining.text = String(gameData.playerFollowerCount)
