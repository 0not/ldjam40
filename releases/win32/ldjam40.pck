GDPC                                                                                 @   res://.import/hit1.wav-3e1d34eeb50523a94849aa73759ab091.sample   e     Q      ���>a^�	�^�@   res://.import/hit2.wav-a7aa1069ee254e8d5e3bff3297059dd2.sample  P�     at      k>�@����zѸ�@   res://.import/hit3.wav-ed4896f054961754d35d19f6edf1f831.sample  �,     N      �Kl��U�*� l�S�4	<   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex |     �      B������P��HVt5@   res://.import/ldjam40.png-6caf79060feb902d6b49eb5d2026190c.stex І     �\      �uG���_��4TqޢD   res://.import/white_bead.png-de67a6ccbfa37a69243c3e6dc644552d.stex  ��     	       '�0Y�V�Y�V�Q�   res://Bead.gd   �      �
      ��4��k}R.�Kf�2n�   res://Bead.tscn �      N      �V؍�~�+�bF�   res://Fake.gd   �            ;	։é}_D�<e�$   res://Fake.tscn        �      w9���Sf���Q���   res://HUD.gd       �       ՞�]��%:��	
[�   res://HUD.tscn  �      z      �~C+L�a��42��/   res://Main.gd   p/      g      �ؘ9Ǒ�5�w|�_���   res://Main.tscn �:      p
      e���.B�[P�   res://Raleway.ttf   PE      P�     nJ�y�\� tl>]H�(   res://Ring.gd   �A     A      ��@{z釠$D�}5�   res://Ring.tscn �W           ��C���1A+��)e,   res://default_env.tres   [     
      �?�թ+Ev�/h�!b�   res://hit1.wav.import   0�           ��oF�:�U4U   res://hit2.wav.import   �+           �zK��A�N �-F�(   res://hit3.wav.import    {           gu��6�1tz�߀��   res://icon.png.import   �     �      �5Om��'�����MU��   res://project.binary`�     Q      X,�9&�������D�(   res://releases/html/ldjam40.png.import  ��     �      �_�I;�X����gA   res://white_bead.png.import ��     �      >��	A��V:&��G�;    extends RigidBody2D

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

	$Sprite.modulate = COLOR

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

#func _draw():
#	if !animating:
#		draw_circle(Vector2(0, 0), RADIUS, COLOR)


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
	$Sprite.visible = !animating
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
	
         [gd_scene load_steps=3 format=2]

[ext_resource path="res://Bead.gd" type="Script" id=1]
[ext_resource path="res://white_bead.png" type="Texture" id=2]

[node name="Bead" type="RigidBody2D"]

input_pickable = true
collision_layer = 1
collision_mask = 1
mode = 1
mass = 0.01
friction = 0.0
bounce = 0.0
gravity_scale = 0.0
custom_integrator = false
continuous_cd = 0
contacts_reported = 1
contact_monitor = true
sleeping = false
can_sleep = true
linear_velocity = Vector2( 0, 0 )
linear_damp = 0.0
angular_velocity = 0.0
angular_damp = 1.0
script = ExtResource( 1 )
_sections_unfolded = [ "Angular" ]
FULL_RADIUS = 20.0
COLOR = null
COLOR_CHOICES = PoolColorArray( 0, 0.427451, 1, 1, 1, 0.00784314, 0.333333, 1, 0.568627, 0.00784314, 1, 1, 0, 1, 0.0745098, 1, 0.945098, 0.945098, 0.94902, 1 )

[node name="HitBox" type="CollisionShape2D" parent="."]

[node name="Sprite" type="Sprite" parent="."]

scale = Vector2( 0.45, 0.45 )
texture = ExtResource( 2 )
_sections_unfolded = [ "Material", "Transform", "Visibility" ]

[connection signal="body_entered" from="." to="." method="_on_Bead_body_entered"]


  extends Area2D

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
	
	$Sprite.modulate = COLOR

	update_radius()

func update_radius():
	scale = Vector2(1, 1) * RADIUS/FULL_RADIUS

#func _draw():
#	draw_circle(Vector2(0, 0), RADIUS, COLOR)

func _process(delta):
	var total_time = $AnimationTimer.get_wait_time()
	var time_left  = $AnimationTimer.get_time_left()
	if shrinking:
		RADIUS = (time_left/total_time) * FULL_RADIUS
#		RADIUS = 0.5 * FULL_RADIUS * (time_left/total_time + 1)
#		print("Shrinking: " + str(RADIUS))
		update_radius()
	else:
		RADIUS = (1-time_left/total_time) * FULL_RADIUS
#		print("Growing: " + str(RADIUS) + "; is_visible = " + str(is_visible()))
		update_radius()

func _on_AnimationTimer_timeout():
	emit_signal("done_animating", self)
         [gd_scene load_steps=3 format=2]

[ext_resource path="res://Fake.gd" type="Script" id=1]
[ext_resource path="res://white_bead.png" type="Texture" id=2]

[node name="Fake" type="Area2D"]

input_pickable = true
gravity_vec = Vector2( 0, 1 )
gravity = 0.0
linear_damp = 0.1
angular_damp = 1.0
audio_bus_override = false
audio_bus_name = "Master"
script = ExtResource( 1 )
_sections_unfolded = [ "Pickable" ]

[node name="AnimationTimer" type="Timer" parent="."]

process_mode = 1
wait_time = 0.3
one_shot = true
autostart = true

[node name="Sprite" type="Sprite" parent="."]

scale = Vector2( 0.45, 0.45 )
texture = ExtResource( 2 )
_sections_unfolded = [ "Transform" ]

[connection signal="timeout" from="AnimationTimer" to="." method="_on_AnimationTimer_timeout"]


  extends CanvasLayer


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
      [gd_scene load_steps=7 format=2]

[ext_resource path="res://HUD.gd" type="Script" id=1]
[ext_resource path="res://Raleway.ttf" type="DynamicFontData" id=2]

[sub_resource type="DynamicFont" id=1]

size = 70
use_mipmaps = false
use_filter = false
font_data = ExtResource( 2 )
_sections_unfolded = [ "Font", "Settings" ]

[sub_resource type="DynamicFont" id=3]

size = 40
use_mipmaps = false
use_filter = false
font_data = ExtResource( 2 )
_sections_unfolded = [ "Font", "Settings" ]

[sub_resource type="DynamicFont" id=4]

size = 28
use_mipmaps = false
use_filter = false
font_data = ExtResource( 2 )
_sections_unfolded = [ "Font", "Settings" ]

[sub_resource type="DynamicFont" id=2]

size = 20
use_mipmaps = false
use_filter = false
font_data = ExtResource( 2 )
_sections_unfolded = [ "Font", "Settings" ]

[node name="HUD" type="CanvasLayer"]

layer = 1
offset = Vector2( 0, 0 )
rotation = 0.0
scale = Vector2( 1, 1 )
script = ExtResource( 1 )

[node name="TitleLabel" type="Label" parent="."]

anchor_left = 0.0
anchor_top = 0.0
anchor_right = 1.0
anchor_bottom = 0.0
margin_top = 100.0
margin_bottom = 183.0
rect_pivot_offset = Vector2( 0, 0 )
rect_clip_content = false
hint_tooltip = "Cool title, bro!"
mouse_filter = 1
size_flags_horizontal = 1
size_flags_vertical = 4
custom_fonts/font = SubResource( 1 )
text = "Shrink the Ring!"
align = 1
valign = 1
percent_visible = 1.0
lines_skipped = 0
max_lines_visible = -1
_sections_unfolded = [ "Margin", "custom_fonts" ]

[node name="PressEnterLabel" type="Label" parent="."]

visible = false
anchor_left = 0.0
anchor_top = 0.5
anchor_right = 1.0
anchor_bottom = 0.5
margin_top = -300.0
margin_bottom = -200.0
rect_pivot_offset = Vector2( 0, 0 )
rect_clip_content = false
hint_tooltip = "Cool title, bro!"
mouse_filter = 1
size_flags_horizontal = 1
size_flags_vertical = 4
custom_fonts/font = SubResource( 3 )
text = "Press Enter to Start"
align = 1
valign = 1
percent_visible = 1.0
lines_skipped = 0
max_lines_visible = -1
_sections_unfolded = [ "Margin", "Visibility", "custom_fonts" ]

[node name="WinLabel" type="Label" parent="."]

visible = false
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
margin_left = -450.0
margin_top = -30.0
margin_right = 450.0
margin_bottom = 30.0
rect_pivot_offset = Vector2( 0, 0 )
rect_clip_content = false
hint_tooltip = "Great job!"
mouse_filter = 1
size_flags_horizontal = 1
size_flags_vertical = 4
custom_fonts/font = SubResource( 1 )
text = "You win!"
align = 1
valign = 1
percent_visible = 1.0
lines_skipped = 0
max_lines_visible = -1
_sections_unfolded = [ "Hint", "Margin", "Visibility", "custom_fonts" ]

[node name="LoseLabel" type="Label" parent="."]

visible = false
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
margin_left = -450.0
margin_top = -30.0
margin_right = 450.0
margin_bottom = 30.0
rect_pivot_offset = Vector2( 0, 0 )
rect_clip_content = false
hint_tooltip = "Great job!"
mouse_filter = 1
size_flags_horizontal = 1
size_flags_vertical = 4
custom_fonts/font = SubResource( 1 )
text = "Game over!"
align = 1
valign = 1
percent_visible = 1.0
lines_skipped = 0
max_lines_visible = -1
_sections_unfolded = [ "Hint", "Margin", "Visibility", "custom_fonts" ]

[node name="StatsLabel" type="Label" parent="."]

visible = false
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
margin_left = -188.0
margin_top = 150.0
margin_right = 188.5
margin_bottom = 54.0
rect_pivot_offset = Vector2( 0, 0 )
rect_clip_content = false
mouse_filter = 2
size_flags_horizontal = 1
size_flags_vertical = 4
custom_fonts/font = SubResource( 4 )
percent_visible = 1.0
lines_skipped = 0
max_lines_visible = -1
_sections_unfolded = [ "BBCode", "Margin", "Visibility", "custom_fonts" ]

[node name="InstructionsLabel" type="Label" parent="."]

anchor_left = 0.0
anchor_top = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
margin_left = 20.0
margin_top = -100.0
margin_right = -20.0
rect_pivot_offset = Vector2( 0, 0 )
rect_clip_content = false
mouse_filter = 2
size_flags_horizontal = 1
size_flags_vertical = 4
custom_fonts/font = SubResource( 2 )
text = "Instructions: Use the right/left arrows keys to rotate the ring and try to intercept the incoming beads with a bead of the same color on the ring. Remove all beads to win, or accumulate too many and lose!"
align = 3
autowrap = true
percent_visible = 1.0
lines_skipped = 0
max_lines_visible = -1
_sections_unfolded = [ "Margin", "Visibility", "custom_fonts" ]


      extends Node

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
         [gd_scene load_steps=8 format=2]

[ext_resource path="res://Main.gd" type="Script" id=1]
[ext_resource path="res://Bead.tscn" type="PackedScene" id=2]
[ext_resource path="res://HUD.tscn" type="PackedScene" id=3]
[ext_resource path="res://Ring.tscn" type="PackedScene" id=4]
[ext_resource path="res://hit1.wav" type="AudioStream" id=5]
[ext_resource path="res://hit2.wav" type="AudioStream" id=6]
[ext_resource path="res://hit3.wav" type="AudioStream" id=7]

[node name="Main" type="Node2D"]

script = ExtResource( 1 )
Bead = ExtResource( 2 )
BEAD_VELOCITY = 250.0

[node name="HUD" parent="." instance=ExtResource( 3 )]

[node name="Ring" parent="." instance=ExtResource( 4 )]

position = Vector2( 450, 450 )
angular_velocity = 0.452631
_sections_unfolded = [ "Angular", "Transform", "Visibility" ]
MAX_ANGULAR_VELOCITY = 0.652631

[node name="StartTimer" type="Timer" parent="."]

process_mode = 1
wait_time = 3.0
one_shot = true
autostart = true

[node name="WinTimer" type="Timer" parent="."]

process_mode = 1
wait_time = 5.0
one_shot = true
autostart = false

[node name="IncomingBeadTimer" type="Timer" parent="."]

process_mode = 1
wait_time = 1.5
one_shot = false
autostart = false

[node name="InstructionsTimer" type="Timer" parent="."]

process_mode = 1
wait_time = 1.0
one_shot = true
autostart = false

[node name="Launchers" type="Node" parent="."]

editor/display_folded = true

[node name="TopLeft" type="Position2D" parent="Launchers"]

[node name="TopRight" type="Position2D" parent="Launchers"]

position = Vector2( 900, 0 )

[node name="BottomRight" type="Position2D" parent="Launchers"]

position = Vector2( 900, 900 )

[node name="BottomLeft" type="Position2D" parent="Launchers"]

position = Vector2( 0, 900 )

[node name="Hit1" type="AudioStreamPlayer2D" parent="."]

stream = ExtResource( 5 )
volume_db = 0.0
autoplay = false
max_distance = 2000.0
attenuation = 1.0
bus = "Master"
area_mask = 1

[node name="Hit2" type="AudioStreamPlayer2D" parent="."]

stream = ExtResource( 6 )
volume_db = 0.0
autoplay = false
max_distance = 2000.0
attenuation = 1.0
bus = "Master"
area_mask = 1

[node name="Hit3" type="AudioStreamPlayer2D" parent="."]

stream = ExtResource( 7 )
volume_db = 0.0
autoplay = false
max_distance = 2000.0
attenuation = 1.0
bus = "Master"
area_mask = 1

[connection signal="remove_instructions" from="Ring" to="." method="_on_Ring_remove_instructions"]

[connection signal="timeout" from="StartTimer" to="." method="_on_StartTimer_timeout"]

[connection signal="timeout" from="WinTimer" to="." method="_on_StartTimer_timeout"]

[connection signal="timeout" from="IncomingBeadTimer" to="." method="_on_IncomingBeadTimer_timeout"]


       GPOS�Nf    /�GSUB���  0�  NOS/2��i  4   `cmap�z�  4|  
�cvt * �p   0fpgmAy�� ��  Igasp    �h   glyf�3�   ?H P:head��`8 ��   6hhea2� ��   $hmtx�P� ��  0kern���� �  Avloca�^� ؈  �maxp�� �$    name��2Z �D  �postK�R �  Pprep|m�q ��   a    
  , latn      ��    kern              ..    �P��>�R�����Zt�"(������	�	�
Z
|P����*�(J��T����<���,����4����r����8B���
8B�������Zp�@���b����� J P �!!�!�"6"<"n"�"�##*#0#�$$2$8$>$D$�%,%Z%�%�&D&R&`&n&�&�'l'�'�(
(t(�(�))$)B)H)�***�*�*�*�*�*�+<+B+H+N+T+�,@,�,�-J-�-�.  I�� `�� e�� ��� ��� ��� ��� ��� ���4��k��q��r��������������������  �  # il m ��� ! I�� e�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���   & ( 9��E��x��|�����������������������������������������  e�� k�� ��� ��� ��� ��� ��� ��� ��� ��� �  ��� ��� ���   & ( 9��E��x��|��������� ������������ ' (�� 5�� D�� I�� `�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���	������& -��4 9��a��c��o��r��x��������������������������  k�� ��� ��� ��� ��� ��� �������   $ & ( 9��E��x��|����������������������������� #  ��� 6 �� I� e�� k�� x�� ��� ��� ��� �  ��� ��� ��� ��� ��� ��� ��� ��� �����	������������ 	   ! $ $& .( 9��E��N��a c��x��|������������������ ���������������������������  ��� ��� ��� ��� ��� ��� ��� ��� ���& 
4 r��������������������������  x�� ��� ��� ��� ���  & 4 c��o��q��r��x��� ������������������������������  k�� � � ���������  ��� ��� ��� ��� ���  & E��x��|��������������  I�� e�� x�� ��� ��� ��� ��� �������   & ( ,��-��9��E��c��x��|��������������������  �  #  2 �� I  k�� w�� x 	 y�� ��� ��� ��� �  �  �  �  �  ��� ��� ��� ���	 
��  ��    ! $ /& #( E��[��\��a 
l m w��|�� ������� � ��������������������� ' �� _�k k�� ��� ��� ��� ��� ��� ��� ��� ��~ ��� ��� ��� ��� ��� �������E��Y��Z��i��o��q��r��w��|������ ���������������������������  ��� ��� ��� ��� ��� ��� ���Y��o��q��r����� 
	��,��N��O��������������������  ��� ; �� (�� 5�� `�� k�� w�� x  y�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �  �  ��� ��� ��� ��� ���	 ����,��4��E��Y��Z��a i��l m o��q��r��w��x��|������������������ ��������������������� ) (�� 5�� D�� I�� `�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���	������& -��4 9��a��c��o��q��r��x��������������������������  ��� ��� ��� ��� �  � a �  , I�� e�� k�� x� ��� �  �  �  �  ��� ��� ��� ��� ��� �������	��
��   ! $ )& 9��?��E��N��x�����������������������������������������������  ��� ��� ��� ��� �  � a �  $ �� I�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� �����	������   	& ( 4 E��a��c��x��|������ � � � � � �   I�� e�� x  ��� �  �  � 	 & 4 a l m ���� ��� * (�� 5�� D�� `�� e�� k�� x  ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���	 ��������& ,��-��9��E��a q��x��|����������������������������� # e�� ��� ��� ��� ��� ��� ��� ��� ��� ��� �������    
& ( ,��-��9��Y��x�������������������������������������� A �� I�� e�� k�� x�� ��� ��� ��� �  ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ����	������������ 
   ! $ /& 5( 9��?��E��N��a c��u��w��x��{��|��}��������������������� ������������������������������ E�� % �� I�� e�� k�� w�� x�� y�� ��� �  ��� ��� ��� ��� ��� ��� �����������9��E��g��h��w��x��y�������������������������������  (�� 5�� I�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �����a��c��i��o��q��r��������������������  I�� e�� x�� ��� ��� ��� ��� ���	������   & ( ,��-��9��E��c��x��|�������������������� D �� (�� 5�� I�� `�� e�� k�� x�� ��� ��� ��� ��� � 
 ��� ��� �  �  ��� ��� ��� ��� ��� ��� �����	�������� ����    ! $ 4& -( 4��9��?��E��N��a c��o q u��w��x��|������������������ ������������������������������ H �� (�� 5�� I�� `�� e�� k�� x�� ��� ��� ��� ��� ��� � 	 ��� ��� �  �  �  ��� ��� ��� ��� ��� ��� �����	�������� ����    ! $ 5& .( 4��9��?��E��N��a c��o q u��w��x��{��|������������������ ��������������������������������� 4 �� x�� ��� ��� ��� � 
 ��� �  ��� ��� ��� ��� ��� ��� �����	�������� ����    ! 
$ .& +( 9��?��E��N��a c��u��w��x��|������������ ������������������������ 2 �� k�� w�� x  y�� ��� ��� ��� � 
 �  �  �  ��� ��� ��� ��� ���	 ���� ����    ! $ :& +( 9��E��[��\��a o q w��|��������� � ��������������������� L �� (�� 5�� I�� `�� e�� k�� x�� ��� ��� ��� ��� ��� � 
 ��� ��� �  �  �  ��� ��� ��� ��� ��� ��� ��� ��� ��� �����	�������� ����    ! $ 8& ,( 9��?��E��I��N��a c��o q u��w��x��{��|��}������������������ ���������������������������������  k�� ��� ��� ��� ��� ��� ��� �������    $ #& *( 9��E��w��x��|�����������������������������  5�� F�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���Y��Z��i��o��q��r��������������������������  ��� ������  ��� ��� ���Z��i��o��q��r��������������������������  I  e  w  y  ��� ��� ��� ��� ��� �  ��� � [ \ q��r��x � ���������� �������  # A  ��� ��� �������,��-��9��E��x��������������������������������  D  I�� e�� k�� �  �  �  � 	 � 
 � 
 ��� ��� ��� ���    ! $ & 2( E��x������ � � � �   e�� ��� ��� ��� ���q��r�� % 5�� F�� I�� e�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���4 Y��Z��a��c��i��o��q��r��x�����������������������������������  I  e  k�� w  y  ��� ��� ��� ��� ��� �  ���q��r������������ 
������������� ������������  M  R 
   # ?& ( ?  �  �  �     # 	$ & ( 	�   e  �  �  �  �     # $ & ( �  ! 5�� e�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �������E��i��o��q��r��x��|�������������������������� #   ��� ��� ��� ��� ���  ���# 
( 
  5�� k�� ��� ��� ��� ��� ��� ���& ���������������������  ���   & (  !   �  � / � K � ' � I � H �  �  � " � 	 �  �  �     ) ), *- )Y  Z a Hi o <q @r 1w � � � %� K�   �  ��	��
��?��N����������� ������ ! 5�� F�� I�� e�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���4 Z��a��i��o��q��r�����������������������������������  e�� ��� ��� ��� ���e����� e�� # % 	��N��O�����������   5�� F�� I�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���& 4 a��o��q��r�����������������������������������   & 
 % �� I�� e�� x�� ��� �  �   �   � ( � % �  ��� �  �  �  � 	 ��� ������� !   )! $ Q& F( 4 E��a c��o q |������ ���    $ 8& $;    $ &    $ &   _�� e  ��� ��� ��� ��� �����6��e���  	����  _�� e  ��� ��� ��� �  ��� ��� �  �����6��e��r������   ��� ���r�� 
 k�� ��� ��� ��� ��� ��� ��� ��� ���# % # % # % # % # % ! 5�� F�� I�� e�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���& Y��o��q��r��x�����������������������������������  ��� ��� ��� ��� ���  (�� 5�� I�� `�� e�� ��� ��� ��� ��� ��� ��� ��� ���q��r��x��������������������������������  k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���Z��i��o��q��r��������������������������  I�� e�� ��� ��� ��� ��� ��� ��� ��� ���	��N��O��x����������������������������������������������� 	 k�� ��� ��� ��� ���   & (   �  � a o q �   �  �  �  � a o q �   �  �  �  �    , - Y Z a i o q r � �   �  �  �  �  �  �    , 	- Y 	Z a i o q r � �  #   #  (   
 �  � ( �  � a  k o q r � , # )  �  � 6 � 
 � ) � ' �   , - Y 	Z a 1i k o q  r � � � 7 # Q  �  �  �  �    #  , - Y Z a i o q r � �   k�� x  ��� ��� ��� ��� ��� ��� ��� �  �  �  �  ��� ��� �������E��[��\��a l m o��q��r��x��|�� % �� F�� _�� k�� x  ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �������E��Y��Z��a o��q��r��w��|��� ������������������������  ���   & (     �  �  � , �  � + � + �  �  �     , - Y Z a 2i o q "r { � � � � -�  # T  ��� ���Y��x � ���������� �������  	��N��O�����������������  k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���i��o��q��r��������������������������  ��� ��� ��� ��� ��� ���r�����  x�� ���a��c����� 	�� # 5�� F�� I�� e�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���4 Z��a��i��o��q��r��x�����������������������������������  _�� e  ��� ��� ��� ��� �  ��� ��� ��� �����6��D e��r������ 	 
 _�� ��� ���
����6��D e��r�����  ���  ��� 4  $ I  R 
 e  k�� w  y  �  �  �  �  �  ��� ��� ���
��    ! # $ & ( E��������� ������������� ������������  k�� ��� ��� ��� ��� ��� ��� ���o�yq�|r������ ������������������������  ��� ���	��N��O��������������������  k�� ��� ��� ��� ��� ��� ��� ��� ��� � # ^l m   # Q * (�� 5�� D�� F�� I�� `�� e�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �������# Y%��( Y,��-��9��E��x�����������������������������������  ��$ &   ���# 
( 
  ���# 
( 
  I�� e�� k�� ��� ��� ��� ���   
& ( E��c�x�����  �� I�� e�� k�� x�� ��� ��� ��� ��� �����   $ & ( E��c�~x�����  �� I�� e�� k�� x�� ��� ��� ��� ��� �����	��
����   $ & ( ?��E��c��x��������������  �� F�� I�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���������4 E��a��c��x��|����� a  
 �  �  �  � , Y a o q �   5�� F�� e�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �����o��q��������������������������  ���# (   I�� _�� e�� x�� ��� ��� ��� �  �����	����6��c��e��� ���  _�� x�� �  �  �  ��� �  �������
����6��D��a c��e��� ���� ��� ��  e�� ��� ��� ��� ��������� 
��  F�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� �������E��o��q��r��|��������������������������  �� x�� ��� ��� �  ��� ��� ���������   & ( E��c��q r��x��|�� ������  � 
 �  �  �  �  �  �  �    , - Y Z a i o q r { � � � � �  4  
 ��� ��� ��� �  ��� ��� ���r������  e��  ��� ��� ��� ��� ����   _��
����6��e��  5�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ���o��q�������������������������� # 
 # ~ # 3 # :  �� 5�� I�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� �  ��� ��� ��� �������4��E��Z a��c��x��|�����  �� 5�� I�� e�� k�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� �  ��� ��� ��� �������4��E��Z a��c��x��|�����  �� x�� ��� ��� �  ��� ��� �������4��E��Z a��c��x��|��  k�� x  ��� ��� ��� ��� ��� ��� ��� �  ��� ��� �������E��a x��|��  �� 5�� F�� I�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �������4��E��a��c��x��|�����  �� x�� ��� ��� ��� ��� ��� �������4��E��Z a��c��x��|��  5�� F�� k�� ��� ��� ��� ��� ��� ��� ��� ��� �������E��|��  I�� e�� x�� ��� ��� ��� ��� ��� ��� ��� ���a��r��������  x�� ��� ���a��c��r�����  �     % ) 3 7 8 : ; D F I M Q U X [ _ ` e k w x y { }  � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � 	
 "#$%&'(),-/0469?@DENO[\^`ceghjklmoqrstux����������������������������    
 . � latn      �� 	           	aalt 8dlig @liga Flnum Lonum Rsalt Xsmcp ^ss01 dss02 j                                      	 
   & . 6 > F N V ^    (    b     @     r     p     n     �     �     �     � `     & * 9 < C G S V Y b d l | ~ � � � � � � � � � ^  p�� � 
 ; � � �'-h��� �       " ( �  � �  �, �  �   , P  
    � �  y �  
 ; � � �'-h���    � �   ; �   * � 9
 < C G V b d@ lO | � ����� � � � ��     " ( . 4 : @   �  & �  S'  Y-  ~h  ��  ��  ��   � � � � � �#),59E^gsx�������  
 �	?N�����  
 �
@O�����  
 : � � �#,g���   �   �x   � �   : � � � � � �	)59?EN^sx���������   � �#,g���   ��   ��   ���  � 2 �    �  �P  [        pyrs @  ���  � �   �    	�             x          & 
                                                                  �kD �b �r`a �e �c x�N��	�� �? �2 �i � e   % ) 8 : B F I U X a c k { }  � � � � � � � � � � � ��  � � � � � �#),59E^gsx������� � � � �       + j q � � � � � � � � � � � �! CFKHI]���� � � ��~ �_w ��    � w  f    �7          YZ   �[j �3       �    z mJ � �npoq �  � � 7  � _mld 	 .  / 1 J L M O n p   r � � � � 
    $  ! t   R   P @   ~ �~���7Y����E����    " & 0 : D p y � �!"!T!^"""������     � ����7Y����D����      & 0 9 D p t � �!"!S!["""��� ���      �v    �����#�    ��                  ���4�����[    ߋ�s    �$ߚߗ	}  s  P  ��        ��  ���������          ��    �         �      �kD �b �r`a �e �c x�N��	�� �? �2 �i � e   % ) 8 : B F I U X a c k { }  � � � � � � � � � � � ��  � � � � � �#),59E^gsx������� � � � �� � ��� �~  �Y3�w  �f�� 7_ _ !QZUR�j   	   �   1 + . / O J L M 5 j r n p z q8 w � � � � � � � � � � � � � � � � � �!  �CKFH]I �[�������  �  �  �  � " � # �  � ' � ( � 2 � , � 0 � 4 � - � > = A ? E D R& P$ K Q% N � H" T( W*+ Z. ]0 [/ ^1 `4 f: h= g<; 3 � uM oG sL mJ �t �v �u �z �}�� �{�� �� �� �� �� �� �� �� �� �� �� � �� �� �� vX  �  � y\ 
   $    t i> �� �� �� 6 � �� �� � �oqmnpl � � ��� �B�TSW�� �AV�P�� �  � � R   P @   ~ �~���7Y����E����    " & 0 : D p y � �!"!T!^"""������     � ����7Y����D����      & 0 9 D p t � �!"!S!["""��� ���      �v    �����#�    ��                  ���4�����[    ߋ�s    �$ߚߗ	}  s  P  ��        ��  ���������          ��    �         �      �kD �b �r`a �e �c x�N��	�� �? �2 �i � e   % ) 8 : B F I U X a c k { }  � � � � � � � � � � � ��  � � � � � �#),59E^gsx������� � � � �� � ��� �~  �Y3�w  �f�� 7_ _ !QZUR�j   	   �   1 + . / O J L M 5 j r n p z q8 w � � � � � � � � � � � � � � � � � �!  �CKFH]I �[�������  �  �  �  � " � # �  � ' � ( � 2 � , � 0 � 4 � - � > = A ? E D R& P$ K Q% N � H" T( W*+ Z. ]0 [/ ^1 `4 f: h= g<; 3 � uM oG sL mJ �t �v �u �z �}�� �{�� �� �� �� �� �� �� �� �� �� �� � �� �� �� vX  �  � y\ 
   $    t i> �� �� �� 6 � �� �� � �oqmnpl � � ��� �B�TSW�� �AV�P�� �  � �   ��  ��    b@
	+@@  !   7  	  )
	 	  )   ' "   '#�;+'73!!!!!!5!#-;H���vT����)���L��']�>�>��>��V��   1l ��  @+@      #�;+'73^-;Hl]      ��  
  B@  
	  +@(  !  7   )   "#�;+33#'!!'73)9)K\��[�� �-;H��:��t��]    ��  
  S@  
	  +@/ !7
   )   )   "	#�;+33#'!!2673#"&53)9)K\��[�� �!)$*8*"��:��t��>&%:+(     +u ��  (@ 
 +@    (#�;+2673#"&53�!)$*8*"�&%:+(      ��  
  E@  
	  +@+  !  7   )   "#�;+33#'!!73')9)K\��[�� ��b2c'UU��:��t��+UU??     *p!�  @+@      #�;+73'*b2c'UU�UU??      ��  
   T@   
	  +@, !
   )   )   "	#�;+33#'!!53353)9)K\��[�� �:[:��:��t��^^^^    =y�   ,@    +@   '  #�;+53353=:[:y^^^^      ��  
  B@  
	  +@(  !  7   )   "#�;+33#'!!3)9)K\��[�� �G<,��:��t���]  1l ��  @ +@     #�;+31G<,�]      ��  
  I@  
	  	+@) !    )   )   "#�;+33#'!!5!)9)K\��[�� ��!��:��t��=//   6�W�  !@
    +@   '   #�;+5!6!�//    �Q��   7@
	+@#!      ) "   #�;+.5467#'!#3!i%&$'\��[J)9)-%4�ْ �'2����:+%���     7�Q �   @ +.5467�%&06-%4�': +%&     ��  
  " W@  ""
	  +@3 ! 
 )    )   )   "	#�;+33#'!!4632#"&7"32654&)9)K\��[�� �*  **  *J��:��t��?$$$$D    2W ��   .@
+@   (  '   #�;+4632#"&7"32654&2*  **  *J�$$$$D       ��   # I@##
	+@- ! 77    ) "   #�;+#'!#&546?3!"32654&z!K\��[J!&"%H`� �&�N���+#i�����      ��  
 * �@   &%!**
	  +K�PX@5 !
  ) 	 	 )   )   "#K�!PX@< !   5
  ) 		 )   )   "#@@ ! 

7   5   ) 		 )   )   "#YY�;+33#'!!".#"#4>3232>53)9)K\��[�� Q!*$*'��:��t��$     ,vj�  �@ 
 +K�PX@    (  '#K�!PX@  8    )  '#@#  8    ) "  ' #YY�;+".#"#4>3232>53!*$*'~       Z  o�   , E@   , +#!	+@+!   ) ' "   '    #�;+%#!!24.#!!2>32>54.#o 6H)��U%<*60=GF!-��	0"�v�-!+�(C1� 3A!6Yb51%��%1���$/0#    Q  $   * @ !+%#!!24.+32>32>54&#.=#��!3",(3;?%��'���%4*�4%$(2*DK($�$g�#)6   ,���� ' 5@
$"+@#	!   '   "  ' #�;+4>32.#"32>7#".,-V~P_�!808<@bC")Ga9?;2:>LU)IzX1h@d?VE"#04Ti6;lS1!1#(=*@g�  -��2' ' @"+4>32.#"32>7#".-&HjDPq2(.25R7!;Q/41)54AH">fJ)1bN0C5 $	'>N(,Q>$&0 1Pe      7$  
 	@	 +33#'!3�4�BL��K�v�$�ܥ���     ,����  + A@(&
+@-  "!!   7  ' "  ' #�;+'734>32.#"32>7#".�-;H�T-V~P_�!808<@bC")Ga9?;2:>LU)IzX1']��@d?VE"#04Ti6;lS1!1#(=*@g�  ,����  . D@+) +@0%$!     7  ' "  ' #�;+7#'4>32.#"32>7#".&UU'c2b�-V~P_�!808<@bC")Ga9?;2:>LU)IzX1�??VV��@d?VE"#04Ti6;lS1!1#(=*@g�   *p!�  @+@     .�;+7#'PUU'c2b�??VV  -�P�� A �@?=97*( 	+K�	PX@C/.5  A !    )     (  ' "  ' #@C/.5  A !    )     (  ' "  ' #Y�;+3254&#"7.54>32.#"32>7>32#"&',09.,EtS.-V~P_�!808<@bC")Ga9?;2:8FO'	#)422~#	RBfB@d?VE"#04Ti6;lS1!1#%;)."$    �P �   G@
	+@5   !    )    &    '   $�;+3254&#"7>32#"&''09.9!#	#)422~#	i8"$    ,����  . D@+) +@0  %$!   7  ' "  ' #�;+73'4>32.#"32>7#". b2c'UU�-V~P_�!808<@bC")Ga9?;2:>LU)IzX1@UU??�=@d?VE"#04Ti6;lS1!1#(=*@g�   ,���� ' + H@(((+(+*)$"+@.	!    )   '   "  ' #�;+4>32.#"32>7#".53,-V~P_�!808<@bC")Ga9?;2:>LU)IzX10>h@d?VE"#04Ti6;lS1!1#(=*@g�aa  2y p�  !@
    +@   '   #�;+532>yaa     Z  ��   1@    +@   '   "  '#�;+332#4.+32>Z�U�U*0X~N$EdA��BeD#�8`�IQ�]3d@kN+��-Ok    Q  =$   	@ +332#4.+32>Q�GlH$)KjA�9S6��7S8$+Jc9?eH'0O: �L!;P     Z  ��     @@
+@(     7  ' "  '#�;+7#'32#4.+32>UU'c2b��U�U*0X~N$EdA��BeD#�??VV��8`�IQ�]3d@kN+��-Ok   "  ��  ! E@    	+@'    )  ' "  '#�;+3#5332#4.+3#32>_==�U�U*0X~N$EdA����BeD#J6F8`�IQ�]3d@kN+��6��-Ok  Z  7�  ?@    
	+@%    )   ' "   '    #�;+%!!!!!7�#��q\��>>�>� ;��   Q  �$  @+%!!!!!��l���#��88$8�4�     Z  7�   M@
	+@1  !   7    )   ' "  ' #�;+'73!!!!!X-;H��#��q\��']��>�>� ;��  Z  7�   \@    
	+@6	7  )    )   ' "
   '    #�;+%!!!!!2673#"&537�#��q\���!)$*8*">>�>� ;��&%:+(    Z  7�   N@
	+@2     7    )   ' "  ' #�;+7#'!!!!!�UU'c2ba�#��q\���??VV��>�>� ;��    Z  7�   P@
	+@4  !   7    )   ' "  ' #�;+73'!!!!!�b2c'UU;�#��q\��@UU??�>�>� ;��  Z  7�    ]@"  
	  +@3 
   )  	  )   ' "		  ' #�;+53353!!!!!�:[:~�#��q\��4^^^^�
>�>� ;��   Z  7�   R@    
	
+@0 	  )    )   ' "   '    #�;+%!!!!!537�#��q\���>>>�>� ;���aa    Z  7�   M@    
	+@1! 7    )   ' "   '    #�;+%!!!!!37�#��q\��VG<,>>�>� ;��W]   Z  7�   R@    
	
+@0 	  )    )   ' "   '    #�;+%!!!!!5!7�#��q\��#!>>�>� ;��//   Z�K��  :@+@&   !   ("    #�;+#33#"&'732>=�E5�F+8 :"'!C�����K�"#9).
"$  Z�Q7�  G@    +@+     )   ' "   '   #�;+%#.5467#!!!!7�-%4%&$'���q\��>>+%&'2�>� ;��  "  ��  ! E@    	+@'    )  ' "  '#�;+3#5332#4.+3#32>_==�U�U*0X~N$EdA����BeD#J6F8`�IQ�]3d@kN+��6��-Ok  Z  7�  +@"  '&" ++  
	+K�PX@<	 	 ) 

 )    )   ' "   '    #K�!PX@C 5	 	 ) 

 )    )   ' "   '    #@G 	7 5 	 	 ) 

 )    )   ' "   '    #	YY�;+%!!!!!".#"#4>3232>537�#��q\���!*$*'>>�>� ;���      "���� 9 e@   9 9874321-+" +@?	'&!
  )	  )   '   "  ' #�;+>32.#"!!!!32>7#".'#73.5#7�	4UsH_�!808<7XA*R��0��1BQ.?;2:>LU)=iS:rXJ�9kT2VE"#0'AU.++-M9 !1#(=*-Kc7++    Z  +� 	 6@   	 	+@    )    '   "#�;+3!!!!Z��tO���>��:��   Q  �$ 	 @ +3!!!!Q�����$8�6�    -���� ( �@('&%$# +K�.PX@1" !    )  ' "   '   #@5" !    )  ' " "   '    #Y�;+%#".54>32.#"32675#53#\c�HyY21WyG4UC26#pG;_C$)Ha9=n3��<gl>f�DG�c;)9"$B>2Sk9<lQ09=w6��   -���� . @	 +".54>32.#"32>7#5!~J|Y22Y{JZ�*6,8C'<aD%%Ea<3VB+�4Ur=e�EF�c<TE-1&4Tk78jS3&@R,?>rV3     -��5' % @+%#".54>32.#"3275#53#�Qk<fJ*)Je<Xn1^:0N7";P.fR��6LP0Ne57cL-B5!2.%>P*-P=#XR0��   -���� ( 8 �@*)6531-,)8*8('&%$# +K�.PX@B" !
7 		 )    )  ' "   '   #@F" !
7 		 )    )  ' " "   '    #	Y�;+%#".54>32.#"32675#53#2673#"&53\c�HyY21WyG4UC26#pG;_C$)Ha9=n3��<�!)$*8*"gl>f�DG�c;)9"$B>2Sk9<lQ09=w6��S&%:+(   -����  / �@/.-,+*'%
+K�.PX@>  )!   7    )  ' "  '#@B  )!   7    )  ' " "  ' #Y�;+73'#".54>32.#"32675#53#�b2c'UU=c�HyY21WyG4UC26#pG;_C$)Ha9=n3��<@UU??�<l>f�DG�c;)9"$B>2Sk9<lQ09=w6��   -�[��  1 �@10/.-,)'
 
+K�PX@A+	!   -    )    (  ' "  '	#K�.PX@B+	!   5    )    (  ' "  '	#@F+	!   5    )    (  ' " 		"  ' #	YY�;+2=3##".54>32.#"32675#53#I:,#c�HyY21WyG4UC26#pG;_C$)Ha9=n3��<�@@l>f�DG�c;)9"$B>2Sk9<lQ09=w6��     )�[ x��  @+2=3#):,#�@@     -���� ( , �@))),),+*('&%$# 
+K�.PX@<" ! 	  )    )  ' "   '   #@@" ! 	  )    )  ' " "   '    #Y�;+%#".54>32.#"32675#53#53\c�HyY21WyG4UC26#pG;_C$)Ha9=n3��<��>gl>f�DG�c;)9"$B>2Sk9<lQ09=w6��4aa    Z  ��  3@    
	+@     )"   #�;+#!#3!�F�[EE���:L�����<  Q  +$  @ +#5!#3!5+>��??]$����$��  ,  ��   R@"    
	+@( 
   )   )	"#�;+3##!##5353!55!�22F�[E22E��[�y'��L��&'yyy�Ĝ�     Z  ��   D@
	+@(  !   7   )"#�;+73'#!#3!�b2c'UUkF�[EE�@UU??e�:L�����<   Z   ��  @
    +@   "#�;+33ZE��;   Q   �#  @ +33Q?#��   Z����   e@    +K�PX@  !  "  '#@$ !  ""  ' #Y�;+33732>53#"'ZE�E+6A"
F0\NZ@��;Y'LoGh��Q�^4,   ����  -@
	+@   ! "    ' #�;+732>53#"'&E+6A"
F0\NZ@Y'LoGh��Q�^4,   V   ��   -@    +@ !  7   "#�;+33'73ZE-;H��;']      ��   <@    +@7   )   "#�;+332673#"&53ZE#!)$*8*"��;S&%:+(       ��  
 0@    +@
	 !  7   "#�;+3373'ZE�b2c'UU��;@UU??      ��    =@  
	  	+@   )   "#�;+3353353ZE�:[:��;4^^^^   Z   ��   2@    +@    )   "#�;+3353ZEB>��;4aa       ��   -@    +@ !  7   "#�;+333ZE�G<,��;�]  ��  �   2@    +@    )   "#�;+335!ZE�!��;R//   #�Q ��  @	+@
  "    #�;+.5467#3n%&$'E-%4�'2��;+%&   ��  �  # �@  
##  
+K�PX@$  ) 	  )   "#K�!PX@+   5  ) 	 )   "#@/ 7   5   ) 	 )   "#YY�;+33".#"#4>3232>53ZE!*$*'��;9      ��^#  @	+732>53#"');$-6>)NBN4L8R6��?fH(!     ����   <@
	+@*  !   7 "  ' #�;+73'32>53#"'�b2c'UU�E+6A"
F0\NZ@@UU??�.'LoGh��Q�^4,    Z  ��  .@    +@
	 !  "#�;+333	#ZE�M��2M�����d����re��   Q  &$  @ +333#Q?DF� D�o#��6���f�     Z�[��   v@				
 +K�PX@(!   -    ("#@)!   5    ("#Y�;+2=3#'33	#:,#�E�M��2M����@@���d����re��   Z  :�  (@    +@   "  '#�;+33!ZE���x>     Q  �$  @ +33!Q?J$�8  Z  :�  	 6@		+@   !   7 "  '#�;+'733!^-;H��E�']�k��x>     Z  :�  	 6@		+@  !   " "  '#�;+'733!}-;H��E�l]�&��x>     1l ��  @ +'73^-;Hl]     Z�[:�   l@				
 +K�PX@$   -    ( "  '#@%   5    ( "  '#Y�;+2=3#'3!:,#�E��@@���x>     Z  :�  	 ;@  		  +@   )   "  '#�;+33!53ZE��:��x>\pp  B � |f  *@
    +@     &     '   $�;+753B:�pp       A�  5@    +@!
	 !   "  '#�;+3'737!a:PE���0(Bw�'���>    Z  �  7@    
+@	 !   5"#�;+!##3	3���)��EGGG�=�������:  Q  �$  @ +!##33a�$�?A��@���O�M$��l��  Z  �� 	 '@
	+@  !"   #�;+#33#�E6�E<D�����N�;    Q  G$ 	 @+#33#�?1�?6��Q$�I���      ��  
 6@  
	  +@ !   )   "#�;+33#'!!)9)K\��[�� ��:��t��    Z  ��   3@
+@  	!   7"#�;+'73#33#�-;H��E6�E<']�������N�;    Z  ��   6@
	+@"!     7"#�;+7#'#33#0UU'c2bkE6�E<�??VV�������N�;     Z�[��   l@
 +K�PX@%	!   -    ("#@&	!   5    ("#Y�;+2=3##33#S:,#�E6�E<�@@������N�;    Z  ��   :@  
  +@ 	!     )"#�;+53#33#f>��E6�E<4aa������N�;    Z  �� 	 ) �@
%$ 
))	+K�PX@,  !	  ) 
 )"   #K�!PX@3  ! 5	  ) 
 )"   #@7  ! 		7 5   ) 
 )"   #YY�;+#33#".#"#4>3232>53�E6�E<�!*$*'D�����N�;9       -����  ' 1@ $"	 +@  ' "   '   #�;+".54>3232>54.#"zJ{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj    -��^'  ' 	@"	 +".54>3232>54.#"F?hI)+Kg<?gJ(+Kf�� 9P12P9 :O02P9/Nd56eL.0Od37dM-+P=%&?O)+P=$&?O    -��[�   4 �@"!  ,*!4"4    	+K�.PX@4!    )	 '"
  '   #@N!    )	 ' "	  ' "
   '   "
 ' #
Y�;+%!5#".54>325!!!!2>54.#"[�(5DQ-J{X13ZzG.RD3��wS����<bD%'F`:<bD%&F`>>�'D2=e�DG�d;2D&�>�>��3Tk89kS13Tk7:kS1    -����   + ?@(&+@'  !   7  ' "  '#�;+'73".54>3232>54.#"�-;H]J{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%']�f=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj   -����  ' 7 N@)( 5420,+(7)7$"	 
+@,7	  )  ' "  '   #�;+".54>3232>54.#"2673#"&53zJ{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%!)$*8*"=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj�&%:+(    -����   . B@+)!+@*  !   7  ' "  '#�;+73'".54>3232>54.#" b2c'UUTJ{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%@UU??��=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj   -����    / O@	  ,*" 	  +@) 	   )  ' "  '
#�;+53353".54>3232>54.#":[:hJ{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%4^^^^��=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj   -����  ' + ?@ )($"	 +@'+*! 7  ' "   '   #�;+".54>3232>54.#"3zJ{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%�G<,=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj�]    -����    / D@	,*" 	+@*  !  7  ' "  '#�;+'73'73".54>3232>54.#"<%9@*&9@�J{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%']n]�f=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj     +l!�   @+@     #�;+'73'73P%9@*&9@l]n]  -����   + D@  (&  +@&     )  ' "  '#�;+5!".54>3232>54.#"�!�J{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%R//��=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj    -�N��  3 2@
0.&$+@     '   "  ' #�;+.5467.54>3232>54.#"_%&$&EpP,3ZzGJ{W0/TsC,$4�&F`;<bD%'F`:<bD%�'2@c|AG�d;?f�CD~b>+%�:kS14Tj7:kR13Tj    -����  ' 3 �@  0.$"  
+K�.PX@0,+  !  '"   '   #@8,+ !"  ' " "   '    #Y�;+#"&'#7.54>3274&'32>%.#"�96=3YzG0U$M86<3ZzG/T#B,&��B&<bD%��+&9A%<bD%�U5�KG�c;,T4�MG�d;,��=o*�)4Tj7>p*�3Tj      C�  @
    +@"    #�;+	#C�'M���:�    -����  ' 3 7 �@  760.$"  
+K�.PX@:54,+  ! 7  '"   '   #@B54,+ ! 7"  ' " "   '    #Y�;+#"&'#7.54>3274&'32>%.#"'73�96=3YzG0U$M86<3ZzG/T#B,&��B&<bD%��+&9A%<bD%-;H�U5�KG�c;,T4�MG�d;,��=o*�)4Tj7>p*�3Tj�]   -����  ' G �@)( CB><9732.,(G)G$"	 +K�PX@2	  )  )  ' "   '
   #K�!PX@9 5	  )  )  ' "   '
   #@= 		7 5   )  )  ' "   '
   #YY�;+".54>3232>54.#"".#"#4>3232>53zJ{X03ZzGJ{W03Yz��&F`;<bD%'F`:<bD%F!*$*'=e�DG�d;?f�CG�c;h:kS14Tj7:kR13Tj�      Z  R�   6@    +@   )   '   "#�;+3!2+32>54.+Z&.M86K.��3$'5��'?P),Q>&��D-; !;,    Q  �$   	@ +332+532>54.+Q�'B/.?'��* ,�$2> "?1�� ,+     -����  / �@'%//+K�.PX@- ! 5  ' "  '   #@1 ! 5  ' " "  '    #Y�;+%#".54>32#'267'3>54.#"<)a8J{X03ZzGJ{W05/TE�-L YE9#&'F`:<bD%&F`? $>d�DG�d;?f�CI�2c:jD*k8:kR23Tk7:kS1   -��^'  / 	@%+%#".54>32#'267'3>54.#"�"R/?hI)+Kg<?gJ(,&G>�$>K>/ :O02P9 9P0/Nd56eL.0Od38e&N5S5 N*+P=%'>P(+P=%   Z  h�   ?@    +@%!    )   '   "#�;+3!2##32>54.+Z+.N8*:$�O���3$'5��'?P)'G9'����D.:  ;,    Q  $   	@ +332#'#532>54.+Q�'A/#0�H���* +�$2> 6+����!+*!   Z  h�   " K@" +@/  !   7    )  ' "#�;+'73!2##32>54.+E-;H��+.N8*:$�O���3$'5�)]�i�'?P)'G9'����D.:  ;,  Z  h�   % N@%#
+@2!     7    )  ' "#�;+7#'!2##32>54.+�UU'c2bi+.N8*:$�O���3$'5��??VV�}�'?P)'G9'����D.:  ;,    Z�[h�   ' �@		'%		
 
+K�PX@5!   -    )    (  ' "	#@6!   5    )    (  ' "	#Y�;+2=3#'!2##32>54.+:,#�+.N8*:$�O���3$'5�@@��'?P)'G9'����D.:  ;,   #��?� 0 5@
.,+@#0  !    ' "  ' #�;+.#"#"'732654.'.54>32�e?_V1K39Z@"&D^7�v"'�QU`6Q58T9%C]8Fo-A"*G= )-A01H0g9)9=>!-!*;+1M3+'  &���' / @,+.#"#"'732654.'.54>32�R4MF)=*.L4 9O.�e!kECN,C+.E/ 8M.sK� 3-	
#2%'9%N4 +,-!	
!/"&;(?   #��?�  4 A@20 +@-  4!   7  ' "  ' #�;+'73.#"#"'732654.'.54>32B-;Hce?_V1K39Z@"&D^7�v"'�QU`6Q58T9%C]8Fo-7]��"*G= )-A01H0g9)9=>!-!*;+1M3+'    #��?�  7 D@53#!	+@07!     7  ' "  ' #�;+7#'.#"#"'732654.'.54>32�UU'c2b:e?_V1K39Z@"&D^7�v"'�QU`6Q58T9%C]8Fo-�??VV��"*G= )-A01H0g9)9=>!-!*;+1M3+'    #��?�  7 D@53#!	+@0  7!   7  ' "  ' #�;+73'.#"#"'732654.'.54>32�b2c'UUe?_V1K39Z@"&D^7�v"'�QU`6Q58T9%C]8Fo-PUU??�"*G= )-A01H0g9)9=>!-!*;+1M3+'       S�  &@
 +@    ' " #�;+###5!S�F�@��x�>      �$  @+###5!��?�����8   %  e�  :@
	 +@   )    ' " #�;+#3###535#5!e���F���@��'��n'�>      S�   5@
	+@!     7  ' " #�;+7#'###5!�UU'c2b��F�@�??VV��x�>   Z  @�   @@ 	 +@"    )  ) " #�;+2+#32>54.+m.M8 6K.�EE�3$'4�9'?P),Q>&yƍ�-; ;,��   O����  +@  +@"   ' #�;+%2>53#".53yCY5F GrRUrFE5X:3Sj6f��H�b:=d�Df��8jR2   G��=$  @+%2>53#".53A7I,?<_EG`:?,G5&=N)��8cL,/Lc5��*N=%   O����   9@
+@!  !   7"' #�;+'732>53#".53�-;H]CY5F GrRUrFE5X']��3Sj6f��H�b:=d�Df��8jR2  O����  ) H@ '&$")) 
+@&7	  )"  ' #�;+%2>53#".532673#"&53yCY5F GrRUrFE5XC!)$*8*":3Sj6f��H�b:=d�Df��8jR2&%:+(    O����    <@  +@$  !   7"' #�;+73'2>53#".53�b2c'UUTCY5F GrRUrFE5X@UU??�3Sj6f��H�b:=d�Df��8jR2   O����   ! I@	  !	!  +@# 	   )"
 ' #�;+533532>53#".53:[:iCY5F GrRUrFE5X4^^^^�3Sj6f��H�b:=d�Df��8jR2  O����   9@  +@!! 7"  ' #�;+%2>53#".533yCY5F GrRUrFE5XG<,:3Sj6f��H�b:=d�Df��8jR2[]   O����   ! >@ !  +@$!7"  ' #�;+%2>53#".53'73'73yCY5F GrRUrFE5X%9@*&9@:3Sj6f��H�b:=d�Df��8jR2�]n]     O����   >@  +@    )"   ' #�;+%2>53#".535!yCY5F GrRUrFE5XM!:3Sj6f��H�b:=d�Df��8jR2//   O�N�� % W@   %%+K�	PX@"   '#@"   '#Y�;+%2>53.5467.53yCY5FCkL,$4%&$&Mg?E5X:3Sj6f��F~a<*%&'1@c{Af��8jR2  O����   1 L@,+&$11

+@*    )   )"	 ' #�;+4632#"&7"32654&2>53#".530*  **  *JCY5F GrRUrFE5XT$$$$D��3Sj6f��H�b:=d�Df��8jR2  O����  9 �@ 540.+)%$ 99 +K�PX@,	  )  )"
   ' #K�!PX@3 5	  )  )"
   ' #@7 		7 5   )  )"
   ' #YY�;+%2>53#".53".#"#4>3232>53yCY5F GrRUrFE5X�!*$*':3Sj6f��H�b:=d�Df��8jR2�        ��  (@    +@ !  " #�;+3#U��J��=�����o�:�     :$  @ +3#T��C�7�$�3���$    
�  Y@
	 +K�.PX@ !  "#@ !"  "#Y�;+3733##3cCdeB|�L��>��>��J��������u�:_�����A      �  @ +##33�I��I�N��Lн��:U�����a��a      r$  @	+3733##372;TT;in�E�7|}7�D�l ���������$�(�       
�   o@+K�.PX@%  
	!   7"#@)  
	!   7""#Y�;+'733733##3-;H��CdeB|�L��>��>��J�']�������u�:_�����A      
�   u@
+K�.PX@(  	!   7"#@,  	!   7""#Y�;+73'3733##3�b2c'UURCdeB|�L��>��>��J�@UU??j������u�:_�����A    
�    �@  	  +K�.PX@)
! 
   )	"#@-
! 
   )	""#Y�;+533533733##3�:[:��CdeB|�L��>��>��J�4^^^^s������u�:_�����A    
�   o@
	 +K�.PX@%  !  7  "#@) ! 7"  "#Y�;+3733##33cCdeB|�L��>��>��J�2G<,�������u�:_�����A]      r�  .@    	+@
 !  "#�;+3	##	S��M��	M��N	�����6����,��^h       $  @ +73#'#S��F��E��F��$��������     s�  *@    +@ !  " #�;+3#T��L��E�����~�B��
�     $  @ +3#5R��E�>�$��"����Y    s�   8@    +@"
	  !  "   ' #�;+3#%'73T��L��E��;-;H���~�B��
�a]     s�   ;@  
  +@%	  !  "   ' #�;+3#?3'T��L��E��b2c'UU���~�B��
�zUU??      s�    H@		  		
  
+@$ !	   )  " #�;+3#753353T��L��E���:[:���~�B��
�n^^^^      s�   8@  
	  +@"  !  "   ' #�;+3#73T��L��E���G<,���~�B��
��]      s�  ( �@
	  $#	(
(  +K�PX@- !  ) 
  )	  " #K�!PX@4 !   5  ) 
 )	  " #@8 ! 7   5   ) 
 )	  " #YY�;+3#%".#"#4>3232>53T��L��E��r!*$*'���~�B��
�s      P� 	 6@
	+@$  !     ' "   ' #�;+7!5!!!��%,�#���7Q>7��>   #  �$ 	 @+7!5!!!#��u��s��%1�82�F8    P�   B@
+@.  	!   7   ' "   ' #�;+'73	!5!!!N-;H�x��%,�#���']��Q>7��>    P�   E@
	+@1!     7   ' "   ' #�;+7#'!5!!!�UU'c2b���%,�#����??VV��Q>7��>      P� 	  I@



	+@/  !   )     ' "   ' #�;+7!5!!!53��%,�#���>7Q>7��>4aa    ��� ( : �@*) 42):*:#!	 ((
+K�PX@G0&% ! 5   )  ' "	  '   #@K0&%! 5   )  ' " "	  '   #Y�;+".54>3254&#"'>323#"&/'267>=.#"�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0
,: $;*/EQ -""na�<).34'"		U;4(     '��!  ' 	@#	 +".54>3253#5.#"32677[B$&AX3BeDDb$.7+F23F*?Z
,Jb57cJ+C4j��i4?Z1$%<L&*L9"J6     ��� " 7 	@(2+!5#".54>3254&#"'>32'6=.#"32>�#m:$@.'?N'6POE'T+,b63N6V#K#:."-0,&R/-,;")<&	/DR -'7L.��sU)*	      ���� ( : > �@*) >=42):*:#!	 ((+K�PX@Q<;0&% ! 5   ) "  ' "
  '	   #@U<;0&%! 5   ) "  ' " "
  '	   #	Y�;+".54>3254&#"'>323#"&/'267>=.#"'73�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0J-;H
,: $;*/EQ -""na�<).34'"		U;4( B]     ���� ( : J �@&<;*) HGEC?>;J<J42):*:#!	 ((+K�PX@X0&% ! 5 

 )   )		"  ' "  '   #	@\0&%! 5 

 )   )		"  ' " "  '   #
Y�;+".54>3254&#"'>323#"&/'267>=.#"2673#"&53�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0D!)$*8*"
,: $;*/EQ -""na�<).34'"		U;4( n&%:+(     ���� ( : A �@*) =<42):*:#!	 ((+K�PX@TA@?>;0&% ! 5   ) "  ' "
  '	   #@XA@?>;0&%! 5   ) "  ' " "
  '	   #	Y�;+".54>3254&#"'>323#"&/'267>=.#"73'�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!07b2c'UU
,: $;*/EQ -""na�<).34'"		U;4( [UU??      ���� ( : > B �@*??;;*) ?B?BA@;>;>=<42):*:#!	 ((+K�PX@W0&% ! 5   )		  '
"  ' "  '   #	@[0&%! 5   )		  '
"  ' " "  '   #
Y�;+".54>3254&#"'>323#"&/'267>=.#"53353�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0$:[:
,: $;*/EQ -""na�<).34'"		U;4( O^^^^  "��� ? Q \ {@&RRA@ R\R\XVKI@QAQ97.,(' 	 ??+@MH	E;32!  		 )   )
 '"  '   #�;+".54>32>7.#"'632>32!32>7#"&''26767.'&#"%.#"�$?/ 9P0#F	K<'S,e_A\!g?9_E'�;"6F'2+!	;,:F&Eo"4>A6Y

<AHZ"-� 4E((D4
,;"":*	(6< -D62/9+Ic7*G4#/#?4,4(!5<1*�+G44H*    "����  C U ` �@(VVEDV`V`\ZOMDUEU=;20,+$"CC+@W   L
I?76!  

 )  )   " '"	 '#�;+'73".54>32>7.#"'632>32!32>7#"&''26767.'&#"%.#"�-;H��$?/ 9P0#F	K<'S,e_A\!g?9_E'�;"6F'2+!	;,:F&Eo"4>A6Y

<AHZ"-� 4E((D4l]�,;"":*	(6< -D62/9+Ic7*G4#/#?4,4(!5<1*�+G44H*    ���� ( : > �@*) <;42):*:#!	 ((+K�PX@Q>=0&% ! 5   ) "  ' "
  '	   #@U>=0&%! 5   ) "  ' " "
  '	   #	Y�;+".54>3254&#"'>323#"&/'267>=.#"3�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0G<,
,: $;*/EQ -""na�<).34'"		U;4( �]     ���� ( : > �@";;*) ;>;>=<42):*:#!	 ((+K�PX@T0&% ! 5   )		  ' "  ' "  '
   #	@X0&%! 5   )		  ' "  ' " "  '
   #
Y�;+".54>3254&#"'>323#"&/'267>=.#"5!�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0L!
,: $;*/EQ -""na�<).34'"		U;4( m//     0���� + 7 I �@-,  FD,7-7 + +'&+K�PX@;="0/*#!  ' "   '  "  '   #@8="0/*#!  ' "   '"  '    #Y�;+!'#".54>7.54>32>53%267'>54&#"<R*n@/R=$*6%
0A&#<-*8 �:���3W!�5F/<V!1#:-*V-33G+$;3,.'$!9*%44.)�&Y1>n.�-+&�%Q6!3#)##%'2$   �Q� 1 C c@32=;2C3C+*&$+@G"!9
, !1   5   )  ' "  '    #�;+.5467./#".54>3254&#"'>323'267>=.#"�%&$)"o9(B/ :Q1'R OC*S+3`4_p-%4�-Y
"J#I[!0�'3).3,: $;*/EQ -""na�<+%�'"		U;4(      �l�  @+@      #�;+'753�-&^l;"      ���� ( : F R �@&HG*) NLGRHREC?=42):*:#!	 ((+K�PX@^0&% ! 5  		 )   )

 ' "  ' "  '   #
@b0&%! 5  		 )   )

 ' "  ' " "  '   #Y�;+".54>3254&#"'>323#"&/'267>=.#"4632#"&7"32654&�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0*  **  *J
,: $;*/EQ -""na�<).34'"		U;4( o$$$$D    ���p ( : > J V@(LK*) RPKVLVIGCA>=42):*:#!	 ((+K�PX@h<;	0&% ! 	7 5  

 )   )	 ' 		"  ' "  '   #@l<;	0&%! 	7 5  

 )   )	 ' 		"  ' " "  '   #Y�;+".54>3254&#"'>323#"&/'267>=.#"'734632#"&7"32654&�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0J-;H�*  **  *J
,: $;*/EQ -""na�<).34'"		U;4( �]�$$$$D    ,/��  (@    +@ ! 8    #�;+3#,�:�<��/��iW��    A ��X   t@ 	+K�'PX@'     )  &  ' $@.    5     )  &  ' $Y�;+74>3232>53#".#"#A)(&&+, *'$+�!$#     >�  #@+@
	      #�;+7'7'37'X+EE,ED, ++">$II$>AA    2�n[ X j }@ iga_PNIG?=53,*%# XX+@W('
]
LK!    )   )  

 )  		 (  ' "  ' #	�;+2#".'#"&54>324.#"'>3232>54.#"3267#".54>>=.#"326�J�d:
 0"X5GO!5B!,B0%(G$Q.8A"	")	2YxFEyZ52WxF+J%)T*K�c9=g��*C01&</1[7e�U/46,!*K;&4$;*'%;I$�,8+>GH~]63Z|JG}]5 8e�QU�b5��6(	#*3      ���� ( : Z~@*<;*) VUQOLJFEA?;Z<Z42):*:#!	 ((+K�PX@`0&% ! 5 
 )   ) 		 '"  ' "  '   #
K�!PX@k0&%! 

5 5 
 )   ) 		 '"  ' " "  '   #@o0&%! 

5 5 
 )   ) " 		 ' "  ' " "  '   #YY�;+".54>3254&#"'>323#"&/'267>=.#"".#"#4>3232>53�(B/ :Q1'R OC*S+3`4_p!"o(-Y
"J#I[!0�!*$*'
,: $;*/EQ -""na�<).34'"		U;4( T     I��@�  ) �@  ))
 +K�PX@+%$! "  ' "  '   #@/%$! "  ' " "  '   #Y�;+"&'#3>32'2>54.#"H=h=D#bB6X=!&C[D+G31D)6.%#28
>1e���5A.Ma37bI+<#;K()L;#$/�/"     �  @
    +@"    #�;+#i�M�L��:�     R�~ �  *@
    +@     &     '   $�;+3R;���w   5�� ��  r@    
	+K�PX@* !   5 ' "    ' #@' !   5     ( ' #Y�;+3#"&54&'52>546;�7^

^���$%��9!49    -�� ��  r@    
+K�PX@*! 5  '   "  ' #@'! 5   (  '   #Y�;+5323+53467.5-^	^7

�9��4!��9%$    T�� ��  Y@    +K�2PX@   (    '   #@"      )   &   '  $Y�;+3#3Tw77(9�f9    -�� ��  Y@    +K�2PX@     (   ' #@"     )     &     '   $Y�;+53#53-88w(9�9��    T�~ �   >@    +@$   )    &   '     $�;+##�;;;�i���i�    X �  %@
+@    &   '    $�;+#"&54>324%%5!!Z&44&    '�� % 5@
" +@#	!   '   "  ' #�;+4>32.#"32>7#".'&E`:JnBN0(E34E'1*B*9E%9`F'7bI*C9(- 7L-,N9! /#+Kb  '��e� W @G4+%#".5#5354.#".#"32>7#".54>32.546323#3267e&(HH,'40BO0,D03F(/+"B-:D";`D&$C_;1EMK<@vv&,
&u6#>.>,:7.-($<L'*L9"!0!.Ka35bK-=#=O"<S16��    '���  ) A@&$
+@-   !   "  ' "  ' #�;+'734>32.#"32>7#".0-;H��&E`:JnBN0(E34E'1*B*9E%9`F'l]�,7bI*C9(- 7L-,N9! /#+Kb  '���  , D@)'+@0#"!     7  ' "  ' #�;+7#'4>32.#"32>7#".�UU'c2b�&E`:JnBN0(E34E'1*B*9E%9`F'�??VV�@7bI*C9(- 7L-,N9! /#+Kb    (�P ?@=;7521(&	+K�	PX@G-,3  ? ! -   )     (  ' " #K�PX@G-,3  ? ! -   )     (  ' " #@H-,3  ? ! 5   )     (  ' " #YY�;+3254&#"7.54>32.#"32>7>32#"&'�09.*5X@$&E`:JnBN0(E34E'1*B
'4?"	#)422~#	N.I_57bI*C9(- 7L-,N9! -!*"$    '���  , D@)'+@0  #"!   "  ' "  ' #�;+73'4>32.#"32>7#".�b2c'UU�&E`:JnBN0(E34E'1*B*9E%9`F'�UU??��7bI*C9(- 7L-,N9! /#+Kb    '��� % ) J@&&&)&)('" +@0	!  ' "   '   "  ' #�;+4>32.#"32>7#".53'&E`:JnBN0(E34E'1*B*9E%9`F'�>7bI*C9(- 7L-,N9! /#+Kb�aa     .��� " - Q@   " "! +@7 )(!     (  ' "  ' #�;+5.54>753.'>7#3V=#!<V6%KdAH+-)B0:@�,<#'<*xo1J\03]J0ttA8)(�_  1 nz%E7%�&:H    F      6@    +@   '   "   '#�;+5353F999�bb�\bb    7�� � b  ,@
 +@  7    &    '   $�;+26=3#7:\f    3���  ' M `@)( FD<:31(M)M''	 +@:IH65!   ) 
 )  ' "	  '   #�;+".54>32'2>54.#"7".54>32.#"3267�O�b77b�OO�b88b�OFzZ42ZzHGzY32YzO-U@'8V:BfA
##(;'.9&LB"2A7a�NM�`77`�MN�a7!0VxIGxX22WyFFxX2a!<V5*TB*961?)A,)#)#  '��7�  0 �@ (&00	 	+K�PX@0"! ! "  ' " '   #K�!PX@="! ! "  ' "  '  "  '   #@:"!! "  ' " ' "  '   #YY�;+".54>3233#"&='2>75.#"!6\C%$?W4BfD
  i+91$
'17*E04G
-Ja57cJ+E1>�~<73<<#/�/$$;L(*L9"   '���  ) 	@#+!5#".54>323.#"32>7�c96\C%$?X3Bd DD
'18*D04G):1$a0;-Ja57cJ+E1>�&T0#$;L(*L9"#/   +�~s  >@    
	+@$   &    )   '  $�;+#5333#���A���r>��'>��     /�~x  R@    
	+@0 	  &  ) 	   ) 	  '
		  $�;+#535#5333#3#�����B�����!?n?|��?n?��     '����   4 �@! ,* 4!4
+K�PX@6  &%!  "  ' "	'#K�!PX@C  &%!  "  ' " '"	 '#@@  &%!  "  ' " ' "	 '#YY�;+'73".54>3233#"&='2>75.#"p-;H�[6\C%$?W4BfD
  i+91$
'17*E04Gl]�-Ja57cJ+E1>�~<73<<#/�/$$;L(*L9"   '��e� # 8@ %$ 0.$8%8	 ##+K�PX@<*)!
 !  ) " 

 ' "	 '   #K�!PX@I*)!
 	!  ) " 

 ' "  '  "		  '   #	@F*)!
	!  ) " 

 ' " ' "		  '   #	YY�;+".54>325#53533#3#"&='2>75.#"!6\C%$?W4BfssDFF
  i+91$
'17*E04G
-Ja57cJ+E1�.CC.��<73<<#/�/$$;L(*L9"    2. ��   )@

+@   (   '   #�;+4632#"&7327654'&#"20##00##04�#//#$00B   B J��    P@  
	  	+@.     )   )   &   '  $�;+5353'5!�;;;���[[��ZZ�99  %��A/ ( 1 : �@980/&%$#"!
+K�PX@77.(  ! + ,	   '" '#K�.PX@57.(  ! 7 8	   '" '#@A7.(  ! 7 8	   '" ' " ' #	YY�;+.'#5&'7.54>7534.'26�_<9]B$%B[6%�j"#vH:W;!=T3%Bh+&-C,U^��(=*UMA *��-C00H/ab	]9&6*;+/I3ed+%�:*��=�'
E  I   �	  @
    +@   "#�;+33ID	��  ���K �	  /@  +@ !    ( #�;+"&'732>53!:!&!D+7�.
"$��#:*     '��. " - K@## #-#-)'	 ""+@-!   )  ' "   '   #�;+".54>32!32>7.#"-9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3
+Kb87aI++J`6*G4#/#**E22F)     '��.�  & 1 W@'''1'1-+&&	+@7  "!!   )   "  ' "  '#�;+'73".54>32!32>7.#"/-;HX9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3l]�+Kb87aI++J`6*G4#/#**E22F)  '��.� " - = h@"/.## ;:8621.=/=#-#-)'	 ""+@>!  )  )	"  ' "   '
   #�;+".54>32!32>7.#"2673#"&53-9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3�!)$*8*"
+Kb87aI++J`6*G4#/#**E22F)x&%:+(  '��.�  ) 4 Z@***4*40. ))	+@:%$!     7   )  ' "  '#�;+7#'".54>32!32>7.#"�UU'c2b9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3�??VV�0+Kb87aI++J`6*G4#/#**E22F)   '��.�  ) 4 Z@***4*40. ))	+@:  %$!   )   "  ' "  '#�;+73'".54>32!32>7.#"�b2c'UUY9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3�UU??��+Kb87aI++J`6*G4#/#**E22F)   '��.�   * 5 k@&++	  +5+51/!*	*  +@=&%!	 	  )
   '  "  ' "  '#�;+53353".54>32!32>7.#"�:[:d9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3y^^^^�}+Kb87aI++J`6*G4#/#**E22F)   '��.� " - 1 `@..## .1.10/#-#-)'	 ""+@:!	   )
  ' "  ' "   '   #�;+".54>32!32>7.#"53-9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3�>
+Kb87aI++J`6*G4#/#**E22F)Yaa    '��.� " - 1 W@## /.#-#-)'	 ""	+@710!   ) "  ' "   '   #�;+".54>32!32>7.#"3-9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3_G<,
+Kb87aI++J`6*G4#/#**E22F)�]   3�� � ' ; O u@LJB@86.,+K�	PX@+#!   )  ' "   '    #@+#!   )  ' "   '    #Y�;+%#".54>7.54>324.#"32>32>54.#" (D[25ZA$(3* (?O((O?(!+4'E 3@!?2 3?  ?2��,67,+77*�/K6!9L+":-!	
&.,C.-D+.'

#.:$7&'8"#7&'7f- .-.   3�� � ' ; O @J@,6+%#".54>7.54>324.#"32>32>54.#" (D[25ZA$(3* (?O((O?(!+4'E 3@!?2 3?  ?2��,67,+77*�/K6!9L+":-!	
&.,C.-D+.'

#.:$7&'8"#7&'7f- .-.     &��g� ! 5 I ?@FD<:20(&+@)!   )   )   '    #�;+%#".54>7.54>324.#"32>'32>54.#"g,;!#:*!.)44)- (5-!)* !** �$$$#o+ +!)&%*4!
�			    &Fg� ! 5 G >@FD<:20(&+@(!   )     (  ' #�;+#".54>7.54>324.#"32>'32>54.#"g,;!#:*!.)44)- (5-!)* !** �$$$'<�+ + )%%*4!
�!     B  � b    7@  
	  	+@    '#�;+353353353B:L:L:bbbbbb     '��.� " - 1 `@..## .1.10/#-#-)'	 ""+@:!	   )
  ' "  ' "   '   #�;+".54>32!32>7.#"5!-9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3,!
+Kb87aI++J`6*G4#/#**E22F)w//   B �D0  *@
    +@     &     '   $�;+75!B�??    B ��0  *@
    +@     &     '   $�;+75!B��??    I�K� ) �@   ))+K�PX@- !    (  '" #@1 !    ( "  ' " #Y�;+"&'732>54&#"#3>32f!:!&!69<4'
D>/:A#,;$+7�.
">]T(7 ��	v/" :T3��#:*    (�K/ , 7 K@---7-731+@1$#!,     )  ' "   '    #�;+.5467.54>32!32>7.#"%%&!%6[B%'F_99_D&�C!3C&2*!	;c?,$4�!3D&&D3�'0-J`67aI++J`6*G4#2E*%�*E22F)     F �tf   =@    +@#    )     &     '   $�;+75!%5!F.��.�11s11    )��/� $ 8 B@53+)! 
+@.$# !  ) "   '    #�;+#".54>32.''7&'3732>54.#"�S+8"*H`55\F('BY3Cm
8?oi8W`7-X��3D'(E43D''F3�3*[[Y*AiL)&BX31XB&A4?|>FA02!'7�&B24E'%@02D  '��.� " - M$@&/.## IHDB?=9842.M/M#-#-)'	 ""+K�PX@F! 

 )  ) 	 '		"  ' "   '   #	K�!PX@M! 5 

 )  ) 	 '		"  ' "   '   #
@Q! 5 

 )  ) " 	 ' 		"  ' "   '   #YY�;+".54>32!32>7.#"".#"#4>3232>53-9`F''F_99_D&�C!3C&2*!	;,:F�!3D&&D3�!*$*'
+Kb87aI++J`6*G4#/#**E22F)^      X   ��   6@    +@   '   "   '#�;+7353XDDD����pp    X�� ��   6@    +@   '"   '    #�;+#7#5�DDD����pp     l�  F@    	+@*!    )  ' "#�;+3#5354632.#"3#eHHRH:)03���6K`m1JFM6�j       `� ' 5 d@ 54/- 
	 ''+@>$	%
 +
!  )  	 ' 		" 

 ' "#�;+"3#####5354>32>32.467.#"3,��D�DHH'<(%9@/#�	
-&
��(4M6�j��j�6,&G7!
$1�6(0.    �� ) 7 g@ ***7*720)('&%$#"! 
 +@?.!	    )  ' "  ' "
#�;+#5354>32>32.#"!#####5467.#"eHH'<(%9F2/'
 >% .D�D�D�	
-&
�6,&G7!
$
1(4M�4��j��j�E6(0.     ��4� 9 G)@(:: :G:GB@4320)'#!
 99+K�PX@G%>5 !  ) 
 ' 

" 	 ' 		"   '   #K�'PX@N%>5 ! 5  ) 
 ' 

" 	 ' 		"    '   #	@R%>5! 5  ) 
 ' 

" 	 ' 		""   '   #
YY�;+"&54.#"3#####5354>32>3232635467.#"�06*+mmD�DHH*='&2G1,B-'!�h&(8&�',6C6�j��j�63(F3
"*9"�-)8�E6%.5    ��  D@
 +@*!    )  ' "#�;+#5354>32.#"!###eHH-F08N>% -D�D�6K$J:%"1(4M�4��j     ��K� / �@/.-+$"
+K�PX@(  )  ' "	  '   #K�'PX@/ 		5	  )  ' "   '   #@3 		5	  )  ' " "   '    #YY�;+%#"&54.#"3###5354>323263K"05)+nnDHH-D.,B-'
8&�',6C6�j�6P,I5*9"�-)   &�k ; . [@ +*)(! 	 ..+@?, ! 5     )    )  &  '  $�;+2#".'732>54.#"#>767!!>1T?$'CZ3&E:/-a:%@0.=$0S?W��1K8!<S25W="$2"1<.@&%=,)'*:G$Tg?�  -��� , @&	+2#"&'732>54.#"#>767!!>1T>$'BZ3Lx-a:%@0.>$.T?W��1K�!<S25V>"J?"2;-@&%=,*&);F$Tg?�   (��C� ! 5 I q w �@ KJonmlgfdb\ZUSJqKqFD<:20(&+@htup	XW
wr ! 
		
5 	
	 )   )   )   )   ' "   '    #
�;+%#".54>7.54>324.#"32>'32>54.#"2#"&'732654.#"#>73#6		C,;!#:*!.)44)- (5-!)* !** �$$$#�� 8),;"1O?(0A(8*߽!$#����o+ +!)&%*4!
�			!.1#(# 1*"CG<,���T[����  !FW� ' Q@ %$#"	 ''+@5& ! 5    )   (   ' #�;+2#"&'732654.#"#>73#6� 8),;"1O?(0A(8*߽!$I!.1#(# 1*"CG<,� �(��r�  @+'		�#����T[����    ��V� ( R@ %$#"	 ((+@6& ! 5     )    )  ' #�;+72#"&'732654.#"#>73#>� 8),;"1O?(0A(8*߽!1�"/1#)! 2)"CG<,�   �K�� ' T@ "!  ''	+@6 !  )    (  ' #�;+"&'732>5#5354632.#"3#�!:!&!HHRG;)02��+7�.
"�6K`m1JFM6�Q#9)     ���; 
  I@   
 
	+@/ ! 7 8    &  '   $�;+5!533#%!c��c/XX���<��6>��_    � 
  	@ +!5!533#%!v��r/XX���=��6>��`     b� 
  ?@   
 
	+@% !    )   '#�;+35#5733#'35���99�g*��,g��     Kb� 
  ?@   
 
	+@% !    )  ' #�;+5#5733#'35���99�Kg*��+g��   (�! $ 9 �@&% 1/%9&9	 $$	+K�PX@7+*" !  '"  '  "  ' #K�2PX@;+*" ! "  ' "  '  "  ' #@8+*" !   ( "  ' "  '   #YY�;+".54>3253#"&'732>='2>75.#"6YA$#@Y6Cb#=)E^4Yn"*f:&E3g&:/ '07,D04G-J`36cJ,C3m��6S8@6!2/)?*g2:9%.�0"%<L'*L9!    (�!� $ 9 I@$;:&% GFDB>=:I;I1/%9&9	 $$+K�PX@H+*" ! 		 )
"  '"  '  "  ' #	K�2PX@L+*" ! 		 )
" "  ' "  '  "  ' #
@I+*" ! 		 )   (
" "  ' "  '   #	YY�;+".54>3253#"&'732>='2>75.#"2673#"&536YA$#@Y6Cb#=)E^4Yn"*f:&E3g&:/ '07,D04G@!)$*8*"-J`36cJ,C3m��6S8@6!2/)?*g2:9%.�0"%<L'*L9!f&%:+(   (�!�  + @@-,86,@-@$"++
+K�PX@D  21) !   "  '"	 '"  ' #K�2PX@H  21) !   " "  ' "	 '"  ' #	@E  21) !   (   " "  ' "	 '#YY�;+73'".54>3253#"&'732>='2>75.#"�b2c'UU,6YA$#@Y6Cb#=)E^4Yn"*f:&E3g&:/ '07,D04G�UU??��-J`36cJ,C3m��6S8@6!2/)?*g2:9%.�0"%<L'*L9!    (�!�  ( = �@*)53)=*=!((
+K�PX@A  /.&!   "  '"	 '"  ' #K�2PX@E  /.&!   " "  ' "	 '"  ' #	@B  /.&!   (   " "  ' "	 '#YY�;+'73".54>3253#"&'732>='2>75.#"L-;H�6YA$#@Y6Cb#=)E^4Yn"*f:&E3g&:/ '07,D04Gl]�-J`36cJ,C3m��6S8@6!2/)?*g2:9%.�0"%<L'*L9!     (�!� $ 9 =@ ::&% :=:=<;1/%9&9	 $$+K�PX@D+*" !  ' "  '"
  '	  "  ' #	K�2PX@H+*" !  ' " "  ' "
  '	  "  ' #
@E+*" !   (  ' " "  ' "
  '	   #	YY�;+".54>3253#"&'732>='2>75.#"536YA$#@Y6Cb#=)E^4Yn"*f:&E3g&:/ '07,D04G >-J`36cJ,C3m��6S8@6!2/)?*g2:9%.�0"%<L'*L9!Gaa     I���� 2 {@21!
	 +K�.PX@+*!    )  ' "    '#@/*!    )  ' " "    ' #Y�;+7>54.+532654.#"#4>32�]p,>%6D"-!2!A5I,(D2&KR(He>9LM#:)>?3))6�,I5*;#2(kI3M6   5���  @+%5-5��\A�����K��I�     , B�   	@+7'?',����������;��;�%�;��;�  @ B�   	@+%57'557'5����������;��;�%�;��;�  , B%�  @+7',�����;��;�     @ B8�  @+%57'58�����;��;�     I  ��  4@ +@ 
 ! "  ' "   #�;+!#4&#"#3>32�D=;92%	DD n?-?'#YX(6 �����;D!;S2     ��  H@ 	+@,
 !  ) "  ' "   #�;+!#4&#"##53533#>32�D=;92%	D==D{{ n?-?'#YX(6 ��i.CC.�;D!;S2    I  ��   ?@+@)  !  "  ' "#�;+73'#4&#"#3>32�]/^%PQD=;92%	DD n?-?'�TT??��#YX(6 �����;D!;S2   B �e0  *@
    +@     &     '   $�;+75!B#�??    I   ��   4@    +@  ' "   "#�;+3353IDDD	��vdd  D   ��   -@+@  !   " "#�;+'733q-;H~Dl]�&	��     	   ��   <@    +@   )"   "#�;+332673#"&53ID"!)$*8*"	���&%:+(   ��   ��  
 0@

	+@  !   " "#�;+73'3b2c'UU3D�UU??��	��        ��    ?@  
	  	+@   '  " "#�;+533533:[:�Dy^^^^��	��      ��   -@    +@ ! "   "#�;+333IDG<,	���]   I�Kc�     ^@$	  	  +@2!  (
  '"  "	#�;+3353"&'732>5353IDDD=!:!&!D+78D	��vdd��.
"$��#:*+dd    ���K ��   D@  +@( !    (  ' " #�;+"&'732>5353!:!&!D+78D�.
"$��#:*+dd   ��   ��   4@    +@  ' "   "#�;+335!ID�!	���//     �Q ��   5@	+@
    ' " "    #�;+.5467#353]%&$'D-%4&D�'2	��+%�dd    ��  �  # �@  
##  
+K�PX@& 	  )  '"   "#K�!PX@-   5 	 )  '"   "#@1   5 	 ) "  ' "   "#YY�;+33".#"#4>3232>53ID!*$*'	��~    I�+ ��   	@ +3#3#IDDDD�&�[    ���K ��   >@  +@( !    ( " #�;+"&'732>5373'!:!&!D+7!b2c'UU�.
"$��#:*:UU??   I  �  2@    	+@
 ! " "   #�;+!#33��pDD%M��h������  I�[�   ~@				 +K�PX@,
!   -    ( " "#@-
!   5    ( " "#Y�;+2=3#7#33�:,#��pDD%M�݃@@�h������    I  	  .@    	+@
 !"   #�;+!#33��pDD%M��h�	�����  L���  -@ +@ 	!   " ' #�;+33267#"&5LD 7/6���!7
50     O   ��  @ +3#ODD��&  @��s   9@

+@'  !   7 " ' #�;+'7333267#"&5m-;HwD 7/6]���!7
50    L��A�   2@

+@   !  " ' #�;+'73#33267#"&5�-;H�D 7/6l]��!7
50    L�[�   z@
	 +K�PX@-!   -    ( " ' #@.!   5    ( " ' #Y�;+2=3#33267#"&5z:,#.D 7/6�@@��!7
50  L��(�   @@ +@(	!   )   " ' #�;+33267#"&5753LD 7/6�:���!7
50�pp   "���  @+%%"���A�]�I��K�     O ~l  2@    +@   8  &  '   $�;+#5!5<��l�>  �� �  5@+@%	 	 !   " ' #�;+'7373267#"&5]@WDYp 7/6S2'EM��G'Y��!7
50     I  P % i@! +K�PX@!
 ! '"   #@%
 ! " '"   #Y�;+!#4&#"#4&#"#3>32632PD9:5-"	D8:;\D> h?BPI�+=%#[V(7!��#]TRC��	v<CJ<� ;S3   F�C  @ +5!F�88  P�,'	   �@ 
 +K�	PX@'	 !  " '" #K�PX@'	 !  " '" #K�!PX@.	 !   5  "  '" #@2	 !   5  " "  ' " #YYY�;+332>733#"&=#"&'#PD{91'D
 *4<1<A	�ڱ&4!H�O<H.#/&��     B l��  @	+%''7'77�,yz+yx,xx+x�+yy,xy+xy,y    I  �  Y@ +K�PX@
 !  '"   #@ 
 ! "  ' "   #Y�;+!#4&#"#3>32�D69<4'
D>/:A#,;$#]T(7 ��	v/" :T3   I  ��   o@
+K�PX@&  !   "  '"#@*  !   " "  ' "#Y�;+'73#4&#"#3>32--;H|D69<4'
D>/:A#,;$l]�&#]T(7 ��	v/" :T3    ��  ��   q@	+K�PX@'  !   "  '"#@+  !   " "  ' "#Y�;+'753#4&#"#3>32(-&^�D69<4'
D>/:A#,;$l;"�&#]T(7 ��	v/" :T3     I  ��    u@+K�PX@)!     7  '"#@-!     7 "  ' "#Y�;+7#'#4&#"#3>32�UU'c2bTD69<4'
D>/:A#,;$�??VV�:#]T(7 ��	v/" :T3  I�[�  " �@
	 +K�PX@,!   -    (  '"#K�PX@-!   5    (  '"#@1!   5    ( "  ' "#YY�;+2=3#%#4&#"#3>32�:,#D69<4'
D>/:A#,;$�@@�#]T(7 ��	v/" :T3   I  ��   {@  
  +K�PX@)!   '   "  '"#@-!   '   " "  ' "#Y�;+53#4&#"#3>32>�D69<4'
D>/:A#,;$yaa��#]T(7 ��	v/" :T3   &�f ; " 6 Q@$#.,#6$6+@7!    )   )  &  '  $�;+4>32#"&'732>5#".7"32>54.&'C\58^C&&E`;Fp,\8,H3kD3YB&�&C32C&&D33CG3YB&)LoEl�k4F>(3=*OsJ;F%AX�2C&&C22C&%C3   ,��'� " 6 	@#,+4>32#"&'732>5#".7"32>54.,'D\58^C&&E`;Fp+[9,H3kC3ZB&�&C33C&&C33C�3YB&(MnEm�k4F?'3<)PrJ;F&AW�3C%&C33B&%D2   "��m�  2 H@ *(2 2
+@.!    )   )  ' #�;+4>32#"&'73265#".7"32>54."-;#J]^N-J;%9G"(";+�,!!,,!!,	2&ZQwu%" SK	$1}#""#   "Bm�  2 �@ *(2 2
+K�
PX@-!   )   (  '   #K�PX@/!   (  '   "  ' #@-!   )   (  '   #YY�;+4>32#"&'73265#".7"32>54."-;#J]^N-J;%9G"(";+�,!!,,!!,P2&ZQxu&" SL
%1}#"#$  I  ��  91@540.+)%$ 99 +K�PX@5
 ! 		 )  '
"  '"   #K�PX@9
 ! 		 )  '
" "  ' "   #K�!PX@@
 ! 5 		 )  '
" "  ' "   #	@D
 ! 5 		 ) 

"  ' " "  ' "   #
YYY�;+!#4&#"#3>32".#"#4>3232>53�D69<4'
D>/:A#,;$�!*$*'#]T(7 ��	v/" :T3M     (  ��   �@&
	 +K�'PX@-  )

"  	  '		"#@+	 	  )  )

"#Y�;+#3##7##7#537#537337337#��/��2:3�2:4q}0��0:2�1:2u�0�/��6����6�3�������   '��-  ' 1@ $"	 +@  ' "   '   #�;+".54>3232>54.#"*9_E&'E_88_E''E_�3E''E44D''E3
+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:M     '��-�   + ?@(&+@'  !   "  ' "  '#�;+'73".54>3232>54.#"0-;H\9_E&'E_88_E''E_�3E''E44D''E3l]�+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:M    '��-�  ' 7 N@)( 5420,+(7)7$"	 
+@,	  )"  ' "   '   #�;+".54>3232>54.#"2673#"&53*9_E&'E_88_E''E_�3E''E44D''E3�!)$*8*"
+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:Mj&%:+(  '��-�   . B@+)!+@*  !   "  ' "  '#�;+73'".54>3232>54.#"�b2c'UUV9_E&'E_88_E''E_�3E''E44D''E3�UU??��+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:M     '��-�    / Q@	  ,*" 	  +@+	   '  "  ' "  '
#�;+53353".54>3232>54.#"�:[:g9_E&'E_88_E''E_�3E''E44D''E3y^^^^�}+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:M   (��� 0 D O@"EE21 EOEOKI<:1D2D*(	 00+K�PX@7	.$#!	 	  ) '"  '
   #K�!PX@D	.$#!	 	  ) '"  '
  "   '
   #@P	.$#!	 	  )  '"  '"  '
  "   '
   #
YY�;+".54>32>32!32>7#".''2>54.#"%.#")7^E'(E_6MwuQ7[C)�C"6F'3+ 9-;D$&F<2!uJ(E33E''F33E�!4D&&C1
*Hb89dI*YLNW'Fd=)G4#0"+<%LW< 9L,,M9!!:N,,L7 �+G44H*     '��-�  ' + ?@ )($"	 +@'+*! "  ' "   '   #�;+".54>3232>54.#"3*9_E&'E_88_E''E_�3E''E44D''E3`G<,
+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:M�]     '��-�    / D@	,*" 	+@*  !  "  ' "  '#�;+'73'73".54>3232>54.#"�%9@*&9@�9_E&'E_88_E''E_�3E''E44D''E3l]n]�+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:M   '��-�   + F@  (&  +@(   '   "  ' "  '#�;+5!".54>3232>54.#"�!�9_E&'E_88_E''E_�3E''E44D''E3�//�_+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:M   .  �;  ?@    
	+@%! 7   )  '    #�;+%!53#52>73����	&/271"F>>>�B"�     )  ��  @+%!53#52>73����%-0%#E>>>E@�o     0��8� ! 5 I \ b u@JJJ\J\[ZVUTSNMLKFD<:20(&+@O`_O	
b] ! 	 	 )   )  )   ) 

"   '    #�;+%#".54>7.54>324.#"32>'32>54.#"%#53#52>53		8,;!#:*!.)44)- (5-!)* !** �$$$#���Q!.J#����o+ +!)&%*4!
�			?--5-����T[����     "F ��  <@    
	+@"!   )    ( #�;+#53#52>53��Q!.s--5-��  1��:� ' : @ r@((  (:(:984321,+*) ' '&%+@L>=- ;!@   )     )	  ) "   '
#�;+!4>7>54&#"'>323#53#52>53		./'12('8$GG)/!+����Q!.Y#����'9, 	, D3*  ,s--5-����T[����     $  ^� ' 6@   ' '&%+@  !     )   '#�;+34>7>54&#"'>32!$ / 0(33( (9%II*1!- '9, 	, D3*  ,   "  	�  ?@    
	+@%! 7   )  '    #�;+%#53#52>53	�Y$-,,,5
,��   .��� 
    & x@"     
 
	+@N$#	
 ! !& 	 	 )  )    ) 

"   '#�;+!5#5733#'35%#53#52>53		���99��T�Q!.5#����g*��,g��!--5-����T[����  1��:� / B H �@"00 0B0BA@<;:94321" 
 //+@\FE5	
(HC ! 	 	 )   )  )   ) 

"   '   #�;+"&'732654&+532654.#"'>32#53#52>53		�?T".1CPE?H'*;Q0!8*[07-:�P�Q!.W#����/*' #((!"
""(E9&(x--5-����T[����    $��a� / M@ " 
 //+@3(!   )   )   '   #�;+"&'732654&+532654.#"'>32�?T".1CPE?H'*;Q0!8*[07-:/*' #((!"
""(E9&(    (�K.  3 1@
0.&$+@    ' "   '    #�;+.5467.54>3232>54.#""%&!%6[@$'E_88_E'!:Q1,$4�3E''E44D''E3�'0-I_57bJ,,Jb72ZH/*%�,K9 !9L,+M9!!:M     /Zx� & 5 b@(' 1/'5(5!	 &&
+@@-$ ! 5   )	   (  ' #�;+".54>3254&#"'632#"&/'2>=.#"�, (6!53-4>FEFPI)!0.9-Z((		+2)%.ID�4 !-4	%(    ,Z��  ' .@ $"	 +@    (  ' #�;+".54>32'32>54.#"�(B00B((B00B� ,+!!++!Z2B$%B22B%$B2�0#$00"#0     '��-  ' 2 �@)((2)2$"	+K�PX@4 10 !     '  " '#K�!PX@8 10 !     '  " " ' #@<10 !   "   '   " " ' #YY�;+7.54>3273#"&'#.#"2>54&'�,1'E_8&C/(-2'E_8'E."�2'E3�'E4#�,2&l?7bJ,6&m?6bJ+0PR!:M�!9L,/Q��    '��-�  ' 2 6 �@)(65(2)2$"	+K�PX@>43  10 !   "   '  " '#K�!PX@B43  10 !   "   '  " " ' #@F43 10 !   " "   '   " " ' #	YY�;+7.54>3273#"&'#.#"2>54&''73�,1'E_8&C/(-2'E_8'E."�2'E3�'E4#�,=-;H2&l?7bJ,6&m?6bJ+0PR!:M�!9L,/Q��:]  '��-�  ' G �@)( CB><9732.,(G)G$"	 +K�PX@4  )  '	"  ' "   '
   #K�!PX@; 5  )  '	"  ' "   '
   #@? 5  ) 		"  ' "  ' "   '
   #	YY�;+".54>3232>54.#"".#"#4>3232>53*9_E&'E_88_E''E_�3E''E44D''E3�!*$*'
+Jb67bJ,,Jb76bJ+,K9 !9L,+M9!!:MP      I�+@  ) �@  ))
 +K�PX@+%$!  '"  '  " #@/%$! "  ' "  '  " #Y�;+"&'#3>32'2>54.#"TBfD= f<6[B%"?WG*D14G)82#%/7
C3���e1=-Kb47bJ+<$;K(*L:"#/�0#   $��/�    @@
	
+@"8	 )  '   #�;+46;####.7%#3$���F<J;<`D$; 7I)bgNJJ�r6� 7��7!>W9/D-scd��   ,�� ��  @+4>7.,&34-%D;3?MZ3caa1Xdi0N�Z^�     �� ��  @+'>54.'7�M?3;D&-43&Z`�^Z�N0idX1aac    -����  ' ; M S h@"=<)( GE<M=M31(;);''	 +@>QPSN!	   )   )  ' " '
#�;+".54>32'2>54.#"".54>32'2>54.#"		�6))67((7$$$#d6))66))6#$#9�\#�����'44''44''%&%&�'54''45'(&&%,<T[����   B   | b  !@
    +@     '#�;+353B:bb   1���  ' ; O c w } ~@2edQP=<)( omdwew[YPcQcGE<O=O31(;);''	 +@D{z}x!   )	 )  ' "
 '#�;+".54>32'2>54.#"".54>32'2>54.#"".54>32'2>54.#"		�7((76))6$$$$c6))67((7$$$#u7((76))6$$$$��#�����'44''44''%&%&�'54''45'(&&%&('54''45'(&&%&T[����     5 �m  5@    
	+@    )   ' #�;+##5#5353m}>}}>8��8��    E =�   @  
	  
+K�)PX@%	  )     (   ' #@/	  )     )     &     '   $Y�;+75!##5#5353EC�>��>=99L9��9��    '�+6  0 �@ (&00	 	+K�PX@6"!!  '"  '  " ' #@:"!! "  ' "  '  " ' #Y�;+".54>3253#"&5'2>75.#"5W>"&C[4=g=%&e'5-#"1:*G31E
-Ka56bJ,?0f�};$:<<!-�1&$;L(*L9"  '�+  ) 	@	+".54>3253#'2>75.#"5W>"&C[4=g=D&e'5-#"1:*G31E
-Ka56bJ,?0f�"A:<<!-�1&$;L(*L9"   #  �� % ) G@&&  &)&)(' % %+@+ !  5    ' "   '#�;+7467>54.#"'>3253�),0*&16U/,7?!%F7!&1 9;�BN$2%!0!;+0!0H0(7(
!0$�kk   $�+�� % ) y@&&  &)&)(' % %+K�!PX@+ !  5   '"    ' #@) !  5   )    ' #Y�;+3267#".54>7>57#5@),0*&16U/,7?!%F7!&0 9;0BN$2%!0!;+0!0H0(7(
!0$�kk   >M ��   ,@    +@   '  #�;+53353><$;M    7�� � b   6@
 +@  7   &   '  $�;+26=3#726=3#7:u:\f4\f    7�� � b  ,@
 +@  7    &    '   $�;+26=3#7:\f    :"	�   )@
 +@   (#�;+".=33".=33�:�:"xo4xo    :" ��   @
 +@     ( #�;+".=33�:"xo   5"�   ,@
 +@8  '  #�;+2#54&#72#54&#5:�:�xo4xo     5" ��  #@
 +@ 8   '   #�;+2#54&#5:�xo    7\ s�  !@
    +@   '   #�;+537<\pp     I  M  1@

 +@ !    '" #�;+#3>3:MEfD@X3	�H?��	}7I  I  M�   :@
	+@&  !   "  '" #�;+'73#3>3:�-;H*EfD@X3	l]��H?��	}7I    I  M�   @@+@, 
!     7  '" #�;+7#'#3>3:rUU'c2bEfD@X3	�??VV�H?��	}7I     7�[M   �@
	 +K�PX@/!   -    (  '" #@0!   5    (  '" #Y�;+2=3##3>3:7:,#EfD@X3	�@@rH?��	}7I     3���  ' 7 @ j@"98 ?=8@9@765432*(''	 +@@1!5  		 )   )  ' "  '
   #�;+".54>32'2>54.#"32#'##72654&+�O�b77b�OO�b88b�OFzZ32YzHHyX22XyP�1$8.o:jv4�)*1&�7a�NM�`77`�MN�a7 0VyJFxX22XwFGxY2+)31M	����7)*5�    ��� 1 :@ ! 11+@$!  ' "   '   #�;+"&'732654.'.54>32.#"�=t*,[4?K';'-B+5G(<b!S-.# 1#2L3n
(&.$$3/	)'<'' (% .!HT   $��!� i �@ec`_^]YWNL:842 
	+K�PX@WPi76  !  ' "   '	"
  '	"   '  "   '   #@TPi76  !  ' "  ' "
  '	"   '  "   '   #Y�;+%#"&5#534.#".#"#"&'732>54.'.54>32.54>323#32>7!%.@II% +  N$0%*2"H9%#9H%Aq&Xa2( /6%C4"7D# C&?/4;vv%
13u68I+%3)(#
%#	3*):&, /G
%"2(*<&0#1&9U76��   ����  5 F@%#
55+@.  ! !   "  ' "  '#�;+'73"&'732654.'.54>32.#"�-;HZ=t*,[4?K';'-B+5G(<b!S-.# 1#2L3nl]�(&.$$3/	)'<'' (% .!HT    ����  8 I@(&!88+@1$#
!     7  ' "  '#�;+7#'"&'732654.'.54>32.#"�UU'c2b}=t*,[4?K';'-B+5G(<b!S-.# 1#2L3n�??VV�0(&.$$3/	)'<'' (% .!HT    ��$   + K@"! '&!+"+	   +@-!    )  ' "  '   #�;+".5467!.#"'>32'2>7!"9_E(�!3D%4Z;,:F&8`F'&E^9&C2�� 5D
+Ib7*G33*0"+Kc87aI*45G*+G4  ����  8 I@(&!88+@1  $#
!   "  ' "  '#�;+73'"&'732654.'.54>32.#"{b2c'UUW=t*,[4?K';'-B+5G(<b!S-.# 1#2L3n�UU??��(&.$$3/	)'<'' (% .!HT    1���� @ S T@OMED:90.)'	+@<,+Q F ! 5   )    (  ' #�;+%#".'732>54.'.5467.54>32.#"%>54.'.'�&;I" :2),HL1'&,^e!7I)@X5I#1%*-(H7!��1EI'/(�5#0D, *D*"MJ->&'?.9& *"'#9)1x-'	(%		%  :�� �   8@  	  +@  5   (   '   #�;+5326=3#O:O:�bb�M\f   .��G  ,@ +@  8     &    '     $�;+!5!#������N?�:       �  @+!5!#������M�?�:     -��1� ! 5 I O U f@UTSRQPFD<:20(&	+@JLMOJ ! 5   )   )   ' "   '    #�;+%#".54>7.54>324.#"32>'32>54.#"		#5!#1,;!#:*!.)44)- (5-!)* !** �$$$#�#�����A�3o+ +!)&%*4!
�			��T[�����,�q     K\�  #@ +@  8     '  #�;+#5!#�A�3�,�q     \�  !@ +@      ) #�;+#5!#�A�3c,�q     7��1� " 6 J@$#.,#6$6+@0!   )  ' "  '    #�;+%#".54>32.#">322>54.#"1'C\58^D%&E`;Fp,\8,H3kD3YB&�&C32D%&D33C�3YB&)LoEl�k4F>(3=*OtI;F%AX�2C&&C22C&&B3  7��1� " 6 	@,#+%#".54>32.#">322>54.#"1'C\58^D%&E`;Fp,\8,H3kD3YB&�&C32D%&D33C�3YB&)LoEl�k4F>(3=*OtI;F%AX�2C&&C22C&&B3   )��t�  0 H@(&00
+@.!   )   )  '    #�;+%#"&54632.#">322>54.#"t,="J\^N-I<%9FH("<+�,!!-,!!,�1&ZQwu%" RM$%1|###"  )Bt�  0 G@(&00
+@-!   )    (  ' #�;+#"&54632.#">322>54.#"t,="J\^N-I<%9FH("<+�,!!-,!!,�2&ZQwv%" SL#$1}"### ��  ��   V@
	 
+@6!    )	   )    '   "   '#�;+!!!!!!5!#���vT����)���L���>�>��>��V��    5���� C i@CB7520,*'%
 
+@K $:/9!.  	   )  ' "  ' "  ' #	�;+3.54>32.#"3#6323267#".#"'>54&'#5^1B&6a(M*+��.:%%$"!*67(();"0ut)*,$>.81**0 +)))62]=			4		2"92/     ��E�  w@+K�'PX@+  ! "  '"   '    #@+  ! 7  '"   '    #Y�;+%#".5#53533#3267E&(HHDxx$,

&u6��6��       $�  @ +3#53533#cLLF{{�>��>�"   ��F� # �@!+K�'PX@7#
  
!	
  ) "  '" 

  '    #@7#
  
! 7	
  )  '" 

  '    #Y�;+%#".=#535#53533#3#3267F&(HHHHDxxxx$,

&�.r6��6r.�   ��j�   �@
+K�'PX@5 !   " "  '"  ' #@8 !   5   "  '"  ' #Y�;+'73#".5#53533#3267-;H%&(HHDxx$,l]�?

&u6��6��     I�+3�  ) B@&$
	+@,! "  ' "   '   " #�;+#"&'#3>324.#"32>3(E\66XFFS=:[@"E0C(4*" 09)E26cK-6$�����)91Ob0)M;#",�."$:L    '�m�@ 2 Q@*(!	+@;$# !   )   )    &   '    $�;+%#"&'732654&+532654.#"'>32XBO!=U4Lr/VAKVZUMR'59W,,8D$.M8"1�bH-K5=6+,4IDEP:H9-3-*+/B(7+    2��� : @( +".'732>54.+532654.#"'>32/R>(*3G*&A0 <T4""bo-<!B^//;E$3V?$GD$:)(DZ	+=%&2'$3!4%;@@3$:+.+5H*=O!0<!-G2   .��>� - O c w } �@ trjh`^VTFD42 
 --+K�PX@dz{&M=
}x	!    )  
  ) 
 	
 )  ' "  ' " 		 ' #
@bz{&M=
}x	!   )    )  
  ) 
 	
 )  ' " 		 ' #	Y�;+"&'732654&+532654&#"'>32#".54>7.54>324.#"32>'32>54.#"		�?T".1CPE?H?+*;Q0!8*[07-:T,;!#:*!.)44)- (5-!)* !** �$$$#�S#����A0)' #')!!!'""(E9&)�+ +!)&%*4!
�			��T[����    $Aa� - �@  
 --+K�PX@4&!    (  ' "  ' #@2&!   )    (  ' #Y�;+"&'732654&+532654&#"'>32�?T".1CPE?H?+*;Q0!8*[07-:A0)' #')!!!'""(E9&)    ,��!� - 8 ; A �@".. :9.8.87654320/ 
 --+K�PX@c>?&; 1<
!A
    )	
  )  ' "  ' " 
  '


#
@a>?&; 1<
!A
   )    )	
  )  ' " 
  '


#	Y�;+"&'732654&+532654&#"'>325#5733#'35		�?T".1CPE?H?+*;Q0!8*[07-:���99���#����A0)' #')!!!'""(E9&)��g*��,g����T[����    ;���   	@
+##5#533#5#'#3)_0_�C0T(T0BV���0��ٯ���     3  �E + 6@   + +*)+@  !     )   '#�;+34>7>54.#"'>32!3%A3?6#!1 !5(-"7K/-G2'8;-<&^%GB=$,&	1  ,9 *=,	&(0>    3  � , @ +354>7>54.#"'>32!32H-"K=(&:'&?1$-%?X97S7-AJ7F)�BaI6):,3'$,(*!!8J)5K5"17>%>  %G^� ' 5@   ' '&%+@ !   (    '  #�;+4>7>54&#"'>323%0 0(33( )9%II -0 )	�G'9+	 +D1#, +   0��G� / U [ �@00 0U0UTSIG><" 
 //+@\XYCB		([V !  	 ) 		  )   )  ' "   '
   #�;+"&'732654&+532654.#"'>324>7>54&#"'>323		�?T".1CPE?H'*;Q0!8*[07-:�j. 0'13((8$HF,.>*��#����/*' #((!"
""(E9&(L'9+	 +D1#,="+��T[����  D��	  �@ 	 +K�PX@" !"  '   #K�!PX@) ! 5"   '   #@-! 5" "   '   #YY�;+"&5332>733#"&=�RTDy:1'D!#t
qp2�ڱ&4!H�O<H=C   D��	  @
+!5#".5332>73�r@3C&D0&:0%
Dr:B%=R-2��%@0'4H��   D���   �@	+K�PX@,  !   "" '#K�!PX@3  ! 5   ""  '#@7  ! 5   "" "  '#YY�;+'73"&5332>733#"&='-;H�RTDy:1'D!#tl]�qp2�ڱ&4!H�O<H=C   D���  + �@ )(&$ ++	 +K�PX@3 !  )	"" '
   #K�!PX@: ! 5  )	""  '
   #@>! 5  )	"" "  '
   #YY�;+"&5332>733#"&=2673#"&53�RTDy:1'D!#t!)$*8*"
qp2�ڱ&4!H�O<H=C�&%:+(  D���  " �@""+K�PX@/   !   ""'#K�!PX@6   ! 5   "" '#@:   ! 5   "" " '#YY�;+73'"&5332>733#"&=�b2c'UURTDy:1'D!#t�UU??��qp2�ڱ&4!H�O<H=C  D���   # �@"	  #	#  +K�PX@2!!
   '  "" '	#K�!PX@9!! 5
   '  ""  '	#@=!	! 5
   '  "" 		"  '#YY�;+53353"&5332>733#"&=�:[:�RTDy:1'D!#ty^^^^�}qp2�ڱ&4!H�O<H=C    D���   �@ 	 +K�PX@, ! "" '   #K�!PX@3 ! 5 ""  '   #@7! 5 "" "  '   #YY�;+"&5332>733#"&=3�RTDy:1'D!#tkG<,
qp2�ڱ&4!H�O<H=C�]     D���   # �@ #"	 	+K�PX@/!  !"" '   #K�!PX@6!  ! 5""  '   #@:! ! 5"" "  '   #YY�;+"&5332>733#"&='73'73�RTDy:1'D!#tN%9@*&9@
qp2�ڱ&4!H�O<H=Cv]n]     D���   �@ 	 
+K�PX@/ !	  ' ""  '   #K�!PX@6 ! 5	  ' ""   '   #@:! 5	  ' "" "   '   #YY�;+"&5332>733#"&=5!�RTDy:1'D!#t�!
qp2�ڱ&4!H�O<H=C�//   ���    *@
    +@     &     '   $�;+5!}>>>    B ��0  *@
    +@     &     '   $�;+75!B��??    #�P?� J `@HFB@=<,*%#		+@D('>  J !    )     (  ' "  '#�;+3254&#"7&'732654.'.54>32.#">32#"&'�09.,�p"'�QU`6Q58T9%C]8Fo-!e?_V1K39Z@""=T3	#)422~#	Qb9)9=>!-!*;+1M3+'8"*G= )-A0/E/."$     �P� K@IGCA>=-+&$		+K�	PX@H)(?  K ! 5  +     (  ' "  '#K�PX@H)(?  K ! 5  +     (  ' "  '#@I)(?  K ! 5   3     (  ' "  '#YY�;+3254&#"7.'732654.'.54>32.#">32#"&'�09.*9h&,[4?K';'-B+5G(<b!S-.# 1#2L3cU	#)422~#	N'#.$$3/	)'<'' (% .!DR*"$   �PS� " S@ 		+@7  " !    )     (  ' "#�;+3254&#"7##5!##>32#"&'�09./�@�
 	#)422~#	W�>>�x3"$  �PE� 1@/-)'	
+K�PX@G !%  1	 ! -   )   	 	 ( "  '#K�'PX@H !%  1	 ! 5   )   	 	 ( "  '#@H !%  1	 ! 7 5   )   	 	 (  '#YY�;+3254&#"7.5#53533#3267>32#"&'�09.,&5HHDxx$,3#	#)422~#	R1-u6��6��7."$   #�[?�  9 �@75%# +K�PX@39! 	!   -    (  ' "  ' #@49! 	!   5    (  ' "  ' #Y�;+2=3#.#"#"'732654.'.54>32:,#�e?_V1K39Z@"&D^7�v"'�QU`6Q58T9%C]8Fo-�@@�"*G= )-A01H0g9)9=>!-!*;+1M3+'     �[�  : �@
	*(#!	:
: +K�PX@4&%!   -    (  ' "  '#@5&%!   5    (  ' "  '#Y�;+2=3#7"&'732654.'.54>32.#"�:,#2=t*,[4?K';'-B+5G(<b!S-.# 1#2L3n�@@�(&.$$3/	)'<'' (% .!HT     �[S�   j@
	 +K�PX@$   -    (  ' " #@%   5    (  ' " #Y�;+2=3####5!:,#P�F�@�@@-�x�>     �[E�  $ �@"  
+K�PX@;$			!   -    ( "  '" 		 ' #K�'PX@<$			!   5    ( "  '" 		 ' #@<$			! 7   5    (  '" 		 ' #YY�;+2=3#7#".5#53533#3267�:,#�&(HHDxx$,�@@�

&u6��6��    I�, 	   �@ 
 +K�	PX@'	 !  " '" #K�PX@'	 !  " '" #K�!PX@.	 !   5  "  '" #@2	 !   5  " "  ' " #YYY�;+332>733#"&=#"&'#ID{91'D
 *4<1<A	�ڱ&4!H�O<H.#/&��    ����Q�  @+'4)���"�T     B � |f  @ +753B:�pp    D�Q	 % v@ 	 %%+K�PX@'# ! "  '   #@.# !  5"   '   #Y�;+"&5332>733.5467.=�RTDy:1'D-%4%&$'#t
qp2�ڱ&4!H�O<+%&'2H=C     D���   3 �@.,*)'&!33
+K�PX@91%+!   )
  '   "" '	#K�!PX@@1%+! 5   )
  '   ""  '	#@D1%+	! 5   )
  '   "" 		"  '#	YY�;+4632#"&7"32654&"&5332>733#"&=�*  **  *JHRTDy:1'D!#t�$$$$D�7qp2�ڱ&4!H�O<H=C  D���  ;\@" 7620-+'&" ;;	 +K�PX@; ! 

 ) 	 '		""  '   #K�PX@B ! 5 

 ) 	 '		""   '   #K�!PX@I ! 5 5 

 ) 	 '		""   '   #	@Q! 5 5 

 ) " 	 ' 		"" "   '   #YYY�;+"&5332>733#"&=".#"#4>3232>53�RTDy:1'D!#t0!*$*'
qp2�ڱ&4!H�O<H=C�       	  (@    +@ !  "#�;+333��G��B�	�6���    	  1@ +@
	 !  "#�;+3##37'373�B�9oo9�A�cY:DC:Xc	��
��	�=�Ԫ���      &	  @ +!#333(��G�H��B��F���^	�L��L���    �   =@
	+@%  !   ""#�;+'733##37'373�-;H�B�9oo9�A�cY:DC:Xcl]���
��	�=�Ԫ���     �   @@
	+@(  !   ""#�;+73'3##37'373b2c'UU�B�9oo9�A�cY:DC:Xc�UU??g��
��	�=�Ԫ���    �    Q@  
	  +@+!
   '  "	"#�;+533533##37'3730:[:�B�9oo9�A�cY:DC:Xcy^^^^p��
��	�=�Ԫ���     �   =@ +@% 
	 ! "  "#�;+3##37'3733�B�9oo9�A�cY:DC:Xc�G<,	��
��	�=�Ԫ����]    �	  .@    +@
 !  "#�;+?3#/#V�	�I��I�	�J��	��������    � 	  X@
+K�-PX@    !"    ' #@   !     (#Y�;+3267>733#"'g

�G��A��3.�!;2	�6��`%$  �+	 	 @ +	#>73��L**�G��	�"pa	�6�  � �   n@+K�-PX@*   ! ""    ' #@'   !     ( "#Y�;+3267>733#"''73g

�G��A��3.�-;H�!;2	�6��`%$I]  � �   t@+K�-PX@-   ! ""    ' #@*   !     ( "#Y�;+3267>733#"'73'g

�G��A��3.2b2c'UU�!;2	�6��`%$bUU??   � �    �@
+K�-PX@0   !	  '""    ' #@-   !     (	  '"#Y�;+3267>733#"'53353g

�G��A��3.F:[:�!;2	�6��`%$V^^^^      ��  P@
	 +@0 !    )  )
		" #�;+3#3##5#535'#5333�To!��F��pV�L��Mn060��040X��~   � �   n@+K�-PX@*   ! ""    ' #@'   !     ( "#Y�;+3267>733#"'3g

�G��A��3.QG<,�!;2	�6��`%$�]  � �  6;@21-+(&"!66+K�PX@9   ! 
 )  '	""    ' #K�!PX@@   ! 5 
 )  '	""    ' #K�-PX@D   ! 5 
 ) 		"  ' ""    ' #	@A   ! 5 
 )     ( 		"  ' "#YYY�;+3267>733#"'".#"#4>3232>53g

�G��A��3.�!*$*'�!;2	�6��`%$[       �	 	 6@
	+@$  !     ' "   ' #�;+7!5!!!`�����^�V.�3.�X3     ��   B@
+@.  	!   "   ' "   ' #�;+'73	!5!!!-;H��`�����^�Vl]�T�3.�X3    ��   E@
	+@1!     7   ' "   ' #�;+7#'!5!!!�UU'c2bf`�����^�V�??VV�h�3.�X3      �� 	  K@



	+@1  !  ' "     ' "   ' #�;+7!5!!!53`�����^�V�>.�3.�X3yaa  9��/U  ' *@
$"+@   )   '    #�;+#".54>324.#"32>/&C\66\C&&C\66\C&E0C()C00C)(C0%BoQ--QoBBoQ..QoB6X?##?X66X?""?X    3��}�  ' 	@"	 +.54>3232>54.#"XHnJ%)LlDImJ%)Ll��7S69S89S59S8
Dh~<@�g@Ej:A�f@g4jU69Xi/4jU6:Xh    &����  ' /@ $"	 +@   )   '   #�;+".54>32'32>54.#"�0H01G-/G01G�%6$%6$&6"%7$&;G"$H:$';G!%H9$�8-/78-.8     &F��  ' .@ $"	 +@    (  ' #�;+".54>32'32>54.#"�0H01G-/G01G�%6$%6$&6"%7$F&;G"$H:$';G!%H9$�8-.88-/7        B\��_<� �    �o�    �o{G�(� [�   	          ��  ��(�([               �               ��� � 1� �  +� J *� I =�  � 1� � 6�  � 7�  � 2� � � ,� ZB Q� ,V -J � ,� ,J *� - � ,� , � 2� Zk Q� Z� "e Z Qe Ze Ze Ze Ze Ze Ze Ze Z� Ze Z� "e Z# "I Z� Q� -� -l -� -� -� - � )� -� Z} Q� ,� Z � Z � Q� Z�  � V �  �  �  � Z �  ��� � # ���� � � Z0 Q� ZN Z� QN ZN Z � 1N ZN Z � BV n Z� Q Z� Q�  Z Z Z Z Z� -� -� -� -� -� -� -� -� -F +� -� -� -^ � -� -m Z Q� -� -� Z; Q� Z� Z� Zd # &d #d #d #f  � %f ^ Z� O� G� O� O� O� O� O� O� O� O� O� O� L  " �     w ) z & z z z z z p % #p p p $  j '  $  $  $  $  � "� "$  $  � 0$  o �$  $   ,� AC >: 2$  h I9  � R � 5 � - � T � - � Tc X& 'l '& '& '( (& '& '7 . � F � 7F 3o 'h '� +� /o 'o ' 2 Bi % � I ���K 'K 'K 'K 'K 'K 'K 'K 'T 3T 3� &� &� BK '� B: BC IM (� F[ )K ' � X � XY W � - � D ' &4 -l (y ! ��(x    7 � � h (h (h (h (h (' I� 5B ,B @e ,e @C IC C I� B � I � D � 	 ��� �  � � I ��� ��� �  ��� � I ��� I I I L � O @ L L9 L� "M O � I  FV P� BC IC IC��C IC IC IM &^ ,� "� "C I� (S 'S 'S 'S 'S ' (S 'S 'S '� .� )a 0 "e 1� $ "> .c 1� $U (� /� ,S 'S 'S 'g IW $ ,  � - � B. 1� 5� Eg 'g '� #� $ >B 7 � 7F : � :F 5 � 5 � 7_ I_ I_ I_ 7F 3� ( $� � K �   1 � :& .
  X -` ` ^ 7^ 7� )� )���� 5L 8 M L Z I 'L 2h .� $N ,� ; 3J 3� %r 0R DJ DR DR DR DR DR DR DR D�    : Bd #� f L d #� f L X ID�� � BR DR DR D / < / / / / �      �   � � � � g 9� 3� &� &     Ar 
�0  d  I��  `��  e��  ���  ���  ���  ���  ���  ��� 4�� k�� q�� r�� ��� ��� ��� ��� ��� ���  �    # i l  m  ���  I��  e��  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���      &  (  9�� E�� x�� |�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���  e��  k��  ���  ���  ���  ���  ���  ���  ���  ���  �   ���  ���  ���      &  (  9�� E�� x�� |�� ��� ��� �  ��� ��� ��� ��� % (�� % 5�� % D�� % I�� % `�� % e�� % x�� % ��� % ��� % ��� % ��� % ��� % ��� % ��� % ��� % ��� % ��� % ��� % ��� %	�� %�� %�� %&  %-�� %4  %9�� %a�� %c�� %o�� %r�� %x�� %��� %��� %��� %��� %��� %��� %��� %��� ) k�� ) ��� ) ��� ) ��� ) ��� ) ��� ) ��� )�� )�� )  )   )$  )&  )(  )9�� )E�� )x�� )|�� )��� )��� )��� )��� )��� )��� )��� )��� )��� 3#  7��� 8 �� 8 I� 8 e�� 8 k�� 8 x�� 8 ��� 8 ��� 8 ��� 8 �  8 ��� 8 ��� 8 ��� 8 ��� 8 ��� 8 ��� 8 ��� 8 ��� 8 ��� 8�� 8	�� 8�� 8�� 8�� 8�� 8�� 8 	 8  8   8!  8$ $ 8& . 8(  89�� 8E�� 8N�� 8a  8c�� 8x�� 8|�� 8��� 8��� 8��� 8��� 8��� 8�  8��� 8��� 8��� 8��� 8��� 8��� 8��� 8��� 8��� : ��� : ��� : ��� : ��� : ��� : ��� : ��� : ��� : ��� :& 
 :4  :r�� :��� :��� :��� :��� :��� :��� :��� :��� ; x�� ; ��� ; ��� ; ��� ; ��� ;   ;&  ;4  ;c�� ;o�� ;q�� ;r�� ;x�� ;�  ;��� ;��� ;��� ;��� ;��� ;��� ;��� ;��� ;��� ;��� D k�� D �  D�  D��� D��� D��� F ��� F ��� F ��� F ��� F ��� F   F&  FE�� Fx�� F|�� F��� F��� F��� F��� I I�� I e�� I x�� I ��� I ��� I ��� I ��� I ��� I�� I�� I  I   I&  I(  I,�� I-�� I9�� IE�� Ic�� Ix�� I|�� I��� I��� I��� I��� I��� I��� M �  Q#  U �� U I  U k�� U w�� U x 	 U y�� U ��� U ��� U ��� U �  U �  U �  U �  U �  U ��� U ��� U ��� U ��� U	 
 U�� U  U  U�� U  U  U   U!  U$ / U& # U(  UE�� U[�� U\�� Ua 
 Ul  Um  Uw�� U|�� U  U��� U��� U�  U�  U��� U��� U��� U��� U��� U��� U��� X �� X _�k X k�� X ��� X ��� X ��� X ��� X ��� X ��� X ��� X ��~ X ��� X ��� X ��� X ��� X ��� X ��� X�� X�� XE�� XY�� XZ�� Xi�� Xo�� Xq�� Xr�� Xw�� X|�� X��� X�  X��� X��� X��� X��� X��� X��� X��� X��� X��� [ ��� [ ��� [ ��� [ ��� [ ��� [ ��� [ ��� [Y�� [o�� [q�� [r�� [��� _	�� _,�� _N�� _O�� _��� _��� _��� _��� _��� _��� ` ��� e �� e (�� e 5�� e `�� e k�� e w�� e x  e y�� e ��� e ��� e ��� e ��� e ��� e ��� e ��� e ��� e ��� e ��� e ��� e ��� e ��� e �  e �  e ��� e ��� e ��� e ��� e ��� e	  e�� e�� e,�� e4�� eE�� eY�� eZ�� ea  ei�� el  em  eo�� eq�� er�� ew�� ex�� e|�� e��� e��� e��� e��� e��� e�  e��� e��� e��� e��� e��� e��� e��� k (�� k 5�� k D�� k I�� k `�� k e�� k x�� k ��� k ��� k ��� k ��� k ��� k ��� k ��� k ��� k ��� k ��� k ��� k ��� k ��� k	�� k�� k�� k&  k-�� k4  k9�� ka�� kc�� ko�� kq�� kr�� kx�� k��� k��� k��� k��� k��� k��� k��� k��� w ��� w ��� w ��� w ��� w �  w �  wa  w�  x I�� x e�� x k�� x x� x ��� x �  x �  x �  x �  x ��� x ��� x ��� x ��� x ��� x ��� x�� x�� x	�� x
�� x  x   x!  x$ ) x&  x9�� x?�� xE�� xN�� xx�� x��� x��� x��� x��� x��� x��� x��� x��� x��� x��� x��� x��� x��� x��� x��� y ��� y ��� y ��� y ��� y �  y �  ya  y�  { �� { I�� { e�� { x�� { ��� { ��� { ��� { ��� { ��� { ��� { ��� { ��� { ��� { ��� {�� {	�� {�� {�� {  {  	 {&  {(  {4  {E�� {a�� {c�� {x�� {|�� {��� {�  {�  {�  {�  {�  {�  {�  } I�� } e�� } x  } ��� } �  } �  } �  }	  }&  }4  }a  }l  }m  }��� }�  }���  (��  5��  D��  `��  e��  k��  x   ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ��� 	  �� �� �� �� &  ,�� -�� 9�� E�� a  q�� x�� |�� ��� ��� ��� ��� ��� ��� ��� ��� ��� � e�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� ��� �  �  �  
 �&  �(  �,�� �-�� �9�� �Y�� �x�� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� � �� � I�� � e�� � k�� � x�� � ��� � ��� � ��� � �  � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � �� ��� �	�� ��� ��� ��� ��� ��� � 
 �  �   �!  �$ / �& 5 �(  �9�� �?�� �E�� �N�� �a  �c�� �u�� �w�� �x�� �{�� �|�� �}�� ���� ���� ���� ���� ���� ���� ��  ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� �E�� � �� � I�� � e�� � k�� � w�� � x�� � y�� � ��� � �  � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� ��� ��� ��� �9�� �E�� �g�� �h�� �w�� �x�� �y�� ��� ���� ���� ���� ���� ���� ���� ���� ���� ���� � (�� � 5�� � I�� � e�� � x�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� �a�� �c�� �i�� �o�� �q�� �r�� ���� ���� ���� ���� ���� ���� � I�� � e�� � x�� � ��� � ��� � ��� � ��� � ��� �	�� ��� ��� �  �   �&  �(  �,�� �-�� �9�� �E�� �c�� �x�� �|�� ���� ���� ���� ���� ���� ���� � �� � (�� � 5�� � I�� � `�� � e�� � k�� � x�� � ��� � ��� � ��� � ��� � � 
 � ��� � ��� � �  � �  � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� �	�� ��� ��� ��� �  ��� ��� �  �  �   �!  �$ 4 �& - �(  �4�� �9�� �?�� �E�� �N�� �a  �c�� �o  �q  �u�� �w�� �x�� �|�� ���� ���� ���� ���� ���� ��  ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� � �� � (�� � 5�� � I�� � `�� � e�� � k�� � x�� � ��� � ��� � ��� � ��� � ��� � � 	 � ��� � ��� � �  � �  � �  � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� �	�� ��� ��� ��� �  ��� ��� �  �  �   �!  �$ 5 �& . �(  �4�� �9�� �?�� �E�� �N�� �a  �c�� �o  �q  �u�� �w�� �x�� �{�� �|�� ���� ���� ���� ���� ���� ��  ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� � �� � x�� � ��� � ��� � ��� � � 
 � ��� � �  � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� �	�� ��� ��� ��� �  ��� ��� �  �  �   �! 
 �$ . �& + �(  �9�� �?�� �E�� �N�� �a  �c�� �u�� �w�� �x�� �|�� ���� ���� ���� ��  ���� ���� ���� ���� ���� ���� ���� ���� � �� � k�� � w�� � x  � y�� � ��� � ��� � ��� � � 
 � �  � �  � �  � ��� � ��� � ��� � ��� � ��� �	  ��� ��� �  ��� ��� �  �  �   �!  �$ : �& + �(  �9�� �E�� �[�� �\�� �a  �o  �q  �w�� �|�� ���� ���� ��  ��  ���� ���� ���� ���� ���� ���� ���� � �� � (�� � 5�� � I�� � `�� � e�� � k�� � x�� � ��� � ��� � ��� � ��� � ��� � � 
 � ��� � ��� � �  � �  � �  � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� �	�� ��� ��� ��� �  ��� ��� �  �  �   �!  �$ 8 �& , �(  �9�� �?�� �E�� �I�� �N�� �a  �c�� �o  �q  �u�� �w�� �x�� �{�� �|�� �}�� ���� ���� ���� ���� ���� ��  ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� � k�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� ��� �  �  �   �$ # �& * �(  �9�� �E�� �w�� �x�� �|�� ���� ���� ���� ���� ���� ���� ���� ���� ���� � 5�� � F�� � k�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� �Y�� �Z�� �i�� �o�� �q�� �r�� ���� ���� ���� ���� ���� ���� ���� ���� � ��� � ��� ���� � ��� � ��� � ��� �Z�� �i�� �o�� �q�� �r�� ���� ���� ���� ���� ���� ���� ���� ���� � I  � e  � w  � y  � ��� � ��� � ��� � ��� � ��� � �  � ��� � �  �[  �\  �q�� �r�� �x  ��  ���� ���� ���� ��  ���� ���� ��  �# A � ��� � ��� � ��� ��� ��� �,�� �-�� �9�� �E�� �x�� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� � D  � I�� � e�� � k�� � �  � �  � �  � � 	 � � 
 � � 
 � ��� � ��� � ��� � ��� �  �  �   �!  �$  �& 2 �(  �E�� �x�� ���� ��  ��  ��  ��  ��  � e�� � ��� � ��� � ��� � ��� �q�� �r�� � 5�� � F�� � I�� � e�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� �4  �Y�� �Z�� �a�� �c�� �i�� �o�� �q�� �r�� �x�� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� � I  � e  � k�� � w  � y  � ��� � ��� � ��� � ��� � ��� � �  � ��� �q�� �r�� ���� ���� ���� �� 
 ���� ���� ���� ���� ��  ���� ���� ���� ���� � M  � R 
 �  �   �# ? �&  �( ? � �  � �  � �  �  �  �   �# 	 �$  �&  �( 	 ��  � e  � �  � �  � �  � �  �  �  �   �#  �$  �&  �(  ��  � 5�� � e�� � k�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� ��� ��� �E�� �i�� �o�� �q�� �r�� �x�� �|�� ���� ���� ���� ���� ���� ���� ���� ���� �#  � ��� � ��� � ��� � ��� � ��� � ��� �# 
 �( 
 � 5�� � k�� � ��� � ��� � ��� � ��� � ��� � ��� �&  ���� ���� ���� ���� ���� ���� ���� � ��� �  �   �&  �(  �   � �  � � / � � K � � ' � � I � � H � �  � �  � � " � � 	 � �  � �  � �  �   �  � ) � ) �, * �- ) �Y   �Z  �a H �i  �o < �q @ �r 1 �w  ��  ��  �� % �� K ��  � �  ��� �	�� �
�� �?�� �N�� ���� ���� ���� ���� ���� � 5�� � F�� � I�� � e�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� �4  �Z�� �a�� �i�� �o�� �q�� �r�� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� � e�� � ��� � ��� � ��� � ��� �e�� ���� �e�� �# % �	�� �N�� �O�� ���� ���� ���� � 5�� � F�� � I�� � e�� � x�� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� � ��� �&  �4  �a�� �o�� �q�� �r�� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� �   �& 
 � �� � I�� � e�� � x�� � ��� � �  � �   � �   � � ( � � % � �  � ��� � �  � �  � �  � � 	 � ��� � ��� ��� ��� � ! �  �  ) �!  �$ Q �& F �(  �4  �E�� �a  �c�� �o  �q  �|�� ���� ��  ���� �  �   �$ 8 �& $ �;  �   �$  �&     $  &  _�� e  ��� ��� ��� ��� �����6��e��� 	����	 _��	 e 	 ���	 ���	 ���	 � 	 ���	 ���	 � 	 ���	��	6��	e��	r��	���	� 
 ���
 ���
r�� k�� ��� ��� ��� ��� ��� ��� ��� ���# %# %# %# %# % 5�� F�� I�� e�� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���& Y��o��q��r��x����������������������������������� ��� ��� ��� ��� ��� (�� 5�� I�� `�� e�� ��� ��� ��� ��� ��� ��� ��� ���q��r��x�������������������������������� k�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���Z��i��o��q��r�������������������������� I�� e�� ��� ��� ��� ��� ��� ��� ��� ���	��N��O��x����������������������������������������������� k�� ��� ��� ��� ���   & (  �  � a o q �  �  �  �  � a o q �  �  �  �  �    , - Y Z a i o q r � �   �   �   �   �   �   �        , 	 -  Y 	 Z  a  i  o  q  r  �  � "#  ##  #(  $ � $ � ($ � $ � $a  $k $o $q $r $� ,%# )& � & � 6& � 
& � )& � '& � & & &, &- &Y 	&Z &a 1&i &k &o &q  &r &� &� &� 7'# Q( � ( � ( � ( � ( ( ( (#  (, (- (Y (Z (a (i (o (q (r (� (� ) k��) x ) ���) ���) ���) ���) ���) ���) ���) � ) � ) � ) � ) ���) ���) ���)��)��)E��)[��)\��)a )l )m )o��)q��)r��)x��)|��, ��, F��, _��, k��, x , ���, ���, ���, ���, ���, ���, ���, ���, ���, ���, ���, ���,��,��,E��,Y��,Z��,a ,o��,q��,r��,w��,|��,� ,���,���,���,���,���,���,���,���- ���- -  -& -( /  / � / � / � ,/ � / � +/ � +/ � / � / � / / / / /, /- /Y /Z /a 2/i /o /q "/r /{ /� /� /� /� -/� 0# T4 ���4 ���4Y��4x 4� 4���4���4���4� 4���4���4� 6	��6N��6O��6���6���6���6���6���9 k��9 ���9 ���9 ���9 ���9 ���9 ���9 ���9 ���9 ���9 ���9 ���9i��9o��9q��9r��9���9���9���9���9���9���9���9���? ���? ���? ���? ���? ���? ���?r��?���@ x��@ ���@a��@c��@���D	��E 5��E F��E I��E e��E ���E ���E ���E ���E ���E ���E ���E ���E ���E ���E ���E ���E4 EZ��Ea��Ei��Eo��Eq��Er��Ex��E���E���E���E���E���E���E���E���E���E���E���N _��N e N ���N ���N ���N ���N � N ���N ���N ���N ���N��N6��ND Ne��Nr��N���N� 	O _��O ���O ���O
��O��O6��OD Oe��Or��O���[ ���\ ���^4 ` I ` R 
` e ` k��` w ` y ` � ` � ` � ` � ` � ` ���` ���` ���`
��` ` `  `! `# `$ `& `( `E��`���`���`� `���`���`���`���`� `���`���`���`���c k��c ���c ���c ���c ���c ���c ���c ���co�ycq�|cr��c���c� c���c���c���c���c���c���c���c���e ���e ���e	��eN��eO��e���e���e���e���e���e���g k��g ���g ���g ���g ���g ���g ���g ���g ���g � g# ^gl gm g h# Qj (��j 5��j D��j F��j I��j `��j e��j k��j ���j ���j ���j ���j ���j ���j ���j ���j ���j ���j ���j ���j ���j��j��j# Yj%��j( Yj,��j-��j9��jE��jx��j���j���j���j���j���j���j���j���j���j���j���k ��k$ k& l ���l# 
l( 
m ���m# 
m( 
o I��o e��o k��o ���o ���o ���o ���o o  
o& o( oE��oc�ox��o���q ��q I��q e��q k��q x��q ���q ���q ���q ���q ���q��q q  q$ q& q( qE��qc�~qx��q���r ��r I��r e��r k��r x��r ���r ���r ���r ���r ���r��r	��r
��r��r r  r$ r& r( r?��rE��rc��rx��r���r���r���r���s ��s F��s I��s e��s x��s ���s ���s ���s ���s ���s ���s ���s ���s ���s ���s ���s ���s��s��s��s4 sE��sa��sc��sx��s|��s���ta u � u � u � u � u, uY ua uo uq u� x 5��x F��x e��x k��x ���x ���x ���x ���x ���x ���x ���x ���x ���x ���x ���x��xo��xq��x���x���x���x���x���x���x���x��� ���# ( � I��� _��� e��� x��� ���� ���� ���� � � �������	������6���c���e���� ����� _��� x��� � � � � � � ���� � � ����������
������6���D���a �c���e���� ������ �������� e��� ���� ���� ���� ������������
��� F��� k��� ���� ���� ���� ���� ���� ���� ���� ���� ���� ����������E���o���q���r���|����������������������������������� ��� x��� ���� ���� � � ���� ���� ������������� �  �& �( �E���c���q �r���x���|����������� � 
� � � � � � � � � � � � � � � � � �, �- �Y �Z �a �i �o �q �r �{ �� �� �� �� �� �4 � ���� ���� ���� � � ���� ���� ����r�������� �e��� ���� ���� ���� ���� ����� � _���
������6���e��� 5��� k��� ���� ���� ���� ���� ���� ���� ���� ���� ����o���q�����������������������������������# 
�# ~�# 3�# :� ��� 5��� I��� e��� x��� ���� ���� ���� ���� ���� ���� ���� ���� � � ���� ���� ���� ����������4���E���Z �a���c���x���|������� ��� 5��� I��� e��� k��� x��� ���� ���� ���� ���� ���� ���� ���� ���� ���� � � ���� ���� ���� ����������4���E���Z �a���c���x���|������� ��� x��� ���� ���� � � ���� ���� ����������4���E���Z �a���c���x���|��� k��� x � ���� ���� ���� ���� ���� ���� ���� � � ���� ���� ����������E���a �x���|��� ��� 5��� F��� I��� e��� x��� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ���� ����������4���E���a���c���x���|������� ��� x��� ���� ���� ���� ���� ���� ����������4���E���Z �a���c���x���|��� 5��� F��� k��� ���� ���� ���� ���� ���� ���� ���� ���� ����������E���|��� I��� e��� x��� ���� ���� ���� ���� ���� ���� ���� ����a���r����������� x��� ���� ����a���c���r������             \ v �B���$f���,J��P|�*~��<��r�	(	�	�	�

p
�
�^�R��2z�b$���p���2����<���<f��8b��Jn��j���l���.Lv���<��r����Z� ( J �!!�!�"t#H#�#�$B$�$�%%l%�&V&�&�'l'�(T(z(�(�) )N)�)�**f*�++\+�, ,d,�-�-�-�..>.f.�/8/�00H0f0�0�0�1$1j1�2J2|2�2�33^44P4�5h6F77�8�9t:8;;�<J<f=T>T>|>�??�AA�A�A�BFB�B�C*C^C�C�DVD�EE�F\F�G.G\G�H"H�IILI�JXK(KhK�LpL�L�M0M�N2N�O*O�P(P�QFQ�R@R�R�SpS�S�T2T�T�UPVNV|V�V�WpW�X�Y:Y�ZJZ�[�[�[�\^\�]]"]Z]�^R_F`&`�a�b`bxb�b�b�b�c$cvc�c�ddBd�d�d�eeze�e�f0f�f�g$gVg�g�hh.hnh�iiPihi�i�j@jPj�kkdk�l6l�m2m�nnfn�otp\p�q(q�r rhr�s�t,t�t�u:u`v(vdv�wRw�x
x�y"y�zzV{{�|�}0}�}�}�~x~��������B����$�P�������2�f����V��J�@���*����������Љ����؋B������������b�ҏ&�P�֑��ܒ6�x�̓���8�̕|����T���������ҙj�V���|���� ���H�\�l�������ʡ�&�n����Z�����h�֤N�����"�b����:�z�̨     � ~       $ / <   �I       z        �          �        �       = �        �       .       4       );       3d      	 3�      
�       "�              �       �       �  	  h�  	  5  	  C  	  zQ  	  �  	  \�  	  5  	  RC  	  f�  	 	 f�  	 
4a  	  D	�  	  ,	�  	  
  	  4%Copyright (c) 2010 - 2012, Matt McInerney (matt@pixelspread.com), Pablo Impallari(impallari@gmail.com), Rodrigo Fuenzalida (hello@rfuenzalida.com) with Reserved Font Name "Raleway"RalewayRegularMattMcInerney,PabloImpallari,RodrigoFuenzalida: Raleway: 2012RalewayVersion 2.001; ttfautohint (v0.8) -G 200 -r 50RalewayRaleway is a trademark of Matt McInerney.Matt McInerney, Pablo Impallari, Rodrigo FuenzalidaMatt McInerney, Pablo Impallari, Rodrigo FuenzalidaIt is a display face that features both old style and lining numerals, standard and discretionary ligatures, a pretty complete set of diacritics, as well as a stylistic alternate inspired by more geometric sans-serif typefaces than it's neo-grotesque inspired default character set.http://theleagueofmoveabletype.comhttp://pixelspread.comThis Font Software is licensed under the SIL Open Font License, Version 1.1. This license is available with a FAQ at: http://scripts.sil.org/OFLhttp://scripts.sil.org/OFLRaleway C o p y r i g h t   ( c )   2 0 1 0   -   2 0 1 2 ,   M a t t   M c I n e r n e y   ( m a t t @ p i x e l s p r e a d . c o m ) ,   P a b l o   I m p a l l a r i ( i m p a l l a r i @ g m a i l . c o m ) ,   R o d r i g o   F u e n z a l i d a   ( h e l l o @ r f u e n z a l i d a . c o m )   w i t h   R e s e r v e d   F o n t   N a m e   " R a l e w a y " R a l e w a y R e g u l a r M a t t M c I n e r n e y , P a b l o I m p a l l a r i , R o d r i g o F u e n z a l i d a :   R a l e w a y :   2 0 1 2 R a l e w a y V e r s i o n   2 . 0 0 1 ;   t t f a u t o h i n t   ( v 0 . 8 )   - G   2 0 0   - r   5 0 R a l e w a y R a l e w a y   i s   a   t r a d e m a r k   o f   M a t t   M c I n e r n e y . M a t t   M c I n e r n e y ,   P a b l o   I m p a l l a r i ,   R o d r i g o   F u e n z a l i d a M a t t   M c I n e r n e y ,   P a b l o   I m p a l l a r i ,   R o d r i g o   F u e n z a l i d a I t   i s   a   d i s p l a y   f a c e   t h a t   f e a t u r e s   b o t h   o l d   s t y l e   a n d   l i n i n g   n u m e r a l s ,   s t a n d a r d   a n d   d i s c r e t i o n a r y   l i g a t u r e s ,   a   p r e t t y   c o m p l e t e   s e t   o f   d i a c r i t i c s ,   a s   w e l l   a s   a   s t y l i s t i c   a l t e r n a t e   i n s p i r e d   b y   m o r e   g e o m e t r i c   s a n s - s e r i f   t y p e f a c e s   t h a n   i t ' s   n e o - g r o t e s q u e   i n s p i r e d   d e f a u l t   c h a r a c t e r   s e t . h t t p : / / t h e l e a g u e o f m o v e a b l e t y p e . c o m h t t p : / / p i x e l s p r e a d . c o m T h i s   F o n t   S o f t w a r e   i s   l i c e n s e d   u n d e r   t h e   S I L   O p e n   F o n t   L i c e n s e ,   V e r s i o n   1 . 1 .   T h i s   l i c e n s e   i s   a v a i l a b l e   w i t h   a   F A Q   a t :   h t t p : / / s c r i p t s . s i l . o r g / O F L h t t p : / / s c r i p t s . s i l . o r g / O F L        �� 2                    �     � � � � � b � � C � c � � � %	 &
 � � � d � � ' ( e � � � � ) * �  +!"# ,$% - �& � �' �()*+, .-. //012345 � 06 17 $89:; f 2< � �= � g �> �?@ � A � 3B 4C 5DEFG 6HI �J 7KLM � 8N �O � h �PQRST 9U :VWXYZ[ ;\ <] �^ �_` =ab �c Dde if k l �g jh 	ij nk A a  # m E ? _ ^ ` > @ � � Fl �  omn �   � Go � �pq � �  �r H pst r su q vwx �y � �z{   �|  � I}~�� ��� �� � ��� J ���� � ! � � � � K��  L t� v w u� M����� N�� O�����  � � P � � � Q����� ��� x  R y� { | � z�� �� � ��� ���� � � �� } S �     �  � T� " �  � � � � � � 
 U��� � V�� ��� �  ���� ��� � � W��� � �� � � � � �� X� ~� � � �� B���������������� Y Z����� [ \� �� � ��� ]� �� ���NULLAEacuteAbreveAmacronmacronAogonek
AringacuteB.scC.scA.scCcircumflex
CdotaccentD.scDcaronDcroatE.scEbreveEcaron
EdotaccentEmacronEngEogonekEtildeEuroF.scG.altG.scGcircumflexGcommaaccentcommaaccent
GdotaccentH.scHbarHcircumflexI.scIJIbreve
IdotaccentImacronIogonekItildeJ.scJcircumflexK.scKcommaaccentL.scLacuteLcaron	caron.altLcommaaccentLdotperiodcenteredM.scN.scNacuteNcaronNcommaaccent
NdotaccentO.scObreveOhungarumlautOmacronOogonekOslashacuteP.scQ.scR.scRacuteRcaronRcommaaccentS.scSacuteScircumflexT.scTbarTcaronU.scUbreveUhungarumlautUmacronUogonekUringUtildeV.scW.altW.scWacuteWcircumflex	WdieresisWgraveX.scY.scYcircumflexYgraveYtildeZ.scZacute
Zdotaccenta.alta.alt2abreveaeacuteamacronaogonek
apostrophe
aringacutec_tccircumflex
cdotaccentd.altdcarondcroatdotlessjebreveecaron
edotaccent
eight.lnumeightinferioreightsuperioremacronengeogoneketildef_ff_f_if_f_lf_if_l	five.lnumfiveeighthsfivesuperiorfiveinferior	four.lnumfourinferiorfoursuperiorgcircumflexgcommaaccent
gdotaccenthbarhcircumflexibreveijimacroniogonekitildej.altjcircumflexkcommaaccentkgreenlandicl.altlacutelcaronlcommaaccentldotnacutenapostrophencaronncommaaccent
ndotaccent	nine.lnumnineinferiorninesuperiorobreveohungarumlautomacronone.lnum	oneeighthtwoinferioroneinferioronethirdthreeinferioroogonekoslashacuteq.altracutercaronrcommaaccents_tsacuteschwascircumflex
seven.lnumseveneighthssevensuperiorseveninferiorsix.lnumsixinferiorsixsuperiort.alttbartcaron
three.lnumthreeeighthstwo.lnum	twothirdsu.altubreveuhungarumlautumacronuni00A0uni00ADuni015Euni015Funi0162uni0163uni0218uni0219uni021Auni021Buni03BCuni2215uni2219uogonekuringutildew.altwacutewcircumflex	wdieresiswgravey.altycircumflexygraveytildezacute
zdotaccent	zero.lnumzeroinferiorzerosuperior  ��              F < F F < <�  �	  �+�������+� , d� `f#� PXeY-�, d ��P�&Z�E[X!#!�X �PPX!�@Y �8PX!�8YY �
Ead�(PX!�
E �0PX!�0Y ��PX f ��a �
PX` � PX!�
` �6PX!�6``YYY� +YY#� PXeYY-�,�#B�#B� #B� C�CQX�C+�  C`B�eY-�,� C E �Ec�Eb`D-�,� C E � +#�%` E�#a d � PX!� �0PX� �@YY#� PXeY�%#aDD-�,�E�aD-�,�`  �	CJ� PX �	#BY�
CJ� RX �
#BY-�,� C�%B�  C`B�	%B�
%B�# �%PX� C�%B�� �#a�*!#�a �#a�*!� C�%B�%a�*!Y�	CG�
CG`��b �Ec�Eb`�  #D�C� >�C`B-�,� ETX  `�a� B�`�+"Y-�	,�+� ETX  `�a� B�`�+"Y-�
, `�` C#�`C�%�%QX# <�`#�e!!Y-�,�
+�
*-�,  G  �Ec�Eb`#a8# �UX G  �Ec�Eb`#a8!Y-�,� ETX ��*�0"Y-�,�+� ETX ��*�0"Y-�, 5�`-�, �Ec�Eb� +�Ec�Eb� +� �     D>#8�*-�, < G �Ec�Eb`� Ca8-�,.<-�, < G �Ec�Eb`� Ca�Cc8-�,� % . G� #B�%I��G#G#ab�#B�*-�,� �%�%G#G#a�+e�.#  <�8-�,� �%�% .G#G#a �#B�+ �`PX �@QX�  �&YBB# �C �#G#G#a#F`�C��b` � + ��a �C`d#�CadPX�Ca�C`Y�%��ba#  �&#Fa8#�CF�%�CG#G#a` �C��b`# � +#�C`� +�%a�%��b�&a �%`d#�%`dPX!#!Y#  �&#Fa8Y-�,�    �& .G#G#a#<8-�,�  �#B   F#G� +#a8-�,� �%�%G#G#a� TX. <#!�%�%G#G#a �%�%G#G#a�%�%I�%a�Ec#bc�Eb`#.#  <�8#!Y-�,�  �C .G#G#a `� `f��b#  <�8-�,# .F�%FRX <Y.�+-�,# .F�%FPX <Y.�+-�,# .F�%FRX <Y# .F�%FPX <Y.�+-�,�  G� #B� .�*-�,�  G� #B� .�*-� ,� �*-�!,�*-�&,�+# .F�%FRX <Y.�+-�),�+�  <�#B�8# .F�%FRX <Y.�+�C.�+-�',� �%�& .G#G#a�+# < .#8�+-�$,�%B� �%�% .G#G#a �#B�+ �`PX �@QX�  �&YBB# G�C��b` � + ��a �C`d#�CadPX�Ca�C`Y�%��ba�%Fa8# <#8!  F#G� +#a8!Y�+-�#,�#B�"+-�%,�+.�+-�(,�+!#  <�#B#8�+�C.�+-�",� E# . F�#a8�+-�*,�+.�+-�+,�+�+-�,,�+�+-�-,� �+�+-�.,�+.�+-�/,�+�+-�0,�+�+-�1,�+�+-�2,�+.�+-�3,�+�+-�4,�+�+-�5,�+�+-�6,�+.�+-�7,�+�+-�8,�+�+-�9,�+�+-�:,+-�;,� ETX�:*�0"Y-   K� �RX��Y�  c �#D �#p�E  �(`f �UX�%a�Ec#b�#D�
+�+�+Y�(ERD�+������ D   extends Node2D

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
               [gd_scene load_steps=3 format=2]

[ext_resource path="res://Ring.gd" type="Script" id=1]
[ext_resource path="res://Bead.tscn" type="PackedScene" id=2]

[node name="Ring" type="RigidBody2D"]

position = Vector2( 500, 500 )
input_pickable = false
collision_layer = 1
collision_mask = 1
mode = 0
mass = 1.0
friction = 1.0
bounce = 0.0
gravity_scale = 0.0
custom_integrator = false
continuous_cd = 0
contacts_reported = 0
contact_monitor = false
sleeping = false
can_sleep = true
linear_velocity = Vector2( 0, 0 )
linear_damp = -1.0
angular_velocity = 0.0
angular_damp = 5.0
script = ExtResource( 1 )
_sections_unfolded = [ "Angular", "Transform" ]
Bead = ExtResource( 2 )
MAX_ANGULAR_VELOCITY = 100.0
ORIGINAL_MAX_ANGULAR_VELOCITY = 175.0
NUM_START_BEADS = 24
MAX_BEADS_ON_RING = 68


  [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

radiance_size = 4
sky_top_color = Color( 0.0470588, 0.454902, 0.976471, 1 )
sky_horizon_color = Color( 0.556863, 0.823529, 0.909804, 1 )
sky_curve = 0.25
sky_energy = 1.0
ground_bottom_color = Color( 0.101961, 0.145098, 0.188235, 1 )
ground_horizon_color = Color( 0.482353, 0.788235, 0.952941, 1 )
ground_curve = 0.01
ground_energy = 1.0
sun_color = Color( 1, 1, 1, 1 )
sun_latitude = 35.0
sun_longitude = 0.0
sun_angle_min = 1.0
sun_angle_max = 100.0
sun_curve = 0.05
sun_energy = 16.0
texture_size = 2

[resource]

background_mode = 2
background_sky = SubResource( 1 )
background_sky_custom_fov = 0.0
background_color = Color( 0, 0, 0, 1 )
background_energy = 1.0
background_canvas_max_layer = 0
ambient_light_color = Color( 0, 0, 0, 1 )
ambient_light_energy = 1.0
ambient_light_sky_contribution = 1.0
fog_enabled = false
fog_color = Color( 0.5, 0.6, 0.7, 1 )
fog_sun_color = Color( 1, 0.9, 0.7, 1 )
fog_sun_amount = 0.0
fog_depth_enabled = true
fog_depth_begin = 10.0
fog_depth_curve = 1.0
fog_transmit_enabled = false
fog_transmit_curve = 1.0
fog_height_enabled = false
fog_height_min = 0.0
fog_height_max = 100.0
fog_height_curve = 1.0
tonemap_mode = 0
tonemap_exposure = 1.0
tonemap_white = 1.0
auto_exposure_enabled = false
auto_exposure_scale = 0.4
auto_exposure_min_luma = 0.05
auto_exposure_max_luma = 8.0
auto_exposure_speed = 0.5
ss_reflections_enabled = false
ss_reflections_max_steps = 64
ss_reflections_fade_in = 0.15
ss_reflections_fade_out = 2.0
ss_reflections_depth_tolerance = 0.2
ss_reflections_roughness = true
ssao_enabled = false
ssao_radius = 1.0
ssao_intensity = 1.0
ssao_radius2 = 0.0
ssao_intensity2 = 1.0
ssao_bias = 0.01
ssao_light_affect = 0.0
ssao_color = Color( 0, 0, 0, 1 )
ssao_quality = 0
ssao_blur = 3
ssao_edge_sharpness = 4.0
dof_blur_far_enabled = false
dof_blur_far_distance = 10.0
dof_blur_far_transition = 5.0
dof_blur_far_amount = 0.1
dof_blur_far_quality = 1
dof_blur_near_enabled = false
dof_blur_near_distance = 2.0
dof_blur_near_transition = 1.0
dof_blur_near_amount = 0.1
dof_blur_near_quality = 1
glow_enabled = false
glow_levels/1 = false
glow_levels/2 = false
glow_levels/3 = true
glow_levels/4 = false
glow_levels/5 = true
glow_levels/6 = false
glow_levels/7 = false
glow_intensity = 0.8
glow_strength = 1.0
glow_bloom = 0.0
glow_blend_mode = 2
glow_hdr_threshold = 1.0
glow_hdr_scale = 2.0
glow_bicubic_upscale = false
adjustment_enabled = false
adjustment_brightness = 1.0
adjustment_contrast = 1.0
adjustment_saturation = 1.0

            RSRC                     AudioStreamSample                                                                 
      resource_local_to_scene    resource_name    format 
   loop_mode    loop_begin 	   loop_end 	   mix_rate    stereo    data    script        
   local://1          AudioStreamSample       (             (              (              (              (   D�                      \O  B
b8�hp�V�?�=I~Q�OI�C:CE�EED�A@W?�>6>�<�;q:�9�8�7~6b5S4P3O2H1:0)/.-, +�)�(�'�&�%�$�#�"�!� ��zofa^VH;1' �����
�	��������� ������{�u�l�c�[�[�^�Y�M�?�5�/�(�!����
��������������������������ܵ۬ڦ٢؜ז֙ՠԟӕ҈�~�y�u�p�i�d�i�s�s�h�[�b�^�[�W�O�K�P�]�_�T�G�>�:�8�5�2�8�D�G�>�1�'�$�O�\6c��r^E|0�:"N�VzP�EP@�A�DFD�@�>J>9>�=w<�:�9�8�77�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$~#z"r!j b\VPNMJC:3-'"�
�	��������� ����������������������������������������������߯ުݢܜۙژٗؖכ֤թԥӞҗѕДϖΝ̭ͧ˩ʡɜȚǚƝťı÷´���������������ƹĸ����������ƲԱݰۯ�$�7�y��_X=5?�MSINFMA`A�C�DqC	A�>�=f=�<	<�:�9m8}7�6�5�4�3~2�1�0�/�.{-v,s+r*s)t(s'p&l%h$f#e"f!h igc_][[]`b`\YWW[`ca]jh
h	imrvvronp v�}������|�{�|�~�������������������������������������������������������� �
���	�
���)�D�H�F�D�E�K�Y�h�t�x�w�u�v�}�����������������öӵ������(���c1Sl�{)eGe8�<gHP O
IWCA�A$C7C�A�?>=�<�; ;�9�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$$#
"! $(+,.5=DIKLNS\dmrt
u	y�������� ������������������������%�2�?�G�K�M�P�X�d�q�~��������������������������%�6�F�Q�X�Z�^�g�vΉ͙̤˩ʮɴ���������������'�<�I�O�S�[�j�~���������ôӳ��������9�gZskbdJ�<Q=�EvL�M�IE�A=A�A-B�A+@�>.=<<�;�:�9�8�7�6�5�4�3�2�1�0�/�.	.-,#+(*/)8(B'L&W%^$d#k"t!� �����������#-4<HTbnw
~	��������� �����!�/�>�N�]�g�o�x�����������������	���(�7�H�[�k�w���������������,�=�K�W�f�wՋԝӬҹ����������'�9�M�c�wǆƓţķ���������
��1�H�^�n�{�������ε����-�h���b�6}`$oTd�O�@y=LB�H�K�JG�C�AAAAf@4?�=�<�;�:�99&8#7"6)594L3^2l1x0�/�.�-�,�+�*�)�(�'�&&%)$9#G"T!c r���������,=M^l|�����
�	�%6FXi{�� �����������"�5�G�[�l�}��������������.�B�U�h�{����������� �7�K�^�sމݟܶ�������
� �8�O�g�}ӓҪ��������(�A�X�lʄɛȳ��������(�@�Z�s�������ؼ���8�Q�l�������ͳ������B��8m[iWbpR�Dz?FA�EzI�I�G�D?B�@�@Z@�?"? >�<�;�:�99/8C7M6f5s4�3�2�1�0�/�. .-&,;+N*c)v(�'�&�%�$�#�""!1 E[o������3I_u������/F
]	t�����3K d�|�����������8�Q�j�������������9�T�o���������%�@�\�y���������:�U�rܐۭ��������7�S�oԌӪ�������=�]�{̘˶������/�M�lōĬ������0�O�n�����˻��-�K�k�����ʹ��1�����S��Z4ySLc�aPV�I9B�@pC�FjH�G�E}C�Ao@�?~?�>0>0=<;:79`8�7�6�5�4�3�2231N0j/�.�-�,�+�**0)J(e'�&�%�$�#�"	"$!? [v����=Yt����"@^z����

-	Jj����"@_ �����������?�^�|����������=�`��������3�R�r��������@�d��������/�P�sޘݼ�����!�G�k؍װ����� �B�fҌѱ������A�g̊˭������B�gƐŸ����&�N�t�������4�f�������,�Q�{���ȳ��n�����^Q7�Q�_l_eV�K,D�A�B�D�F
G�ED B�@�??�>�=(=:<<;B:V9v8�7�6�55.4J3i2�1�0�/�..1-Q,r+�*�)�(�''=&_%�$�#�"�!!; ]����1Sv���(Mr���(Kp��
�		+Pv���4Z� �������B�i��������-�R�y��������@�j������B�i������4�_������3�\������*�S�ۭ��� �.�[ׅ֭����0�Z҄Ѳ����6�d͒̽����F�qȜ�����#�N�zé����3�c�������M�z�����@�m���ʴ��,�ڳ����.{H�Y~^�Y�PTHJC�A�B�D�E�E�DAC�AH@I?�>�=P=�<�;�:�99%8N7z6�5�4�3"3H2o1�0�/�..9-a,�+�*�))-(W'�&�%�$�#4#^"�!� �0[���1[���3_���9e���B
n	���"P~��5b �������H�w������3�c��������M�|�����;�x����	�:�k������/�_������$�W����� �Sޅݵ����M�~ٲ����I�}ղ����J�Ѳ����N΂ʹ����Rʅɻ���$�XƎ�����,�b����=�s�����[���Ź��4�h���ٵ�D�{�R��̉��?'�?�R�[$[�T�L`F�B"B�B(D�D�D�C�B5A�?�>$>v=�<<W;�:�9�8�77M6~5�4�33C2q1�0�/ /0.a-�,�+�*#*S)�(�'�&#&V%�$�#�""M!� ��Fx��Cv��Cv��Cw��H}��

N	���!W���,b� ���=�r������L�������'�_������H�����&�_�����@�x����$�]�����A�{����&�a�����Iރݾ���4�oک����Zז����EԂӽ���6�qЭ���'�d͠����Tʒ����Kǉ����@ċ����E�������>�}�����9�v�����6�u�����2�r�óϻ/�/��jb#�9LMJX�Z�V�O_I�D�BDB�B�CD�CC�A�@�?�>�==X<�;�:+:_9�8�7�6&6^5�4�3
3B2y1�0�/-/e.�-�,,F+~*�)�(+(c'�&�%%I$�#�"�!0!j ��R��=x��+e��S��D���6r��
(
f	��[��Q��J �����Q������M������J�����	�H����
�I�����K�����N�����W�����\����!�d����,�m߰���7�yܼ���Cڇ����Sח����bԦ���/�rѸ�	�Nϔ����f̬���5�y����KǑ����dĪ���:����W����*�r��� �G���ٸ!�j�����E�����gű߸��	�;"q7�IOUY�V�Q�K�F�CqBRB�B%C:C�B#B.A:@6?E>o=�<�;J;�:�9#9b8�7�66S5�4�33W2�1�00Y/�.�--\,�+�**`)�(�'$'g&�%�$.$o#�"�!7!y � B��O��^��)n��;~�Y��&l��<�
�		S��&l��@��] ����4�z���
�Q�����)�r����K�����%�n����I����%�o���L����*�t��
�T����5�����l���N�����2�}����bۯ���Hٖ���1�~����hԵ��PҞ���9Ї���#�qͿ��\˪���Hɗ���5Ǆ���"�r����a±� �P����D����7���ں-�}�θ �q�¶�p���@�0���q���A/�AJOV�V�S�NJ5F�C�B4BQB{BuB%B�A�@�?�>>I=�<�;!;s:�99]8�7�636y5�4	4Q3�2�1/1x0�//V.�-�,3,}+�**\)�(�'<'�&�%'%s$�#
#V"�!� 8 ��g�L��3��f�M��7�� o�Z��F�
�	3	�� o�_��N�� ? ����2�����$�u����s����h����^����S����K����E����=����8����4����/����*����(�}���&�{���%�{���'�|���'�}���)ـ���.ׄ���1Ո���7ӎ���<ѓ���LϤ���Uͭ��]˶��h����q���$�}���0ĉ���;���I�����X����e����w�ѹ,����?�����Q��?�;�8���
�V!�32DBO�T>U�R�N�J�F}DCOBBB�A�ATA�@@I?|>�=�<4<�;�:,:�9�8-8�7�6#6u5�44i3�22a1�00[/�..S-�,�+M+�*�)H)�(�'D'�&�%A%�$�#@#�"�!>!� �>��?��@��C��F��V�[�	`�g�n�w�
(
�	�3��=��I��W�
d ���s���'�����8�����H��� �\����n���'����;����P��	�f���)����@����[���s���0����J���f���"����Aߠ���^ݾ��~���>ڝ���^ؿ�����@ա��d���%҇���KЭ��o���4͖���Z˼�ʂ���Gȩ��o���Ať�	�l���3���_�¿&����T�������K����}��G����.�F�i�w���\	sB�0@&KuQ�S�R�OEL�H?FHDCOB�A�A|A1A�@C@�?�>E>�=�<(<|;�:1:�9�8S8�77k6�5"5}4�353�2�1J1�00`/�..v-�,1,�+�*J*�))c(�''}&�%:%�$�#T#�""q!� 0 ��M�l�-��L�m�0��Q�t�8�g�+��P�x
�	>	�f�-��X���I�  w���A���
�n���8����i���4�����e���0�����c���0����d���1����f���6���v���E���|���M������Z���-����h���;ߤ��x���Lܶ� ۋ���`���5؟��v���Lշ�"Ԏ���f���>ѩ�Ђ���[���4͠��y���S���/ɜ��x���R���7ť�Ă���^���:��������g�׽E���"����q��P���0�����������Ҫ��5��-5'�6�B�KP�Q�PpN�KI�F�D�C�BB�AMA�@�@"@�??s>�=/=�<�;G;�::{9�8H8�77|6�5I5�44{3�2H2�11|0�/J/�..�-�,O,�++�*�)W)�('(�'�&a&�%2%�$$l#�">"�!!y �L���^�2�q�G���_�?���Z�2�w�P�)�p
�	K	�%�o�J�&�q�N� , ���z���Y���7��������h���H���)����|���^���@��"���~���b���E��(������d���I��/������m���T���=��%������l���U���?ݴ�(ܝ�ۇ���q���\���G׾�4֪�!՗�ԅ���r���a���N���<ϴ�*Ϊ�!͘�̉� �y���j���[���L���?Ƹ�1ũ�"ě�Î����u��i��^�ٽS�ͼH�»=���4���*��� ��������s�\߮���� B�Q8)�6�A'I�M?OO�M�K�I�GF�D�C�BB�AA�@H@�?\?�>P>�=1=�<	<u;�:O:�9-9�88~7�6`6�5B5�4$4�33w2�1[1�0=0�/ /�..w-�,\,�+@+�*%*�))~(�'e'�&K&�%2%�$$�##}"�!f!� N �8�!���i�T�@�,��y�f�R�@�/����r�b�Q�
A
�	3	�#��~�r�e�W�K� G ��<���1���&��������������x���o���g���_���W���O���H���A��;��5��/��)���$�� ��������������
��	���������ߎ�ޏ�ݏ�ܐ�ۑ�ړ�ٕ�ؘ�ך�֝�ա�#ԥ�&Ө�,Ү�1ѳ�6и�;Ͼ�A���H���N���U���^���e���m���v���~�ƈ�Œ�ě� å�*±�6���I�οT�ھ`��l��x�����������(���6�������ʏ�����^���^&�2�<jDPIL�L�L�KSJ�HHG�E�D�C�BIB�A4A�@G@�?_?�>j>�=i=�<a<�;T;�:H:�9E9�8;8�737�6+6�5"5�44�33�22�11�00}/�.w.�-r-�,m,�+i+�*e*�)a)�(^(�'['�&X&�%V%�$S$�#Q#�"P"�!O!� O �N�O�O�P�R�S�V�`�c�f�i�m�q�u�z�������#�
+
�	3	�;�C�L�V�`�i�s�~�  �����'���4���A���N���d���r�����������%���5���E���U���f���v�������!��3��E���X���j���}�����1��E���[���p������(��@���W���n��߆�ߝ�)޶�A���b���z�۔�!ڮ�;���T���o��֋�֦�5���Q���m��ҋ�ҧ�7���S���q� ϐ�ί�>���^���|�˜�-ʽ�M���n��ǐ� ǲ�B���d��Ć�Ĩ�:���^��������=�Ͽb��������?�Ѽe��������D�عk�����9�<��Å�}�x����� �;�>+95$=�B�F=IWJ�JJQITHGG>FGEfD�C�BLB�A8A�@C@�?[?�>s>�=�==�<!<�;7;�:E:�9R9�8a8�7o7�6}66�55�4%4�363�2F2�1X1�0i0�/z//�..�-(-�,<,�+O+�*c*�)w))�((�'+'�&@&�%V%�$l$�#�##�"$"�!;!� R �k���/�H�b�{	�"�=�Y�s��9�V�r��<�Z�x�&�F�f�
�

�	6	�W�w	�+�L�o �#�F�q� & ��L���q����(���N���t����.���T���{����7���_��������C���l���*��T������?���j����,���X������F���t���8���m���3���b����(���X������O�������J���|�ޯ�G���z�ܭ�E���y�ڭ�F���z�د�I���~�ֳ�N��Ԅ�Ժ�U��Ҍ�'���^��Ж�2���i�ϡ�>���|�Ͷ�R��ˌ�(���b��ɜ�:���t�Ȱ�M��Ɗ�'���c�Š�>���z�ù�X�����4���r����O�ﾏ�/�νn����N��.�κo����P���Ǻt�������y��������_��<$�-e5�;G@�C�E-G�G�G�GVG�F!FwE�D)D�C�BoB�AmA�@�@@�?1?�>W>�=~==�<:<�;a;�:�::�9C9�8k8�7�7&7�6N6�5w55�454�3^3�2�22�1M1�0w00�/8/�.d.�-�-%-�,Q,�+~++�*A*�)n))�(4(�'a'�&�&'&�%W%�$�$$�#M#�"}""�!E!� v  �A�r�>�p
�=�p
�>�r�G�|�L���S��%�\��0�h�<�t�J�� �
Z
�	�	2	�m�E���[��6�s�N��,� j 	 ��H�����-���l����L�����,���l����N�����1���r����U�����:���}����c���H����/���t���]����E����.���t���`���K����7���~�"���q���`���N����>����-���w����i���\���M��ޚ�A��ݎ�4��܂�(���w����m�ڻ�c�ٲ�Z�ت�R��֢�J��՛�C��ԕ�=��ӏ�8��҉�3��х�4��Ј�1��υ�/��΃�-��̀�*����)���~�(���~�(���~�)��Ȁ�-��Ǆ�0��ƈ�4��ō�9��Ē�?��Ø�E���K�����P�����W����_����f����n��ɼw�*�ٻ��6�亓�A���u��-̓ԕ���	�?�y�	���[���!{)>0�5N:�=s@bB�C�D'EgEqETEE�DuDD�CBC�BmBB�A3A�@g@@�?=?�>y>>�=X=�<�<7<�;w;;�:`::�9B9�8�8%8�7g7	7�6K6�5�505�4s44�3Z3�2�2@2�1�1&1�0l00�/T/�.�.>.�-�-'-�,o,,�+Z+�*�*E*�)�)2)�(z((�'h''�&W&�%�%E%�$�$5$�#�#+#�"u""�!g!!� Y   �K��?��3��'�v�l�c
�Z�Q��J��C��=��7��3��/��,�~(�|&��+��)�~)�
~
)
�	�	,	��.��0��4��7��;��A��G��M� � T  ��^����f����n����x�&�����1�����=�����H�����[�	���h����u�$�����4�����C����S���d����u�&�����8����K����_����s�$����:����O���f����|�/����G����`����x�,����J����e�����4����P���m�!�����?��ߨ�]����|�1��ݛ�P�ݼ�q�&��ے�G��ڳ�i���ٌ�B��د�e���׉�?��֭�d���Չ�@��԰�g���ӎ�E��ҹ�q�(��љ�Q�
���z�3��ϣ�]���·�@��Ͳ�k�$��̗�P�
���}�7��ʪ�d���ɓ�L����{�7��Ǭ�f�!��Ɨ�Q���Ń�>��ĵ�p�,��ã�_����N�
�����C�����w�4�񿮿j�&�侠�^��ؽ��Q��̼��G��»��>���к��:�O��͘��ڔ���������� SX�`#2)5.w2	6�8i;_=�>+@A�A^B�B�BC#CCC�B�B�BMBB�A�A?A�@�@\@@�?o??�>}>->�=�=9=�<�<E<�;�;P; ;�:^::�9j99�8x8'8�7�767�6�6D6�5�5T55�4e44�3u3%3�2�282�1�1I1�0�0]00�/p/!/�.�.;.�-�-O--�,f,,�+{+.+�*�*E*�)�)]))�(u(((�'�'A'�&�&[&&�%u%(%�$�$D$�#�#`##�"|"1"�!�!M!!� l   ��?��_�~4��T�z1��R	�u,��O�s+��O�t,��R
�y1��Y��:��c��E��p(��T��:��f �
�
M

�	�	:	��i#��S��>��o+��]��K�~:��n+� � _  ����Q������E����{�9�����p�.�����g�$�����^������U������R������L������G������C�����@����~�?����~�>����}�>����~�?������A�����D�����H�
����M�����T�����\�����c�)����p�3����z�=������H�����T�����b�%����p�5�����D�	����U�����g�,��ߵ�y�>���ލ�R���ݡ�g�,��ܷ�|�B���ۓ�Z���ڬ�q�;���َ�T���ا�n�5����׊�P���֥�m�4����Պ�Q���Ԩ�p�8����Ӑ�X� ��ұ�x�A�
��њ�c�,��нІ�N���ϩ�r�<���Η�a�*��ͽ͇�P���̮�x�E���ˣ�n�8���ʘ�b�-����ɍ�X�"��ȹȄ�N���Ǳ�{�G���Ʃ�u�A���Ť�p�<�	��Ġ�m�9���Þ�k�8����j�7������k�9������n�;�	�׿��q�B��޾��y�H��佲���N��뼺���W�%����'��Ŧʱϔ�0�q�R���������r����{��=,�#�'+2.�0Y3u5M7�8L:�;�<l=.>�>Z?�?(@s@�@�@�@AAAAA�@�@�@�@r@J@@�?�?�?Z?#?�>�>z>?>>�=�=N==�<�<T<<�;�;W;;�:�:V::�9�9S99�8�8P88�7�7N77�6�6M66�5�5K55�4�4K44�3�3L33�2�2Q22�1�1S11�0�0W00�/�/[//�.�.`.!.�-�-f-'-�,�,m,/,�+�+u+7+�*�*}*@**�)�)J))�(�(V((�'�'b'$'�&�&n&2&�%�%|%@%%�$�$O$$�#�#c#'#�"�"t"8"�!�!�!J!!� � ^ " ��q7���L��b'��y?��X��p7���Q��l4���O��m5���S��v>��_&���H��k4���X ��|E��k5���\%���M��vA�
�
k
5
 
�	�	a	,	���X#���S���M��}I��yE��wD��vC��vC� � x E  ����|�J��������O��������U�#�������]�,�������f�5������t�C��������O��������]�-�������k�;������{�K��������]�.�������p�A������U�&������k�=������T�%������m�?������Z�,������w�J�������g�:������Y�,������y�L�������n�B������e�9������^�2������Y�-������T�)������}�R�(������}�R�(� �����X�.������[�1������a�7�������h�?�����ߚ�q�H�����ޤ�{�S�*���ݱ݉�a�8���ܿܗ�o�G�����ۧ��X�1�	��ںڒ�k�C�����٨ق�[�4���ؿؘ�q�J�#����װ׉�c�<�����֣�}�W�1���տՙ�s�M�'���Էԑ�l�F�!����ӱӌ�g�B�����Ү҉�d�?�����ѭш�d�?�����ЮЊ�h�D�����ϴϐ�l�H�$���κΖ�s�O�,�	����͞�{�Y�6�����̩̇�d�A�����˷˔�q�O�-�����ʣʂ�`�>�����ɶɔ�r�P�/�����ȨȈ�f�D�#�����Ǡ��_�=�����ƺƙ�x�X�7�����ŵŕ�t�T�4�����Ĵē�s�S�4�����õÕ�u�U�6�����¸�y�[�;������������b�C�$����������m�N�0���׿����|�_�@�"���Ⱦ����o�Q�4������3�%�o���>΍ѷԷ׋�1ݪ���p�������z ~	�}x��;!�#&>(?*,�-i/�0<2|3�4�5�6�7j8-9�9r:;�;<|<�<==�=�=>S>�>�>�>�>?'?8?E?M?Q?S?P?K?C?9?,??
?�>�>�>�>�>z>]>>>>�=�=�=�=r=L='==�<�<�<b<9<<�;�;�;f;;;;�:�:�:a:5::�9�9�9X9+9�8�8�8v8H88�7�7�7e777
7�6�6�6S6%6�5�5�5o5A55�4�4�4^4044�3�3z3M3 3�2�2�2k2>22�1�1�1]1011�0�0|0P0#0�/�/�/q/E//�.�.�.j.>..�-�-�-b-6--�,�,�,\,0,,�+�+�+W+,++�*�*~*S*(*�)�)�)|)Q)')�(�(�(|(R('(�'�'�'~'S')' '�&�&�&X&.&&�%�%�%]%3%	%�$�$�$c$:$$�#�#�#n#E##�"�"�"x"O"&"�!�!�!�!\!3!!� � � i A  ���xP(���b:���tM%����b;���xQ+���jC����`:���{V0
���sM(���mH"����iD����gB����gC����jF!����nJ&���wS1����]:����hE" ���uR0����b@����tQ0�
�
�
�
f
D
"

�	�	�	{	[	:		����sT4����oN.����kK+����jJ+����lL-����pQ2����wY9�����bC$� � � � p R 4  ����������b�D�&�	���������t�W�9������������k�M�1������������e�H�,�����������c�F�)�����������c�G�*������������g�L�1������������o�S�8�����������x�^�B�'������������k�P�5������������{�a�F�,�����������t�[�@�&���������q�X�>�$���������s�[�A�'����������x�_�F�.�����������g�N�6����������s�\�C�*�����������k�S�<�$�����������~�g�P�9�!�
����������i�R�;�$�����������n�X�A�*�����������w�a�J�5��	����������n�Y�C�.������������k�U�@�*�������������l�W�B�-������������s�_�J�6�!�����������~�k�W�B�/������������{�g�S�@�-������������|�i�W�C�0��
�����������q�_�K�9�'�������������m�[�H�6�#����������������n�]�J�9�&��������߼ߪߙ߈�v�d�R�A�0����������޷ޥޕބ�r�b�P�?�/����������ݺݩݘ݈�w�g�W�E�5�$����������ܳܢܒ܂�r�b�Q�B�2�!����������۳ۣ۔ۄ�t�e�U�E�6�&����������ڻڭڝڎ�~�o�a�Q�B�4�$����������ٽٯ٠ّك�t�f�W�H�:�,��� ��������عت؜؏؀�r�d�W�H�:�-�����������׾ױעו׈�z�l�_�Q�D�7�)�����������ֲֿ֥֘֋�~�q�e�X�K�>�2�$������������տճզՙՍՀ�t�h�\�O�C�7�*�������������ԾԲԥԚԎԂ�v�j�_�R�G�<�0�$�������������ӽӲӦӛӐӅ�y�n�d�Y�M�B�7�-�!��� ����������ҿҵҩҟҕҊ��u�j�`�U�K�@�6�,�!���������������ѻѱѦќѓщ�~�t�k�a�X�M�C�:�0�&���
��������������оеЪСИЏІ�|�s�j�a�X�N�E�<�4�*�!�������������������ϷϯϦϝϕότ�{�r�j�b�Z�Q�H�@�8�0�'��������������������ξζίΧΟΗΐΈ��x�p�i�a�Z�R�J�C�;�4�-�$����������������������Ϳ͸ͱ͕͎͇ͩ͛͢��y�r�k�e�^�W�P�I�C�<�6�/�(�!����� ��������������������̶̼̰̩̣̝̗̑̋̅�~�y�s�m�g�b�\�U�P�J�D�?�9�4�.�(�"������������������������������˼˷˲˭˧ˢ˝˘˓ˎˉ˅��z�v�q�l�g�c�^�Y�T�O�K�F�B�=�9�4�0�*�&�"���������������������������������������ʼʹʵʱʭʨʤʡʝʙʖʒʎʋʇʃ��{�x�t�q�n�j�g�c�`�]�Y�U�R�N�K�H�E�A�>�;�8�5�2�/�,�(�%�!��������
�����������������������������������������������������ɾɼɺɸɵɳɱɯɭɪɨɦɤɡɟɝɛɚɘɖɔɒɐɎɌɋɉɇɅɄɂ��}�|�z�x�w�u�t�r�q�o�n�l�k�i�h�f�e�d�b�a�`�^�]�\�[�Y�X�W�U�T�S�Q�P�O�N�M�L�K�J�I�H�G�G�F�E�D�C�B�A�A�@�?�>�>�=�<�<�;�:�:�9�8�8�7�7�6�6�5�5�4�4�4�3�3�3�2�2�2�1�1�1�1�0�0�0�0�0�/�/�/�/�/�/�/�/�/�/�/�/�/�/�/�0�0�0�0�0�0�1�1�1�1�2�2�2�3�3�3�4�4�4�5�5�6�6�7�7�8�8�9�9�:�;�;�<�=�=�>�?�?�@�A�B�B�C�D�E�F�G�H�H�I�J�K�L�M�N�O�P�Q�R�S�T�W�X�Y�Z�[�\�]�_�`�a�b�d�e�f�h�i�j�l�m�o�p�q�s�t�v�w�y�z�|�}�ɂɃɅɆɈɊɋɍɏɐɒɔɖɘəɛɝɟɡɢɤɦɨɪɭɯɱɳɵɷɹɻɽɿ������������������������������������������������������� ���	��������� �#�%�(�,�.�1�4�7�9�<�?�B�E�G�J�M�P�S�W�Z�]�`�c�f�h�l�o�r�u�x�{�~ʂʅʈʋʎʒʕʘʛʞʢʥʨʬʰʳʶʺʽ������������������������������������� ���������"�&�)�.�2�6�9�=�A�D�H�L�P�T�Y�]�a�d�h�l�p�t�x�|ˀ˅ˉˍˑ˕˙˞ˢ˦˪˯˳˷˼��������������������������������������!�%�*�/�4�8�=�A�F�J�O�S�Y�]�b�g�k�p�u�y�~̴̛̗̠̥̪̯̹̄̈̍̒̾����������������������������
�����#�(�.�3�8�=�B�G�L�R�X�]�b�g�m�r�w�|͈͍͂͒͗ͧͭ͢͝ͳ͸;����������������������� ������"�'�.�3�9�?�D�J�P�U�\�a�g�m�s�x�~΅ΊΐΖΜΡΧήδκο���������������������������%�,�2�9�?�E�K�Q�X�^�d�j�p�v�|σϊϐϖϜϢϨϰ϶ϼ����������������������	����#�)�0�7�=�D�J�P�X�^�e�k�r�x�ІЍГКРЦЮдл������������������������� �'�/�6�<�C�J�Q�X�_�f�m�s�zтщѐїѝѤѬѳѺ������������������� �����$�,�3�:�A�H�O�W�^�e�l�s�z҂ҊґҘҟҦҮҵҽ�����������������������$�,�3�;�B�I�Q�Y�`�h�o�v�~ӆӍӕӜӤӬӳӻ�����������������������%�.�6�=�D�L�S�\�c�k�s�zԃԊԒԚԡԩԲԹ����������������� �����'�0�8�@�G�O�X�`�g�o�w�ՈՐ՗՟էհո����������������� �	���!�)�2�9�A�I�Q�Z�b�j�r�zփ֋ֵֽ֛֣֓֬�������������������� �(�1�9�B�J�R�[�c�l�t�|ׅ׍זמצׯ׸���������������������%�/�7�?�H�P�Y�a�j�r�z؄،ؕ؝إدط���������������������'�1�9�B�J�S�\�e�m�v�~وِٙ١٪ٴټ�������������������%�/�8�@�I�R�[�d�m�u�}ڇڐڙڡڪڴڼ�������������������'�1�:�C�K�T�^�g�p�xۂۋ۔۝ۥۯ۸��������������� �
���%�.�7�@�I�R�\�e�n�w܀܊ܓܜܤܮܷ��������������� �
���%�/�8�A�J�S�]�f�o�x݂݋ݔݝݦݰݹ�������������������(�2�<�E�N�X�a�j�s�|އސޙޢެ޵޿������������� �	���%�/�9�B�K�T�^�h�q�z߄ߎߗߠߩߴ߽���������������	���%�/�8�B�K�T�_�h�q�{����������������������� ����'�1�;�D�M�X�a�j�s�}������������������������!�*�5�>�H�Q�[�e�n�x�������������������� �
���'�1�;�D�N�X�b�k�u�~������������������������$�.�8�A�K�U�_�i�r�|������������������������#�.�7�A�J�T�_�h�r�{������������������������#�.�8�A�J�T�_�h�r�|������������������������$�/�8�B�L�U�`�j�t�}���������������������	���&�1�;�D�N�Y�c�l�v������������������������)�3�=�G�Q�[�e�o�y�����������������������"�-�7�A�J�T�_�i�r�|���������������������	���&�1�;�D�N�X�b�l�v����������������������� �*�5�>�H�R�]�f�p�z������������������������$�/�9�C�L�W�a�k�t�~���������������������� ����(�3�<�F�P�[�e�n�x�����������������������"�-�7�@�J�T�_�i�r�|���������������������	���&�1�:�D�M�X�b�l�u�������������������������)�4�=�G�Q�\�e�o�y�����������������������"�-�6�@�J�T�^�h�r�{������������������������$�.�8�B�K�U�`�j�s�}������������������������%�0�:�C�M�X�a�k�t�~��������������������������	���&�0�:�C�M�W�a�k�t�~������������������������������%�0�9�C�L�W�`�j�t�}������������������������������#�.�8�A�K�T�_�h�r�{������������������������������ �*�4�>�G�Q�[�e�n�x�����������������������������	���&�0�:�C�L�W�`�j�s�|������������������������������ �)�3�=�F�O�Z�c�m�v�������������������������������"�,�6�?�H�Q�\�e�n�x��������������������������������#�-�6�?�H�R�\�e�n�w��������������������������������!�*�4�=�F�P�Z�c�l�u�~�������������������������������'�1�:�C�L�U�_�h�q�z��������������������������������!�*�4�=�F�O�Y�b�k�t�}�����������������������������   ! + 4 = F O Y b k s | � � � � � � � � � � � � � �  )2;DMW`hqz��������������%/8@IR\dmv~��������������(1:BKS]fnw���������������'09AJS\emv~��������������
$-5>FOXaiqy���������������%.7?GPYajrz���������������$-5=FNW_hRSRC               [remap]

importer="wav"
type="AudioStreamSample"
path="res://.import/hit1.wav-3e1d34eeb50523a94849aa73759ab091.sample"

[params]

force/8_bit=false
force/mono=false
force/max_rate=false
force/max_rate_hz=44100
edit/trim=true
edit/normalize=true
edit/loop=false
compress/mode=0
           RSRC                     AudioStreamSample                                                                 
      resource_local_to_scene    resource_name    format 
   loop_mode    loop_begin 	   loop_end 	   mix_rate    stereo    data    script        
   local://1          AudioStreamSample       (             (              (              (              (   D�                      �r  B
b8�hp�V�?�=I~Q�OI�C:CE�EED�A@W?�>6>�<�;q:�9�8�7~6b5S4P3O2H1:0)/.-, +�)�(�'�&�%�$�#�"�!� ��zoe\WSK>1&�����
�	��������� �������r�h�a�[�R�H�?�8�9�<�8�,���������������������������߸ޯݨܬ۳ڲ٥ؘ׎։Ն��w�o�j�p�y�x�m�_�U�Q�N�I�A�J�F�L�X�Y�N�@�7�4�1�-�%���#�1�3�(�����8��PXl��l�@T0=PnV#O�D$@�AHE�E�C�@�>C>.>�=C<�:�9�8�7�6�5�4�3�2�1�0�/�.y-s,q+p*j)q(g'_&Y%R$K#D"=!: 85-#	������������
�	��������� ��������������~�w�r�o�l�g�c�e�k�l�f�]�U�Q�O�L�G�T�X�_�b�]�T�L�H�G�E�A�<�:�?�H�L�H�?�8�5�4�2�/�.�3�=�C�?�7�0�-�-�,�)�(�/�;�B�?�7�0�-�-�.�,�(�(�1�?�G�E�=�6�4�5�6�ǰ���f�mn�GL4�9�HnR�P IrB�@�BsDD�A�?>x==Z<5;�9�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!� �����������~{yxutuy{z�
�	~|{zy|��� ��|�y�y�x�x�x�{���������~�|�|�}�|�}���������������ߠޜݛܜ۞ڟ١ب׳ּվԻӸҶѸлϼο����������������������������������#�/�<�H�N�L�I�I�L�Ƕ���`|�l�M:4:tE�N�O�JcD=AnA�B@C"B(@V>+=�<�;; :�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!� ������������� 
	%-48989 <�?�B�F�M�U�^�c�d�d�e�g�k�p�x��������������������������������������� �&�,�3�>�J�X�`�d�e�g�k�q�yɇȔǢƬŰıó¸���ſξܽ����	�
����#�3�B�b�m�������>$�Y.s�j�R�?�;'BeJ�M�K�F�BAcA�A�A�@�>d=L<�;�:�9�8�7�6�5�4�3�2�1�0�/�.�-�,,+*	)('&%!$'#/"5!9 <@DHNW_gm�������������
�	�����	 �$�-�7�B�M�W�^�c�g�m�s�|������������������������� �'�3�A�N�^�j�r�w�}ٔ؜צַ�����������������#�4�D�R�\�c�i�p�yĄÐ¡���ÿҾݽ�����
��/�A�Q�\�d�j�r�ʲ����/*@XEnnh�ToC3=�@PG�K6K�G�C~A�@�@�@L@?�=w<h;�:�9�8�7�6�5�4�3�2 2
10/.!-),3+=*G)P(Z'b&j%q$x#�"�!� ����������  (19BLZfs�
�	��������� 	 ��%�/�;�I�Y�g�u���������������������	���(�9�J�[�k�x�����������������"�.�<�N�b�tӆҔѠЪϵ�����������-�9�C�N�j�yÎ¢���ʿ۾������1�F�[�o�����������]�eҿ���GVc8hY\1L�AW?�B�G�I�H6F:C/AG@	@�?6?3>�<�;�:�9�8	87%6'5,453C2Q1`0k/v.�-�,�+�*�)�(�'�&�% %$#+"9!F R^ju����������-=L\iu�
�	�������
% 9�K�]�n�~������������������ �0�=�J�Z�{��������������'�<�P�d�w��ߖޣݳ���������-�=�L�[�kӀҗѭ�����������(�@�X�nǅƚŬĻ��������"�;�Q�d�s���������ٶ�
� �3�R�������f�4�S0c~a�U8I�A�@JC�FHqGOE�B�@�?E?�>K>r=c<B;.:29I8i7�6�5�4�3�2�1�0�/�..-/,?+O*a)r(�'�&�%�$�#�"�!�  ,;K\o�������3FZm����
�	��(<M^p� �������������!�5�J�a�v��������������1�H�_�s����������	� �6�H�[�m߂ޚ�������
��4�F�[�sՌԤӾ�������(�>�X�rˋʥɿ��������.�H�b�|�����žڽ�	�$�?�[�v�������ʹ���w�T�!�}�[<=V�a�^3TII�B�@�B(E�F}F1E4CEA�?�>?>�=�<!< ;:9807M6j5�4�3�2�1�0�/�..-1,D+X*k)�(�'�&�%�$�#�""%!< Qg}������+AXn������
!9N
r	������-CY p�������������1�G�`�y������������#�:�T�o����������8�S�n���������!�>�Y�tڑ٬��������-�I�e҂ў��������,�I�fʃɠȽ�����
�&�D�b�~�����վ�	�&�E�c�������ڶ��,�K����L3�L\�^ XEN.F�A^A�B�DzEE�C�AT@?>c=�<<0;@:D9G8S7w6�5�4�3�2 21,0C/[.r-�,�+�*�)�(('8&P%h$�#�"�!� � 3Kd}����3Ke����� :S
o	�����.Gc� ���������6�P�m������������5�O�l����������9�S�q�������	�%�B�^�|��������4�P�lډ٧������&�F�eӂҞѾ������>�_�~˜ʹ������;�\ŋĬ�����	�*�K�k�����ϻ��/�Q�r�����ٴ��ͳ������e";HPJ[�[�U-M4FMBXA,BsC7DDC�A#@�>�=�<"<k;�:�9�8�7 76,5I4i3�2�1�0�/�..0-K,v+�*�)�(�''!&>%\$x#�"�!� �
&Db�����1On����"A`~��
�	�8Wu����2 R�r����������1�R�r��������"�B�c�������	�)�J�j��������5�W�w�������!�C�f݉ܪ������5�W�y֝������'�L�oВϵ����� �B�fʋɯ������@�cĆê������<�b�����ܻ�'�L�p�������)�s��Ǽ�_ ��2{HbV�Z�W�P�I�D�AEA�A�B"C�B�A�@`?>=$<Z;�:�99%8@7W6o5�4�3�2�11.0M/n.�-�,�+�**.)N(o'�&�%�$ $ #B"c!� ���)Km����7Y{���&Ik���
�		<_����3Vx �������-�Q�u��������)�O�u�������*�O�s�������;�a��������C�h�������$�K�rݙܾ����2�X�~ץ������@�hҏѶ����.�T�{̡������A�jǓƻ���	�2�[���ӿ��&�M�u���Ⱥ��C�m���̵󴯴���ڳ��� !x6�IqUYbV|P$J(E7BA2A�AB�A_Af@:?>�<�;
;<:t9�8�77#6B5a4�3�2�1�004/Y.|-�,�+�**1)V(z'�&�%�$$1#V"z!� ��Bg����#In���/Tz���:a�
�	��"Ip���6\ ��������$�L�t��������<�d��������/�W��������%�N�v������)�T�������$�N�x������"�L�t۟������J�v֡������J�uѠ�����%�O�y̤�����'�TȂǮ����/�\È´����<�h�������I�x���ѷ��)�W���`������.~�,]@�NCVWhS�M�HeD�A�@�@�@A�@m@�?�>w=f<h;�:�9�88B7q6�5�4�3312X1~0�/�.�--G,p+�*�)�((8'a&�%�$�##."V!~ ���"L����'Q{���$Mv��� Lw��
�	 	Ju���"Lw�� ��'�S������ �-�Y��������7�b������A�n�������L�z�����3�l������!�P������4�bݐܿ����M�zا����3�bԒ������M�{Ϫ����>�n˝�����)�Yǉƺ����K�z©���
�;�m���ϼ��/�^������$�W���J�ɱ������(�;tJ S�U�S�O�JLF/CXA�@K@I@7@�?[?�>�=�<�;�:�9�88O7�6�5�44=3g2�1�0�//=.i-�,�+�**E)r(�'�&�%"%O${#�"�!!0 ]���=w��.Z���@n���%S���

>	l���'X���A q������2�a��������N�������@�o�����5�f������'�X�����-�^����� �Q������L�|ݯ����F�zٮ����A�sզ����D�wѨ����@�sͨ����D�vɨ����C�xů����I�{�����N������ �S�������-�c�e����Ԇ�E��8�^)
;�HQT�R�OIKAGD�A�@�?�?�?;?�>,>f=�<�;�:�9�8
897k6�5�4473g2�1�0�/#/Q.�-�,�++?*p)�(�''1&a%�$�#�"#"T!� ��F���J{��?q��9j�� 3e��
�	.	`���.`���)] ������.�`�������-�a�������2�d����� �6�k�����;�o�����S�����%�[������4�i�����<�rݩ����Mڃٷ���"�[֓����8�mң����Iςι���&�\˒��� �:�sǬ����Oćþ���0�j���ܾ�H�����/�i���ڷ���4������"	�%.�=hIPQRSQkN�J:GHDB�@�?F?�>�>>�=�<<D;f:�9�8�7�6-6`5�4�3372k1�0�//7.j-�,�++8*l)�(�'';&p%�$�##@"t!� �S���&[���0e��9n��G|��R�
�	�/d��=t��P ������,�d������B�x������W����� �8�n�����Q����	�@�w����"�]�����?�w����$�_������D�|ܶ���.�i٣����Nֈ�����:�uұ���#�]ϗ����K̇�����6�pȪ���#�aŝ����M����@�}����=�w����/�m���:�ܽ������b�	3�#�3 A)J"O�P�O�L�I�F1D$B�@�?�>i>�=t=�<E<�;�:�9+9V8�7�6�55K4�3�2�1,1d0�/�.	.@-v,�+�**T)�(�'�&?&v%�$�##X"�!� �6n��Q���3l��R���6o��W��<
v	��&`��G��� 4 o������Z������H�������4�p�����2�l�����Z�����M������;�w����1�n����!�^�����Xߔ����J܈����Dقؿ���8�uմ���3�rұ���,�hϦ���'�ģ���#�aɟ����`Ơ���*�iæ���$�f����(�h����#�d����)�����͓����_+�+C9�C�JN�N�MVK�HF�C�A�@r?�>�=d=�<?<�;�:;:z9�8�77O6�5�4�3-3g2�1�00S/�.�--K,�+�*�)8)s(�'�&#&`%�$�##N"�!�  =y��/k��\��O��@~��7t��)g�
�	"	`��V��P�� 
 I������Q������K������H������E�����B������C���� �A�����E�����D����
�J�����Jތ����R۔����Uؗ����`բ���%�fҧ���-�pϴ��D͆����Jʎ����Zǜ����aĤ���.�r�����<�}����J���Ժ�\���=�����������|���
�Z%�2�=�E{J�L�L�K�IgG<EHC�AD@,?H>�=�<=<�;�:N:�9�818o7�6�5!5]4�3�22M1�0�/	/G.�-�,,B+�*�)�(=({'�&�%9%x$�#�"5"u!� �5s��2r��3s��2r��5u��7v��;|��
?
�	�Q��X��^� ��&�h�����-�o�����9�{��� �B������O�����\����%�j�����6�y����B�����U���� �c����2�w߽��E݉����Yڟ���6�{׿��HՏ����cҨ���2�vϼ��J͑����dʨ���4�z����QŘ���$�j²���B���Ҿ�_����5�}�ƹ�Ժ�����z����E��d�,�7I@FuI�J�J�I=HsF�D�BlA@?>:={<�;;s:�99d8�7�666w5�4�383x2�1�0;0{/�.�-A-�,�+	+J*�)�((S'�&�%%_$�#�"&"i!� �4w��@��
N��^��4w�E��V��$j�
�	8	{�L��b��0u ���I������_�����2�x����K������e����;�����T����-�t���I�����g���K���� �h����Bߌ����cܪ���=ڇ����bת���;Յ����cҭ���=І����cͮ���Bˌ����gȲ���HƓ���'�pú��P����4�~�Ƚ�\�����A�������/ҳ�����������$�/;9+@�D�G�H�H�G�FWE�CeBA�?�>�=�<%<g;�:�9M9�8�777�6�55W4�3�2&2k1�0�/9/}.�-	-N,�+�**e)�(�'7'}&�%
%P$�#�"."t!�  I��c��8��V��+r�I�� h��A��b
�	�;��_��8��] ����9������^�����<������b����L�����,�u��	�S����6�����_����@����#�n���N����3�~����aޭ���Eܒ���,�w����[ק���BՐ���(�u����ZШ���DΑ���*�v����`ɯ��Uǣ���=ŋ���(�x����c�����L����;���ٺ~�������%�D���������|�)�2q:�?�C�E�F�FDF\E=DC�A�@�?�>�=�<�;;\:�9�8:8�7�6 6l5�44L3�2�121{0�//V.�-�,0,x+�**T)�(�'1'z&�%%W$�#�"5"~!�  ]��;��e��D��%p�P��3~�a��B��
&
r	�V��E��+w�\ ����D�����,�x����_�����H�����0�|����f���P����9����#�r����^����H����7����#�r����`����Oޞ���<܋���*ڇ���&�v����dյ��Wӧ���Hј���8ϊ���-�}����o����cȶ��Yƪ���KĜ���@���8���۾,�|�μ!�t�N������%�d�<��7���7�!q+m3�9R>�A9C[D�D�DD>CRBWAW@[?h>�=�<�;;@:�9�88\7�6�5C5�4�3,3x2�11_0�/�.D.�-�,),v+�**\)�(�'B'�&�%)%v$�##^"�!� F ��/|�f�P��E��1~�j�W��C��0~�

n	�\��I��:��)y ���j����]�����M�����?�����3�����$�u����k���_�� �R����S����I����?����7����.����%�x����q����iܼ��cڷ�
�^ر��W֪���Sԧ���NҢ���IО���HΜ���D̘���@ʕ���@ȕ���>ƒ���<Ē���=���G����G�����J��ȿ ��5ټ�.�Z�;���
�����!*=1�6J;p>�@�A�B�B|BBfA�@�?	?4>`=�<�;�:::{9�88R7�6�5:5�4�3'3w2�11g0�//W.�-�,F,�+�*A*�)�(2(�'�&"&s%�$$e#�""W!� �I��=��1��$v�k�`�V��L��C��;��
3
�	�+}�$w�p�k�  r����l����h����e����`���	�^����\���Y���Y���X����W���X���Y���X���[���]��	�_ߵ��cݺ��fۼ��j����p���(�~���,Ԅ���3ҋ���9А���?Θ���H̠���Oʧ���Xȱ�
�bƻ��k����u���'���ٿ2����<���Ծ��L̃�tܦ����)�y�����qB'�-K3�7�:1=�>�?o@�@�@@@�?G?�>�=K=�<�; ;g:�9�8C8�7�6+6z5�44m3�22d1�0	0\/�..V-�,�+O+�*�)I)�(�'D'�&�%?%�$�#<#�"�!8!� �5��3��0��.��.��7��7��8��8��:��<�
�	=	��@��D��G��L� ��R�����W����^����d����j����r���"�y���)����3�����<����P���[���e���p���#�|���0����;����Iߣ���Wݰ�
�d۾��s���'؂���7֑���GԢ���XҲ��h����z���1͌���B˝���Uɲ��h����{���5đ���S°��h�Ŀ!�}�۽��������	�J��P��.���Z ���!(�-2�5�8�:@<W=	>i>�>u>;>�=q=�<b<�;,;�:�999�8�797�6�575�4�353�2�161�0�/7/�.�-D-�,�+H+�*�)L)�(�'Q'�& &W%�$$]#�""c!�  j�q�!y�)��3��<��E��O�[�f�q�$}
�	1	��=��K�
d�r� ' ����8�����G�����Y����i����z���2�����C����U���j���!�|���5����J���_���t���.����D����[���s���.ފ���Eܭ��i���$ق���=כ���Xն��r���/ҍ���JЩ��f���#̓���Aˠ���^ɽ��{���:ƚ���Yĸ��w���8�����X���о��)�j���(����t�6�S�������	��$	*K.�1�4�6�8:;�;)<b<o<X<$<�;{;;�::�9�8c8�7.7�6�5N5�44d3�22t1�0)0�/�.8.�-�,F,�+�*T*�)	)d(�''r&�%'%�$�#8#�"�!H!� �Z�u�,��>��Q�	e�x�1��E��[�p�)��
A
�	�X�o�+��C��\�  v���2�����L���	�g���#�����?�����e���#����@����^���{���;����Z���x���8����Y���y���9����[���|���>ޞ���a���#ۄ���F٧�	�k���.֐���RԵ��x���<ў� �c���&Γ���Y̻�����Eɧ��n���4Ɩ���\Ŀ�"Ç���M���������Ģ�J���l�k�����3��a�����I�����$�(s,�/2.4�5:7G89�9	:B:Z:S:4::�9f99�8+8�7.7�66�5�4e4�353�2�1a1�0$0�/�.E.�--c,�++~*�);)�(�'V'�&&p%�$-$�#�"G"�!!c �~�<��Y�u�4��Q�o�/��X�w�7��X�x
�	9	��[�}�?�b�$� ��I����n���1�����W����{���@����g���,����R���z���@���i���/����Y���(����S���~���E���q���9���f���/ޓ���\���%ۊ���Sٹ�؃���Lֲ��|���Gӭ��x���CШ��t���@ͦ��r���?ʤ��q���>Ǥ��r���?ĥ��}���K���p�mĺȠͧҋ��L��_�D����6����-
r7k !$�'�*g-�/�13k4z5R6�6z7�78-838#88�7�7B7�6�6"6�5=5�4B4�373�22�1�0l0�/A/�..�-�,N,�++|*�)C)�(
(m'�&3&�%�$Z$�##�"�!E!� 
 l�0��X�~�C�	l�1��Z� ��I�s�;�f�.�
�	Y	�!��X� ��M�{� E ���t���?���	�n���9����i���5��� �f���2�����d���0����c���1����d���2����f���4���j���8���n���=���~���M߶�ކ���Uܾ�&ۏ���`���1ؙ��k���<ե��w���Iҳ�х���X���*Δ���g���;ˤ��x���Lȷ�!ǌ���`���5ğ�
�t���0��P̸��3�
ݍ������4�@�ihQlJ�"�%q(�*�,�.0X1m2S34�4"5|5�5�5�5�5�5�5�5j5'5�4�4+4�3`3�2~22�11�00�/�.m.�-R-�,2,�++y*�)P)�($(�'�&h&�%8%�$$n#�"="�!
!p �>�q�>�q�>�q�>�r�?�s�B�w�E�{�
J
�		��P� ��X�(��a� ; ���v���G��������S���%�����b���5����q���D������U��)����h���<���{���Q��&����g���=���~���U���-���n���F޲�݊���a���Bگ�و���`���9֥��~���X���2Ҟ��x���R���.Κ��u���P˾�,ʚ��u���Qǿ�.ƛ�
�x���T�
�b�Ǔ�Z�/���rپ��߈��E�������0�����w���"%>'-)�*c,�-�.�/�0g12�2�243n3�3�3�3�3�3w3L33�2�2I2�1�1=1�0p00�//�...�-2-�,.,�+"+�**�)�(n(�'Q'�&3&�%%�$�#\#�"6"�!!� �\�3�	t�J���`�6�u�J� ��`�6�v�L�#��
e
�	;	�}�T�,�o�G�� ��f���>��������f���?��������a���;��������^���8������]���9������`���<������e���B�� ����m���K��)��	�w���W���6ݦ�܆���e���Eٶ�/؞�����a���AԲ�"ӓ��u���W���9Ϫ�΍���o���R���6ʦ�Ɋ���n���R���6Ũ�uĿ�(�(�lν����ۺ�;�������&�������^�
�L���1O u"f$&&�'#)f*�+�,d-(.�.d/�/G0�0�0141J1R1O1B1+1	1�0�0t050�/�/P/�.�.@.�-v--�,/,�+G+�*W*�)^)�(_(�'Z'�&P&�%C%�$2$�##�""{!� b �O�4���h�I�(�w�W�5���b�?���k�I�(�v
�	V	�4���b�B�!�q� Q ��3��������e���O���1��������e���G���)����}���`���C��&���|���`���D��(������e���J��0������n���T���;��"���	�|���d���Kܿ�3ۧ�ڏ��w���i���Q���;հ�$ԙ�Ӄ���l���W���@϶�*Π�͋� �v���b���M���9ȯ�%Ǜ���sǢ�C���Ѻ�i���Wܐޠ���S���s������1 1�z���C����h! #s$�%�&()�)�*p+,�,-�-�-$.a.�.�.�.�.�.�.�.�.�.j.=..�-�-O--�,i,,�+`++�*9*�)f)�(�((�'3'�&D&�%P%�$X$�#[#�"Z"�!T!� V �K�?�1�!���t�a�K�6� �
~�g�O�8� �{�d�K�
4
�		�w�_�G�0��t� ] ��G���1���"��������j���T���>���(��������s���_���J���6��!������p���]���I���6��#������u���d���Q���@��0���������t���e���T���M���>ڶ�/٦�ؘ�׊��{���m���_���P���Cѽ�6а�(Ϣ�Ζ�͊��}���q���e���Z���{�/�����8Χ��rշ������ݚ�D���>��D�8�4�������0=	��t���m� \!�"�#�$�%�&O'(�(?)�):*�*�*K+�+�+�+,/,@,H,H,A,3,,,�+�+�+\+$+�*�*g* *�)�)6)�(�(/(�'s''�&H&�%v%%�$0$�#T#�"n"�!�!!�  �$�-�2�4�5�3�0�+�$����{�p�e�Y�K�?�2�$�

�			��t�f�X�J�<�7�(�  ����� �z���m���`���R���E���9���-��� ����������v���j���_���T���I���>���4��)�� �������~���u���m���e���\���]���T���M���F���?ݻ�8ܵ�1ۮ�*ڧ�$١�؛�ז�֑�Ռ�	ԇ�ӂ���}���y���u���r���n���k���h���e���f�n�i��������������׹�u�ݥ����x�>�z���n���I������ y(�^��k5�v�T���	 !�!�"�#I$�$�%&�&'�'�'6(�(�(�(()N)n)�)�)�)�)�)�)�)o)V)6))�(�(�(Y(!(�'�'g'!'�&�&A&�%�%I%�$�$>$�#�#!#�"["�!�!%!� Q �x
�+�G�a�v��#�1�<�F�N�V�[�`�c�f�g�h�i�h�o�
n
�	m	�k�i�g�d�b�_�\�Y� V ��S���P���M���K���H���E���B���@���>���;���9���7���5��3��2��1��/��.��.���-��4��4��4��4��5��5��6��7��8��9��;��=��?���A���D���G���J���M���P���T���Y���]���a���f���k���p���u���{��π�ψ�Ύ�͔�̣�<ˈˇ��͋�A��ҵ�b��׍��p����A���.�������������z��� �$IR	C���[������|8 � �!!"�"1#�#${$�$,%v%�%�%"&P&w&�&�&�&�&�&�&�&�&�&�&�&�&q&P&-&&�%�%x%D%%�$�$T$$�#�#=#�"�"T""�!\!!� S ��>�}�V��#�R�~�:�_���5�Q�k���%�:�M�`�q��	��%�
3
�	@	�L�X�c�n�x����� $ ��/���8���A���I���R���\���d���u���}�������������&��0��:��C���L���W���a���k���u����������%��1��<���H���S���`���l���x��߆�ߒ�ޟ�%ݭ�4ܺ�A���O���e���s��ׂ�	ב�֟�'կ�7Ծ�F���W���f���v��χ�Ϙ� Ψ�[ͻ͠���.њ��y���:؈�����"�;�F�~�]��6����#��8�����9�b�u�r\0��:
���(c������{N��-�`�p�^ � ,!�!�!+"r"�"�""#Q#z#�#�#�#�#�#$$$$	$ $�#�#�#�#�#|#\#8##�"�"�"["'"�!�!~!B!!� � @ ��i��5��>��=��1�y�_��<�v�I�|�E�s
�5�^���=�a���5�T�
s

�		�B�^�y� �:�S�l��� ( ��@���X���n��������'���=���S���i������� ���6���L���b���w�����/��D���[���q������0��G���^���t������.��E���]���t� ����1��I���b���z�ޓ�ݬ�9���R���l��ن�ٟ�-غ�G���b���|�
՗�$Գ�@���\���w�є�!й���[�<�J�oӝ������8�J�R�Q�F�1��������W����� �.�*������w�! �J�9��:
v���������d,��M��%�:�3�v�'{�X�� 4 ` � � � � � !!$!-!1!1!/!(! !!!� � � � � t S 1  ���`1���_&��r4��n)��S
�s&��:��H��J��F��:��'�n�S��3�p�I���V��$�X�
�
"
�	S	���H�u�7�b��!�J�s� 7 ��`��������A���g����� ���E���k�����"���G���l�����"���G���k����!��E���j������D���h������B���g������A���f������A���m����$��J���o���'��M���s�ޙ�,ݿ�R���x�۟�3���Z��؀�ا�<���c��Ջ�ճ�G���o�Ә�@�\��қ�x�f�[�P�C�2�����ۦ�r�6��޽�����3���������_����w����"����c�� @u�����	�
����_,��e�_�� �-�#�l�.��-x�B}��Bk�����"1=EKNNLHA8,������bA����\0��q>	��d+��v8��w5��h!��J�k#��<��M��Z�`�b�_�X��L��=��+�
r

�	\	��A��$�f�E��"�`��;�v� N ����&���f����;���r����E���|����N��������T�����$���Z����(���^����,���`����.���b����0���c����1���e����2���f����3���g� ��5���h�	��<���p���>���r���A���u�ߪ�D���y�ݮ�H���}�۳�M��ك�ٹ�S��׉�$׿�[��Ց�-��>ջ�]���ז�Z���ڑ�E��ܞ�C���|���X���b���~���C���K���0����B������7�_����� �����vW0	�	�
W�u�c��"�3�2���a�#~�+z�V��J���
3Z~����1ANZbinpqolf_VK>0������eF&���uN%���xJ���S��|D��_#��j+��i'��]��G�p'��K�j��7��K��]�
k

�	v	$	�~,��0��2��1��/��)�z(�x � o  ��e����Y�����J�����;�����,���u����c����P�����=�����(���o����Z����D����.���s���\����D����-���r����Z����F����.���r���Z����A����'���l���S����;����!���g�	��N��ߓ�6���z����c�ݧ�J��ې�3���x�ھ�a�٧�J�����@خ�3���\��ڎ�%ܿ�P���i���r���l��������U���T����0�l�������;�Q�b�k�o�m�f�Y�E�-����� �b+��g�y!�d	�	�
(�B�M�H�6���C�]�	[��?��I���)\���4Yz����3EVer}������������~ti\M>.�����}bE(
����d?���|S)���wI���X%���T��yA	��[��k/��t5��u5��p.��d �
�
W

�	�	?	��i!��I�m#��E��e��6��O�h� � 1 ����F�����Z����k����{�,�����;�����H�����T����a����p����z�'�����1����9����@����G����M����S����Y���^�
��b����f���j����n����q����u� ���x�$���{�'���~�*����-����0����8����;�����>��ߖ�A��ޙ�D��ݜ�H��ܟ�K��ۣ�O����-�}���O���9ݮ�"ޖ��u���K���y���A������������	��.�:�C�G�G�C�:�,���������m�A������j�*�����U����^ �G�}�6�K�V�R�E	�	-
�
	r�?�_�h�]��=��K�� 8n��6c���'Jl�����+@Sfw��������������������������ufWE4!������mS9����iH'���wQ,���f=���f9���S#���a0���d0���]&���K�
�
k
2
�	�	�	J		��_"��q5��|> ��D��F��D��?��y8� � o - ����d� �����S������B�����s�.�����]������E�����r�,�����X������;�����i�!�����J����r�)����P����w�/����S����y�0����T����x�/����R�	���v�-����O���q�'����J����l�!����C����e�����=����c�����:����[����|�2�����S�	��t�*��ޖ�L� �,�Zޜ���>ߕ���E�����H����=����"�l��)����`�9��������]�0� ����_�#����^����p����v����d����9���e��������&���/ � 0�&���j�C�y�>��W�		_	�	
W
�
�
>��\��!`��K���M}��1Z����8Yx����5Kau���������	!(.37:<>>>=;951,&����������zjYF4 ������qZ@&�����gI,����nL,	���}Y5���xQ+���b9���f:�
�
�
a
4

�	�	|	N		���c3��p?��wE��yF��vB��n9��a+���P� � r ;  ����\�"�����|�C�
�����^�$�����v�<������R������g�,�����z�>������O������_�"�����m�1�����z�=� ����I�����S�����^�����f�(����n�0����x�;�����A�����F�����K�����P�����T�����Y�����\�����_�����b�"����e�%����g�'����j�*����l�-����n�B�A�]������?���� �@�~����5�o�����N����\����:����?����=����,���j���:���f�������0���@���I���K���F���:���'�������\���3����h���' � � G� [�a�	[��H��+s�F��O��
	E	�	�	�	)
`
�
�
�
/`���Fq���:_����-Kj�����$=Sj�������-:GR_is|������������������������������wof\QG<1$���������sbP>+������r\E.������iN4����d>���~X0�
�
�
g
>

�	�	�	T	!	���W"���O��zD��l6 ��\$��~G��h0���N� � k 2 ������M������f�-�����}�C�	�����Z������n�3�������I������\������l�1�����|�@������N������]� �����j�-����v�9�����D�����O�����Z�����d�%����m�/�����u�8����~�@�����L�����T�����\�!����1�Q�v�������:�`��������6�W�v��������p���l���j���f���\���M���9�������n���G��������N����p���0�����G�����S��� �T�����L�����;����� h � � @��Q��T��G���,b��5g���(W���2[����	A	e	�	�	�	�	
/
M
l
�
�
�
�
�
.F_v������0ARcr�����������"(/49>AEHJLNOPPPONLJHEB>:51+%
������������yl_QC5%��������m[H5!�
�
�
�
�
�
z
d
N
7
 

�	�	�	�	�	y	a	G	.		�����tY=!����uX:�����eE%����eD#���{Y7����fB����lG#����iD� � � � ` 9  ������w�P�(��������b�:��������o�F��������x�O�%�������~�T�*���������U�,� ������T�(�������{�Q�&�������v�J��������l�@��������`�3������~�Q�#������n�@������[�-������t�F�������_�0�����u�F������]�.�������q�B������Y�(������k�<�����}�M��������������(�F�e���������0�J�e��������?����L����t���:����\���w���0����=����=�����<�����3�����"�q����W�����6�~����T�����#�g�����.�n�����-�j������[������@�x����� O � � � P���Ao���#Ny���Dl���)Mq����=]|����1Lh�����6Mdz������	 	4	F	X	i	z	�	�	�	�	�	�	�	�	


)
5
@
K
W
a
k
u
~
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
  �
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
z
r
j
a
X
N
D
;
1
&



�	�	�	�	�	�	�	�	�	�	�	r	d	W	H	:	,			��������~n]L;)�������q^J6"�������jT?)������v`H2�����s[B)�����y`F,�����tZ>#	�����dH,� � � � � h K /  ����������d�F�(����������u�X�9������������d�E�&����������k�K�-����������n�M�.����������l�L�,����������g�F�'����������a�?����������v�T�3����������g�E�"� �������w�U�3���������d�A��������p�M�*�������{�X�5��������a�=���������k�G�#�������q�M�)������v�R�/�������z�W�3�������}�Z�6�����������������#�8�M�c�w������������(�:�L�c���� �D�����`����9������T����#�g����0�q����4�t�����1�n�����$�a������K�������.�e�����	�?�t������D�w������?�p�������/�^��������A�j��������A�k��������7�^��������� B g � � � � =_����%Fe�����9Vr�����2Ke~�����'?Vl�������&;Mas�������  0?N^lz����������
!-7BLWajs}������������������								#	&	+	.	1	4	6	9	;	=	?	A	C	D	E	F	G	H	H	I	I	I	I	H	H	G	F	E	D	C	A	@	>	<	:	7	5	2	0	-	)	%	"									��������������������~wog_WNF=5,"�������������wlaVJ?3'����������xk^PB5'���������zk\M>/ ��������p`O>.��������q`N=,�������vdQ?-�������n[G4 � � � � � � � m Z E 1   ������������y�e�O�;�&��������������}�h�R�=�'��������������{�f�O�:�#��������������r�\�F�0�������������z�d�M�7��	�����������~�h�P�:�"�������������h�P�9�!�
�����������{�d�L�5�������������w�_�G�/��������������n�U�=�%������������z�b�I�1�� ����������m�T�<�#����������v�^�D�,����������}�e�L�3����������m�S�;�!�	���������r�Z�@�'����������w�^�D�,����������{�b�H�0��������������������!�0�=�K�Z�g�t�����������������;�f������(�[������"�T������G�v�����3�a������D�q�������!�L�w�������!�J�t��������?�g��������*�Q�w��������3�T�y�������	�,�O�r����������>�_���������!�A�`�����������6�S�q�����������9�U�q������������-�F�`�y����������� & > V n � � � � � � "9Ndy������3G[n�������&8I[k|��������,;IYgu����������"0<GS`kv������������&09BJS\dmu|������������������ $)/38<@EIMPTY\`cgjmpsux{}������������������������������������������������������}zxvspnkheb_\YVRNKGD@<851-(#	 �����������������������ztmgaZSMF?92+# ����������������|tld\SJB:1(��������������|si`WLC90%�������������xncYNC9.#�����������}rg\OD9." ����������}rfZMB6)� � � � � � � � � � | p d W J > 1 $   ��������������������~�q�e�X�J�=�0�#��
���������������������w�j�]�O�B�4�&�����������������������u�h�[�L�?�1�#���������������������|�n�`�R�D�6�'���������������������~�p�c�T�F�8�)���������������������|�n�`�Q�C�5�&��	�������������������w�i�[�K�=�/� �������������������~�o�a�R�C�5�%��
�������������������u�g�X�I�:�,���������������������x�j�[�L�=�/��������������������{�l�]�N�?�1�!������������������|�n�_�P�B�3�#���������������~�p�a�R�C�4�%����������������q�c�S�D�6�&��	��������������s�d�U�F�8�(������������������v�h�Y�J�;�-���������������������������������'�0�8�A�I�Q�[�c�k�s�{��������������:�Y�w��������1�O�m�������� �<�Z�v��������#�?�\�w�����������9�S�n������������(�B�\�u������������'�@�Y�q�������������3�J�b�y�������������1�G�^�s�������������� �6�K�`�u���������������.�B�U�j�}���������������*�>�P�c�u�����������������)�;�L�^�n������������������&�6�F�U�e�u���������������������-�;�J�Y�g�u�������������������   ( 6 C P ^ j w � � � � � � � � � � $1<HS_kv������������"-7AKT_ir|��������������(19AIQZbjry������������������%,39?EKQX^djpu{������������������������� 	!%).269=@DHKORVZ]`cgjmpsvy|~�����������������������������������������������������������������������������������������������������������������������������������������������������������������~{ywtrpmkhfca^[YVSPMJHEB?<:741.+'$!�����������������������������������~zvrnjfb^ZVQMIEA=950,'#	���������������������������~zuplgb]XSNID?:51,&!�������������������������ytojd_ZSNIC>94.("����������������������~xrmga\VOJD>83-& 	� � � � � � � � � � � � � � � � � � � � � � y s m g a [ T N H B < 6 0 ) #      ������������������������������������������|�v�p�j�d�^�X�P�J�D�>�8�2�,�%�����������������������������������������������y�r�l�f�`�Y�R�L�F�?�9�3�,�%����������������������������������������������}�w�q�j�d�^�W�P�J�C�=�7�0�)�#����	������������������������������������������y�s�l�f�`�Y�R�L�E�?�9�2�,�$����������������������������������������������{�u�o�h�b�[�T�N�G�A�;�4�.�'� ����� ���������������������������������������~�x�q�k�e�_�X�Q�K�D�>�8�2�*�$����������������������������������������������}�w�p�j�d�^�W�P�J�D�=�7�1�*�$�����������������������������������������������y�s�m�g�`�Z�S�M�G�A�;�5�.�'�!����	��������������������������������������������z�s�m�g�a�[�T�N�H�C�=�7�1�*�$��������������������������������������������������z�t�n�i�c�]�W�P�J�D�?�9�3�-�&�!����	����������������������������������������������|�v�p�k�e�_�Z�S�M�H�B�<�7�1�*�%�����	���������������������������������������������z�t�o�j�d�_�Y�S�N�H�C�=�8�2�-�&�!������ �����������������������������������}�w�r�m�h�b�]�X�R�L�G�B�=�7�2�-�'�"��������������������������������������������{�u�p�k�f�a�\�W�Q�L�H�C�>�9�4�/�)�$������� ��������������������������������������������������������
�����"�'�-�2�7�<�@�E�L�U�b�o�|������������� ���,�;�I�X�f�t�����������������,�9�G�T�b�o�|���������������������*�8�E�R�`�l�y������������������������,�8�D�P�]�i�u��������������������������*�6�B�M�Y�e�p�{��������������������������%�1�;�F�Q�]�g�r�}����������������������������&�2�<�F�P�[�e�o�y������������������������������!�*�5�>�G�Q�[�d�m�w���������������������������������%�/�7�@�I�Q�[�c�l�t�}�����������������������������RSRC               [remap]

importer="wav"
type="AudioStreamSample"
path="res://.import/hit2.wav-a7aa1069ee254e8d5e3bff3297059dd2.sample"

[params]

force/8_bit=false
force/mono=false
force/max_rate=false
force/max_rate_hz=44100
edit/trim=true
edit/normalize=true
edit/loop=false
compress/mode=0
           RSRC                     AudioStreamSample                                                                 
      resource_local_to_scene    resource_name    format 
   loop_mode    loop_begin 	   loop_end 	   mix_rate    stereo    data    script        
   local://1          AudioStreamSample       (             (              (              (              (   D�                      rL  B
b8�hp�V�?�=I~Q�OI�C:CE�EED�A@W?�>6>�<�;q:�9�8�7~6b5S4P3O2H1:0)/.-, +�)�(�'�&�%�$�#�"�!� ��zpeZPLIA5'�����
�	��������� ��������w�i�_�Y�Q�I�@�6�.�'�(�,�&��������������������������ߴޯݨܟۗڏًؐח֕Չ�{�r�m�i�d�\�S�N�U�_�_�R�E�<�H�E�@�9�1�)�'�/�:�;�1�"�����	��������A��OSl��l�@T0=	PlV#O�D%@�AFE�E�C�@�>@>)>�=A<�:�9�8�7�6�5�4�3�2�1�0�/�.z-u,o+g*^)f(_'X&P%I$A#;"7!6 2)��������������
�	��������� ��}�w�q�m�o�s�s�l�c�[�W�R�O�J�D�>�;�?�E�F�@�6�/�;�9�6�1�,�&�$�(�1�4�/�%�������	���������������������	���������������������
� �����������3�,��,mt��dh@�3/=L
S/O�F�AA>C�D�CCA?�=Z=�<<�:�9i8u7�6�5�4�3y2u1u0u/p.j-d,_+[*X)T(R'Q&P%L$G#B">!: 740,((++'"	

	
 �
�������������������������������������������������� � ������ ��������������&�0�;�E�H�D�@�>�@�B�D�E�D�G�Q�^�j�n�k�g�e�h�k�n�o�o�o�?���_	S�y=s
U�<�8\B3MwP7L�E�AAoB<CyB�@�>Q=�<�;;;0:�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!� ��������������������	
		

 ���"�%�%�#�#�$�&�(�*�,�-�/�6�N�W�\�]�[�[�]�`�c�e�g�h�l�t�}���ߏގݎܑ۔ژٛ؝ן֤ծԹ��������������������������� ������� �&�*�/�2�5�<�H�X�f�o�r�r�s�w���m���AHTrm�UnAa;A�I�M�K,G�BA7A�A�A�@�>j=F<w;�:�9�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!� ���
(/6=BEGILOS
X	[^afnu~�� �����������������������������������������������	���*�4�:�<�?�C�I�O�U�\�a�f�m�x؆ד֭մԸӻҿ�����������������	��#�,�0�3�8�?�G�N�U�]�c�i�r���������������ųͲձ������$�H�i md\�H>�>�DgJ�K I EB�@�@�@m@c?�=�<s;�:�9�8�7�6�5�4�3�2�110/.-,#+(*.)2(7'<&A%F$K#P"V!^ emu{������������������
�	�	")5? K�U�^�d�y�~���������������������������� �����'�/�7�>�F�O�^�k�x߇ޑݘܞۥڮٶؿ���������������(�5�=�C�J�R�]�g�p�zƄŌĕà²���ҿ������ �*�5�@�J�T�^�j�{���۸`���)�P�f4f�W�H@�?DJH�I/H+EYB�@�?�?q?�>�=N<;:'9K8f7r6r5o4p3w2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�##"!) 3;CJQ[ckt|������������
�		'09CP^ k�x����������������������������� �/�=�J�T�^�g�p�z�����������������!�0�<�F�O�Z�e�p�|ԈӔҟѪж�����������$�0�:�D�O�]�i�v���������Ǽۻ������*�5�@�L�Z�g�[�M�`�F5eU�dGb�UDJ"BX@�BF�G]GHE�B�@�?�>�>�=!=<�:�9�8�7�665%4)3.251@0K/X.b-l,u+~*�)�(�'�&�%�$�#�"�!� �".8BMYfs����������
	&3>IWet�� �������������������&�3�?�M�^�n�~������������������ �-�:�G�T�c�uވݙܪۼ�������������)�8�F�c�q�~΍̰͜�����������)�7�D�R�b�q�����������ʺڹ����)�>�R�e�t��������4Q+`6`�VNK_C�@�AhDEFsFECAz?�>�=Q=�<�;�:�9�8�7�6�5�4�3�2�110/-.<-I,W+c*o)z(�'�&�%�$�#�"�!� ��"2AO_mz���������)
7	FWhw����� ����������)�G�U�d�r������������������*�9�G�U�e�t������������� ��%�:�M�`�tهؘקֶ�����������'�8�H�Y�i�yʊɜȲ���������.�>�M�^�n�������úԹ���	��,�=�N��Ǔ�$\}3M\S^�W�M�E�AA�B]D"E�D.C\A�?^>m=�<	<F;e:i9b8]7b6o5�4�3�2�1�0�/�.�-�,,+)*8)G(V'd&r%�$�#�"�!� �� 0>M]l{��������':L
_	p��������  �'�8�H�Z�j�z�����������������-�@�T�h�z��������� ��$�6�H�Z�k�|ߎޠݲ����������,�@�U�k�Ӓңѵ����������#�7�I�\�nǂƔŧĺ���������8�O�f�}�������ѷ���	��{���>�1���"u<�Q,\�[V�M=FB�@�A�B�C�C�BA�?>�<<W;�:�9�8�7�6�5�443)2=1O0`/o.~-�,�+�*�)�(�'�&&%)$;#L"^!n ��������+;L^o�������
4	H[o������ ����(�;�M�`�r�����������������.�@�S�g�}�������� ��'�;�M�`�s���߯����������%�:�M�a�u՘ԭ����������%�;�S�l˅ʛɳ��������"�6�J�_�s�������ȼ޻���2�G�]�r���C����ޤ�'1�G8V[X�P|IDCA�@pAPB�BTBWA�?�>== <3;`:�9�8�7765 4.3>2Q1f0y/�.�-�,�+�*�)�(
('0&D%X$k#~"�!� ����(;Nat������� 4G[n
�	������3H a�v�������������/�B�W�j�~�����������$�9�M�b�w����������
��5�I�_�t݊ܞ۴��������$�>�W�nӇҠѹ��������'�=�R�i�Ȗǭ��������*�A�X�n�������ɻ����$�;�R�i�������j�/�@2�FFT$Y
WQdJ�D�A|@�@AwA\A�@�?^>=�;�:�99:8a7�6�5�4�3�2�1�0�//.4-H,\+o*�)�(�'�&�%�$$#/"C!W k~������ 5I^r������#9N
c	w������ 6 L�b�w��������������#�9�O�e�z����������#�:�O�f�|����������0�F�]�sފݠܷ��������)�@�X�rԍӧ��������(�A�Y�pˇʞɵ��������,�D�\�s�������ӽ���4�L�d�|�������ݽg՘���M4+}?�NYVW+SPM�GoC�@
@�??@\@@l?p>H=<�:�9�88/7R6s5�4�3�2�1�0�/�..&-<,Q+g*{)�(�'�&�%�$�##""8!L bx����� -Qg|����� ,AXm
�	�����
 6Lc z�������������1�G�_�u�������������.�E�]�t�������� ��0�G�_�w��߾������-�D�]�t؍פֽ�������7�N�g�Θͱ��������,�D�^�vŏħ��������$�>�W�p�������ո��!������H�P)Zp%79]ISV'T�O'J�E6BW@�?f?l?C?�>G>c=V<9;:98)7F6f5�4�3�2�1�0�// .5-J,a+v*�)�(�'�&�%�$$&#="R!i ~�����2H_u������+AYo�
�	����7Ne|� ���������"�:�Q�i��������������'�@�X�p�����������2�J�c�{����������'�@�Y�rۋڣٽ������ �:�R�l҆ўи�������E�_�xɒȬ��������-�F�`�y�����Ƚ����0�J�e�~�����J�u������	�p0@AQMYS%ThQ�LKH\D�A�??�>}>=>�=!=F<I;>:19+8/7>6T5p4�3�2�1�0�//..B-X,n+�*�)�(�'�&�%%#$;#Q"h!� �����
!8Og~�����
5Kcy��
�	��3Kc{�� �������$�=�U�n������������'�@�Y�q�����������9�Q�k����������5�N�gހݚܴ����� ��4�N�hՂԛӶ�������8�Q�l̆ˠʺ�����
�#�>�Y�sÎ¨���ڿ�� �9�a�y�����·ܶ�O��6������,�<>IdP�RNQ�M�I�E�Bx@?I>�=z==�<�;�::9876!554M3g2�1�0�/�.�-�,,)+@*W)m(�'�&�%�$�#�""(!? Vl�����1H`w�����8Oh�
�	����)B[s� ��������	�!�:�S�l�������������5�N�g������������'�?�W�n����������.�H�b�|ܖ۰��������3�L�gԀӛҶ�������:�T�oˊʤɿ������*�E�`�{���ſݾ���(�B�[�r�������LԼ�
�3	� 1�?J�OQ�O�LbI�E�B�@�>�=B=�<><�;;A:e9w8�7�6�5�4�3�2�1�00/6.M-e,{+�*�)�(�'�&&%5$L#d"{!� ����
!:Qi������)AXo����
�	
	!9Pi����� ���1�J�c�{������������,�E�_�w���������
�!�:�R�k�����������2�L�f��ߚ޵�������8�Q�lׇ֠ջ������4�M�f�}Ζͮ��������,�C�]�vőĬ��������5�P�k�������ٹ�����Q��֊�F�|s�+�9�D�K�N
OM%J�F�CyA�?,>,=j<�;0;�:�9938L7]6j5�4�3�2�1�0�/�..'-@,X+o*�)�(�'�&�%�$$'#?"W!n ������-E]u����� /E]t��
�	��8Pi��� �������1�H�m��������������-�D�]�u�����������(�B�\�u����������%�=�T�mއݠܸ����� ��3�M�gՂԜӷ������!�<�W�q̌ˤʼ�������:�R�jÃ���޿���0�J�f���������Č� �W���q��!l0�<�EEKeMMOK�H�EECA.?�=�<�;;S:�9�88H7h6�5�4�3�2�1�0�/�..+-B,Z+q*�)�(�'�&�%�$$-#C"i!� �����	6Ld{�����
":Rj���
�	��$<Sj��� �������-�F�_�w�������������6�N�f�}����������(�B�j�����������/�G�`�xݑܩ�������
�#�=�X�qԌӦ��������%�=�T�mˇʠɹ�������4�N�h�����Ӿ�
�"�;�R�k���Ē������� Q�/)j4�>F,J�K?K�I\G�D�B�@�>P=$<);N:�9�8�717]6�5�4�3�2�1�00/+.?-S,j+�*�)�(�'�&�%%$5#K"b!y ����� -D[q������(Nf|��
�	��3Iaw�� ��������8�N�f�|�����������	��6�M�e�}�����������'�>�U�m�����������*�C�\�uۏڨ���������F�^�wҐѧп�������9�R�lɆȞǶ��������1�I�a�y�����¼ܻ�����������M���w�C w-�8�@LF'I�I]I�G�E�C�A�?#>�<�;�:�9�8�77B6j5�4�3�2�110+/>.Q-e,y+�*�)�(�'�&�%%%$;#Q"g!| ������+@Vl������3H_u�
�	����'>Vk� ����������
��D�[�q��������������'�>�T�l�����������#�;�R�i�����������!�8�N�f�}ؕ׭�������	� �8�O�g�Ηͮ��������#�<�S�jłĘñ��������7�N�f�}���ܼ�śҵ�r����� ��6�'3�;B�E�GHLG�EDCBs@�>D=�;�:�9�8�7�6615S4s3�2�1�0�/�..-+,=+Q*e)y(�'�&�%�$�#�"	"!3 G]�������&;Oez������#8
M	bv������" 9�N�d�y��������������%�;�P�f�{�����������(�?�U�k�����������&�<�Q�h�ܖۭ���������2�G�]�r҈ўе��������&�=�S�j�Ǖƪ���������4�J�a�w�����A���;ڰ�e���1�����;�)�3u;�@<D�EKF�E�DJC�A@�>=�;z:Z9O8T7d6{5�4�3�2�1104/I.^-q,�+�*�)�(�'�&�%
%$0#C"X!k ~������/BWj}������1D
X	l������. C�X�l��������������� �5�J�_�s�������������(�=�R�h�|����������
��3�H�^�sډٝز���������,�@�U�lςΗͬ�������� �5�I�_�uċá·������
��7��N�����e�B�7�@�����J�$y.z6w<�@	C2D[D�C�B�A#@�>L=�;�:�9g8[7[6c5r4�3�2�1�0�/�.	.-1,D+W*i)�(�'�&�%�$�#�""!+ =Obs�������)<Nar�����
�	�,>Obs�� ������������0�A�S�f�x���������������3�D�W�i�|������������(�;�M�`�s݇ܛۯ�����������2�E�Y�lрЕϩν���������-�@�T�i�}Ēå¹���޿�����\ͧ׉�4�G�������{�%�.�5�:�>�@&BxB'BhAb@2?�=�<g;0:9�7�6�5�4�3�2�1 10$/7.I-\,m+~*�)�(�'�&�%�$�##"$!5 ETfv��������,=N`�����
�	��%7HYiy ����������������%�5�E�U�f�w����������� ��!�3�D�W�i�z�������������&�9�K�]�n�}֎՟԰���������,�<�L�]�n�~ɑȢǵ�����������/�@�Q�㽝�9�x��ۄ�����w�����?~�D%X-�3�8]<�>@�@�@@G?O>;=<�:�9�8�7z6o5j4k3p2x1�0�/�.�-�,�+�*�))(%'5&C%Q$`#n"}!� �������-<K[iw�������
�	�(7ETds� ����������������
��)�9�H�W�e����������������(�8�G�W�g�w���߳������������ �0�?�M�\�j�y҉љЩϻ�����������$�4�D�U�f�vÅ�����ľɿ,�͹�0���K��������zi""*{0t5+9�;o=Y>�>�>>_=�<�;�:v9e8T7F6<554232241:0A/I.S-_,k+w*�)�(�'�&�%�$�#�"�!�  (5AM[ht���������)6
B	N\hu����� ������������ �-�9�E�Q�_�l�x����������������	��%�2�>�J�X�d�q�~ߍޛݨܶ��������������=�J�W�c�o�|Ί̥͗˴����������� ���*�9�F������ȊЇ����}�����}��5� �'�-�2Z69�:<�<�<�< <z;�:�9�8�7�6�5�4�3�2�1�0�/�.�-�,,+*%)0(9'C&L%W$a#k"v!� ������������	'2<GQ]gq
{	��������� ���������'�3�=�G�Q�\�f�q�|��������������������"�-�8�B�M�Y�d�p�z݅܏ۙڤٯغ����������������(�4�@�K�U�`�j�t�Ƌŗģïº���r���:̀���y�f�h�|����7�g6���${*B/3�5�7j9K:�:�:�:5:�9�8#8H7a6r5}4�3�2�1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!�  '19@HOX`hpx�������
�	������	 $�-�4�<�D�L�T�]�e�n�w�����������������������������$�-�5�=�F�O�Y�a�h�p�x׀։ՒԛӤҭѵм�������������	��� �(�1�:�D�������C���u�T�t���P�"���/�[V�#q(�,�0X3v5�68�8�8�8�8=8�7
7M6�5�4�3�2�1�00/.-!,&+,*1)6(;'@&D%J$O#d"j!o ty~�������������������
�	���
% ,�2�7�=�B�G�M�R�Y�_�d�j�o�t�y��������������������������������
���� �%�,�2�8�>�D�I�N�T�[�a�g�m�r�x�}ȃǉƏŕě���cį�\΄ԕ�9�B��G�H�������h-�!�!�&+_.13�4�5r6�6�6�6�676�55g4�3�22!1;0P/a.o-z,�+�*�)�(�'�&�%�$�#�"�!� ����������������������
�	��
 ���"�%�9�<�?�A�D�G�I�L�O�R�U�Y�\�_�a�d�h�k�n�q�t�v�y�|�����ߌޏݑܔۗڛٞءפ֧ժԭӰҳѷкϽ������������������������ċȔ�/������)�����k��K�9 ��jl� 6%)%,�.�0;2_3+4�4�4�4�4�4"4�33^2�1�007/W.q-�,�+�*�)�(�'�&�%�$�#�"�!� ����������������������
�	��������� ������������������ � � � ����� � � ����� � ������������������������������������?�d��ɀ΢��ؤ��
�w�c������ �
D$^� �$#(�*-�.P0_1 2�2�2�2�2�2]2�1h1�0%0o/�.�--3,Q+k*�)�(�'�&�%�$�#�"�!� ����������������������
�	��������� ������������������������}�{�x�u�r�o�m�j�g�d�b�_�\�Y�W�S�P�^�\�Y�U�R�O�M�J�G�D�A�>�<�9�6�3�1�.�*�'�$�"�������o��x��ϓ�Cٲݿ�]��?��?�����t�
��=#!|$R'�)�+:-y.n/ 0�0�0�0�0�0}00�//�.�-(-i,�+�*�))9(P'e&v%�$�#�"�!� �����������������~ysni
c	^XRLGA;60 *�$���������������������������������������������}�w�q�k�f�`�Z�S�M�H�B�<�6�0�*�$������ ��8ȓ�/�]ұ�����s��y����������� �o�y�V!($�&�(@*�+�,�-&.�.�.�.�.�.|.$.�-6-�,,]+�*�))M(v'�&�%�$�#�""! $).010/-)%!�����
�	��������� ������z�q�h�`�W�M�D�<�3�)� �������������������������|�s�j�a�X�N�E�<�3�)� �����������������ʻ�]��
μѬՓ�Iݷ�����*�)����� Z�x��LZ"G$8&�'4)M*.+�+W,�,�,�,�,�,g,,�+%+�**[)�(�'-'b&�%�$�#�""(!: HT^ejmoonkhd_YQJSKC:0&
	������ �����������t�h�\�O�D�8�,��������������������t�h�[�N�B�6�)�������������ԺӮҡѕЈ�{�o�s�g���g��p�֕���-��������������M���f��-Lt �"S$�%',()�)1*�*�*�*�*�*�*8*�)m)�(d(�'''z&�%%<$m#�"�!� �(9GR[ptvwvtplf`XOF=3(
	������ �������q�c�T�E�7�'��
��������������p�a�P�A�2�"����������ݴܤەچ�v�f�g�X�G�8�(��	������̍���zЈ���	�%����D�(���8���������	M"��|�� �"�#,%&&�&�'(p(�(�(�(�(�(J(�'�'#'�&&}%�$.$x#�"�!(!b ���� "/9AFIJIGD?92) 
	�������� ��r�c�Q�A�1���������������m�[�H�6�"�������������y�x�e�R�?�,��������պԦӔҀ�m�[�S�Z���H������s���� ��G���s����V��
L��h���
!K"\#A$�$�%&a&�&�&�&�&�&L&&�%>%�$F$�##{"�!!^ ��+Op�����������������
�	������qbQ A�0�����������������p�\�G�3��	����������r�n�X�B�-�� ����ݽܧۑ�z�e�N�8�!����������r�"�u����i���D�k�_� ���T�����@���� ��L3�1N2�V�� �!x"!#�#$_$�$�$�$�${$C$�#�#G#�"Z"�!@!� �P��P����)?Q`lu|����}yr
k	bWK?2#��������������o�Z�D�/����������x�a�H�B�)����������}�d�K�2�������شך��f�L�7����ҷ���]���#�\�m�Q�	����O������ � �I�
�>���w�/LC � Z!�!)"k"�"�"�"�"k"7"�!�!@!� [ �I�j�D~��6Xt�����������
�	��������� v�e�R�@�-�������������|�e�L�4�� ���������u�[�?�#�����߶ޙ�}�a�D�(�����շ���SԲՓײ��������{���N��������s�7���D|y	<�5�g���+� Q � � � � � ` ( ��0�M�A�k�Q���-W|�����!(.0
0	.+$ � ������������{�f�P�;�#����������u�Z�P�5����������l�N�1�����ܷۘ�y�[�;�-����u�I�=�4�����%���������|���@���E�����z	d��T�q����r
��?y�����Y��"�B�:�m�]��Gu���/AP]g
m	rttroibYN C�6�'���������������t�\�C�)���������y�\�=�� ��������c�B�!� ��ٿ�،ش�=��ܸ�t���#�y��������������3�f�v�\��	),�?��
��m��?~������[�}�=�7�p�j��,b���,G`u�
�	��������� ��������y�k�[�I�6�"����������|�b�F�*��������u�h�G�&�����ݠ�~�u�L��8ܭ�<���X���)�m����m���*��(�3�'����/���
�hv���j��E��������n.��+�L�J�(��?��\���&Nr��
�	���
 ""  �������������������s�]�E�-����������j�K�,���������e�T݀ܡ�lݕ���Q���W�����a��.���S�'�����U�� -bq\	#�N��%5)�v� \�� +&���R�N�q�s�V�"|�f��R���
�		6Ndv����� ����������������~�q�b�Q�?�-�����������j�M�0��������p�Q߮��ޯ߾���1�m���������9��������`�����$�����0 ��	2��8Y`O'��/�%��Cduzq\:��F��'�>�5�r�&w�
K���
.
Y	�����$5CN X�^�b�c�b�_�[�S�K�B�6�(��	�����������r�X�<� ��������������������������8���m�2����������i���� ��B�f	�
Plq_7��E�G�K��������h2��Q��"�0�!��Y�\��/l
�	�	5]���� & 7�C�L�S�Y�\�\�[�W�Q�J�A�6�)�������������x�_�D�'��/���L�5�.�'������Z� ������M�T������*�A�?�!��)�	H
x�yiC�`�p�>��+CPQG1��s,��!�G�P�?�u�'x�

N	���.\����$ <�N�`�n�y�������������������w�j�\�K�:�'���������!�7��m�@�������P����&����������.�/����� [�a�
=	Z
bW7�l�	s�]���������R��;�~�,�(�t�5�
�	0	y� <t��1Wy ������������$�.�5�9�<�=�;�8�2�*�!��
�����������#��=����|�8����&���-����S��h����������p�-���c�B���	
�
��K����W�� Kj~��ycC��l!�s�9�K�@��
�	A	��9��C{��9 a�����������	��*�7�A�I�O�S�U�U�R�N�H�@�7�,��6�����(���~�(���b���n���G����H�/��.�����O�	���J���?��=MK8	
�
�E�o�a�i��!4=;0���o0��C���.�,�

~	�F��M��-o��(\ �������*�J�g�����������������������������������A���[����������H���������^�����;���c���N�� �'L_bS5	�	|
!�3� ��'h��������b(��O��8�^�
k
�	b	�C�p�!s�
O�� 
 A�t��������C�c������������������*�.�4��~�� ��$��-�������0�w����&����e���d���`���,�z�� ����l	�	^
�
h�B��3m����������}M��C��4�
a
�	v	�v�a�7��W�N�� # d������?�m��������'�E�`�w���������'���&�{���^���H���w����P�����b�\�����9��� �Y����� -<=0��l�N	�	S
�
)��V�����������c1��o!�
s

�	A	�Y�\�J�%��M��N� ��8�z�����0�e��������B�f������������������`���3����N�����R�|���7��;�z����Z������� ���x2���!	�	�	^
�
�
6m���� ����yI�
�
G
�	�	D	�z�$�&���[�y� $ u���
�N�����
�A�v������,�Q�u������������Y�� �|���%�n�����?�_�v���!���B�u��������#�$ ��o&�q���O	�	�	8
r
�
�
�
	!"�
�
�
�
`
)
�	�	`		�b�7�T�^�S�9�q� - ����*�x���	�K������8�k��������C�x���/�q����h�� �C�}��������.�=���F�7�E�b�������������� sE��e�6�8�r�	Y	�	�	�	
0
C
N
R
O
E
4

�	�	�	{	D		�y+�|�Q�q�}�x�b�;�  d����k���	�S������\������?�n���H�:�[����&�q�����4�g������������3�������������������w�Q "��T��)�1�u�!j��	>	_	y	�	�	�	�	�	�	i	L	(	 	��b"��B��3�f����
}� [ ��(�����B�����<������\������L���D�:�Z�����T�������,�Q�p�����������W����������������[�' � �T��+�5���4��:h�����������yR%��}:��R��?�p���� ��i���:�����X����a�����D������u�9�8�Z������?�v��������2�C�O�T�S�u�����w�Y�>�#������t�3 � �8�d�l�Q�n�D|���.<EGC7'����R��Y�j�R���(�.� $ ���{���M����p���!�u����_���;��#�H�y������I�s�����������������#���U��������Y�!�����K � �+�@�4�	g�W��2Xw��������|`?���I	�z-��'�c���2� 7 ��.��������_���%�����8�����C������� �O�������	�-�K�d�w�������������9�����`�'�����g����h �"�!�h�l��2g����',&����X'��x5��O��D�}�6� H ��M���C���,����p���8�����O������������9�d�����������	����
�
�N���p�"�����<�����B���w ���i�+��^�� )Mk��������|dF#���k2��j�|$�j�5� T ��g���k���a���P���.�����b���q�U�_�z��������;�Y�r�������������������Y�����D�����A���{� � ���O�P��P����
.7<;5)����X'��|;��_�_�<� i �������������
�}���\���?��������6�\��������������������L���S�����5���n���� � ��[�o�	L���#Jl�����������wZ7���J��C��T��E� }  ��;���R���^���\���M���4�����z���������	�(�D�[�n�|���������|�n�l������'���U���{���� � � k�5��8��Au���-BR^efd]P@+����S"��t3��X�\� A ��t�	���(���;���A���<���A�
���
�"�A�a�����������������������������[���[���u������� x � M�d��@���&S{�����
	�����|X0��g,��c�z%� s  ��O���|����)���8���<����l�r������������#�<�H�P�S�S�N�E�8�&�4�w���X���^���d���Z���< � 	h�d��1k���"Day���������~hM/���^(��t1��S� \  ��F���|����8���P���a���������*�F�`�w���������������������������e���W���N���:��� w � 3��&m��%Z����0DP]ehhc[N>)����a3��X��F� � Y  ��O�����)���Y���{�	���`�M�R�d�{���������������
������������Z���2��������_���( � � 5��X��1\�����!" �����c<��~F��G � g  ��l����W�����'���P���������������  RSRC       [remap]

importer="wav"
type="AudioStreamSample"
path="res://.import/hit3.wav-ed4896f054961754d35d19f6edf1f831.sample"

[params]

force/8_bit=false
force/mono=false
force/max_rate=false
force/max_rate_hz=44100
edit/trim=true
edit/normalize=true
edit/loop=false
compress/mode=0
           GDSTA   A           �  PNG �PNG

   IHDR   A   A   ���E  �IDATx�͜Ml��d�q>L��,f�J�+�Fj�@MN���@����v�ą�!��V=�v���Ֆ��=5uU*u1JT)w���6�B(��4&�Lp�|��x����'(�J2y���?��|�ޅK�b1��ۆd2�Jn��@���.�Y���'	,�i��$�|+�` ��,	�!0�A�0d�"A��?���S� 0�����H��@?�C� ���D�-	����_�!�
�aG�%	D��X�ׅE��ȩ�UI �����}8hE5"*H �6	;S��0\�%ʉ�+�Á�V�;� 0��$�hA	�9L�B����%
����2::��ȽZ�0чa8��XDH���K�.q��9�2�d����%�����Ql��ID8j��x@����	0�28�1����$��:��p��9N�<%\>������Y0���Xx1s�u���G7FT3����eb���Q/��`x4�v�Hh�����'\���ǽ�y�e.cE�gapGGԵl4��EL��bZT#!����wZ1�|����ء襊�����pv6�ZV�5{R@�K.'�s-u-;::V�y8�@ײ�m���ن���[�\�����l�a6��Vf�/�����Vf �u���{Rq@*�*	����\�o�g�������c�Ɲ�hʦh���޻���^��F}���d��X������[(����駿-��p��e��' \���O�g��k�&��/�U��!5 JQ���o8Ig�:����d�N�r/��F�m�>�+:���9B0���u��7o������K�8u��W��~&�_/Yh�p*>#��PL��N��&���u_�c� �}����6�t:�_�����h>������=
�Mϒ��Sbm�A�1}wۅ�a����Ѝ�l�"u�]Ro�#�)�//�f�K������LNN29����O���5H��`�xےS�a���a��|>|A�C �o\� ���V��6�" ��f
��t��$�M�l�\u�΀Z�s��U[ ]�����w�uEl� �p����	;nwUS-�(ф��t�xSֽ�*,[�	�P3�(��b��G�S�	�*3�5W�%���'�I �7sW�r-	Wr����e4eS�3�@���w��A͌��Kɘ��-ɨ6`�9 I�����0��	}uU�C�zp��)���*[)�X���O9�sq)¬�)�\���`�29��-q�cZz��̰�	.ܤ��EfowI2�f��Ri��5^�Z�ŋ =@¬��� 53�^cƷ��kT�"l���A��2��WɅ�P�:�Ǎ�M(��-wё>Mh�56��O�j��w�}�hZ��C/�3dz�<��X|9��}w�~�lY�o#��g��d�o<
���;�t7�1
�	�Ը̞>���_/��vO�_�w��oВ�Lr|N��B�]��}];F f�%����}��SH�+�޵��x`�>�L��JK~�� ����U1�/�8j���O�a���`"�N�d�������k�2�_o1	���-۹fi����ro/N��Cͅ��OJ^x1	I��TC�@�e��d�+�Ӡ_ӥI(y���j�uOj��-�S���r���@�����T�\*
���I��	���a�j$!�-\�	��
��c�����C�+�ZŰ��k����+ÊVG0�T�{�-NN��8'��Si�0���g�M�q�M�h�[�%yDN�= �)�S4�o�]�B�t�����v�hXP�����`���Ǖk���)t�,����qוֹ�Z�c�[n�H&�(�T�j�x����n�V�>Z{x��U�۫��VG��^�߶N���	����"���mq�|�g�|���O�RƉV�����S#۹F�'K�p���&����'����d,�Si	�1��}37~E�6��ё�׈$F�l�`d���l��Y�S��״]H �  �Z�p`v�`A0Qg��*H�pws�q������ ��c|W��ۇ)��c�&"u
�o�uc̈H�m�y	L��	K� x�2�P�)1�o�}j  ��
�+����wX�� ]���+ø*�M턘w���͝�j��p1\ޘ��ua�{�g�e��>���'��9/���3�;�����?i���=�    IEND�B`�            [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
      GDST   X          �\  PNG �PNG

   IHDR     X   �v�p    IDATx���y�\U���Ϲ��Iw��+���-!�EqEP�U@t��}��~*���8 �""(:�	!d���I��=�?��������Nޯ�']�n�{n�ͭ�g�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        L�  �ڌ�7&����� `t�j �L� ���7 ��qu�����L�b( �xqE�Q.�X� �T @q*-t  �sP�/�t��E��JzR�_$��f��'�,I'K�'�)IOK��4��c'�ч+7 �"9���Hz���%-�T���Α��A��~��5H�?��h�
>�J�{�;I�@   p�Z��c���Bk�m��f���'�/�2�>�}7��za��3   �dQ	���^l�����7͊��2��')��Y��7|���@   ȧ*��Z��Z{��v_�5��m=���;����c_z*�g����>����C�w��m=�ӆ���1�+�� 
�N� P�ҨD�Iz���tb���w�kņf=�y�^غO;��H��M�׵���p��;��o����H���v�>s�J���M�4qL�L�c�7��Y���*Ku��OI7H�URo� ŉ�3 �$�zI��IIӒ�c��Z߬�^k�?��Ӡ���q�N�sHt�I�P�O3 �����Y���^٣o��R����_�E�6i�aM�=�.�aI�I?�t����<���b�� �T����$�\����t��ѵ����]zuW{Z��4�J7}�D��x�ɟ�tm����}� �3��y2�[}�Ok[kwZ��T�7͟�79Q5��6m�t��{� P\�:@�
�ܟ(�q��^�[��������S�nl�������p�w���I�+`Z�H��W%5F�]�U?y�Ռ����g6�-GM�)���*�%�"iEP Ņ�3 ������.�N���l�nݱ|���v崿��R��E���|Sҗ3����y��;�+��ں�s*߄�J����:k�$U��ľ�IG'� @q�� E*  yQґ�'�[�Ew�؜s�>څ'Mו���O�%g`���
��.I���t�ӛ]Q�Ue���i������/I:*:�  ���z @��<�f���C��]�M���9V��2��_|�u��U����<Y�;69�� #�  F�a#��!嬷PX�56�Ӓ�b�<ŷ�W+43א{�ݪ��A�e�����N  yA  �ǰ �*�$�q�6u�kP�P��m
L�4�P�L8m����J���t�sn[?"��	@ `�" ��cX%�*��Dg�������C%MVh��Ҩ��pڔ�6C�[�=6�q&�$��� G  �ǰ $]�"�yv�zs�:�7���Uq]���./�M" �Q�  F�a��nH�����_^ܙ�ukm�E��;��ٗ��I�*��~�� �D�-$ @���� D�~�b����hw{�v��hO{�z��7�A?|�xFU�%�(-�!u__��uzdm�,UNU� � �����U�-�����^��-I���:zԡ5w�j͎t��Mme������  Ň.X 0z�~�T[^�rܸڊؤ���  E� �Q����Z�;A�æ�j���4���i����~�I��: �  r�M6�}����[T��@�=. �����J'� $F, �R.���<"���߰J����VcM��hџ��� � �BPO���I�BICV������kȮ�(�]�J:6��2�(�o$A d�  2���Y/�I���>+�2�]�K����$��s0v�j�?f#��~&�.��+%��B�Y���A��?A d�  2���Y+�AI�����G�+�ޯ̯��Iz^ҕ�	>�w���q0�}���M6��R�:-�,=���W$}O��L
}�S�;�M�f� ���  M)*�e��(�ټ ����b�rIߔ��-V�C�w�G֫-�"~P��(�eKf�܅S���%}_җ%�Z��m��#iA���t���D00 ��� Ґ"�0�~!�}��IR)}X��$=��tIwIZ��ƽ����v��+vs'��So9B3������$��x���J:#�	��_(�ʒ�d ��� ���b��u��u���u�ӛ�7���
U�o����o���b�+�+��_o{��#ʚm��۞�]Oo�$.��R�[���J����
>}�������=�9@��\� Vܪ�R�~|@�-�	;�u��w�Ҿ�P�����┙:sބDw�wH���i
ݕvshW[���5za��� �`�X���s5�>n������풮�4)vk�\�K���F�n�$��.�u�,Ԥ�U���_ҭ��A+ $�U �H|��PW��i�ں���;Vi[kW��ӛjt���:u�!i���ך��֨���둩��R}�#�tv���M��٣�~wG�k��T��K��zغ#=
��<�(O� H�+$ $�"��"i������s�yN��jO�������5��:�6�������͉ ��t�I���������ڥ=�N�mnM�ߜ�u�ޅǪb��#�G�pD� �� H�TIZ�P4���o߿Z��ݝV�奞.<i�.:i��J�����7�{I�6%�#��3��w�ژ��}������S��?8>'��G���ϙ������j�C  ��:@��7I�Pt��7���7d���c���7��q3$I����=/vB�f4����/�����ӏ���6��w�K�K�E���&�(��D�!�x\ F�������|}������ztFҙ�'�MGN��X����2B���
���s���]z�Ywi3F����Цؗ�#����� �qU�I���V)4��$ikK�>q�Ju�%\����R���ij��;��J�� �u@  J��T��
>�}}�O�	>"]}��91k�4(�*V��-j p�! ���/KZ��e�S����qo�ny���$}>�{B �u  ��|I_�NX��Y\��@�A�ݻr��|uol�$�+@q `T! ��<�f:Z����O�{`�sĬ���o�Z;���+$�"~[ ).� �܇%-�N���ש����vm�������&/��� F Hl���D'��Ь�^�S���<�ʞ��X��й @  �}JҘȓ��A]�`�o�h�:{�̈́6V�s �  6�կߨ]m=�*�TsG�nrcl��-  $����*����b�:�� � @2�F?9s��|��B�E��Y�z㼸!�m   �dn��|t��Ϝ�ڊ�Ŧ��T�x����+t�  � @b����44¸��BW�vh�J������!u�I
�3�� 	� @r�J��脳����3
T������GO�M��B�   H�I�#O��O�i�*�J
V VEY�>��#d�'����� F 3�$z�W�n5���Ic���3�b�]}��4�*:�Wh��y���[ p�! ��,�tCt�ێ��7��~�ܩs��GO�M����8 0�pK bXk�T�P���i�����۞ն֮�(
lҘ*]��>�I'(���~ �p�� @�$�NI+��MUy�����TZ���@W�}�m�b��I�� ��/& d�9I��0gB�޿tV������Sռ���ɟ��� F- ������Nx�	�t��Ƽ�	�s��F���i�ɿ���D�� �� @)*�WJ�8�������� 1wR}��-�>�h{� H�4�& � �$�������<ct�1Z|X��O���r5Ԕ�o�WsG�v��hņ-_߬�m�3��Z��+���&�8�Q�+�X[��RO-�}j����������Z��M~�	\������ H@  	cL�Y��^�5���9DW�v�&���{���SME��7���YM��gkզV��ȫڸ7p\��1��Z�;e���9$p�����__�y�����iO{��X�Iya�H"	w@� $G  )�B�f|}����#5gb]F�[8�A7\~��|j�n{bc��$ǌ��O���N��/���!u�ě��&�|I{�{�W�>  5ƀ @F�b9or�~���2>"J<���<S_9�(U��8.]�T���+��K��(��v��z����X�R\\G� �! �"3��Z_?�h5T��ג���o���P76�>{�\-�=.�j���w�M5� �]� ���V��޵@��/�]]]Z��)�Z�J�{��[_���Z��(-Y�Dcƌ��ɇ��Kf���7��9�b�,�:琸�}���'�ԋ/����y�SӸ&w�qZ��$UWW�WU^���w�>��g��3��� �D  E��%�4yl�`sI�o�;���_���#���<�UTT���ߥ+�w�***�^�h�t-[��h�Oo�օ'N���ӣ_��+�s���?��O��Iuuu���Kt�������4T齋g��G^�[� �� ��c*���'���٩/|����ƛ�����^�qǝ�Ŀ~R{��J���N=�I9�K=͙P���T^��g䃧6l��޽{��O|Rw�����#���]7�x����/���+p�w;Y�u ��G  E�܅SUVY�}_��Ʒ��3Ϥ�׺u���Q==��	���&Mic�K��o>z�~x����e��7=E�,����)�:�Ц�������|A�֥�j�b�
]��������JK<����� � �%����������3�o������K;��[�v婇�Sf����Y���K�����ٷ����7ݬ�^{-�|�y����{_;ev�� @a� @��X��c*�һ��u�m�g��}�O�v�z~Ҭ��1Ue:��i	_?��i��*�*�g5��s�N�����G�n���a�>�+5�1�� �;  P�Qx�����ޞu�Z�Ȳ��AAN:�7�$]���3�9.�)o��?��2d?cU[[��~���� Ł  �@SmE`�s�=�s��y4�Vd5^��$���Ư�b�4����N�w|�њjs_W �; (e���={��wt���*PȗR�SiTˊ��ݛ �Ѵ"< Ȋ�W b-�}��V6缭���n��W߀�d��?諣��"�����t� ��E  E Q�xܸ���2�G�@��Z:^_�cܸ�g����Ϭ� F  P^���2q��r���c�����m9����;^/ӂ���9���������� �! �"��?���K_�x�����>��<�v�iCϟ|uo����W���>����y��4UWWkѢ���WmjUw_�"� ��G  E�5���jjjt�Ef��Yg�US�L�$���תͭY�/+7�hw�$i��)z�[ߒu^_rq`��Ț�Y�	 p�  ���/��ƽ�q�\zI`��T�N���\����?����G�����MC�?�ѫ5uꔌ�9��#���{;	@ ��� @����]7�Uii���j���i�5m�4}翿���:I�֖.���;�֭?=�]�Z�$Iuuu��w���S�����G��׿�5��_��J�y�z�6���  n� @Y��E�yjS\�رcu�u��%�^����E%���D�s�n����<y�$��oP߸�%_�G����k��:�S�N�2E7��z������$���������رc�^�s�&=��%o� d���  w��4yl�N;b�����r}�CԻ�}�{�1�Z���6�����ƍ��ҩ���I�&��o�׷�_ص��li��w����r�*/�TWW��~�3���K��ez�ŗ�w�^���h\�8w�B-=u��[�v�~�Ć>
 @*  Pd���}�jmn��{O�)�zcc��;�<�w�yI���ݯo��%��5~v��˔�6�9��Ь�����z�Qj�)�$M�4Q]|�.� �{Wn�OyU����C  E�J�퉍zuW�>x�a�ژ�T��Z���ݺ�����_.�w��ܦ5�mұfG����gu�i��s�˘�,�--]�y�z=�Zs� A  El��f��Т79Qo�7AGM�/�B���_����Wm���N˱aO�6����q5��o�۩�{�����W���˺��-:o�T-:�Ic�����^غO�٭_کA�f (f  P�}����C}a��*�4wR�k*4��B�}j��ӎ}=Z��=o�=Y���}�=G��v� ��^}���iu��������k����4il�k�UU^����j��՚�j�q�� �? E�{��bCafu��ܩ��r�޺`��O��$��ަ���C�٫�ŷVkw�i�ζ�� �  ��u���g���B 0j�   �C    `��    1   ���J$ �T@    �f� GfO���ه���O-��Go�`���,T�����\�5�j�.���
]$ 8`� �#��Ň���7ૹ�W-}j�PK���>5w����է<�!�(奞�j*�X
.k+�TS���r�V��)*�nW �  �G奞&��Ҥ1UI�����_{;z���O�}j�|=PY���վS��,Ӽ��W[j��)WSm��V����B�e*-��1  ��O��*4��"����}��/h���#\��a��1���TS�� ;n�(PSQ�˗�,t1���Kf| �(�� yd�n�������5�W[�1�e[]��)ɻqe�o������3�N%^~F>�Vkw���Y�m�]��w��XI����?����/4^��O�&�댹�s/( �  \ymO��]�5�뵕�j���������T��*UU^���ʲ����g�y���wD�g4�}�G�w�r�me⟳�A_�����;�����I�;������O{�{4��P�h�� �@  ��j;��PGπ67w&ݮ��L����[���I�U�%*-�40�;(mHy��y��|D�?�^奞��C�gTU>��l��6]���j��S[w��sb�3� G�qSIm��צ�N�n�{���8��c���;�M�+Y]eY\x�k�65w:	>$)O=� �D 8���3�VWY�֮>g���P����K{�{��?��B���cJC�6�M�
�����W��].F2H� do�2�p��QW�vH���_�c���n���O�}��r��Ҧ:L���w�@J�[���,� �7l:��R��Ԏ- .M�:��*hƫ�}�"�3q�hcEY�� �p � C  ��~�z��������e���}���߾�[��Yj���n_��L���嶏� ��� � B  ���d|}���G�$�֞�^�3T��q�I�4�����vK�v �� ���dF��;�Aw��M������3���~�����_�	֯H���Tc�ˇ�mku�����{X���\5���b�x�gT_Y���R�U���7d%    IDATyL�v�[@�7�}���  "  ���
������
5�V����RAw�O�s�N�sH\zW��PP��3���Pp��ӯ���硿'��o����U���.7�aXڌ����=,���,=�"����ڦ�<��-�- ��+�P3,P됴�� � C  �����S"	�7���;�d��]���P�|B������*(��������eHl�$�Y1 d�1  ���E?Yr�8g�t�:ː�֖<t�jq�$��ݯ�Nwk�,:�)6�Ag��A�  rs_��E�59�n�t���
O%- [�0�$��_�?�N��|LL���r����$s 8H� �d���RV�JI�H:A
�>w��l�z'�\�v���آ��jT?l������_�]�fEZ��tiGƀ��׭--]q+����ph�J{O�ڢ���wÞά�'�c&�.B��B��a�t HWL �@@ "IWH�5�w@������
3L���T"��c��mi��M��筻Դ�j}���5��J]��q�D[�@��G�(Zuy�n�Т�uF>%���� @��b@ �
M�:)����[�Ӈ_�R!>~�l�s��fI��! ��1  ��>I�G'��p����>F�������L�M�N�� 9# �$��}��W���ԛ�Py)��Ѧ��D�=kn�w�F������ 2�/# ��-����,Lm��ϙ/�
�a���g�Ք���d_҇$��T p`! �%������6N�r�켗	n\}��Z:;n��J�G���~ @�r@F��ZIOHZ�x�?6莧6�X��e'��eKf�&?��J��A�! ��q��,%	B&+�̈N��?�놇�i�w�H�����o8\�.���VIK$m	z� d��' d)I "I�%=&�1:�ٍ-�����.���U������ע��Λ%-Uh�y  �WO �A� d��?K6��N}��/k��|)̞P�?{��7�ľ�O�ْ�'z/� d�+( �(Er���%͌N���~f�~��Ƃ��}�*���?a��X2S�%qs�l�t��Չ�O� ��*
 9J�H�I�JZ�������W����|1��2F�r�lzHm��OJz�����  ��p �B�Z-�ʠWmj�M��k��e�ô�j]q�,-�sH���K��R��A� ��J
 ���H��%ݤ�LY����o/��oWl�֖.��;(Mk��'Nכ���hA�m
-2�@��> ��� �P�AH��H�<�/mۯ?�ܪ��핟^�3F:vz��[8U�kJ�Cw��O)4�<E��\�+\Q��4�I:U�w�-+��}���;��=ڱ��E�X��V�#��-GMԤ�U�6}\���M�� ��
 y�A r��o)�vHBkw�iٚ=z�����ޛk���+u�Ct��5gb]��_��EIL'o ��� �G!%��#�J�"�c�VmjժM�Z����Yذ��D�'�k��-�Ѡ�'ԥ�C���J�[�`:�!� ���
 # �@D�J�Z�e��Sm<0���mZ��Mkw��]��ݖt2�Qc|}���X�#&�k�z͝T�vG�^�Z:�Shzݴx @�q���a"I�j�X��"iռ%���O��lצ����ڥ��]��ڥ���l)��,Ӕ�*Mo��Ԇj�W�9��P]�I6��e�~#�w��3y3� ��� 0²D�д���겕������ڥ�>�m�՞�^�t��m��WG�:z��hu��RO5���(U}U���PSm���Vh\]��j�5��Zc�ʲ�ŀ��~~��4 Y\u�@�D$i��7HzS�1�U�"��P0�;���а�H�o���Bi��%C�k�V�J
�Ө�i7�db��Ï�%��& (�� P`9"��~b�q���\3-�VJzZ�
��sl�%C (,�� P$"%
M�{�����P���I�v�X�B-���]#�yI/+͙��!� ��� ���`$�'i�B-&�%M�45��$�I��]c%e4�;�>�VߧР�풶I��{K��I�A�Nx @��� �@��d�%5(�T����z�Ƅ�ޯ����=
����^�( P��R�(S�`��t ���U  KPB� �Wr 8�����@ \\� ���T                                                                                                                                    �S� 8�Xks�Ø�|�r\�x<�\�O�K H��$��JT��}_��e���6���]LvLƘ��o�Mx,��#Y�s���X��r�秵6�qf{�A����ʗ�8�J]  -���4����8
��D*�A�/T��E6�e��@�� p&�
S�;�.�~��;��'��e�w.�Q��|���/���,�zN�&��pp  ��t*_)����4ER��Z���F2m��"i��}Y�UE(Ǌ�XI�%Uk�1��%i���L�9�*��R)����:7�+�=�)�]�I�P��&i0�<��k4|� ���dXI7�HZ*�dI�ZkU����nI�ÏJzF�S�veR�TRS@�r��7*tL�%Ͷ�6���ݒ�Jz2�����t�888����t6M�0I�J��Cݒz$�*(n��C҆�kä��;:�!Y��I:U���8k�I�)��/i��U
}����B��)˘Ar��%�n<�z$ݢ��  Iq�@���{����c.�4�q1��笵x�w��W�m�������I�Zk/�t�$��^I5��!�n�*�)eyL�[k���|���y���!鯒^�dpw�-��s}���1�B�;?�Xk�y�/$��jc���^	��S���*�*S�VI:.�{��@,�
 ����P%)I%�k�Hz�F�zc%���9I�m�N������Ic�G%5eS�4m6��@�OՒ����qͲ־�P�������6��n��%��l�+�4��S���ە�J�U(����G�6��je�*��6h��[�1W䩜NcN��<&�@�P���.
�"]a�~e���>k�Ò�����0��b�}V�g2yc�G���Yk�c����4�Z�}k�K��)%ﾔaW�K4���$n���Z��Z{������587�"�4�ϩ���a����w(���F�Y��e�ڻ$MK�����󼡩��1�籜���2(0 ���T�>�4�3��$\y���iT�gZk��� �1��ef������T�l�dkZ�<�磠�$�o�}���_*�g9�2	��8?/�־l��8�2�p��v���F�)�� �1��4cʘ����=�  ��%�� U���+k폔���2�T��&���y��U�9)T��1c�U�� ���>�����c�g��X#��.I��8?+}߿�Z�+�f�*�Zk�m���,�<��IƘq�-�ƘCb�7 �E  -�+��7�<d��|D�Z��?�*4�Ea8<<��Dd�e�L���+�sR|��,I����1�NJ�1�Ƙ?( XOp�̪VFK9��b��T��%�EI*�2 ig�RT���Z�S���ʥk���*6P�.<��g��o�� %8'��9V���ਜ.��������$��h�؏�r(  ���*4]l����Z۟�B���~����*ޙk���H�I���Ϥ�^��1��<韛^O\Ŝ��~/�xw%t�TI�*�IJ|��NX$FK9�����wA��J��Hz�)-��G��Cә��</�Ӭ�?S�M�����uA]�Fi+�$�Z�_�.Ls۸����fg�G���_��������d��@� Ȋ�yc>Y�r$�y޽�iL#���Jk$=�n�k��*����bv��fԷ|Ĳ��D����|��y���ь1_�<�$�����f��@X�X �JR�g��~$˒�.I�ML4#O��k%M�g�\3�|�������DR����t��T��g�Rk�-��D'��hi�7Z�	��@ d$�e�ZI�]�D��w��ߝ���TL�$e�Xk�g�-�.c�x�1fq&o����ȯ��$��nI�#Y�lXk�F�>F � @F<�;���B�#	�y��c�]�P!
W��������Ƙs]�|��~-�w�󼹣��U,k����1i���Hz�@�J��y�$�� \ JRQ������'I�3y�1f��t0}��נ��Ʃ7c�Hg�p��WT|S'gbFl�՚�B*M��
] ů�+ ��1f��w�Ic��B����X��_�����IƘ�.D���L4�Y4���c�3B��k�U�%�?V�+VQ���\ҖB�@�+-t ���߇�v�S��Ƙ�KڪPEkP�8I�}�_l�9U��Dc�&�D�Ƕx�'km��w�^�@+���y���B����1�|���+��? �3R�g���Y�E���1�RI�7ƤjιB�����Z{��yO+tnVK�a�=G�Iy��c�I�Ĥo�4�3;�L���H:'��Xk�y�-il�c�]} �E �@ ���WH�<��6�|�Z{���$��P��1'���1�*EU⭵7c���΍1��Vf\��^6�\e�}2���b��Oç�%�s����1H��-�Ш�N�t���K�1�4����c���b����e��k��?5�|I��;}�s\�����kZ%�|6ƴIz6�L��͹���mOw���� H�+�8A��1g���B�t��c��2H�Ӓ>a��m����Ƙ/J�����;�A���~�g�r ~/�IO&��Yk�$}��v%�25%�MnĄ�q�Bco� i�1�c����-)�1In��~c��>f��Z6|�+%-
���Xkߜ�,R�� �R��: ��@Q�#"�����Z�#I�Kj��%�[}G5��vI�Sh��ogZ�	�Lҙ��<�e�.U��UtY���b��XҀ�2��a^3��I��1�dI-���.M1��[�n3k�����ӹ�o��t��{�_�K�ͦ�Е����#�`" (2��y��0��%}�Z;(���)(IV2Ɯ ���Υc�Ƙ^cL�c����^ �	k��#�CЪ�a�c>�pW�D����1r�b�ٰ��,����dAH�\3�(�Eq��b�g�Jty
��<������ �����Ii|MC�1�j��lxlI��fs�4û�κ�c�*iO��m��Ƈ+�_������e(���J��(�Y�ꢏ'&@^�h?-��})61z|C��2�c��Q9���2`_q��
>��!� �� H�s�uo���L����H%2r�>��Me&�6�[�1	���vI?z!�����pKS�1�:Ge9LR�HV �����k��w9ڍ	��(I���I�k�ޠ�"�Ut�K���r��u.������s� X� @ ��UE}���`�M��%�kIII�]�K�vN�Ͱ�����`���c�-W��ޡ�����1�
q7:j��f;%(�3W��<9�<��D�E��@$ZT��0�Lc��U��� @������~F	���/;�!�#��J�����;#�T�t��.�q�Q��R�%I�8�U�SH4��4G�?��A��}G]�uT���� ��� @���'<k�S������ú�$0"���������I�"W"i����U��Uc���c\�<��u8�{��ϾU�.���?1:0��2�)k��tV\O�E�	�J< h@ ��I���m)�7c�x�Y��%km� '-QwΟwP��?9�k$}�e]�$��\�����)fR�<|쾤:(RI�<�J�k F�:G���kA� Y�mȵ,�}����ce�ee��cs�Ek�$%Z�����c[ꬵk���� Pp.��8�U9�glB�53T+4�QY�\m��IJ�I$���Չ*���j��ǽ/��Hr�}e,��NG�':.W�e܊�9tr�]�:6 (  ��B�n��PI�)������MQ�O|E���C�FIk��WI�'>$w����9TZ��R0"��NG��ڻ:޶lޔ �ls4e.��t�D��y��+�1_ʰ�Z+�(IGc�m����e��f��
ؾ"���<�U� ����c���:�(���'Q燓�R�>�y�5 �1  ���(�zG���tc��	^sU)v���$Yk]#;�<��ԛ�eX 5���wY�(�]��bm (*�� HGo�M�2V�fGy�+Q?'������2�Ի�c��ki��\L��* I�
�k�`�d"Ĩs����hF  A]��166!A�ͥDw�]U��km�~W���
�+�.2�<o�$Q�M޾��j�+�� rF, ���(�#哉D����bnLG���Y.ʤ�5�\,�(I����ekzlB�-R��C�΃��|  '`U��.��}Q�K4>`������]�β+�1.
�yޮ����c����.���z���p���LߐdJ'ߥ�" ń @:� Ƙ�Ƙ��ǵ����ne��G���d��*�����-�r�}e*(�2�L���dU�]�Gș�ƘC$MrP�nk�>G��@�  '���y�e}�1�DGy�kX S�sQq5Ƙ��^Hw��p�R)�M�#( I�X�y�K���E�Ƙ7cJ����(������`T" ��\e����c�0<��^�yl�r�ɦ1]�e��Xk/JT9L��h�y��1.ʣЂ�#jpp��iI�}?08��vk����ZG�g�	�m	
�8*�G� @Q! ���hm	c̅��͍<O0&����~�+��V3�0�|�y�:�3#ы��i���/���!i}l�#-< �c��(ˡ`1�x��Q����#�Z�"�al���<IotT��c�c��t� �O  �
W|:$��(�Jk�����t��+]�N�l�:WH�����vp�1�rTi������`2|\�\�o�}6(��z��|�1����J�E+\��$��(��y�,�� �5�f E*�Q���f���G
_��U����f�$���ܵ�\�y޻�x�$k�\�A���+#��H�8{W>|�x�گ�ڇ�y�UģZ��t�/k폭�cS�8�~�Ƙ+%��U9$=�0/ (  ���?��c>,�V%	,b*��UN�어*�|ck�풖��k�k���D�<�{�Pwͣ�e�����e�Kz<�6u�/I�+�^IU�6�
B�n���avHZ�0? (  �$�����~�������#�^b����r7�HT�ˊk���o�>-)Ug�S$���Y�$��a~�M�0��D�׍1�r���ږ�ʞ���p��)�B�jj�R������Aٷ�ű����};�k� ��  �R���*�<d���ik�]��%�.��&I��^�e��c@�Z~�e��TZk��־$��NThM�1
�������G%�xߏ'�)ʥzIu�ǙƘ'�1_v�3c�]�V��~8pi���k�=��#i�B�>Y�ɒ�1Ƽb��O9>$����@��	��U������<�D������+t7��Zېc�ɺ`I�~��T�;ݙ�g����<�2��:B�*��IO(�2�Z�X��<��J�m��*�Xk�r��2I�־3��<�HժP0 8 � �ğ��b��d��њ��A)ye��s���M�]#��%Ƙ%#��$mIs�'$�,i^�����_[k�%���m� %���c�;�e�р�r%�_H�;b%�k�/}�����@%r�s]��Dۏ��3��y�O�~�@��@�nT�d�H�K��Gyŵ�����֕���=�Iz%e��;%�T�r @>P�T FD�1�K�.D�VBO�I��^�<��ޠ���c>���Lc�������	za��d@4 	%���R��uA�(�I�2�|P�Wx�5I_��u4WZ�����h�k��Jr|w�����[��� �o  �a�	�� )�
X�<I��o�ڛ�Z"�|c��=���<oDV=![=���\20�|L��&G����q }� ����T�7c.���	K��C�Ъ֟R�U��Bx���"���ƘK�`R���1�����nI�NK�{�1{��H��, r@�Z(���1W�v[J��V�|ߏ,L�c�y����.\.��7J
��U  �IDAT\g����Zi��1WI�����a��R�{~J�1U�*���H@B\� ���2{S��K1�I�$�ҷ��Ik���k�/%}<Qw����-�#�1�jI�J�A��w����p�Qk��0ƼSғA/��@ �" ��O�1WH�)tAb${��l��c�i
��^4��ߔt���v�����ߜ��i��PRw���Ʈp��p2�QH@J  ҒƝ�ۍ1K%m��+�]���ݒ�Zk�U1�ľ�/+�KQt2
�?m�Y$�d�:�4���Ƙ�U�L-3Ɯ �B 
� @�Ҩ�=+�xk��U]�r�vc������蝹)+3�+�w��$�Y>�Q--�{'+EW�t��4�{^�	ဲ�gWx��3%mM��($ m  2��bd�m���pkH`���a���1Fя ��#-�J����Zk��Fnf�W�]��"iS$1(I֒Y!=��\>
����gH��1&i �iE<��M��r���ۻ�(�������oQ,�h�@�A��A1$.�e�� �h��I�G�'1:=��L�br��f��n<"h4e=&����N�]����?�ŭ[�[�vuUu����9��~�����������Wv��+Wf�ƈ�Y�FĒ��ɇ�ig"i�M��ňx:p��	�.��2�0�͓�8���~f����̷��Tiǻ<"6 �>>�l�r����X�Y���]���w/��J�	�W O��g�amjD���wG�c�����a����H�w�~]����Y$�X���M��lGm6d����
E�)��̼�(�K2�+T�H��a� o8�r���t�צ��>�,7Dį _�ul���O�3�����h�s�Z��k��� f&/��S �s����C���(����7g�/����>N��O�_�io��/EqAf~:3�Lz�;{�#��C˲|UD<x�?���#�|����,�$�WD�N��SI��88�,�#��"�!�,p���ws�y+UmÏ�������w3���͹�`r��'��^�ߛ��p���QeY��w�l��[�k����ff~�[��F㮥}kL6�w����Y��s&"����GԿ�}���Mo�z�������W3���q��^�k��[ϸW'Y�J�f�}�j~T��{��3��e"ig�WDҪ�ڮ�45K5�cw���c�Z�e�$xd.�)�{�������!Y�Z�k���ۛ4�Z�+�T��ߌ	�������4��d�@o�����(�\�y{�޲�_���')���4 _o�̮��sW����L2$�%I�j�@o=�V�>ή��iw������4<�i�I��	��5�T�2�k�8�Gp���Z\���B���ܕ5;����J�$I�$I�$I�$I�$I�$I�$I�$I�ơ-$I{���;o��N?��5.�$�]v~|>I��0�&����< ����矿h�p8�(��y��q�aÆ5-�$I{+IS�y�=��z��$&�6m��N[��I��w�	�����Mk�DDS��������HҴ3�4�����4�]��+<;"���s#��G���l�%ijL�(�D�����p�%�b����I��2& ���̿��3"�h'���p�f��@��Ur�p�S�n������ �4�L@$M�%j?g��=����e�M�^o��px4�x.��1�KҪ���E�G���l�*i*�J@"b�k��2����qT��^o�H��l������=^�/I��'"�m����,�E� ��g��cv�$���r�g �u���a�!�7nܸhY����V��۷o_�}ff��,�#�،N��5FEQuw����������=�ߣ������5ۼy�ueY�{��n͛�ic"i*��ymD�9pcf�
�{M�
_���n����M@����|������-�	TН�K?|�y�<�z& ͺq�i/��Lr�nY�2j}s�Q&M@"��%MG��4�"�P}]D�ڬt��~��S�a�y��v�������yP��DoG�VٝE1�i'K%�;r���>�M�41�4���À{����o��s;�E��(�m���	�Ӹ�c�rw˼\�]��t��Z��v�ҲM��K��4& ��B;Y�?O�W}��l�\��?� �"`SY�?)˒��h���|�j�ہ� �o���xQ�}�l��T#q� �'���~�����r;p����`q�1"h=x����|xЛ$������aT#�]]�F������;ʹIu/^Y/� �
��)�y�y흖���g����\�3�=xt}�������^?�\�������g���������U�1���|���n���;�������G>�Ŗ�=�}@$M���� ��p6}6o޼l��16Dć���jY�*I �Nf�|��99">��~f^O��w�}�ޕ�O�
L�.���m��e wE����p���}�;?^/�ا� \����lڴi�}yNDl����\KD|xaf`��=>"����t��ܗ�͵�U���n��ֱ���`P�a[D��73?F�L��S�DĹ�7��j1-��F�Z���T��rF�����w�z��Cf����6����]��Fj�m0p�Yg!I{:k@$M����q@f��m�_����K�4�yZ���3�U�}�����GGą1�Dꃁ�GD?3�N��f�Q�nX���x|f��*�ٿ(��3�*��ܘ���cx��xf1/��#������zp"Um�"\p�����Ԉ�U����a�����wf�2���#����[�a��`08��� o��_��X�g�:�;�63�G�O�����_u�pPD��*����γ�yhD���/~��ck������|��pPD<:3/�z6�����`�`0�ɢK���D�T�&�ټ}t���n_��&�h%!� 3�n�����a�#f}~0<��)��c�O��"�8�YT�=�YEq2P���x!���9W��k�s�jJ]��)���æ���e��T��w�{0>�J�D�d������]��}뚠}���8����3sUm�+#���~w��̓��7��\S_����W5Ϸ3r�+�� ��_>���"b�����g����D��Ts���N,n�JJ��,˳��{���� n�O.��a�<�l�̋���E�����d"i��D��d��������zGEıT���t��kn����uҸ�����E���u��u�b��<'3� >5bhݛ����>��De��3��D�>�fA�{���֋^�.������
�_�]Y'	� �����1�Kݟ*��bwH^ #����K��4�Uӷ����\�"x�������_Jռig�#����u����xjDܿy^�s��(^W��u����EY�ò,Ϯ���}���dy%i�d"I�ؾ}{���K��MӮ~�OQ����%3�P����N�-�Q�F���C2�_��zumP%��%u��o ���&�o�����m#��L�}�OQM��Ӛr�2�����ߓ�s����z�A��e��#����&��l۶��dnn������������T��^�����Yfgg盡���5���z4�����j�?"����?G<���I��X�d�C�3�eٮ��w��ffffN�������i�x�(I�{�{�7�β�j25�(
ʲ��t@D�,����̜���(���)���}"��;M�n���F�넺�g�'o��:��f��A�^��#�{���M��KF]g+@�f�����N���e�����֩G5J�[�b}�o��=;;�֭[�g��>�������~&	�(3���5��s�P������������E��q��w�����1��W��F|xИM7K94���6�~���#������n��vޘ��
Ї��� ����F�'�kS�R������;�	��|`D4��]=j�ֽ��.�AM�m��R��R��`q|@D\��z4ϥ�x�����xxD����6Ww����^QՒ�_��K�.d"i��	����^�4�*Pn%�[�é�Q���V򦽓X�Zc��>���H���o?����l�ۿ�j�����w����;n����K�SKm�����[�&�<l�k������|_��Y-��g�l��n9�!�O�j�̑�k|L��mv�v��'3��7{ֈeo��Cd)� ��/�tW�̧�ߢ�4�;������]�����!���z$�uWߏ&Hߺ+�0���Q��=2"��L.�
��$i�f"iZ� ��Ӄmt�G���?rդvWR7���?���b�Pŉ�M�l������E1�o���aQ�׈�s"�]�o	eYޱ�V���1�4��v��FĸQ��T�n5|�*���(��˲\ؗe�e5�i��>���z?�d�X8k��Q�㶚�}G
��G�7|�y[DLt��$iژ�H�V?h�F��1jD<?3G5���7w��ݨ�̐���~eYP���ø�JBF�{W}ݳeY����`�����疺�����w@]�� "�Vg�e��H�F�"i*�g3�?_�W=���m'�hX0��3 "bps�&��i7J>7�z�G6ssLj� �7���P͗��լ���4� 3ڝewQ����G63�O�{1s�$����&iZ]I�����xN������cB���&�m&lO��,w�ur@D�rS�n��LLX����4��,ٰaâ���f�U �~�i�$��}G}� 1h��x"P���%&�\Wu�{E��D��%ضm۶m[�O�Yd&��v��Z�֐	���S��"���7df�3�߼^��NB�]�J,�=�Y��	�3���W��%�� ��[���ٱ ᚴF΢~~}����h��u�}��&)�b�L�͵����^ςu\F5G�C#��o������"Q���b"ij���177���ۛ�_PM�w<�״��5o��2�D�e��/��7���E�̎�+QE�x\�߾;���"�j�ЈxK]&2�;�H oa�����8>3�FN���� �Y�{Q7��-".�o��Q�5.eY�if>v�N���m+��z�_���=&�$����\LIZ7& ��ٍEQ�E���T����}�����Q��D\��|�����=�7_813?��g�j@�������"`[f�23��}en\�&"��Ӕl~�SO=u�i~Ju_3"��'2���ˁWe���\;a04���F�S��gG��LD�="���j��Wf~%3933������:�P��kʲ�$"�Ũg!I{:ISaT�\Ϧ}iD<#"��^��eeY��2pYY��/��x#����R��\��� 3_����EĖ��7�	EQ�|�������x΋+2���0����U��px�p8��\���Wp�M��RuH+pU������
�<�A༝����gsqRY��-��z�Z����7Eħ�����pU��cʲ��eY^|�ճypwf�(3�V��.+�$�6��4���	ܮ �����Z�-F�ՙy�p8|w�׻z�1�D�̼�������T#Bm.��TA�pI�/�!�eY6�E~���F�u��w�E�Yť���]����̼�9D�����3���g�����Dē���>��s1����n8^���_��'�X����<xoD\2���u����g�w3�'��L�Fē3��s��ہ�#�/2�yNw�V��-�s���sou�;�7���m�͂�5G�m�/��6pp4��� 3�A=��$M#�t%M��7���Z��f��"b���}B����9|lD�R%w7��}m���V��i���x�sE1r�Iކ��h�[�P͙�k�=������6m�4���d� P%3[:��������
��9���g�J|�O���G���!�}};S�q�Rպ��?�Q��O?���吤=�M�$M�3�<s��cp�7ڰ8�\" ��do��]7�踗�^I?�1ǿ���.��͈n�j6�֤�?�� ��|n�{[R�d��!i��N�T9��SW%����6V�J��(��w��l%�_�$�;�H��D�߈�G���n�g�cK�V�M�$M�͛7/Z6* n��
��8��;ot���[�ݩ	֨㵚`-0��& l;��s-k5���҄cg���o�Y��F����1���{��ι
M��]�ܳ��=�	�$i�3")|��_�& �"�b���f�u�u���I��p,I�gDm�ˁ���oQM"y�O=RٯQp���c8ĭ$�/I�4��x<��κ!�w�ٙ��I�$i�2�$M������=~0�BDN5�Ե����~�c�a���ͯ$i}��H��B=˷����`A'�Q�%I��ax%I{��䑣tf�'3aJ�vI�^�����J�v�%I{�.�`Ѳ�`��yU����3�\�rI�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I�$I��5������/�    IEND�B`�   [remap]

importer="texture"
type="StreamTexture"
path="res://.import/ldjam40.png-6caf79060feb902d6b49eb5d2026190c.stex"

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
   GDSTX   Y           �  PNG �PNG

   IHDR   X   Y   ���  �IDATx��OhU�?���)�A��xʢF*�b%�S��CP�R� ������jS(ԈT*�b�
����A̖"Rh@�A��x�����������������73;/_~�{���{�������Cݮ@�����ݮ�Bx����w�ly�]D��&��q��wn �Wc�����#�+�����{U�k��_y�WI<�G��iw�o�ρ[I�0)������5�N^��-�$p���V�
����2
�j�_@ƨ,g�{m\�ė�y��T��f����"|���W��x��>�E|\�q^]���C��'�b��ׁ��h�q
�.�������E`�r�WEz8�t��x����j�u�0�[����:�Y��bw	+��&i�.J�"vױ���M:x���`���W���Lt$r'�_Z��".�("u6o[�v���^�QB�m�ڵ%r;�ĝ��]��%�`d����/H�� �d8v��&��/(�i��%̖�!督X�G\�[��kvւǁ���D���
z÷��8�j(_&��F����l��0�<��� _���߹���q�u�K�<�R^��4�TW��c0��=�.�
�5��+�bK�g8�>Fנ����CT�	l�ދ��*n"�h�6��+e;����B3��j҂I�Y��A��:&+V��&�甲
����ڠQd@ք&p}5x��J�����M`՗�o�_�P�^
h���M���B[P( �hO(e1T(mT��D�~A�G���Y㦣�Rn�X�~3=���D㇠�����aW)kz�&(�����1����	3�Y�mTw��&(�S~�20�]f�97l�89�d{&�3�����L&�g�\�^���
X[g�R���A��SN�,؎Ds�cP���K�ŽF}�� �.(����a"$M���Ǡ�ڸ���g2t��g㇠�[ȓ�A�1U(mho6~кiZ�A�еR@w�4�T��1T(m����T�[�,Lw^�T�=��K�@�_�7�<�%��ۖ��P��l���VG3�� f�W�{3T*-�/h'���A3E6���*�D��q
�B	�z�a��c�2d�����B�N�.p�������z#��%��K���x�V b��=k�0̊�"��iSF�xiw�i��8r��]�k�=���ڔL��6p�uqX�������VlʯVER�:����:���0?�6��1��:IȬ�Q����{E�%�4����e"$m7�)�Iɀ��I3�;�c���4�΃'[�)ñ"�ԯ�fqw�㷭��d�y�"�P�~���:��L�"a���v��r��r|��^ve��\�@\�'���	�
�j����}�r�_H`P�	���&�����vH���c˸
1����3`������n	]�(�����!Fia���斸��R��k/W�k;G����څ`I"v��$����h�'�/������2f}�q�S�OB�{4��n��q�2\����,��F��lX��N0y$��<ф��6�!�7�Jr/�<�V��ͅ�5d>!�]����$���"	��E��_�Ӗ:&za?�H�#ķ�Y�	\A���켥����n���
�i�S{��l�EA�����"���L&�g�KȈo���    IEND�B`�       [remap]

importer="texture"
type="StreamTexture"
path="res://.import/white_bead.png-de67a6ccbfa37a69243c3e6dc644552d.stex"

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
ECFG      application/config/name         ldjam40-0not-shrink    application/run/main_scene         res://Main.tscn    application/config/icon         res://icon.png/    display/window/size/width     �         display/window/size/height     �         display/window/size/resizable             display/window/size/fullscreen            display/window/dpi/allow_hidpi            gdnative/singletons          )   rendering/environment/default_clear_color                    �?)   rendering/environment/default_environment          res://default_env.tres                 GDPC