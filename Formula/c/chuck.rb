class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.0.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.0.tgz"
  sha256 "8e35810ad4c1c9b172e7e61980f449694396fc0400bb56628faf4fc787f8ea06"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9a2adb9ee9ade9e1c73c3c5c9a598f5c952b20958c27e8133c6db403a392ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204c18dc2e95d84c3e9c418b66c89a10ea2d399d4a123fa79de0223ca357e379"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d3ff5a5d188bd91ad4aa19ad123782858778e1ed93c4b7fea0f8cfbdf7943fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "434cdc4ed0d648e25520cf96199b6b4b5faf9a5aa4730606b7026f7e9e4250e6"
    sha256 cellar: :any_skip_relocation, ventura:       "00c0c2b78cb9c2e56b870191b7a22b62796fc99aae1a482f43ef8b8d4540bb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d8cf39a956e5031f5384f070e3656c2e320e59d28ffcbe26568066cbcdb9163"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libsndfile"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
