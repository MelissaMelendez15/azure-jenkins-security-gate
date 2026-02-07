from flask import Flask, request, jsonify
import ast
import os   

app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify(status="ok"), 200

@app.post("/run")
def run_expr():
    data = request.get_json(silent=True) or {}
    user_input = data.get("input", "")
    try:
        result = ast.literal_eval(user_input)
        return jsonify(result=result), 200
    except Exception as e:
        return jsonify(error=str(e)), 400

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
    
    
    
    