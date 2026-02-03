extends Camera2D

var current_player_distance: float 
var previous_player_distance: float = 0.0

# Parámetros de zoom
var min_zoom_value: float = 0.5 # Valor flotante para el zoom mínimo (más cerca)
var max_zoom_value: float = 2.0  # Valor flotante para el zoom máximo (más lejos)
var zoom_increment: float = 0.01 # Cantidad de cambio de zoom por paso
var diferencia_distancia: float = 5.0 # Mínima diferencia en distancia para activar el zoom

func _ready() -> void:
	previous_player_distance = CameraManager.calculo_distancia_players()
	
	# Asegurarse de que el zoom inicial está dentro de los límites
	# Con clamp lo que hacecemos es que si zoom supera el min o el max valor, se ajusta a uno de ellos
	# Dependiendo si se tiene que ampliar o reducir 
	zoom = Vector2(clamp(zoom.x, min_zoom_value, max_zoom_value), clamp(zoom.y, min_zoom_value, max_zoom_value))

func _physics_process(_delta: float) -> void:
		current_player_distance = CameraManager.calculo_distancia_players()
		manageZoom()
		previous_player_distance = current_player_distance


func manageZoom() -> void:
	# Si la distancia de los jugadores ha cambiado significativamente
	if abs(current_player_distance - previous_player_distance) > diferencia_distancia:
		if current_player_distance > previous_player_distance:
			# Jugadores se separan, alejar zoom (aumentar el valor de zoom)
			zoom += Vector2(zoom_increment, zoom_increment)
		elif current_player_distance < previous_player_distance:
			# Jugadores se acercan, acercar zoom (disminuir el valor de zoom)
			zoom -= Vector2(zoom_increment, zoom_increment)
		
		# Limitar el zoom dentro de los rangos min_zoom_value y max_zoom_value
		zoom.x = clamp(zoom.x, min_zoom_value, max_zoom_value)
		zoom.y = clamp(zoom.y, min_zoom_value, max_zoom_value)
