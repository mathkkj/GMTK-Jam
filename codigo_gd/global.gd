extends Node2D


var tempo = 60

func _physics_process(delta):
	if tempo > 0:
		tempo -= delta

	if tempo <= 0:
		tempo = 0
			
	
