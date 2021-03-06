extends TextureRect

onready var countLabel = $followerIcon/followerCount
onready var deity = $deity
onready var nameLabel = $nameLabel

func _ready():
	pass

# setCount
# param [String||Number]
# Public function to update the countLabel text
func setCount(count):
	countLabel.text = String(count)

# setDeityTexture
# param [String]
# Sets the deity texture based on the provided deity
func setDeityTexture(deityName):
	deity.texture = load("res://assets/sprites/deities/" + deityName.to_lower() + ".png")

# setName
# param [String]
# Sets text of name label to provided deity name
func setName(deityName):
	nameLabel.text = deityName
