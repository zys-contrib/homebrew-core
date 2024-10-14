class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.10.5.tar.gz"
  sha256 "6a2edff4dd0cc91c2d81741b29b6fa2eebfeae3b6d76eec677d55f439104631d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98651b4dc86130de395e528092ab34477107beedb67741e770647839bfe59967"
    sha256 cellar: :any,                 arm64_sonoma:  "6d3eafd264ad2a0f7042702465004550d153405536285ebbccede7b8025f663c"
    sha256 cellar: :any,                 arm64_ventura: "9dc87c06474f0f50ca485654309381c043abf424dfdfaf3558eb7c181d37aa4f"
    sha256 cellar: :any,                 sonoma:        "4452b0263ec430546200c8405b21b05d64f2dd95b9764c36e2a595eae1c632e7"
    sha256 cellar: :any,                 ventura:       "b840508d1efb8ddeead1e9254f2ccb44814911dffe011a8ddbd8b116395fedc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "391ac6584c6072f6157643e34899c747d7edc2c82b9baceed7b88838e18a3f43"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz" # for liblzma
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}/mise exec terraform@1.5.7 -- terraform -v")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
