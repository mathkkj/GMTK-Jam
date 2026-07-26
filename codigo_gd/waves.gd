extends Marker2D

var rodando_waves := false
var wave_atual := 0

var lista_inimigos: Array[PackedScene] = [
	preload("res://cenas_tscn/inimigo.tscn"),
	preload("res://cenas_tscn/inimigos_projetil.tscn"),
	preload("res://cenas_tscn/inimigos_3.tscn"),
	preload("res://cenas_tscn/boss.tscn")
]

@onready var cena_carta: PackedScene = preload("res://cenas_tscn/card.tscn")
@onready var spawn_carta: HBoxContainer = $"../CanvasLayer/HBoxContainer"

var waves := [
	{
		"tempo_entre_spawns": 1.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 3}
		]
	},
	{
		"tempo_entre_spawns": 1.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 5}
		]
	},
	{
		"tempo_entre_spawns": 1.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 7}
		]
	},
	{
		"tempo_entre_spawns": 1.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 9}
		]
	},
	{
		"tempo_entre_spawns": 1.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 5},
			{"tipo": 1, "quantidade": 3}
		]
	},
	{
		"tempo_entre_spawns": 1.0,
		"inimigos": [
			{"tipo": 0, "quantidade": 4},
			{"tipo": 1, "quantidade": 4}
		]
	},
	{
		"tempo_entre_spawns": 1.0,
		"inimigos": [
			{"tipo": 0, "quantidade": 6},
			{"tipo": 1, "quantidade": 4}
		]
	},
	{
		"tempo_entre_spawns": 1.0,
		"inimigos": [
			{"tipo": 0, "quantidade": 6},
			{"tipo": 1, "quantidade": 8}
		]
	},
	{
		"tempo_entre_spawns": 1.0,
		"inimigos": [
			{"tipo": 0, "quantidade": 7},
			{"tipo": 1, "quantidade": 7}
		]
	},
	{
		"tempo_entre_spawns": 1.0,
		"inimigos": [
			{"tipo": 0, "quantidade": 4},
			{"tipo": 1, "quantidade": 4},
			{"tipo": 2, "quantidade": 1}
		]
	},
	{
		"tempo_entre_spawns": 0.7,
		"inimigos": [
			{"tipo": 0, "quantidade": 5},
			{"tipo": 1, "quantidade": 5},
			{"tipo": 2, "quantidade": 1}
		]
	},
	{
		"tempo_entre_spawns": 0.7,
		"inimigos": [
			{"tipo": 0, "quantidade": 8},
			{"tipo": 1, "quantidade": 5},
			{"tipo": 2, "quantidade": 2}
		]
	},
	{
		"tempo_entre_spawns": 0.7,
		"inimigos": [
			{"tipo": 0, "quantidade": 9},
			{"tipo": 1, "quantidade": 6},
			{"tipo": 2, "quantidade": 2}
		]
	},
	{
		"tempo_entre_spawns": 0.7,
		"inimigos": [
			{"tipo": 0, "quantidade": 10},
			{"tipo": 1, "quantidade": 5},
			{"tipo": 2, "quantidade": 4}
		]
	},
	{
		"tempo_entre_spawns": 0.7,
		"inimigos": [
			{"tipo": 0, "quantidade": 5},
			{"tipo": 1, "quantidade": 10},
			{"tipo": 2, "quantidade": 4}
		]
	},
	{
		"tempo_entre_spawns": 0.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 6},
			{"tipo": 1, "quantidade": 6},
			{"tipo": 2, "quantidade": 6}
		]
	},
	{
		"tempo_entre_spawns": 0.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 8},
			{"tipo": 1, "quantidade": 8},
			{"tipo": 2, "quantidade": 6}
		]
	},
	{
		"tempo_entre_spawns": 0.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 9},
			{"tipo": 1, "quantidade": 9},
			{"tipo": 2, "quantidade": 8}
		]
	},
	{
		"tempo_entre_spawns": 0.5,
		"inimigos": [
			{"tipo": 0, "quantidade": 10},
			{"tipo": 1, "quantidade": 10},
			{"tipo": 2, "quantidade": 8}
		]
	},
	{
		"tempo_entre_spawns": 0.5,
		"inimigos": [
			{"tipo": 3, "quantidade": 1}
		]
	}
]

func _ready() -> void:
	await get_tree().process_frame
	spawn_carta.process_mode = Node.PROCESS_MODE_ALWAYS
	iniciar_wave()

func iniciar_wave() -> void:
	if rodando_waves:
		print("iniciar wave ignorado porque ja esta rodando")
		return

	rodando_waves = true
	
	while wave_atual < waves.size():
		var wave = waves[wave_atual]
		var delay: float = float(wave["tempo_entre_spawns"])

		print("wave ", wave_atual + 1)
		
		#aq coloca as info dos inimigos, tipo e quantidade
		for info in wave["inimigos"]:
			var tipo := int(info["tipo"])
			var quantidade := int(info["quantidade"])
			var cena: PackedScene = lista_inimigos[tipo]
			#aq coloca eles na cena
			for i in range(quantidade):
				spawnar(cena)
				await get_tree().create_timer(delay).timeout

		print("wave concluida, esperando derrotar todos os inimigos")

		while get_tree().get_nodes_in_group("inimigos").size() > 0:
			await get_tree().create_timer(0.2).timeout

		wave_atual += 1

		# se ainda tem wave, mostra cartas
		if wave_atual < waves.size():
			mostrar_cartas()
			get_tree().paused = true
			rodando_waves = false
			return

		# acabou tudo
		fim_da_ultima_wave()
		rodando_waves = false
		return


func fim_da_ultima_wave() -> void:
	print("ultima wave concluida!")
	Global.transition.emit("out")
	await Global.change
	get_tree().change_scene_to_file("res://cenas_tscn/credits.tscn")


	

func mostrar_cartas() -> void:
	#deleta as antiga
	for filho in spawn_carta.get_children():
		filho.queue_free()
		
	#aleatoriza
	var chaves = Global.cartas.keys()
	chaves.shuffle()
	#instancia
	for i in range(min(3, chaves.size())):
		var carta = cena_carta.instantiate()
		spawn_carta.add_child(carta)

		carta.get_child(0).carta = chaves[i]
		# atualizar desc
		carta.get_child(0)._ready()
		carta.get_child(0).carta_escolhida.connect(_on_carta_escolhida)

		Musica.process_mode = Node.PROCESS_MODE_ALWAYS
		carta.process_mode = Node.PROCESS_MODE_ALWAYS
	
func _on_carta_escolhida():
	for carta in spawn_carta.get_children():
		carta.queue_free()
	#despausa 
	get_tree().paused = false
	iniciar_wave()

func continuar_jogo() -> void:
	get_tree().paused = false
	iniciar_wave()

func spawnar(cena: PackedScene) -> void:
	var inimigo := cena.instantiate() as Node2D
	inimigo.add_to_group("inimigos")
	get_tree().current_scene.add_child(inimigo)

	inimigo.global_position = global_position + Vector2(
		randf_range(-100, 40),
		randf_range(-100, 40)
	)
