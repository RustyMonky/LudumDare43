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

# Signals

# Called when a deity is selected and the carousel has exited the tree
func _on_carousel_tree_exited():
	playerDeityPanel.setCount(gameData.playerFollowerCount)
	computerDeityPanel.setCount(gameData.computerFollowerCount)
	tween.interpolate_property(deityHbox, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(textInterface, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

	textInterface.setText(["How many worshippers will you sacrifice?"])

	var vertScroll = load("res://ui/vertScroll/vertScroll.tscn").instance()
	vertScroll.connect("tree_exited", self, "_on_vertScroll_tree_exited")
	textHbox.add_child(vertScroll)

	for i in range(gameData.playerFollowerCount):
		var follower = TextureRect.new()
		follower.texture = followerIcon
		followerHbox.add_child(follower)

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
	elif gameData.playerSacrificeCount == computerBid:
		textArrayToUse.append("You and " + gameData.computerDeity + " sacrificed the same! Neither wins...")
	# If you lose, lose 1 worshipper
	else:
		textArrayToUse.append("You lost the bid and an extra worshipper.")

	# Update text
	textInterface.setText(textArrayToUse)
