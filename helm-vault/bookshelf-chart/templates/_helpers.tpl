{{/*
Expand the name of the chart.
*/}}
{{- define "bookshelf-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bookshelf-chart.fullname" -}}
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
Generate root name to access names exactly from the parent chart helper  
*/}}
{{- define "bookshelf-chart.rootname" -}}
{{- $root := index . 0 -}}
{{- $name := default "bookshelf-chart" (index . 1) -}}
{{- printf "%s-%s" $root.Release.Name $name -}}
{{- end -}}

{{/* Generate namespace */}}
{{- define "bookshelf-chart.namespace" -}}
{{- coalesce .Release.Namespace (include "bookshelf-chart.fullname" .) "default-namespace" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bookshelf-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bookshelf-chart.labels" -}}
helm.sh/chart: {{ include "bookshelf-chart.chart" . }}
{{ include "bookshelf-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bookshelf-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bookshelf-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/app: {{ include "bookshelf-chart.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bookshelf-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bookshelf-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Configure the datasourcePrefix for database access
*/}}
{{- define "bookshelf-chart.datasourcePrefix" -}}
{{- $serviceName := printf "%s-service" .Values.global.database.appName -}}
{{- printf "%s:%s://%s:%s" .Values.global.database.datasource.dbAccessApi .Values.global.database.datasource.dbAppName $serviceName .Values.global.database.datasource.port  -}}
{{- end }}