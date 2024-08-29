class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.8.15.tar.gz"
  sha256 "f544f01381a42e4c7225bbce99dce876390fc6c45dd4697fbca2a47b2e0b4e0a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2617ead9446d0182dd3e1738dabf583a6379f95990eb8298c0c42ce3ea78cb55"
    sha256 cellar: :any,                 arm64_ventura:  "eb853b45d67c9b2a3f2a1d2722fc400fca5678ef285ca48db768fa472668cf3c"
    sha256 cellar: :any,                 arm64_monterey: "05425618991f0b53b42e5c148c7c4f32b1d42b4e0c669ffe5051b134ae09dd98"
    sha256 cellar: :any,                 sonoma:         "d7171d3348e091cfc656ec5839b315dce77bc3003cac8dce1da1eeb404870115"
    sha256 cellar: :any,                 ventura:        "799fbff9d37627df94eca9fe7786c1334516e454369ecc14b5e31e8ab288c582"
    sha256 cellar: :any,                 monterey:       "0a9918beac70734b43b791dad04a78004aceb6fb2f3ad1d226300162cc5c72ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb338ef63afafdfd03f8a4af770b1885b8b12f8e433e528f2e6d11458ad933b2"
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
