extends TextureProgressBar
#Anytime P is infront of health it indicats that it is the Players HealthBar
@onready var Phealth_bar: Sprite2D = $Health



@onready var default_width = Phealth_bar.region_rect.size.x
@onready var default_height = Phealth_bar.region_rect.size.y
# Called when the node enters the scene tree for the first time

func update_Phealth(new_Phealth: int) -> void:
	var new_widths = (new_Phealth / 100.0) * default_width
	Phealth_bar.region_rect = Rect2(0,0, new_widths, default_height)
	
	Phealth_bar.queue_redraw()
	print(new_widths)
