extends Node2D


var weapon_num = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_shotgun_body_entered(body: Node2D) -> void:
	set_weapon(weapon_num, Player.Weapon.SHOTGUN)

func _on_blaster_body_entered(body: Node2D) -> void:
	set_weapon(weapon_num, Player.Weapon.BLASTER)

func _on_laser_body_entered(body: Node2D) -> void:
	set_weapon(weapon_num, Player.Weapon.LASER)

func _on_sword_body_entered(body: Node2D) -> void:
	set_weapon(weapon_num, Player.Weapon.SWORD)

func set_weapon(hand_i:int, weapon:Player.Weapon):
	if hand_i >= 2:
		return
	if hand_i >= 1:
		if GameManager.weapons[hand_i - 1] == weapon:
			return
	GameManager.weapons[hand_i] = weapon
	GameManager.weapons_changed.emit()
	
	$Selected.text = "selected: "
	for i in range(0, hand_i+1):
		$Selected.text += Player.WEAPON_NAMES[GameManager.weapons[i]] + ", "
	
	
	weapon_num += 1
