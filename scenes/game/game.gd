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
	carousel.setOptions(["A", "B", "C"])

# Signals

# Called when a deity is selected and the carousel has exited the tree
func _on_carousel_tree_exited():
	playerDeityPanel.setCount(gameData.playerFollowerCount)
	computerDeityPanel.setCount(gameData.computerFollowerCount)
	tween.interpolate_property(deityHbox, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(textInterface, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

	textInterface.setText("How many worshippers will you sacrifice?")

	var vertScroll = load("res://ui/vertScroll/vertScroll.tscn").instance()
	vertScroll.connect("tree_exited", self, "_on_vertScroll_tree_exited")
	textHbox.add_child(vertScroll)

	for i in range(gameData.playerFollowerCount):
		var follower = TextureRect.new()
		follower.texture = followerIcon
		followerHbox.add_child(follower)

# Called when a sacrifice count is selected and the vertical scroll has exited the tree
func _on_vertScroll_tree_exited():
	# Reset the vertical scroll value
	gameData.playerFollowerCount -= gameData.playerSacrificeCount

	# Update text
	textInterface.setText("You've sacrificed " + String(gameData.playerSacrificeCount) + " worshippers.")

	for i in range(gameData.playerSacrificeCount):
		followerHbox.get_children()[i].queue_free()
