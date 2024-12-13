from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return "OK"

{{/*
additional app configurations
*/}}
{{- with .Values.app.conf.main }}
{{ . }}
{{- end}}
