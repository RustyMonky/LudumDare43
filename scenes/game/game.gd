extends Node2D

onready var carousel = $ui/uiContainer/carousel
onready var computerDeityPanel = $ui/uiContainer/deityHbox/computerDeityPanel
onready var deityHbox = $ui/uiContainer/deityHbox
onready var followerHbox = $ui/uiContainer/followerHbox
onready var playerDeityPanel = $ui/uiContainer/deityHbox/playerDeityPanel
onready var textHbox = $ui/uiContainer/textHbox
onready var textInterface = $ui/uiContainer/textHbox/textInterface
onready var tween = $tween
onready var uiContainer = $ui/uiContainer

var followerIcon = load("res://assets/sprites/ui/icons/follower.png")

func _ready():
	carousel.setHeader("your deity")
	carousel.setOptions(gameData.deityOptions)

	textInterface.confirmButton.connect("pressed", self, "_on_confirmButton_pressed")

# addFollowers
# Adds followers to the appropriate container
func addFollowers():
	for child in followerHbox.get_children():
		child.queue_free()

	for i in range(gameData.playerFollowerCount):
		var follower = TextureRect.new()
		follower.texture = followerIcon
		followerHbox.add_child(follower)
	playerDeityPanel.setCount(gameData.playerFollowerCount)

# resetSacrificePrompt
# Resets sacrifice data and updates text interface for next bidding
func resetSacrificePrompt():
	if gameData.playerFollowerCount > 0:
		gameData.computerSacrificeCount = 0
		gameData.playerSacrificeCount = 0
		textInterface.setText(["How many worshippers will you sacrifice?"])
		textInterface.confirmButton.hide()

		var vertScroll = load("res://ui/vertScroll/vertScroll.tscn").instance()
		vertScroll.connect("tree_exited", self, "_on_vertScroll_tree_exited")
		textHbox.add_child(vertScroll)

	else:
		print("Lose")

# Signals

# Called when a deity is selected and the carousel has exited the tree
func _on_carousel_tree_exited():
	playerDeityPanel.setCount(gameData.playerFollowerCount)
	computerDeityPanel.setCount(gameData.computerFollowerCount)
	tween.interpolate_property(deityHbox, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(textInterface, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

	resetSacrificePrompt()
	addFollowers()

# Called at end of text cycle to trigger a reset of the bidding flow
func _on_confirmButton_pressed():
	resetSacrificePrompt()

# Called when a sacrifice count is selected and the vertical scroll has exited the tree
func _on_vertScroll_tree_exited():
	var textArrayToUse = ["You've sacrificed " + String(gameData.playerSacrificeCount) + " worshippers."]
	# Reset the vertical scroll value
	gameData.playerFollowerCount -= gameData.playerSacrificeCount

	for i in range(gameData.playerSacrificeCount):
		followerHbox.get_children()[i].queue_free()

	# Randomly choose computer bid count
	randomize()
	var computerBid = randi() % (gameData.computerFollowerCount + 1)
	gameData.computerSacrificeCount = computerBid

	textArrayToUse.append(gameData.computerDeity + " sacrificed " + String(gameData.computerSacrificeCount) + " worshippers.")

	# Subtract computer bid
	gameData.computerFollowerCount -= computerBid

	# Compare results
	if gameData.playerSacrificeCount > computerBid:
		var difference = gameData.playerSacrificeCount - computerBid
		textArrayToUse.append("You outbid " + gameData.computerDeity + " and gained " + String(difference) + " worshippers!")
		gameData.playerFollowerCount += difference

		if gameData.computerFollowerCount > 0:
			gameData.computerFollowerCount -= 1
			textArrayToUse.append("They lost an extra worshipper, too!")

	elif gameData.playerSacrificeCount == computerBid:
		textArrayToUse.append("You and " + gameData.computerDeity + " sacrificed the same! Neither wins...")
		if gameData.computerFollowerCount == 0:
			textArrayToUse.append("But they are out of worshippers!")
	# If you lose, lose 1 worshipper
	else:
		textArrayToUse.append("You lost the bid and an extra worshipper.")
		gameData.playerFollowerCount -= 1

	# Then, if computer lost, remove god from game
	if gameData.computerFollowerCount == 0:
		gameData.deityOptions.remove(gameData.computerDeity)
		gameData.deitiesDefeated += 1
		randomize()

		if gameData.deityOptions.empty():
			print("Win")
		elif gameData.playerFollowerCount > 0:
			var randIndex = randi() % gameData.deityOptions.size() - 1
			gameData.computerDeity = gameData.deityOptions[randIndex]
			gameData.computerFollowerCount = 10
			gameData.playerFollowerCount += 5
			playerDeityPanel.setCount(gameData.playerFollowerCount)
			textArrayToUse.append("Your victory has attracted 5 more worshippers!")
			textArrayToUse.append(gameData.computerDeity + " is the next deity to defeat.")
	else:
		textArrayToUse.append(gameData.computerDeity + " still has " + String(gameData.computerFollowerCount) + " worshippers left.")

	# Update text
	textInterface.setText(textArrayToUse)
	addFollowers()
	playerDeityPanel.setCount(gameData.playerFollowerCount)
	computerDeityPanel.setCount(gameData.computerFollowerCount)
