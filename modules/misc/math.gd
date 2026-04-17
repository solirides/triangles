class_name MathStuff


# https://www.desmos.com/calculator/zaghwvmvev

static func random_asymptotic(n:float, b:float, randomness:float, max:float):
	return (1 - pow(b, n + randomness*randf()))*max

static func random_logarithmic(n:float, b:float, randomness:float, m:float):
	#print("logarithm")
	#print(log(n)/log(b) * (1 + randomness*randf()) * m)
	#print(log(n)/log(b))
	#print((1 + randomness*randf()))
	return log(n)/log(b) * (1 + randomness*randf()) * m

static func random_exponential(n:float, b:float, randomness:float, m:float):
	return (pow(b, n + randomness*randf()) - 1)*m
