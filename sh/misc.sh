#!/bin/bash
echo "Generating dependent project files..."


# Generate clangd file
# --------------------
echo "CompileFlags:
  Add: [-I../inc]" > .clangd


# Generate .clang-format file
# ---------------------------
echo "BasedOnStyle: llvm
IndentWidth: 4
TabWidth: 4
UseTab: Never

BreakBeforeBraces: Stroustrup" > .clang-format


# Generate debug.json
# -------------------
echo "{
  \"program\": \"$PWD/build/app\",
  \"cwd\": \"$PWD\"
}" > debug.json

