pipeline {
    agent any

    environment {
        SOURCE_DIR = 'src'
        VENV_DIR   = '.venv'
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
                    # Análisis de calidad con Flake8
                    # Guardamos salida en un reporte para archivarlo en Jenkins
                    "$VENV_DIR/bin/flake8" "$SOURCE_DIR" \
                      --count --statistics --show-source \
                      | tee "$REPORTS_DIR/flak8.txt"
                '''
            }
        }

        stage('Security - Bandit') {
            steps {
                sh '''
                    set -e

                    # Análisis de seguridad con Bandit
                    # -ll = solo severidad alta
                    # Generamos reporte JSON (útil para automatizar/inspeccionar)
                    "$VENV_DIR/bin/bandit" -r "$SOURCE_DIR" -ll | tee "$REPORTS_DIR/bandit.txt"
                '''
            }
        }

        post {
            always {
                // Archivar reportes aunque falle (para poder ver qué pasó)
                archiveArtifacts artifacts: 'reports/*', fingerprint: true, onlyIfSuccessful: false
            }

            success {
                echo 'Pipeline OK: calidad y seguridad pasaron sin hallazgos bloqueantes.'
            }

            failure {
                echo 'Pipeline FALLÓ: revisa reports/flake8.txt y reports/bandit.txt o bandit.json.'
            }

            cleanup {
                cleanWs()
            }
        }
    }
}
