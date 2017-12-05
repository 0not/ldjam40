extends Area2D

signal done_animating

var RADIUS = 20
var FULL_RADIUS
var COLOR  = Color(255, 0, 0) 

# This is the bead_id of the bead that is being replaced
var bead_id

var shrinking

func _ready():
	if typeof(shrinking) == TYPE_NIL:
		shrinking = false
	
	FULL_RADIUS = RADIUS
	if !shrinking:
		RADIUS = floor(FULL_RADIUS/2) 

	update()

func _draw():
	draw_circle(Vector2(0, 0), RADIUS, COLOR)

func _process(delta):
	var total_time = $AnimationTimer.get_wait_time()
	var time_left  = $AnimationTimer.get_time_left()
	if shrinking:
		RADIUS = (time_left/total_time) * FULL_RADIUS
#		RADIUS = 0.5 * FULL_RADIUS * (time_left/total_time + 1)
#		print("Shrinking: " + str(RADIUS))
		update()
	else:
		RADIUS = (1-time_left/total_time) * FULL_RADIUS
#		print("Growing: " + str(RADIUS) + "; is_visible = " + str(is_visible()))
		update()

func _on_AnimationTimer_timeout():
	emit_signal("done_animating", self)
