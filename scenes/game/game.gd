extends Node2D

onready var carousel = $ui/uiContainer/carousel

func _ready():
	carousel.setHeader("your diety")
	carousel.setOptions(["A", "B", "C"])
