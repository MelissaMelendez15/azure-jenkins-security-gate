import ast

def run(user_input: str):
    # Antes: eval(user_input)  # vulnerable a ejecución de código
    return ast.literal_eval(user_input)  # Solo permite literales seguros (números, listas, dicts, strings, etc.)

if __name__ == "__main__":
    expr = input("Expression: ")
    print(run(expr))

