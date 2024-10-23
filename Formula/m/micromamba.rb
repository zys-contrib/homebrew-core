class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-2.0.3.tar.gz"
  sha256 "564e9ffc91015e8b1699f2de1baa59449ab037f27e4c19355680a0f145fd2b9d"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3bf5ba3e4fa863d6072c78c4229e533efaeda27137e78191c3c5d852470f46b2"
    sha256 cellar: :any,                 arm64_sonoma:  "01eed43203215173119a8280a7ed2f97417f09c236ac279d95ad94fe57af8fd1"
    sha256 cellar: :any,                 arm64_ventura: "273313c71f6212077cff10f6ee2ba00fe2d50056d356088935d38204bcf3ab71"
    sha256 cellar: :any,                 sonoma:        "e0d5863f983f062ea6e108d8258d755ad0fd28d9d5fd764d559b8ec46199aa57"
    sha256 cellar: :any,                 ventura:       "45a20d1caddf34134b10cd45b6af40a5db46787b44a5a358ba0cf306871a2076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3af94e30de7979583d176e00f31195eaebeb24fef85f3919923c7de5ead80fc"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libarchive"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "simdjson"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  # Fixes PR'd to upstream in https://github.com/mamba-org/mamba/pull/3613
  patch do
    url "https://github.com/henryiii/mamba/commit/d789f35b38852da2e4e3f6073b32e1119b8d471d.patch?full_index=1"
    sha256 "c183d63f800d8c6d04d9be95366d1ce2af199e13b61b6d5bd0e314f90f3c9d3b"
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_STATIC=OFF
      -DBUILD_MAMBA=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Upstream chooses names based on static or dynamic linking,
    # but as of 2.0 they provide identical interfaces.
    bin.install_symlink "mamba" => "micromamba"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/mamba shell init -s <your-shell> -p ~/mamba
      and restart your terminal.
    EOS
  end

  test do
    ENV["MAMBA_ROOT_PREFIX"] = testpath.to_s
    assert_match version.to_s, shell_output("#{bin}/mamba --version").strip
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    python_version = "3.9.13"
    system bin/"mamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/mamba run -n test python --version").strip
  end
end
