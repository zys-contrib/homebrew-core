class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v3.3.tar.gz"
  sha256 "6636f97f3a5446e3a1c845545108cf692bbd9cdc02cacfda099a2789ca7f6d56"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "5bc8d3e9b80d38d837b1d910724c96324337401350a499f7bce66599c1774b58"
    sha256 arm64_sonoma:  "45c991850ec0a38e724ce5f9ec6aeddb33686b76389bf179906ccdfc5329963a"
    sha256 arm64_ventura: "dcd0c0336f03804bb4f8c77f99bf1a87b596573bfd71a9e56df4df3e38945cf4"
    sha256 sonoma:        "92646abdda536014901033936af533f221835b2766f45e4b95dba6d08ac57780"
    sha256 ventura:       "441f55d3f5deae929fd9834dd6256535a81463170ce2488d8a5d6657ba01615b"
    sha256 arm64_linux:   "46ce2ef60d17e534c3fdcb5a7021ad2a3908007b664b19f65bd1758c881b3bf2"
    sha256 x86_64_linux:  "91e75e3978f2630997ea0af0b836f1d8175ddfd5abd9385963e7b1d46622de86"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v3.3/scrcpy-server-v3.3"
    sha256 "351cb2edc7e4c2c75f09a7933fdabcf137be52e2602df154f24ec02db46e9e51"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "prebuilt-server resource needs to be updated" if version != resource("prebuilt-server").version

    buildpath.install resource("prebuilt-server")
    cp "scrcpy-server-v#{version}", "prebuilt-server.jar"

    system "meson", "setup", "build", "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb five times:
    #  - adb start-server
    #  - adb devices -l
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~SH
      #!/bin/sh
      echo "$@" >> #{testpath/"fakeadb.log"}

      if [ "$1" = "devices" ]; then
        echo "List of devices attached"
        echo "emulator-1337          device product:sdk_gphone64_x86_64 model:sdk_gphone64_x86_64 device:emulator64_x86_64_arm64 transport_id:1"
      fi

      if [ "$3" = "reverse" ]; then
        exit 42
      fi
    SH

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}/scrcpy --no-window --record=file.mp4 -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
