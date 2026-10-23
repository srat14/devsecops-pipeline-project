import subprocess
from fastapi import FastAPI, Query

app = FastAPI(title="DevSecOps Demo API", version="1.0.0")

[TEST 1 - GITLEAKS]: Aşağıdaki satırın yorumunu kaldırırsan Gitleaks pipeline'ı anında durdurur.
AWS_SECRET_KEY = "AKIAIOSFODNN7EXAMPLEKEY123456"

@app.get("/health")
def health_check():
    return {"status": "secure", "service": "running"}

@app.get("/network-check")
def network_check(host: str = Query(default="8.8.8.8")):
    # [TEST 2 - SEMGREP SAST]: shell=True kullanımı Command Injection zafiyeti yaratır.
    # Semgrep bu satırı yakalar. Güvenli geçiş için shell=False ve liste yapısı kullanılmalıdır.
    
    # Zafiyetli kullanım (Test için yorumu kaldır):
    # output = subprocess.check_output(f"ping -c 1 {host}", shell=True)
    
    # Güvenli kullanım:
    output = subprocess.check_output(["echo", f"Checked host: {host}"], shell=False)
    return {"result": output.decode("utf-8").strip()}