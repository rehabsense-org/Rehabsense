#!/bin/sh
# Rebuilds code.js from src/*.js (plain JavaScript, no compiler needed)
cd "$(dirname "$0")"
cat src/lib.js src/patient.js src/doctor.js src/admin.js src/main.js > code.js
node --check code.js && echo "code.js OK"
