class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.39.0.tar.gz"
  sha256 "f07f9a81460b1a30ccb16c8c7b9b8021f8618d307a708b8ed36d439a403db92e"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "1bc0c4e06234d135bdef98fb033ed41be59ff80bc958e41f055965ac585eb991"
    sha256 arm64_sonoma:  "9a5c95a60fa2f1ace5ec346ec123d933bebd53f82bb8d2179df8e9c6d8a5101e"
    sha256 arm64_ventura: "1d60fe0164bdce21c1972d149c2027d244d6f06f44e700ad0377264266e78b08"
    sha256 sonoma:        "6df6bffb52933014518748cdc3028577e9fd43be16c7680ead1808b167ae19ff"
    sha256 ventura:       "92b450325a2642a399c5f34787e021aba37e59cf5c5c9f46dcd67f975a45107a"
    sha256 x86_64_linux:  "58f887c26d79bafd1322e7e9a607547b588921d8d48f40535372abbe58d157a4"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
