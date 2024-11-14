class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.11.tar.gz"
  sha256 "632faa5fe8122ee3f7973fec6eb8c7ffcb7ad498cb8d55a6e7adcaab7551c79b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4329e1937f538701a23039941b8fc6a193a279ab979cb1c0bbfa867a5940565"
    sha256 cellar: :any,                 arm64_sonoma:  "be52fa159e85c8a709ee6ba4a75ca14ab4f2cabc7237e17967f5a6e1440d0675"
    sha256 cellar: :any,                 arm64_ventura: "d88e6cb89f1818d3d650684fe3a3e40c53739a3eeba9d98b25857818362cc684"
    sha256 cellar: :any,                 sonoma:        "43795190f162f116e29202e20bff40e2e3c2f28384e6c25924c1d69cc8ab340f"
    sha256 cellar: :any,                 ventura:       "5bf1439cd871f4321dd656c87d3c203635ac74b011f8e495b6915e4c6d1cb7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "538431ba60b95664702e8194f1bfe897c82d44d205106c1451fe08ee991d4367"
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
