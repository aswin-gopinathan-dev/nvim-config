#! /bin/fish

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


# Create source code
# ------------------
mkdir -p src
mkdir -p inc

echo "#include <iostream>


int main()
{
    std::cout<<\"Hello World\";
    return 0;
}
" > src/main.cpp

./build_script.sh
