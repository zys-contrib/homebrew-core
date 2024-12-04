class Screenpipe < Formula
  desc "Library to build personalized AI powered by what you've seen, said, or heard"
  homepage "https://github.com/mediar-ai/screenpipe"
  url "https://github.com/mediar-ai/screenpipe/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "1166b309204fd7c6f9306ee4da57d918dfdc8c17348510818f872024eb80b700"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba3ebe387b9a23771606e4c92cf41641543dccd3b7b1a4824f2054fee30ab080"
    sha256 cellar: :any,                 arm64_sonoma:  "251cb436fc3b1233087d65ea6bae4c3156166470da306cef5c9ef43f8d3828fa"
    sha256 cellar: :any,                 sonoma:        "abff08008f5ae7b375a1e49fa3f5bc7887798ad94786479f20dfe0afabede9af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3474067aaf94e670414d4c66e32bfcf7e5ac7740a17760f598e644e9e22aedaa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on macos: :sonoma

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3"
    depends_on "tesseract"
    depends_on "xz"
  end

  def install
    features = ["--features", "metal,pipes"] if OS.mac? && Hardware::CPU.arm?
    system "cargo", "install", *features, *std_cargo_args(path: "screenpipe-server")
    lib.install "screenpipe-vision/lib/libscreenpipe_#{Hardware::CPU.arch}.dylib" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/screenpipe -V")

    log_file = testpath/".screenpipe/screenpipe.#{time.strftime("%Y-%m-%d")}.log"
    pid = spawn bin/"screenpipe", "--disable-vision", "--disable-audio", "--disable-telemetry"
    sleep 200

    assert_path_exists log_file
    assert_match(/INFO.*screenpipe/, File.read(log_file))
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
