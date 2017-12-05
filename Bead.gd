extends RigidBody2D

signal hit

export (float) var FULL_RADIUS
export (Color) var COLOR
export var COLOR_CHOICES = PoolColorArray()

var bead_id
var shrinking   = false
var growing     = true
var RADIUS      = FULL_RADIUS
var animating   = true

func set_id(n):
	bead_id = n

func get_id():
	return bead_id

func _ready():
#	hide()
	randomize()
	if typeof(COLOR) == TYPE_NIL:
		COLOR = COLOR_CHOICES[randi() % COLOR_CHOICES.size()]
#		COLOR = COLOR_CHOICES[0]
#	if growing:
#		RADIUS = floor(FULL_RADIUS/2)
	RADIUS = FULL_RADIUS
	
	make_fake_bead()

	set_hitbox()

func make_fake_bead(shrink = false):
	var fake_bead       = preload("res://Fake.tscn").instance()
	
	fake_bead.position  = position
	fake_bead.RADIUS    = RADIUS
	fake_bead.COLOR     = COLOR
	fake_bead.bead_id   = bead_id
	fake_bead.shrinking = shrink
	add_child(fake_bead)	
	fake_bead.connect("done_animating", self, "done_animating")

func done_animating(bead):
	animating = false
	update()
	bead.queue_free()

func set_hitbox(radius=RADIUS):
	var circle_shape = CircleShape2D.new()
	circle_shape.set_radius(radius)
	$HitBox.set_shape(circle_shape)

func _draw():
	if !animating:
		draw_circle(Vector2(0, 0), RADIUS, COLOR)

# TO DO: Shrinking looks cool, but is causing a problem. Since the beads don't disappear immediately, 
# they can hit other beads. 
func shrink():
	shrinking = true
	animating = true
#	if typeof(bead_id) == TYPE_NIL:
#		make_fake_bead(true)
#	update()
#
#	var fake_bead       = preload("Fake.tscn").instance()
#	add_child(fake_bead)
#	fake_bead.position  = position
#	fake_bead.RADIUS    = RADIUS
#	fake_bead.COLOR     = COLOR
#	fake_bead.bead_id   = bead_id
#	fake_bead.shrinking = true
#
#	fake_bead.connect("done_animating", self, "done_animating")
#
#	update()
	
#	var fake_bead = FakeBead.instance()
#	fake_bead.RADIUS = RADIUS
#	fake_bead.COLOR  = COLOR
#	add_child(fake_bead)
	hide() 
	queue_free()
#	contact_monitor = false
#	$HitBox.disabled = true
#	call_deferred("set_monitoring", false)
	
func _process(delta):
	pass
#	if !shrinking and !growing:
#		contact_monitor = true
#	if shrinking:
#		if RADIUS == 1:
#			queue_free()
#			return
#		RADIUS -= 1
#		set_hitbox(1)
#		update()
#	elif growing:
#		if RADIUS >= FULL_RADIUS:
#			growing = false
#			set_hitbox()
#			return
#		RADIUS += 1
#		contact_monitor = false
#		set_hitbox(1)
#		update()


#func _on_Bead_mouse_exited():
##	hide()
#	var bead_incoming_color = COLOR_CHOICES[0]
#	print("Emit signal hit: " + str(bead_id))
#	emit_signal("hit", bead_id, bead_incoming_color)
#	call_deferred("set_monitoring", false)


func _on_Bead_body_entered( body ):
#	queue_free()
	shrink()
#	print("Body entered: " + str(body))
	emit_signal("hit", body.bead_id, COLOR, position)
	# TO DO: Do I need to set_monitoring to false?
	call_deferred("set_monitoring", false)
	
