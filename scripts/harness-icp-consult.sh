#!/usr/bin/env bash
# harness-icp-consult.sh — consult the real ICP for a customer-shaped decision.
#
# The first Harness → FreedomOS bridge. Implements the "Context-Grounded Consumer
# Simulation" Strategic Position: when a skill hits a customer-shaped checkpoint
# (e.g. the ceo-plan-review ICP Pressure Test), score the artifact against the
# real ICP loaded fresh from the operator's ICP scorer — instead of the operator's
# remembered guess of the customer.
#
# PORTABLE + SECRET-FREE: this script contains no URLs, secrets, company ids, or
# business names. Every instance value lives in a PRIVATE per-operator config that
# is never committed to any repo:
#
#   ${HARNESS_ICP_CONFIG:-~/.config/harness/icp.json}
#   {
#     "scorer":   { "url": "<your ICP-scorer endpoint>",
#                   "secretFile": "<path to a file holding the shared secret>" },
#     "projects": { "<repo-name>": "<id of the company whose ICP to load>" }
#   }
#
# Each operator (and each machine) wires their own. No config / no project mapping
# → exit 3, and the calling skill falls back to reasoning through documented ICP
# profiles (graceful absence: the framework still works without a scorer).
#
# Usage:
#   harness-icp-consult.sh [--project NAME] [--type TYPE] "<deliverable text>"
#   echo "<deliverable text>" | harness-icp-consult.sh --type strategy
#
# Exit: 0 + score JSON on success · 3 = not configured (caller should fall back)
#       2 = bad usage · 1 = scorer/transport error
set -euo pipefail

CONFIG="${HARNESS_ICP_CONFIG:-$HOME/.config/harness/icp.json}"
PROJECT=""; DTYPE="other"; ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:-}"; shift 2 ;;
    --type)    DTYPE="${2:-other}"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)         ARGS+=("$1"); shift ;;
  esac
done
DELIVERABLE="${ARGS[*]:-}"
[ -z "$DELIVERABLE" ] && DELIVERABLE="$(cat 2>/dev/null || true)"
[ -z "$DELIVERABLE" ] && { echo "harness-icp: no deliverable text given" >&2; exit 2; }

command -v jq   >/dev/null 2>&1 || { echo "harness-icp: jq required" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "harness-icp: curl required" >&2; exit 1; }

[ -f "$CONFIG" ] || { echo "harness-icp: no ICP scorer configured ($CONFIG missing) — fall back" >&2; exit 3; }

[ -z "$PROJECT" ] && PROJECT="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
COMPANY_ID="$(jq -r --arg p "$PROJECT" '.projects[$p] // empty' "$CONFIG")"
[ -z "$COMPANY_ID" ] && { echo "harness-icp: no ICP mapped for project '$PROJECT' in $CONFIG — fall back" >&2; exit 3; }

URL="$(jq -r '.scorer.url // empty' "$CONFIG")"
SECRET_FILE="$(jq -r '.scorer.secretFile // empty' "$CONFIG")"
SECRET_FILE="${SECRET_FILE/#\~/$HOME}"
{ [ -n "$URL" ] && [ -f "$SECRET_FILE" ]; } || { echo "harness-icp: scorer url/secret not configured — fall back" >&2; exit 3; }
SECRET="$(cat "$SECRET_FILE")"

PAYLOAD="$(jq -nc --arg c "$COMPANY_ID" --arg d "$DELIVERABLE" --arg t "$DTYPE" \
  '{jsonrpc:"2.0",id:1,method:"tools/call",params:{name:"challenge_as_customer",arguments:{companyId:$c,deliverable:$d,deliverable_type:$t}}}')"

RESP="$(curl -s --max-time 120 -X POST "$URL" \
  -H "Content-Type: application/json" -H "X-Internal-Secret: $SECRET" -d "$PAYLOAD")" \
  || { echo "harness-icp: scorer request failed" >&2; exit 1; }

# The tool result is a JSON string inside result.content[0].text; surface it, else the error.
echo "$RESP" | jq -r 'if .result.content[0].text then .result.content[0].text
                       elif .error then "SCORER ERROR: " + (.error.message // (.error|tostring))
                       else "no response" end'
