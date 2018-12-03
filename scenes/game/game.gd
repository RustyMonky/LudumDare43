extends Node2D

onready var carousel = $ui/uiContainer/carousel
onready var computerDeityPanel = $ui/uiContainer/deityHbox/computerDeityPanel
onready var deityHbox = $ui/uiContainer/deityHbox
onready var followerHbox = $ui/uiContainer/followerHbox
onready var playerDeityPanel = $ui/uiContainer/deityHbox/playerDeityPanel
onready var sfx = $sfx
onready var textHbox = $ui/uiContainer/textHbox
onready var textInterface = $ui/uiContainer/textHbox/textInterface
onready var tween = $tween
onready var uiContainer = $ui/uiContainer

var computerBid = 0
var followerIcon = load("res://assets/sprites/ui/icons/follower.png")
var worshipper = load("res://ui/worshipper/worshipper.tscn")

func _ready():
	carousel.setOptions(gameData.deityOptions)

	textInterface.confirmButton.connect("pressed", self, "_on_confirmButton_pressed")
	textInterface.nextButton.connect("pressed", self, "_on_nextButton_pressed")

# addFollowers
# Adds followers to the appropriate container
func addFollowers():
	for child in followerHbox.get_children():
		child.queue_free()

	for i in range(gameData.playerFollowerCount):
		var follower = worshipper.instance()
		followerHbox.add_child(follower)
	playerDeityPanel.setCount(gameData.playerFollowerCount)

# checkComputerCount
# If the computer follower count descends past zero, round it to zero
func checkComputerCount():
	if gameData.computerFollowerCount < 0:
		gameData.computerFollowerCount = 0

# checkPlayerCount
# If the player follower count descends past zero, round it to zero
func checkPlayerCount():
	if gameData.playerFollowerCount < 0:
		gameData.playerFollowerCount = 0

# promptSacrifices
# Resets sacrifice count and adds the vertical scroll interface
func promptSacrifices():
	gameData.computerSacrificeCount = 0
	gameData.playerSacrificeCount = 0

	textInterface.confirmButton.hide()

	var vertScroll = load("res://ui/vertScroll/vertScroll.tscn").instance()
	vertScroll.connect("tree_exited", self, "_on_vertScroll_tree_exited")
	textHbox.add_child(vertScroll)

# resetSacrificePrompt
# Resets sacrifice data and updates text interface for next bidding
func resetSacrificePrompt():
	var textArrayToUse = []

	if gameData.playerFollowerCount == 0:
		fader.fade("res://scenes/result/result.tscn")
		return

	if gameData.computerFollowerCount == 0:
		textArrayToUse.append({
			"event": "computerLose",
			"text": gameData.computerDeity + " is out of worshippers!"
		})
		victory(textArrayToUse)

	if gameData.playerFollowerCount > 0:
		textArrayToUse.append({
			"event": "sacrificePrompt",
			"text": "How many worshippers will you sacrifice?"
		})

		if textArrayToUse.size() == 1:
			promptSacrifices()

	textInterface.setText(textArrayToUse)

# victory
# param [Array] textArray
# Determines victory results
func victory(textArray):
	gameData.deityOptions.remove(gameData.computerDeity)
	gameData.deitiesDefeated += 1
	randomize()

	if gameData.deityOptions.empty():
		fader.fade("res://scenes/result/result.tscn")

	elif gameData.playerFollowerCount > 0:
		var randIndex = randi() % gameData.deityOptions.size() - 1
		gameData.computerDeity = gameData.deityOptions[randIndex]

		textArray.append({
			"event": "victory",
			"text": "Your victory has attracted 5 more worshippers!"
		})

		textArray.append({
			"event": "nextDeity",
			"text": gameData.computerDeity + " is the next deity to defeat."
		})

# Signals

# Called when a deity is selected and the carousel has exited the tree
func _on_carousel_tree_exited():
	playerDeityPanel.setCount(gameData.playerFollowerCount)
	playerDeityPanel.setDeityTexture(gameData.chosenDeity)
	playerDeityPanel.setName(gameData.chosenDeity)
	computerDeityPanel.setCount(gameData.computerFollowerCount)
	computerDeityPanel.setDeityTexture(gameData.computerDeity)
	computerDeityPanel.setName(gameData.computerDeity)
	tween.interpolate_property(deityHbox, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(textInterface, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

	resetSacrificePrompt()
	addFollowers()

# Called at end of text cycle to trigger a reset of the bidding flow
func _on_confirmButton_pressed():
	sfx.play()
	resetSacrificePrompt()

# Called when cycling through the text array
func _on_nextButton_pressed():
	match(textInterface.textArray[textInterface.currentTextIndex].event):
		"computerSacrifice":
			gameData.computerFollowerCount -= computerBid
			checkComputerCount()
			computerDeityPanel.setCount(gameData.computerFollowerCount)

		"winBid":
			gameData.playerFollowerCount += (gameData.playerSacrificeCount - computerBid)
			playerDeityPanel.setCount(gameData.playerFollowerCount)
			addFollowers()

		"computerLoseBid":
			gameData.computerFollowerCount -= 1
			checkComputerCount()
			computerDeityPanel.setCount(gameData.computerFollowerCount)

		"computerWinBid":
			gameData.computerFollowerCount += (computerBid - gameData.playerSacrificeCount)
			computerDeityPanel.setCount(gameData.computerFollowerCount)

		"loseBid":
			gameData.playerFollowerCount -= 1
			checkPlayerCount()
			playerDeityPanel.setCount(gameData.playerFollowerCount)
			addFollowers()

		"victory":
			gameData.playerFollowerCount += 5
			playerDeityPanel.setCount(gameData.playerFollowerCount)
			addFollowers()

		"nextDeity":
			gameData.computerFollowerCount = 10
			computerDeityPanel.setCount(gameData.computerFollowerCount)
			computerDeityPanel.setDeityTexture(gameData.computerDeity)
			computerDeityPanel.setName(gameData.computerDeity)

		"sacrificePrompt":
			resetSacrificePrompt()

# Called when a sacrifice count is selected and the vertical scroll has exited the tree
func _on_vertScroll_tree_exited():
	sfx.play()

	var textArrayToUse = [{
		"event": "playerSacrifice",
		"text": "You've sacrificed " + String(gameData.playerSacrificeCount) + " worshippers."
	}]
	# Reset the vertical scroll value
	gameData.playerFollowerCount -= gameData.playerSacrificeCount

	for i in range(gameData.playerSacrificeCount):
		followerHbox.get_children()[i].queue_free()

	# Randomly choose computer bid count
	randomize()
	computerBid = randi() % int(gameData.computerFollowerCount + 1)
	gameData.computerSacrificeCount = computerBid

	textArrayToUse.append({
		"event": "computerSacrifice",
		"text": gameData.computerDeity + " sacrificed " + String(gameData.computerSacrificeCount) + " worshippers."
	})

	# Compare results
	if gameData.playerSacrificeCount > computerBid:
		var difference = gameData.playerSacrificeCount - computerBid
		textArrayToUse.append({
			"event": "winBid",
			"text": "You outbid " + gameData.computerDeity + " and gained " + String(difference) + " worshippers!"
		})

		if gameData.computerFollowerCount > 0:
			textArrayToUse.append({
				"event": "computerLoseBid",
				"text": "They lost an extra worshipper in their defeat."
			})

	elif gameData.playerSacrificeCount == computerBid:
		textArrayToUse.append({
			"event": "tieBid",
			"text": "You and " + gameData.computerDeity + " sacrificed the same! Neither wins..."
		})

		if gameData.computerFollowerCount == 0:
			textArrayToUse.append({
				"event": "computerLose",
				"text": "But they are out of worshippers!"
			})
	# If you lose, lose 1 worshipper
	else:
		textArrayToUse.append({
			"event": "loseBid",
			"text": "You lost the bid and an extra worshipper."
		})

		var difference = gameData.computerSacrificeCount - gameData.playerSacrificeCount

		textArrayToUse.append({
			"event": "computerWinBid",
			"text": gameData.computerDeity + " outbid you and gained " + String(difference) + " worshippers."
		})

	# Then, if computer lost, remove god from game
	if gameData.computerFollowerCount == 0:
		victory(textArrayToUse)
	else:
		textArrayToUse.append({
			"event": "biddingDone",
			"text": "That concludes this round of bidding!"
		})

	# Update text
	textInterface.setText(textArrayToUse)
	addFollowers()
	playerDeityPanel.setCount(gameData.playerFollowerCount)
	computerDeityPanel.setCount(gameData.computerFollowerCount)
