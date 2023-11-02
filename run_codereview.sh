#!/bin/bash

CLANG_RESULT_FILE="result.log"
CHECKER_REPORT_FILE="report.json"

echo "step-1. generate compile_commands.json"
cmake -S . -B temp_build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ > /dev/null
cp temp_build/compile_commands.json .

echo "step-2. run clang-tidy tools"
run-clang-tidy | tee >(ansi2txt > $CLANG_RESULT_FILE)

echo "step-3. run code checker and generate $CHECKER_REPORT_FILE"
set -e
run_codechecker $CLANG_RESULT_FILE $@

echo "step-4. remove temp build directory"
rm -rf temp_build
