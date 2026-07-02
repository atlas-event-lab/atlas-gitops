{{/* Expand the chart name. */}}
{{- define "atlas-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Fully qualified app name; defaults to the release name (one release per service). */}}
{{- define "atlas-service.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Common labels. */}}
{{- define "atlas-service.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/name: {{ include "atlas-service.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: atlas
{{- end -}}

{{/* Selector labels. */}}
{{- define "atlas-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "atlas-service.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* ServiceAccount name. */}}
{{- define "atlas-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "atlas-service.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/* Image reference. tag is REQUIRED (CI sets it to the immutable git sha).
     Never fall back to Chart.AppVersion: that silently deploys a non-existent
     tag (e.g. 0.0.1) and causes ImagePullBackOff. Fail loudly instead. */}}
{{- define "atlas-service.image" -}}
{{- $tag := .Values.image.tag | required "image.tag is required — CI must set it to the git sha (e.g. --set image.tag=sha-<commit>). Refusing to default to Chart.AppVersion." -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end -}}
