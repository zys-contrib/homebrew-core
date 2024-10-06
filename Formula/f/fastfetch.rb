class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.27.0.tar.gz"
  sha256 "a861e2e4962531e1ea1fc405c74d204136a863f529dc2d49a8e1447d1e5cccc2"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "31231dfaec9411391b5e5d42e234ce714175e6dbd4e5c362a6218a793398c282"
    sha256 arm64_sonoma:  "0a978b601a4a7c35b427d41221ff0f22b88a00e534126351705e121e3f115410"
    sha256 arm64_ventura: "1a9ba9c408eb0c348e4cf5b06852ab0a4f4edab402a617d9cb79a69a8bbce09a"
    sha256 sonoma:        "0c3e7a8b10bd34e2cc87a685ff9eaa8167a04f0ae4cd37c63829e8cea12a7af8"
    sha256 ventura:       "4910f2c058e81b864b4614b3d98fc5bbbf2250fd8179646b56162f547d8d8924"
    sha256 x86_64_linux:  "2095c3bf5e6a31d45696345d8563687f87395f12f9001c5907141948eb9e7e8d"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
