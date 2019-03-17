sources = $(shell find benchmarks/ -type f -name '*.cpp')
objects = $(patsubst %.cpp,%.o,$(sources))

all:
	rm -rf obj
	mkdir obj
	g++ -fPIC -c $(sources) Bunnymark.cpp -g -O3 -std=c++14 -Igodot-cpp/include -Igodot-cpp/include/core -Igodot-cpp/include/gen -Igodot_headers
	mv *.o obj
	g++ -o lib/BunnymarkCPP.so -shared obj/* -Llib -lgodot-cpp/bin -llibgodot-cpp.linux.debug.32.a
