pipeline {
    agent {
        docker {
            image 'python:3.10-slim'
            args  '-u root:root'
        }
    }

    options {
        skipDefaultCheckout(true)
    }

    environment {
        SOURCE_DIR  = 'src'
        VENV_DIR    = '.venv'
        REPORTS_DIR = 'reports'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python venv') {
            steps {
                sh '''
                    set -e

                    # 1) Comprobar versión de Python (requerimos 3.9+)
                    python3 --version
                    python3 -c 'import sys; assert sys.version_info >= (3,9), "Se requiere Python 3.9 o superior"'

                    # 2) Crear carpetas necesarias
                    mkdir -p "$REPORTS_DIR"

                    # 3) Crear el entorno virtual si no existe
                    [ -d "$VENV_DIR" ] || python3 -m venv "$VENV_DIR"

                    # 4) Instalar dependencias dentro del entorno virtual
                    "$VENV_DIR/bin/pip" install -U pip

                    if [ -f requirements.txt ]; then
                        "$VENV_DIR/bin/pip" install -r requirements.txt
                    else
                        echo "ERROR: requirements.txt no existe" >&2
                        exit 1
                    fi
                '''
            }
        }

        stage('Quality - Flake8') {
            steps {
                sh '''
                    set -e
                    mkdir -p "$REPORTS_DIR"

                    "$VENV_DIR/bin/flake8" "$SOURCE_DIR" --count --statistics --show-source > "$REPORTS_DIR/flake8.txt"
                    cat "$REPORTS_DIR/flake8.txt"
                '''
            }
        }

        stage('Security - Bandit') {
            steps {
                sh '''
                    set -e
                    mkdir -p "$REPORTS_DIR"

                    # Genera JSON (Bandit puede devolver exit != 0 si encuentra issues)
                    "$VENV_DIR/bin/bandit" -r "$SOURCE_DIR" -f json -o "$REPORTS_DIR/bandit.json" || true

                    # Gate: falla si el JSON trae resultados
                    python3 - <<'PY'
import json
import sys
import os

reports_dir = os.environ.get("REPORTS_DIR", "reports")
path = os.path.join(reports_dir, "bandit.json")

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

issues = data.get("results", [])

if issues:
    print(f"Bandit encontró {len(issues)} issues")
    for i in issues[:5]:
        print(
            f"- {i.get('test_id')} "
            f"{i.get('issue_severity')} "
            f"{i.get('issue_text')} "
            f"({i.get('filename')}:{i.get('line_number')})"
        )
    sys.exit(1)

print("Bandit OK (0 issues)")
PY
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/*', fingerprint: true, onlyIfSuccessful: false
        }
        success {
            echo 'Pipeline OK: calidad y seguridad pasaron sin hallazgos bloqueantes.'
        }
        failure {
            echo 'Pipeline FALLÓ: revisa reports/flake8.txt y reports/bandit.json.'
        }
    }
}
