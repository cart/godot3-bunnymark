sources = $(shell find benchmarks/ -type f -name '*.cpp')
objects = $(patsubst %.cpp,%.o,$(sources))

all:
	rm -rf obj
	mkdir obj
	g++ -fPIC -c $(sources) Bunnymark.cpp -g -O3 -std=c++14 -Icpp_bindings/include -Icpp_bindings/include/core -Igodot_headers
	mv *.o obj
	g++ -o lib/BunnymarkCPP.so -shared obj/* -Llib -lgodot_cpp_bindings
