extends HBoxContainer

onready var optionLabel = $optionLabel

var currentOption = 0
var options = []

func _ready():
	pass

# setOptions
# param [Array]
# Public function to set carousel selection options
func setOptions(optionsArray):
	options = optionsArray
	optionLabel.text = options[currentOption]

# Signals

func _on_arrowLeft_pressed():
	if currentOption - 1 < 0:
		currentOption = options.size() - 1
	else:
		currentOption -= 1

	optionLabel.text = options[currentOption]

func _on_arrowRight_pressed():
	if currentOption + 1 > options.size() - 1:
		currentOption = 0
	else:
		currentOption += 1

	optionLabel.text = options[currentOption]
