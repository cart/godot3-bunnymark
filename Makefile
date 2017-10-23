comp:
	clang -fPIC -o src/BenchmarkCPP.os -c src/BenchmarkCPP.cpp -g -O3 -std=c++14 -Icpp_bindings/include -Icpp_bindings/include/core -Igodot_headers
	clang -o lib/BenchmarkCPP.so -shared src/BenchmarkCPP.os -Llib -lgodot_cpp_bindings