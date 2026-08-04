extends Node2D

# ===================== MAIN =====================
enum GameState { MENU, GAME }

var game_state: GameState = GameState.MENU

# Player
var p := {
	"x": 64.0,
	"y": 64.0,
	"dx": 0.0,
	"dy": 0.0,
	"angle": 0.0,
	"angle_speed": 0.02,
	"thrust": 0.15,
	"friction": 0.96,
	"max_speed": 3.0
}

var trail: Array = []

# Menu
var menu := {
	"options": ["new game", "continue", "options"],
	"selected": 0
}

# Camera / UI
var cam_x := 0.0
var cam_y := 0.0

const SCREEN_SIZE := 128.0   # matches PICO-8 resolution

# Equivalent of _init()
func _ready() -> void:
	main_menu_init()
	plr_init()
	ui_init()
	map_init()

# Equivalent of _update()
func _process(delta: float) -> void:
	match game_state:
		GameState.MENU:
			main_menu_update()
		GameState.GAME:
			plr_update(delta)
			ui_update()
			map_update()


func _draw() -> void:
	# Equivalent of _draw()
	# Note: Godot clears automatically; we just draw
	match game_state:
		GameState.MENU:
			main_menu_draw()
		GameState.GAME:
			map_draw()
			plr_draw()
			ui_draw()


# ===================== PLAYER =====================
func plr_init() -> void:
	p.x = 64.0
	p.y = 64.0
	p.dx = 0.0
	p.dy = 0.0
	p.angle = 0.0
	trail.clear()


func plr_update(delta: float) -> void:
	# Turn
	if Input.is_action_pressed("ui_left"):
		p.angle -= p.angle_speed
	if Input.is_action_pressed("ui_right"):
		p.angle += p.angle_speed
	p.angle = fmod(p.angle, 1.0)
	if p.angle < 0.0:
		p.angle += 1.0

	# Thrust
	if Input.is_action_pressed("ui_up"):
		p.dx += cos(p.angle * TAU) * p.thrust
		p.dy += sin(p.angle * TAU) * p.thrust

		trail.append({
			"x": p.x - cos(p.angle * TAU) * 4.0,
			"y": p.y - sin(p.angle * TAU) * 4.0,
			"life": 12.0 + randf() * 8.0,
			"r": 1.0 + randf()
		})

	# Friction + max speed
	p.dx *= p.friction
	p.dy *= p.friction

	var speed := sqrt(p.dx * p.dx + p.dy * p.dy)
	if speed > p.max_speed:
		p.dx = p.dx / speed * p.max_speed
		p.dy = p.dy / speed * p.max_speed

	# Move
	p.x += p.dx
	p.y += p.dy

	# Screen wrap (like PICO-8)
	if p.x < 0.0:
		p.x += SCREEN_SIZE
	if p.x > SCREEN_SIZE:
		p.x -= SCREEN_SIZE
	if p.y < 0.0:
		p.y += SCREEN_SIZE
	if p.y > SCREEN_SIZE:
		p.y -= SCREEN_SIZE

	# Update trail particles
	var i := 0
	while i < trail.size():
		var part = trail[i]
		part.life -= 1.0
		part.r *= 0.92
		if part.life <= 0.0 or part.r < 0.3:
			trail.remove_at(i)
		else:
			i += 1


func plr_draw() -> void:
	# Trail
	for part in trail:
		var c: Color
		if part.life > 8.0:
			c = Color("ffaa00")   # approx color 9
		elif part.life > 4.0:
			c = Color("ffcc00")   # approx color 10
		else:
			c = Color("ffffff")   # color 7

		draw_circle(Vector2(part.x, part.y), part.r, c)

	# Ship (triangle made of lines)
	var size := 5.0
	var a := p.angle * TAU

	var x1 := p.x + cos(a) * size
	var y1 := p.y + sin(a) * size
	var x2 := p.x + cos(a + 0.4 * TAU) * size * 0.7
	var y2 := p.y + sin(a + 0.4 * TAU) * size * 0.7
	var x3 := p.x + cos(a - 0.4 * TAU) * size * 0.7
	var y3 := p.y + sin(a - 0.4 * TAU) * size * 0.7

	var col := Color("ffffff")  # color 7
	draw_line(Vector2(x1, y1), Vector2(x2, y2), col)
	draw_line(Vector2(x2, y2), Vector2(x3, y3), col)
	draw_line(Vector2(x3, y3), Vector2(x1, y1), col)

	# Engine glow
	if Input.is_action_pressed("ui_up"):
		var ex := p.x - cos(a) * 3.0
		var ey := p.y - sin(a) * 3.0
		draw_circle(Vector2(ex, ey), 1.5, Color("ffcc00"))  # 10
		draw_circle(Vector2(ex, ey), 0.8, Color("ffaa00"))  # 9


# ===================== UI / MENU =====================
func main_menu_init() -> void:
	menu.selected = 0


func main_menu_update() -> void:
	if Input.is_action_just_pressed("ui_up"):
		menu.selected -= 1
		if menu.selected < 0:
			menu.selected = menu.options.size() - 1
	if Input.is_action_just_pressed("ui_down"):
		menu.selected += 1
		if menu.selected >= menu.options.size():
			menu.selected = 0

	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
		if menu.selected == 0 or menu.selected == 1:  # new game / continue
			game_state = GameState.GAME
			plr_init()


func main_menu_draw() -> void:
	# Background is already cleared by Godot
	draw_string(ThemeDB.fallback_font, Vector2(32, 30), "project evren", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color("ffffff"))
	draw_string(ThemeDB.fallback_font, Vector2(32, 36), "-------------", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color("555555"))

	for i in range(menu.options.size()):
		var y := 55 + i * 10
		var col := Color("555555")
		if i == menu.selected:
			col = Color("00ffaa")  # approx color 11
			draw_string(ThemeDB.fallback_font, Vector2(40, y), ">", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, col)
		draw_string(ThemeDB.fallback_font, Vector2(50, y), menu.options[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 8, col)

	draw_string(ThemeDB.fallback_font, Vector2(28, 110), "enter / space = select", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color("333333"))


func ui_init() -> void:
	cam_x = 0.0
	cam_y = 0.0


func ui_update() -> void:
	cam_x = p.x - 64.0
	cam_y = p.y - 64.0


func ui_draw() -> void:
	# In Godot we usually use a Camera2D node, but for a pure _draw() port
	# we just draw the HUD in screen space.
	var speed := sqrt(p.dx * p.dx + p.dy * p.dy)
	var angle_deg := int(p.angle * 360.0)

	# Reset any camera transform if you had one
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	draw_string(ThemeDB.fallback_font, Vector2(2, 10), "angle: %d" % angle_deg, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color("00aaff"))
	draw_string(ThemeDB.fallback_font, Vector2(2, 20), "spd: %.1f" % (floor(speed * 10.0) / 10.0), HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color("00aaff"))


func map_draw() -> void:
	# Simple starfield (same as original)
	for i in range(41):
		var sx := fmod(i * 37.0, SCREEN_SIZE)
		var sy := fmod(i * 53.0, SCREEN_SIZE)
		var col := Color("555555")  # 5
		if i % 7 == 0:
			col = Color("888888")   # 6
		draw_circle(Vector2(sx, sy), 0.5, col)  # pset equivalent
