class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.32.0.tar.gz"
  sha256 "a397846ea5b46c0caf2b46cb71464127d2daeded61b7cc4d21c648b29ac34bee"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "d1f37cb25033bd37569d4502c4675ebaf334120e09e98a2c17545179e5c0b4ba"
    sha256 arm64_sonoma:  "65400baf27dc31df35e6ad06f893ce1cc87ab927f05be52453121d3843bbab50"
    sha256 arm64_ventura: "a2998e7daee33240b1e2bc453278d04dd29f19e96b4b21a4d0d60f8c2ce30c0d"
    sha256 sonoma:        "c318bdb8e74a4f42acaa9141bd4da92cee8feaa698348db6c48c17110664c63b"
    sha256 ventura:       "64bd85bd5392d4b337f1e7d11979536f888831ba87bb86169eef12bde7f2ed9a"
    sha256 x86_64_linux:  "39ddead4cdb197f1fded9341773cea98748fe095837325770980dca8adbabcb3"
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
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
