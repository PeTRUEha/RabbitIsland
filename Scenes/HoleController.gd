extends Node2D

func get_hidden_rabbit_conut() -> int:
	var values = get_children().map(func(h: RabbitHole): return len(h.residents))
	var res = values.reduce(func(a, b): return a + b)
	return res
