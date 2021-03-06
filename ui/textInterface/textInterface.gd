extends CenterContainer

onready var confirmButton = $patch/confirmButton
onready var label = $patch/patchMargins/patchHbox/label
onready var nextButton = $patch/patchMargins/patchHbox/nextButton
onready var sfx = $sfx

var currentTextIndex = 0
var textArray = []

func _ready():
	pass

# setText
# param [Array]
# Sets an array of text and reset the index to 0
func setText(labelText):
	textArray = labelText
	currentTextIndex = 0
	label.text = String(textArray[currentTextIndex].text)

	if textArray.size() > 1:
		nextButton.show()
		confirmButton.hide()

# Signals

func _on_nextButton_pressed():
	currentTextIndex += 1
	label.text = String(textArray[currentTextIndex].text)
	sfx.play()

	if currentTextIndex + 1 > textArray.size() - 1:
		nextButton.hide()
		confirmButton.show()
