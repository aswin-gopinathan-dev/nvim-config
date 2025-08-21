#!/bin/bash


# Exit if any command fails
set -e

echo "Creating Project..."

# 1. Create project template if folder is empty
# Check if current directory is empty
if [ -z "$(ls -A)" ]; then
  echo "Initializing project setup..."
  mkdir -p src inc
  cat <<EOF > src/main.cpp
#include <iostream>

int main()
{
    std::cout << "Hello World";
    return 0;
}
EOF
  echo "Project setup completed (new)."
  "$HOME/.config/nvim/sh/misc.sh"
  "$HOME/.config/nvim/sh/build.sh"
  exit 0
fi


# 2. Exit if project template present in the folder
# If src and inc already exist, do nothing
if [ -d "src" ] && [ -d "inc" ]; then
  echo "src/ and inc/ folders already exist. No changes made."
  exit 0
fi


# 3. If source code exists but is not in the correct folder structure
# If src/inc don't both exist, create them
mkdir -p src
mkdir -p inc

# Move all .cpp files (except existing in src) to src/
for f in *.cpp; do
  [ -e "$f" ] || continue
  if [ "$f" != "src/main.cpp" ]; then
    mv -n "$f" src/
    echo "Moved $f to src/"
  fi
done

# Move all .h/.hpp files to inc/
for f in *.h *.hpp; do
  [ -e "$f" ] || continue
  mv -n "$f" inc/
  echo "Moved $f to inc/"
done

# If main.cpp still doesn't exist in src/, create it
if [ ! -f src/main.cpp ]; then
  cat <<EOF > src/main.cpp
#include <iostream>

int main()
{
    std::cout << "Hello World";
    return 0;
}
EOF
  echo "Created default src/main.cpp"
else
  echo "src/main.cpp already exists. Not overwritten."
fi

echo "Project setup completed (restructured)."

"$HOME/.config/nvim/sh/misc.sh"
"$HOME/.config/nvim/sh/build.sh"
