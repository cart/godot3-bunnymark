sources = $(shell find benchmarks/ -type f -name '*.cpp')
objects = $(patsubst %.cpp,%.o,$(sources))

all:
	rm -rf obj
	mkdir obj
	clang -fPIC -c $(sources) Bunnymark.cpp -g -O3 -std=c++14 -Igodot-cpp/include -Igodot-cpp/include/core -Igodot_headers
	mv *.o obj
	clang -o lib/BunnymarkCPP.so -shared obj/* -Llib -lgodot_cpp_bindings
