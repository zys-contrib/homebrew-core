class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.26.tar.gz"
  sha256 "893feca9e1c69ff3bef006121cc94237bcdfa3a46009e094fa33f033846f4fca"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb33db73d0fcc2f94bf41788bbdbb65cc64136600543ccea02424def24bd9b9b"
    sha256 cellar: :any,                 arm64_sonoma:  "d901bdaa219a1bd27e1e1828e8649ad528ffa59af094b5cd3540fabd97c962f7"
    sha256 cellar: :any,                 arm64_ventura: "ae24ce2706270bf8c9f18b2d11e6c5e3309bf06a4128123284798dbfac4d1c4d"
    sha256 cellar: :any,                 sonoma:        "e745b18c885dc32c00b64330b74f55e2c9c7f5c4b3b8c6ce372b6a118308b963"
    sha256 cellar: :any,                 ventura:       "7dbbaf938741295ffbe64cd2cc572ffc8c43c2cd6de0a74546cf11345f2e20b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c86ee7788b10d12226cbf1579253b09402b3efd7e928c6f4b288ed96b53c08f"
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
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "node@22"
    assert_match "22", shell_output("#{bin}/mise exec -- node -v")

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
