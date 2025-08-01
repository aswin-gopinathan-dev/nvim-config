#! /bin/fish

# Generate Makefile
# -----------------

echo "SRC := \"$PWD/src\"
INC := \"$PWD/inc\"
BUILD := \"$PWD/build\"

.PHONY: build clean run

build:
	@echo \"Building with debug info...\"
	mkdir -p \$(BUILD)
	g++ -I\$(INC) -Wno-narrowing -g -lSDL3 -o \$(BUILD)/app \$(SRC)/*.cpp
	# Generate compile_commands.json using bear
	bear -- g++ -Isrc -Iinc -c src/*.cpp
	mv *.o build/

clean:
	@echo \"Clean build...\"
	rm -r build

run:
	@echo \"Running...\"
	\$(BUILD)/app" > Makefile

