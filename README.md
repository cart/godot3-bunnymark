![Godot Bunnymark](images/banner.png)

Renders an increasing number of bunny sprites until a stable 60fps is hit.  This is a decent test of real world usage as it combines Godot api usage with raw computation.  I plan to update this README whenever significant performance changes occur or when new languages are added.  Feel free to contribute language implementations or improvements!

## Disclaimer

It is important to note that C#/Mono and GDNative are both very young.  Its possible that their performance characteristics will change.  Additionally, these are just a few benchmarks testing a few use cases.  Please don't use them to say "Language X is better / faster than Language Y", we don't have enough data to make those assertions.  If anything this proves that any of the choices below are viable.  Choose the language that you are comfortable with and do your own testing to cover your own scenarios.

## Running

* Build C++ files
    * Setup headers and bindings using [these directions](https://github.com/GodotNativeTools/godot-cpp)
    * run ```make``` in the root of this project
* Build C# files
    * run ```msbuild /p:Configuration=Tools;DebugSymbols=false;Optimize=true``` (some terminals might require escaping some of those symbols)
* Build Nim files
    * Setup headers and bindings using [these directions](https://pragmagic.github.io/godot-nim/master/index.html)
    * run ```nake build```
* Build D files
    * `git clone` [godot-d](https://github.com/GodotNativeTools/godot-d) to your favorite directory
    * [generate the buildings](https://github.com/GodotNativeTools/godot-d/blob/master/generator/README.md)
    * run `dub add-local /path/to/godot-d/`
    * run `dub build -b release`
* run ```sh run_benchmarks.sh```
* wait!  This will take some time ... the automation code is still a bit naive so it takes awhile to converge on 60 fps
* view the results in ```USER_HOME_DIRECTORY/.godot/app_userdata/Bunnymark/benchmark_results.json```

## Benchmark Run - October 31, 2017

### BunnymarkV2

Attempts to draw as many sprites as possible using Sprite nodes.  It calls GetChildren() to iterate over a list of Sprites and sets their positions.  It also updates a Label's text once per frame.  This test aims to be a better emulation of real world api usage than the V1 tests.

| Language           | Bunnies Rendered |
|--------------------|------------------|
| GDScript (Release) | 12160            |
| ~~C#/Mono~~       | ~~16000 (encountered errors)~~|
| GDNative (D)       | 21380            |
| GDNative (Nim)     | 22520            |
| GDNative (C++)     | 29240            |

### BunnymarkV1 - DrawTexture

Attempts to draw as many sprites to the screen as possible by drawing textures directly with VisualServer.  This test focuses on compute / render performance and avoids making godot api calls.

| Language           | Bunnies Rendered |
|--------------------|------------------|
| GDScript (Release) | 13820            |
| C#/Mono            | 48680            |
| GDNative (Nim)     | 52780            |
| GDNative (D)       | 57360            |
| GDNative (C++)     | 58120            

### BunnymarkV1 - Sprites

Attempts to draw as many sprites to the screen as possible by adding Sprite nodes.  This test focuses on compute / render performance and avoids making godot api calls.

| Language           | Bunnies Rendered |
|--------------------|------------------|
| GDScript (Release) | 11420            |
| C#/Mono            | 19940            |
| GDNative (Nim)     | 27840            |
| GDNative (D)       | 28420            |
| GDNative (C++)     | 30240            |

### Hardware:

* CPU: Intel i7 7700k 4.2GHz
* GPU: Nvidia GeForce GTX 1070
* RAM: 16GB DDR4

### Build Info:
* OS: Arch Linux
* Compiler: gcc 7.2.0
* Build Command: ```scons p=x11 target=release_debug tools=yes builtin_openssl=yes module_mono_enabled=yes -j4 -use_lto=yes```
* Godot Commit: [619e4eb23df037d152bf7776c5447d46293aadff](https://github.com/godotengine/godot/commit/619e4eb23df037d152bf7776c5447d46293aadff)

### Remarks

* The C# BunnymarkV2 test is currently hitting null reference exceptions where we would not expect them.  This may affect performance.  We are investigating this.

## Credits

* GDScript example adapted from: https://github.com/curly-brace/godot-bunnies.  Thanks @curly-brace!
* @Capital-EX provided the initial Nim tests, the D tests, and the display server tests
