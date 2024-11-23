class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.25.tar.gz"
  sha256 "3eacc0e2d8a236153b572673e6410b33c0e5fd17956dd4828a4557b481f620fe"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "431980c5e82fa529638304794c1672cc3357be6256c3d08b5abcd730b4dd600f"
    sha256 cellar: :any,                 arm64_sonoma:  "7dd0b46cb6eed4b5b657e7157b7a3ff0952c9459c3d53bf6e3e9c8e37fa1a78c"
    sha256 cellar: :any,                 arm64_ventura: "fc4915f7d5612cb5446797d33dd9e06027c741ee888e35c53352ccb8b19194e9"
    sha256 cellar: :any,                 sonoma:        "23b6abf40f9bc47b49e228fc219e53b51ac790475f2042b050954cec4a26f702"
    sha256 cellar: :any,                 ventura:       "4d05f16d601ce20a8488e910bad92bce9f2e9871b52c869bb729e4747e858ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89244db2cae30864ff167e31f10785f99731be645ff3fd41683de77c3c00065f"
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
