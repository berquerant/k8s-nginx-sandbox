{{/*
Expand the name of the chart.
*/}}
{{- define "nginx-sandbox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nginx-sandbox.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nginx-sandbox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nginx-sandbox.labels" -}}
helm.sh/chart: {{ include "nginx-sandbox.chart" . }}
{{ include "nginx-sandbox.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "nginx-sandbox.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-sandbox.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
StatefulSet name of nginx
*/}}
{{- define "nginx-sandbox.nginxStatefulSetName" -}}
{{- printf "%s-nginx" (include "nginx-sandbox.fullname" .) -}}
{{- end }}

{{/*
Service name of nginx
*/}}
{{- define "nginx-sandbox.nginxServiceName" -}}
{{- printf "%s-nginx" (include "nginx-sandbox.fullname" .) -}}
{{- end }}

{{/*
Service name of httpbin
*/}}
{{- define "nginx-sandbox.httpbinServiceName" -}}
{{- printf "%s-httpbin" (include "nginx-sandbox.fullname" .) -}}
{{- end }}

{{/*
Service name of app
*/}}
{{- define "nginx-sandbox.appServiceName" -}}
{{- printf "%s-app" (include "nginx-sandbox.fullname" .) -}}
{{- end }}

{{/*
Job name of nginx
*/}}
{{- define "nginx-sandbox.nginxJobName" -}}
{{- printf "%s-job" (include "nginx-sandbox.fullname" .) -}}
{{- end}}

{{/*
Nginx application labels
*/}}
{{- define "nginx-sandbox.nginxAppLabels" -}}
app: nginx
{{- end }}

{{/*
Bastion application labels
*/}}
{{- define "nginx-sandbox.bastionAppLabels" -}}
app: bastion
{{- end }}

{{/*
Httpbin application labels
*/}}
{{- define "nginx-sandbox.httpbinAppLabels" -}}
app: httpbin
{{- end }}

{{/*
App application labels
*/}}
{{- define "nginx-sandbox.appAppLabels" -}}
app: app
{{- end }}

{{/*
Nginx syntax check application labels
*/}}
{{- define "nginx-sandbox.nginxJobLabels" -}}
app: syntax-check
{{- end }}

{{/*
Service FQDN suffix
*/}}
{{- define "nginx-sandbox.serviceSuffix" -}}
{{- if .Values.clusterName -}}
{{- printf "svc.%s.cluster.local" .Values.clusterName -}}
{{- else -}}
svc.cluster.local
{{- end }}
{{- end }}

{{/*
Kubernetes DNS resolver FQDN
*/}}
{{- define "nginx-sandbox.resolverFQDN" -}}
{{- printf "%s.%s.%s" .Values.resolverName .Values.resolverNamespace (include "nginx-sandbox.serviceSuffix" .) -}}
{{- end}}
