import ospaths

switch("nimcache", ".nimcache"/hostOS/hostCPU)

when defined(macosx):
  when defined(ios):
    if hostCPU == "arm64":
      switch("passC", "-arch arm64")
      switch("passL", "-arch arm64")
    elif hostCPU == "arm":
      switch("passC", "-arch armv7")
      switch("passL", "-arch armv7")
    switch("passC", "-mios-version-min=9.0 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk")
    switch("passL", "-mios-version-min=9.0 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk")
  else:
    switch("passL", "-framework Cocoa")
elif defined(android):
  let ndk = getEnv("ANDROID_NDK_ROOT")
  let toolchain = getEnv("ANDROID_TOOLCHAIN")

  if ndk.len == 0:
    raise newException(OSError,
      "ANDROID_NDK_ROOT environment variable is necessary for android build")
  if toolchain.len == 0:
    raise newException(OSError,
      "ANDROID_TOOLCHAIN environment variable is necessary for android build")

  const level = $16 # change this to the necessary API level
  const arch = "arm"
  let sysroot = "--sysroot=\"" & ndk & "/platforms/android-" & level & "/arch-" & arch & "/\""
  switch("passL", sysroot)
  switch("passC", sysroot)

  switch("cc", "clang")
  switch("arm.linux.clang.path", toolchain / "bin")
  switch("arm.linux.clang.exe", arch & "-linux-androideabi-clang")
  switch("arm.linux.clang.compilerexe", arch & "-linux-androideabi-clang")
  switch("arm.linux.clang.linkerexe", arch & "-linux-androideabi-clang")
elif defined(windows):
  assert(sizeof(int) == 8)
  switch("cc", "vcc")
elif defined(linux):
  switch("passC", "-fPIC")
else:
  raise newException(OSError, "Unsupported platform: " & hostOS)

when not defined(release):
  switch("debugger", "native")
