#!/usr/bin/env bash
# PreToolUse hook for Write|Edit. If the target file looks like a test file in
# any of the languages the user works with, inject a reminder about real test
# data sourcing. Otherwise stay silent.

set -euo pipefail

input="$(cat)"
file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"

if [[ -z "$file_path" ]]; then
  exit 0
fi

is_test=0

# Kotlin / KMP
if [[ "$file_path" =~ Test\.kt$ ]] || [[ "$file_path" =~ Tests\.kt$ ]]; then is_test=1; fi
if [[ "$file_path" == */commonTest/* ]] || [[ "$file_path" == */androidHostTest/* ]] \
   || [[ "$file_path" == */androidDeviceTest/* ]] || [[ "$file_path" == */androidTest/* ]] \
   || [[ "$file_path" == */androidUnitTest/* ]] || [[ "$file_path" == */iosTest/* ]] \
   || [[ "$file_path" == */jvmTest/* ]] || [[ "$file_path" == */src/test/* ]]; then is_test=1; fi

# TypeScript / JavaScript
if [[ "$file_path" =~ \.(test|spec)\.(ts|tsx|js|jsx|mjs|cjs)$ ]]; then is_test=1; fi
if [[ "$file_path" == */__tests__/* ]]; then is_test=1; fi

# Python
if [[ "$(basename "$file_path")" =~ ^test_.*\.py$ ]]; then is_test=1; fi
if [[ "$file_path" =~ _test\.py$ ]]; then is_test=1; fi
if [[ "$file_path" == */tests/* ]]; then is_test=1; fi

# Swift
if [[ "$file_path" =~ Tests\.swift$ ]] || [[ "$file_path" =~ Spec\.swift$ ]]; then is_test=1; fi
if [[ "$file_path" == */Tests/* ]]; then is_test=1; fi

# PHP
if [[ "$file_path" =~ Test\.php$ ]]; then is_test=1; fi

if [[ "$is_test" -eq 0 ]]; then
  exit 0
fi

reminder=$(cat <<'EOF'
Test file detected. For every value in this test, you should be able to answer "where does this come from?" — a captured backend response, a real run of the app, an existing fixture elsewhere in the codebase, an official spec/sample, or a real entity in the system. If you cannot, ask the user. Plausible-looking made-up values are the failure mode. The same applies to shapes: do not extrapolate from a sibling fixture without verifying. Hard-code expected values as literals. Don't go overboard: no test data in method names. Only explain the relevance in comments inside the method when not obvious.
EOF
)

jq -nc --arg ctx "$reminder" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    additionalContext: $ctx
  }
}'
