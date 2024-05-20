{{/*
Expand the name of the chart.
*/}}
{{- define "ecflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ecflow.labels" -}}
helm.sh/chart: {{ include "ecflow.chart" . }}
{{ include "ecflow.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ecflow.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ecflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ecflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ecflow.localImageRepository" -}} 
image-registry.openshift-image-registry.svc:5000/{{ .Release.Namespace }}
{{- end}}

{{- define "ecflow.imageTag" -}}
{{- if eq .Values.environment "dev" -}}
latest
{{- else -}}
{{ .Values.prodType }}
{{- end }}
{{- end }}
