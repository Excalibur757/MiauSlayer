extends Node

var xp = 0
var level = 1
var xp_needed = 100
var survival_time = 0.0  # <- ADICIONAR ISSO
var survival_time2 = 0.0  # <- ADICIONAR ISSO
# Função para adicionar XP e verificar level up
func add_xp(amount: int):
	xp += amount
	if xp >= xp_needed:
		xp -= xp_needed
		level += 1
		print("Level up! Novo level: ", level)
		apply_level_buff()
		notify_enemies()
		update_hud_level()  # <-- ESSENCIAL
	# Dentro do loop que passa por todos os players:




# Função para aplicar buffs ao player
func apply_level_buff():
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		if player:
			player.movement_speed += 10
			player.max_health += 1
			player.attack_cooldown = max(player.attack_cooldown - 0.05, 0.1)
			
			# Atualiza a vida atual e emite o sinal
			player.current_health = player.max_health
			player.emit_signal("health_changed", player.current_health)
			
			print("Buff adplicado ao ", player.name, ": Velocidade +10, Vida +1, Cooldown -0.05s")
			print("vida de ", player.name, ": ", player.max_health)
			if player.has_method("play_level_up_animation"):
				player.play_level_up_animation()

		
# Função para escalar inimigos já existentes
func notify_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy.has_method("scale_difficulty"):
			enemy.scale_difficulty(level)
	print("Inimigos escalados para o level ", level)
	
func update_hud_level():
	var hud = get_tree().get_first_node_in_group("HUD")
	if hud and hud.has_method("update_level"):
		hud.update_level(level)
