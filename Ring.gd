extends Node2D

signal win_game
signal lose_game
signal remove_instructions
signal hit
signal miss

export (PackedScene) var Bead
export (float) var MAX_ANGULAR_VELOCITY = 100
export (float) var ORIGINAL_MAX_ANGULAR_VELOCITY = 100
export (int) var NUM_START_BEADS = 24
export (int) var MAX_BEADS_ON_RING = 68

var bead_count = 0
var polygon
var bead_radius
var screen_size
var click_on_right_side = false
var click_on_left_side  = false

# Some stats
var beads_hit    = 0
var beads_missed = 0
var largest_ring = 0

func _on_Bead_hit(bead_id, bead_incoming_color, bead_incoming_position):
	var bead = get_bead(bead_id)
#	print("Recieve signal hit: " + str(bead))
	if bead.COLOR == bead_incoming_color:
		beads_hit += 1
		emit_signal("hit")
		remove_bead(bead_id)
	else:
		beads_missed += 1
		emit_signal("miss")
		# Add bead
		var bead_new      = Bead.instance()
		bead_new.COLOR    = bead_incoming_color
		add_bead(bead_id, bead_new)		
		bead_new.position = bead_incoming_position


# TO DO: Should add to the side closest to where the incoming bead was, but doesn't seem to work.
func add_bead(bead_id, bead_to_add):
	var color = bead_to_add.COLOR
#	bead_to_add.set_id(bead_id + 1)
	var hit_bead = get_bead(bead_id)
	
	# Check angles:
	var angle = hit_bead.position.angle_to(bead_to_add.position)

	# Push back the other beads
	for bead in get_beads():
		if bead.bead_id > bead_id:
			bead.bead_id += 1		
	
	# Add to the right
	if angle > 0:
		bead_to_add.set_id(bead_id + 1)
#		print("Right")
	# Add to the left
	else:
		bead_to_add.set_id(bead_id)
		hit_bead.bead_id += 1 
#		print("Left")

	add_child(bead_to_add)
	bead_to_add.add_to_group("beads")
	bead_to_add.connect("hit", self, "_on_Bead_hit")
#	make_fake_bead(bead_to_add)
	# Color gets reset randomly, so set to desired color
#	bead_to_add.COLOR = color
	
	
#	print("Bead to add: " + str(bead_to_add.position))
#	print("Hit bead: " + str(hit_bead.position))
#	print("Angle: " + str(angle))

func make_fake_bead(bead, shrink = true):
	var fake_bead       = preload("Fake.tscn").instance()
	
	fake_bead.position  = bead.position
	fake_bead.RADIUS    = bead.RADIUS
	fake_bead.COLOR     = bead.COLOR
	fake_bead.bead_id   = bead.bead_id
	fake_bead.shrinking = shrink
	add_child(fake_bead)
	fake_bead.connect("done_animating", self, "done_animating")

func remove_bead(bead_id):
	for bead in get_beads():
		if bead.get_id() == bead_id:
			make_fake_bead(bead)
			bead.hide()
#			bead.queue_free()
#			bead.shrink()

func done_animating(fake_bead):
	var real_bead = get_bead(fake_bead.bead_id)
	if !fake_bead.shrinking:
		real_bead.show()
	else:
		if typeof(real_bead) != TYPE_NIL:
			real_bead.queue_free()
	fake_bead.queue_free()

func sort_beads(first, second):
	return first.bead_id < second.bead_id
	
func get_beads():
	var beads = get_tree().get_nodes_in_group("beads")
	# Sort by bead_id
	beads.sort_custom(self, "sort_beads")
	return beads
	
# TO DO: Proper error handling.
func get_bead(bead_id):
	for bead in get_beads():
		if bead.bead_id == bead_id:
			return bead
	
func new_ring():
	# Start with 5 beads on the ring
	for n in range(0, NUM_START_BEADS):
		var bead = Bead.instance()
		bead.set_id(n)
		bead_radius = bead.FULL_RADIUS
		add_child(bead)
		bead.add_to_group("beads")
		bead.connect("hit", self, "_on_Bead_hit")
	
func _ready():
	screen_size = get_viewport_rect().size
	new_ring()

func _input(ev):
	if ev is InputEventMouseButton and ev.is_pressed():
		click_on_right_side = ev.position.x > screen_size.x/2
		click_on_left_side  = ev.position.x < screen_size.x/2
	else:
		click_on_right_side = false
		click_on_left_side  = false
		

func _process(delta):
	var beads_group = get_beads()
	var new_count = beads_group.size()
	
	# Update stats
	if new_count > largest_ring:
		largest_ring = new_count
		print("Largest ring: "  + str(largest_ring))
		print("Beads added: "   + str(beads_missed))
		print("Beads removed: " + str(beads_hit))
	
	# Win condition
	if (is_visible() and new_count == 0 and bead_count == 1):
		bead_count = 0
		emit_signal("win_game")
		return
	
	# Lose condition
	if (new_count > MAX_BEADS_ON_RING):
		emit_signal("lose_game")
		return
	
	# Remove instructions.
	if beads_hit > 0:
		emit_signal("remove_instructions")
	
	# Check for new beads
	if (new_count > 0 and bead_count != new_count):
#		print("Bead count changed from " + str(bead_count) + " to " + str(new_count))
		
			
		var vertex = Vector2(0, 0)
			
		if (new_count > 1):
			vertex = Vector2(1, 0)
		
		# Calculate new positions
		var angle = 2*PI/new_count
		var vertices = PoolVector2Array()
		
		
		# Scale vertex
		var poly_radius = bead_radius/sin(angle/2)
		vertex = vertex * poly_radius
		MAX_ANGULAR_VELOCITY = ORIGINAL_MAX_ANGULAR_VELOCITY/poly_radius
		
		for n in range(0, new_count):
			vertices.append(vertex)
#			print(str(vertex))
			beads_group[n].position = vertex
			vertex = vertex.rotated(angle)
		
#		set_polygon(vertices)
		
		# Add to polygon vector array
#		polygon = get_polygon()
#		# TO DO: This only adds the last bead, but several could have been added or removed since the last tick
#		polygon.append(beads_group[new_count - 1].position)
		
		# Update bead count
		bead_count = beads_group.size()
		
	var angular_velocity = get_angular_velocity()
	var delta_angular_velocity = 0
	
	# Handle rotation
	if Input.is_action_pressed("ui_right") or click_on_right_side:
		delta_angular_velocity += 0.2
	if Input.is_action_pressed("ui_left") or click_on_left_side:
		delta_angular_velocity -= 0.2
	
	if delta_angular_velocity != 0:
		angular_velocity += delta_angular_velocity
		angular_velocity = clamp(angular_velocity, -MAX_ANGULAR_VELOCITY, MAX_ANGULAR_VELOCITY)
		set_angular_velocity(angular_velocity)
