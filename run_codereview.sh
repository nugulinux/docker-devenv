#!/bin/sh
set -e

mkdir -p build
cd build

CLANG_RESULT_FILE="result.log"
CHECKER_REPORT_FILE="report.json"

echo "step-1. generate compile_commands.json"
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ../ > /dev/null

echo "step-2. run clang-tidy tools"
run-clang-tidy -checks='-*,clang*,perf*,cert*' > $CLANG_RESULT_FILE 2> /dev/null

echo "step-3. run code checker"
run_codechecker $CLANG_RESULT_FILE $@

echo "step-4. codechecker report generate to $CHECKER_REPORT_FILE"
mv $CHECKER_REPORT_FILE ..

cd ..
rm -rf build
