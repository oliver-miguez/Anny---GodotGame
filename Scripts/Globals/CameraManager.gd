extends Node


var position_player1
var position_player2

func calculo_distancia_players()->float:
	var calculo = position_player2 - position_player1
	return calculo.length()
	
