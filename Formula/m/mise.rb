class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.1.14.tar.gz"
  sha256 "6745ef5b1be5478848e1e45d826dc1e37b177efeefc5fedf6fb184ddb7204aac"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31c5263ae3c204162e2f83b066ba9654daf4e9e08fa4bc419655b852128ff1d5"
    sha256 cellar: :any,                 arm64_sonoma:  "03c41df16b07a442b9fc60b190354532aa648ab2376d0f6787a61fccd642a91c"
    sha256 cellar: :any,                 arm64_ventura: "909e25f0c4d98e874245862b52f27cc38fcd80b34c1deef601b839ca19e00d34"
    sha256 cellar: :any,                 sonoma:        "487760227a7352d2fcd1571cba587abd77d8102c1a43b9774cd30da7fd83b5da"
    sha256 cellar: :any,                 ventura:       "9ec06288f46ffcaf76b9d26ca316c73195b0cd2eacb59e8025de3affb6a82637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36dcea969a1e770e01539a9ce8c34cca4db4d37bf8fd6da7676f9ffdd522106"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH
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
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")

    [
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
