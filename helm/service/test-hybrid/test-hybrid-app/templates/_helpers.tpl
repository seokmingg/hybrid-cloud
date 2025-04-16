{{/*
Generate the full name for the frontend resources.
*/}}
{{- define "test-hybrid.frontendFullname" -}}
{{- printf "%s-front" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate the full name for the backend resources.
*/}}
{{- define "test-hybrid.backendFullname" -}}
{{- printf "%s-back" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}