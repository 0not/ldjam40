extends Node

export (PackedScene) var Bead
export (float) var BEAD_VELOCITY
var screen_size
var screen_center



func _ready():
	screen_size = get_viewport_rect().size
	screen_center = screen_size * 0.5
	
	# Setup ring
	$Ring.position = screen_center
	$Ring.connect("win_game",  self, "win_game")
	$Ring.connect("lose_game", self, "lose_game")
	$Ring.connect("hit", self, "play_hit_sound")
	$Ring.connect("miss", self, "play_miss_sound")
	
	# Setup launchers
	$Launchers/TopLeft.position     = Vector2(0, 0)
	$Launchers/TopRight.position    = Vector2(screen_size.x, 0)
	$Launchers/BottomRight.position = Vector2(screen_size.x, screen_size.y)
	$Launchers/BottomLeft.position  = Vector2(0, screen_size.y)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
#func _input(ev):
#	if ev is InputEventMouseButton and ev.is_pressed():
#		pass

func play_hit_sound():
	$Hit3.play()

func play_miss_sound():
	$Hit2.play()
	

func launch_bead():
	var bead = Bead.instance()
	bead.set_mode(RigidBody2D.MODE_RIGID)
	add_child(bead)
	bead.add_to_group("incoming")
	bead.position = choose_launcher().position
	bead.set_linear_velocity((screen_center - bead.position).normalized()*BEAD_VELOCITY)
	bead.connect("hit", $Ring, "_on_Bead_hit")

func choose_launcher():
	var launchers = $Launchers.get_children()
	var n = randi() % launchers.size()
	return launchers[n]

func start_game():
	$StartTimer.stop()
	$HUD/TitleLabel.hide()
#	$Ring.show()
	$IncomingBeadTimer.start()
	
func end_game(label):
	label.show()
	$WinTimer.start()
		
	# Make sure instructions label is hidden
	$HUD/InstructionsLabel.hide()
	
	$IncomingBeadTimer.stop()
	destroy_all_beads()
	
	show_stats()
	
	yield($WinTimer, "timeout")
	$HUD/StatsLabel.hide()
	label.hide()
	$Ring.new_ring()
	start_game()
	
func win_game():
	end_game($HUD/WinLabel)
	
func lose_game():
	end_game($HUD/LoseLabel)

func show_stats():
#	var str1 = "Beads hit " + str($Ring.beads_hit)    + "\n"
#	var str2 = "Beads missed "  + str($Ring.beads_missed) + "\n"
#	var str3 = "Largest ring " + str($Ring.largest_ring)

	var str1 = str($Ring.beads_hit)    + " bead(s) removed\n"
	var str2 = str($Ring.beads_missed) + " bead(s) added\n"
	var str3 = str($Ring.largest_ring) + " bead(s) in largest ring"

	var message = str1 + str2 + str3
	print(message)
	$HUD/StatsLabel.set_text(message)
	$HUD/StatsLabel.show()
	
	# Erase game stats
	$Ring.beads_hit = 0
	$Ring.beads_missed = 0
	$Ring.largest_ring = 0
	

func destroy_all_beads():
	var incoming_beads = $Ring.get_tree().get_nodes_in_group("incoming")
	for bead in incoming_beads:
		bead.queue_free()
		
	var ring_beads = $Ring.get_tree().get_nodes_in_group("beads")
	for bead in ring_beads:
		bead.queue_free()

func _on_IncomingBeadTimer_timeout():
	launch_bead()


func _on_StartTimer_timeout():
	start_game()


func _on_Ring_remove_instructions():
#	$InstructionTimer.start()
	$HUD/InstructionsLabel.hide()
