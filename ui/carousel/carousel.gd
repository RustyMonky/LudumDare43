extends HBoxContainer

onready var carouselHeader = $carouselHeader
onready var chooseButton = $chooseButton
onready var optionLabel = $optionLabel
onready var tween = $tween

var currentOption = 0
var options = []

func _ready():
	pass

# setHeader
# param [Text]
# Public function to set carousel header text
# All text should assume that "Choose" is prefixed
func setHeader(headerText):
	carouselHeader.text = headerText

# setOptions
# param [Array]
# Public function to set carousel selection options
func setOptions(optionsArray):
	options = optionsArray
	optionLabel.text = options[currentOption]

# Signals

# Moves carousel option to left
func _on_arrowLeft_pressed():
	if currentOption - 1 < 0:
		currentOption = options.size() - 1
	else:
		currentOption -= 1

	optionLabel.text = options[currentOption]

# Moves carousel option to right
func _on_arrowRight_pressed():
	if currentOption + 1 > options.size() - 1:
		currentOption = 0
	else:
		currentOption += 1

	optionLabel.text = options[currentOption]

# Assigns the diety to the player
func _on_chooseButton_pressed():
	chooseButton.disabled = true
	gameData.chosenDiety = options[currentOption]

# Fades out the carousel
func _on_chooseButton_button_up():
	tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

# Removes the carousel after a completed fade
func _on_tween_tween_completed(object, key):
	self.queue_free()
