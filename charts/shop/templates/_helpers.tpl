{{/*
Expand the name of the chart.
*/}}
{{- define "shop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "shop.fullname" -}}
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
{{- define "shop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels shared by every component of the shop.
*/}}
{{- define "shop.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels. `shophub.devops-siit.io/shop` ties every object back to the Shop
custom resource, so metrics, logs and dashboards can be filtered per shop
(spec 4.1: every Shop application gets its own dashboard).
*/}}
{{- define "shop.labels" -}}
helm.sh/chart: {{ include "shop.chart" . }}
{{ include "shop.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
shophub.devops-siit.io/shop: {{ .Values.shopName | quote }}
{{- end }}

{{/*
Replica count derived from the availability tier (spec 1.2): standard -> 2,
high -> 3. Anything else falls back to standard, mirroring the operator's
desiredReplicas().
*/}}
{{- define "shop.replicas" -}}
{{- if eq .Values.availability "high" }}3{{ else }}2{{ end }}
{{- end }}

{{/*
Container image reference. imageRegistry is optional so a locally built image
(kind load) works without a registry prefix.
*/}}
{{- define "shop.image" -}}
{{- $img := .image -}}
{{- with .registry }}{{ . }}/{{ end }}{{ $img.repository }}:{{ $img.tag }}
{{- end }}

{{/*
frontend component: fully qualified name.
*/}}
{{- define "shop.frontendName" -}}
{{- printf "%s-frontend" (include "shop.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
frontend component: selector labels (distinct component so it never selects the
order/payment pods and vice-versa).
*/}}
{{- define "shop.frontendSelectorLabels" -}}
app.kubernetes.io/name: {{ include "shop.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
frontend component: common labels.
*/}}
{{- define "shop.frontendLabels" -}}
helm.sh/chart: {{ include "shop.chart" . }}
{{ include "shop.frontendSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
shophub.devops-siit.io/shop: {{ .Values.shopName | quote }}
{{- end }}


