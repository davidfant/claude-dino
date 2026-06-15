#!/usr/bin/env bash
set -euo pipefail

hook_json_get() {
  local json="$1"
  local field="$2"
  local pattern

  pattern="\"$field\"[[:space:]]*:[[:space:]]*\"((\\\\.|[^\"])*)\""
  if [[ "$json" =~ $pattern ]]; then
    hook_json_unescape "${BASH_REMATCH[1]}"
  fi
}

hook_json_unescape() {
  local value="$1"

  value="${value//\\\"/\"}"
  value="${value//\\\//\/}"
  value="${value//\\b/$'\b'}"
  value="${value//\\f/$'\f'}"
  value="${value//\\n/$'\n'}"
  value="${value//\\r/$'\r'}"
  value="${value//\\t/$'\t'}"
  value="${value//\\\\/\\}"

  printf '%s' "$value"
}

hook_state_json() {
  local status="$1"
  local session_id="$2"
  local tool_name="${3:-}"
  local escaped_status
  local escaped_session_id
  local escaped_tool_name

  escaped_status="$(hook_json_escape "$status")"
  escaped_session_id="$(hook_json_escape "$session_id")"
  escaped_tool_name="$(hook_json_escape "$tool_name")"

  printf '{"status":"%s","sessionId":"%s"' "$escaped_status" "$escaped_session_id"
  if [[ -n "$tool_name" ]]; then
    printf ',"tool":"%s"' "$escaped_tool_name"
  fi
  printf '}\n'
}

hook_json_escape() {
  local value="$1"

  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\b'/\\b}"
  value="${value//$'\f'/\\f}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"

  printf '%s' "$value"
}
