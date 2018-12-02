extends TextureRect

onready var countLabel = $followerIcon/followerCount

func _ready():
	pass

# setCount
# param [Text||Number]
# Public function to update the countLabel text
func setCount(count):
	countLabel.text = String(count)
