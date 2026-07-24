extends Marker2D

var rodando_waves := false
var wave_atual := 0

var lista_inimigos: Array[PackedScene] = [
	preload("res://cenas_tscn/inimigo.tscn"),
	preload("res://cenas_tscn/inimigos_projetil.tscn"),
	preload("res://cenas_tscn/inimigos_3.tscn")
]

# configuracao das waves
var waves := [
	{
		"tempo_entre_spawns": 1.0,
		"inimigos": [
			{"tipo": 0, "quantidade": 2}
		]
	},
	{
		"tempo_entre_spawns": 1.0,
		"inimigos": [
			{"tipo": 2, "quantidade": 1},
			{"tipo": 1, "quantidade": 2}
		]
	},
]

func _ready() -> void:
	# espera um frame para garantir que a cena terminou de carregar
	##fiquei maluco tentando entender pq o primeiro inimigo nao funcionava, mas era pq ele tava instanciando antes do frame inicial tmnc
	await get_tree().process_frame
	iniciar_wave()

func iniciar_wave() -> void:
	# impede que o sistema de waves seja iniciado mais de uma vez
	##fato curioso: eu tava fazendo esse script no global, ele tava instanciando dois inimigos por ver por conta de ser um script global, ai eu botei no marker msm, da pra trocar pra uma area ou algo assim dps
	if rodando_waves:
		print("iniciar wave ignorado porque ja esta rodando")
		return

	rodando_waves = true

	# percorre todas as waves
	while wave_atual < waves.size():
		var wave = waves[wave_atual]
		var delay: float = float(wave["tempo_entre_spawns"])

		print("wave ", wave_atual + 1)

		# percorre todos os tipos de inimigos da wave
		for info in wave["inimigos"]:
			var tipo := int(info["tipo"])
			var quantidade := int(info["quantidade"])
			var cena: PackedScene = lista_inimigos[tipo]

			# instancia os inimigos um por vez
			for i in range(quantidade):
				spawnar(cena)
				await get_tree().create_timer(delay).timeout

		print("wave concluida, esperando derrotar todos os inimigos")

		# espera ate nao existir mais nenhum inimigo vivo
		while get_tree().get_nodes_in_group("inimigos").size() > 0:
			await get_tree().create_timer(0.2).timeout

		wave_atual += 1

		# pequeno delay antes da proxima wave
		await get_tree().create_timer(1.0).timeout

	print("todas as waves acabaram")
	rodando_waves = false

func spawnar(cena: PackedScene) -> void:
	var inimigo := cena.instantiate() as Node2D

	inimigo.add_to_group("inimigos")
	get_tree().current_scene.add_child(inimigo)

	# cria uma pequena variacao na posicao de spawn
	inimigo.global_position = global_position + Vector2(
		randf_range(-40, 40),
		randf_range(-40, 40)
	)
