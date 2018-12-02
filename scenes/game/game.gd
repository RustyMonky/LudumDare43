extends Node2D

onready var carousel = $ui/uiContainer/carousel
onready var textLabel = $ui/uiContainer/textLabel

func _ready():
	carousel.setOptions(["A", "B", "C"])
	textLabel.text = "Choose your diety"
