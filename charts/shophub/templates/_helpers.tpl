{{/*
Expand the name of the chart.
*/}}
{{- define "shophub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "shophub.fullname" -}}
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
{{- define "shophub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "shophub.labels" -}}
helm.sh/chart: {{ include "shophub.chart" . }}
{{ include "shophub.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "shophub.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shophub.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
shophub-api component: fully qualified name.
*/}}
{{- define "shophub.apiName" -}}
{{- printf "%s-api" (include "shophub.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
shophub-api component: selector labels (distinct name so it never selects the
auth-service pods and vice-versa).
*/}}
{{- define "shophub.apiSelectorLabels" -}}
app.kubernetes.io/name: {{ include "shophub.name" . }}-api
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: api
{{- end }}

{{/*
shophub-api component: common labels.
*/}}
{{- define "shophub.apiLabels" -}}
helm.sh/chart: {{ include "shophub.chart" . }}
{{ include "shophub.apiSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
shophub-frontend component: fully qualified name.
*/}}
{{- define "shophub.frontendName" -}}
{{- printf "%s-frontend" (include "shophub.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
shophub-frontend component: selector labels (distinct name so it never selects
the auth-service or api pods and vice-versa).
*/}}
{{- define "shophub.frontendSelectorLabels" -}}
app.kubernetes.io/name: {{ include "shophub.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
shophub-frontend component: common labels.
*/}}
{{- define "shophub.frontendLabels" -}}
helm.sh/chart: {{ include "shophub.chart" . }}
{{ include "shophub.frontendSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "shophub.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shophub.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
