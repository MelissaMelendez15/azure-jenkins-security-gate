def run(user_input: str):
    # Muy Vulnerable: ejecuta código arbitrario
    return eval(user_input)

if __name__ == "__main__":
    expr = input("Expression: ")
    print(run(expr))
