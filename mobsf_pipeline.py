import requests
import json
import os
from datetime import datetime

MOBSF_URL = "http://localhost:8000"
API_KEY = "160b9cd40a2b0cf7f578962ff64bf83fbc62270ee5a43cff67894cbc1bb2c4a3"
APK_PATH = "build/app/outputs/flutter-apk/app-release.apk"
OUTPUT_JSON = "assets/security_summary.json"

HEADERS = {"Authorization": API_KEY}

def run_pipeline():
    print("🚀 Iniciando pipeline de seguridad para SecurePulse...")
    
    # 1. Subir el APK
    print("📤 Subiendo APK a MobSF...")
    with open(APK_PATH, 'rb') as f:
        files = {'file': (os.path.basename(APK_PATH), f, 'application/octet-stream')}
        upload_res = requests.post(f"{MOBSF_URL}/api/v1/upload", headers=HEADERS, files=files)
        
    upload_data = upload_res.json()
    scan_type = upload_data['scan_type']
    file_name = upload_data['file_name']
    apk_hash = upload_data['hash']

    # 2. Iniciar el escaneo
    print(f"🔍 Escaneando {file_name} (Esto puede tardar un par de minutos)...")
    scan_payload = {'scan_type': scan_type, 'file_name': file_name, 'hash': apk_hash}
    requests.post(f"{MOBSF_URL}/api/v1/scan", headers=HEADERS, data=scan_payload)

    # 3. Descargar el reporte en JSON
    print("📥 Descargando reporte...")
    report_payload = {'hash': apk_hash}
    report_res = requests.post(f"{MOBSF_URL}/api/v1/report_json", headers=HEADERS, data=report_payload)
    report_data = report_res.json()

    # 4. Procesar y reducir el reporte
    print("⚙️ Procesando resumen de hallazgos...")

    # Security findings
    security_analysis = report_data.get('appsec', {})
    security_findings = []
    for issue in security_analysis.get('high', []):
        security_findings.append({
            "title": issue.get('title', 'Problema de Seguridad'),
            "description": issue.get('description', ''),
            "severity": "high"
        })
    for issue in security_analysis.get('warning', []):
        security_findings.append({
            "title": issue.get('title', 'Problema de Seguridad'),
            "description": issue.get('description', ''),
            "severity": "warning"
        })
    for issue in security_analysis.get('info', []):
        security_findings.append({
            "title": issue.get('title', 'Problema de Seguridad'),
            "description": issue.get('description', ''),
            "severity": "info"
        })
    for issue in security_analysis.get('secure', []):
        security_findings.append({
            "title": issue.get('title', 'Problema de Seguridad'),
            "description": issue.get('description', ''),
            "severity": "secure"
        })

    security_score = security_analysis.get('security_score', 100)
    has_critical = any(f['severity'] == 'high' for f in security_findings)
    final_status = "FAIL" if security_score < 50 or has_critical else "PASS"

    summary = {
        "scan_date": report_data.get('timestamp', datetime.now().isoformat()),
        "apk_hash": apk_hash,
        "status": final_status,
        "score": security_score,
        "findings": security_findings
    }

    OUTPUT_JSON = "assets/security_history.json"

    history = []
    if os.path.exists(OUTPUT_JSON):
        try:
            with open(OUTPUT_JSON, 'r') as f:
                history = json.load(f)
        except Exception:
            history = []

    history.insert(0, summary)

    # 5. Guardar en la carpeta assets/ de la app Flutter
    os.makedirs(os.path.dirname(OUTPUT_JSON), exist_ok=True)
    with open(OUTPUT_JSON, 'w') as f:
        json.dump(history, f, indent=2)

    print(f"✅ ¡Historial actualizado con los últimos {len(history)} escaneos en {OUTPUT_JSON}!")
    print(f"📊 Estado Final Último Escaneo: {final_status} (Score: {security_score}/100)")

if __name__ == "__main__":
    run_pipeline()
