class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.40.1.tar.gz"
  sha256 "de1a41ee23273832d4283fca2002a9809e3f38259a0f4a497e14d5ea04b9be90"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "0bd069671eb3f2ddc1f65714a157ec624e6dcb8712a26b91ef8d06044f9d4b84"
    sha256 arm64_sonoma:  "55471f6279e431ffb5f6755495ae08215b30c0205010ae0c618c1535d7867317"
    sha256 arm64_ventura: "46472a4ec1757d3f7424d9bcd9d1b49c85e3ffde6bf986a9ac428a7dd4dc651e"
    sha256 sonoma:        "fbb75343bfee8e9c952135ce807e5e8c71570a3dee4e2055481bc79368a7b088"
    sha256 ventura:       "3bf89e43a5b9399a28627426689d4f7b9a46ac4869e452a52a3be66cb4ded71d"
    sha256 arm64_linux:   "a7165e54101445b38ae682cc744087142c27cc58c095957628556d914b6fff4f"
    sha256 x86_64_linux:  "929ed24430b53e425bd0c9c6ae0a5510295fc907353b60da19e4129587262862"
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
