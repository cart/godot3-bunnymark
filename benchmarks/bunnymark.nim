# Copyright 2017 Xored Software, Inc.

## Import independent scene objects here
## (no need to import everything, just independent roots)

when not defined(release):
  import segfaults # converts segfaults into NilAccessError

import BunnymarkV1Sprites/nim/BunnymarkV1Sprites
import BunnymarkV1DrawTexture/nim/BunnymarkV1DrawTexture
import BunnymarkV2/nim/BunnymarkV2
