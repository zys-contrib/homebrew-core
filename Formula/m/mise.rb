class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.12.18.tar.gz"
  sha256 "8b9a32214636b07be94dcbfa6e0221337a78949106153572ee88fa04f0477f3a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da4b1145201e1d9f9dda902351e42498f1d2140d95706ce7078b4e0d4cb79042"
    sha256 cellar: :any,                 arm64_sonoma:  "70ae90ba9162b180a0f51d105b1a90863de19ff872e5cbf72c67d90831339909"
    sha256 cellar: :any,                 arm64_ventura: "81c600a50c705a692e16550053340ac03243b1856cd21533f84b4d61ae87cab1"
    sha256 cellar: :any,                 sonoma:        "5c52e5163b565ad10ef25ee6a6bbb6060ffe165825c62873893f12063759776d"
    sha256 cellar: :any,                 ventura:       "d6e0c457982e65d3bd6c012d594c3032ec5e42d35e25a3e45c5f7562454e675e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fed6050501220751d03a99bbdf7a49d1cfb60a0b47b4e03d30730f3fbe0e05b"
  end

  depends_on "pkgconf" => :build
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
