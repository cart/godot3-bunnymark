version       = "0.1.0"
author        = "Capital Ex"
description   = "Godot-Nim Bunnymark"
license       = "MIT"
bin           = @["bunnymark"]

requires "godot >= 0.7.6 & < 0.8.0"

task make, "build":
  const bitsPostfix = when sizeof(int) == 8: "_64" else: "_32"
  const libFile =
    when defined(windows):
      "nim" & bitsPostfix & ".dll"
    elif defined(ios):
      "nim_ios" & bitsPostfix & ".dylib"
    elif defined(macosx):
      "nim_mac.dylib"
    elif defined(android):
      "nim_android.so"
    elif defined(linux):
      "nim_linux" & bitsPostfix & ".so"
    else: nil
  if libFile.isNil:
    raise newException(OSError, "Unsupported platform")

  exec "nimble build -y"
  const dir = "../_dlls/"
  const target = dir & libFile
  mkDir(dir)
  when defined(windows):
    rmFile(target)
    mvFile(bin[0] & ".exe", target)
  else:
    mvFile(bin[0], target)
