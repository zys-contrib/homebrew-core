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
    sha256 cellar: :any,                 arm64_sequoia: "f882ba1a37f7b870b374e41b6a83cb7977985f3df732dff9a017587b6ad0f717"
    sha256 cellar: :any,                 arm64_sonoma:  "5b8cb113b587508ae6bed4ff7b394ce178575c3aee0c22bcce3e73fd6897376b"
    sha256 cellar: :any,                 arm64_ventura: "262d972441c56bb9f78b74f8948600b8f598a7438511e6956996705f7ba3031b"
    sha256 cellar: :any,                 sonoma:        "08482df5c454613a50abb8a4360a45894d977b46c8bec8155ca65809a8e4cc72"
    sha256 cellar: :any,                 ventura:       "1e5785d3030ff0b91bd3c44b021c96ef0e681ab0687594e02f940368ff42d2ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426be92a991cfeb6b5a598129f5cf369620a19c69f6d70c88a01d37324eac147"
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
