
# Copyright 2017 Xored Software, Inc.

import nake
import os, ospaths, times
import godotapigen

proc genGodotApi() =
  let godotBin = getEnv("GODOT_BIN")
  if godotBin.len == 0:
    echo "GODOT_BIN environment variable is not set"
    quit(-1)
  if not fileExists(godotBin):
    echo "Invalid GODOT_BIN path: " & godotBin
    quit(-1)

  const targetDir = "_godotapi"
  createDir(targetDir)
  const jsonFile = targetDir/"api.json"
  if not fileExists(jsonFile) or
     godotBin.getLastModificationTime() > jsonFile.getLastModificationTime():
    direShell(godotBin, "--gdnative-generate-json-api", getCurrentDir()/jsonFile)
    if not fileExists(jsonFile):
      echo "Failed to generate api.json"
      quit(-1)

    genApi(targetDir, jsonFile)

task "build", "Builds the client for the current platform":
  genGodotApi()
  let bitsPostfix = when sizeof(int) == 8: "_64" else: "_32"
  let libFile =
    when defined(windows):
      "nim" & bitsPostfix & ".dll"
    elif defined(ios):
      "nim_ios" & bitsPostfix & ".dylib"
    elif defined(macosx):
      "nim_mac.dylib"
    elif defined(android):
      "libnim_android.so"
    elif defined(linux):
      "nim_linux" & bitsPostfix & ".so"
    else: nil
  createDir("_dlls")
  withDir "benchmarks":
    direShell(["nimble", "c", ".."/"benchmarks"/"bunnymark.nim", "-o:.."/"_dlls"/libFile])

task "clean", "Remove files produced by build":
  removeDir(".nimcache")
  removeDir("benchmarks"/".nimcache")
  removeDir("_godotapi")
  removeDir("_dlls")
  removeFile("nakefile")
  removeFile("nakefile.exe")