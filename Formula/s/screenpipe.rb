class Screenpipe < Formula
  desc "Library to build personalized AI powered by what you've seen, said, or heard"
  homepage "https://github.com/mediar-ai/screenpipe"
  url "https://github.com/mediar-ai/screenpipe/archive/refs/tags/v0.1.98.tar.gz"
  sha256 "cb3c8039ecb60d35bacd2b9673db112f907b4a1d3d7c32f49a5e77c0274268ad"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3"
    depends_on "tesseract"
  end

  def install
    features = ["--features", "metal,pipes"] if OS.mac? && Hardware::CPU.arm?
    system "cargo", "install", *features, *std_cargo_args(path: "screenpipe-server")
    lib.install "screenpipe-vision/lib/libscreenpipe_#{Hardware::CPU.arch}.dylib" if OS.mac?
  end

  test do
    assert_match "Usage", shell_output("#{bin}/screenpipe -h")

    log_file = testpath/".screenpipe/screenpipe.#{Time.now.strftime("%Y-%m-%d")}.log"
    pid = fork do
      exec bin/"screenpipe --debug setup"
    end
    sleep 200

    assert_predicate log_file, :exist?
    assert_match "screenpipe setup complete", File.read(log_file)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
