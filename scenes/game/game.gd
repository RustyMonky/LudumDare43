extends Node2D

onready var carousel = $ui/uiContainer/carousel
onready var computerDeityPanel = $ui/uiContainer/deityHbox/computerDeityPanel
onready var deityHbox = $ui/uiContainer/deityHbox
onready var playerDeityPanel = $ui/uiContainer/deityHbox/playerDeityPanel
onready var tween = $tween

func _ready():
	carousel.setHeader("your deity")
	carousel.setOptions(["A", "B", "C"])

# Signals

# Called when a deity is selected and the carousel has exited the tree
func _on_carousel_tree_exited():
	playerDeityPanel.setCount(gameData.playerFollowerCount)
	computerDeityPanel.setCount(gameData.computerFollowerCount)
	tween.interpolate_property(deityHbox, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
