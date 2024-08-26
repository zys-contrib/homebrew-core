class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.22.0.tar.gz"
  sha256 "ada2d56e14ce2eadaa88573dada5881684ceeaaa11df23017631b91dfa745d00"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "15fc995728c023c5288544b50003dc3b2953db27e25da8df04032e259a821e43"
    sha256 arm64_ventura:  "b76af61f85ec1c7a3370f3b6a792b46a2c5501eb56cc1334e16d440768e31533"
    sha256 arm64_monterey: "236d9573990aa3f46cf396a6963a535309f4af743649fb573f36efc6a8840ef5"
    sha256 sonoma:         "b641531e953f6614a241087b9fbe08faed572271d0bf4cc794cce18566edd800"
    sha256 ventura:        "63a4715ba2fc656a0cf40c7a4e24d0ae15f7a2640e190b98b181b61b1d39b2f3"
    sha256 monterey:       "4adf09dd2940ab9f45251e56ddf16da63ca79ebbea4fbdf76bc195a120e8faa6"
    sha256 x86_64_linux:   "dcdf1470881ed9f621ee19ae249397783e33c349bd3d9bf686304d3c084316c4"
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
