import ast


def run(user_input: str):
    """
    Evalúa solo literales seguros (números, listas, dicts, strings, tuplas…).
    Antes usábamos eval() y era vulnerable a ejecución de código.
    """
    return ast.literal_eval(user_input)


if __name__ == "__main__":
    expr = input("Expression: ")
    print(run(expr))
