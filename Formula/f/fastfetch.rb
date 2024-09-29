class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.26.0.tar.gz"
  sha256 "30e97fced444013d3be67c783843984727cb4194a3e1652953737bf2e1484470"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "7c34bf5f0b08d6c2af763c0da11e0041a8a053e3b305c70f8097b09d8a0d210c"
    sha256 arm64_sonoma:  "d204ab10c07f8b52d7762d9bfee06560fdd28a2fd79ddc8a997a22294dd1f3e3"
    sha256 arm64_ventura: "1c70ff2f5fc65952e79a802d257eae8cab550db58ba7811d6d0e85c809fb65cf"
    sha256 sonoma:        "463325359b6bd3419b0b262607a4d1c954a738c3b2dca8098f787aa4763eab0c"
    sha256 ventura:       "c4b8c0b2e8cfaeb194ddd278693c77bbd4c955899997dd978cca320648ca1ebe"
    sha256 x86_64_linux:  "0f75531eaa66a3c8230b2c1ad23aa0f6d89cfd100720a308d870a0c143baab0c"
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
