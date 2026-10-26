extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.disabled


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	$".".scale += Vector2(.8,.8)


func _on_button_pressed() -> void:
	queue_free()
