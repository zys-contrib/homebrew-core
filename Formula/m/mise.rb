class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.28.tar.gz"
  sha256 "3599b14201ee1a723ce3934043249d38742ba51e7009234d65c0f8c3b3525e2f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36f6f09c852549641d96d237a62b5983a0be37d97b244241610169f9a4ba9319"
    sha256 cellar: :any,                 arm64_ventura:  "f931c70c1662131a1ea448a8269ff56ae19724f7eb71edb5d4baae23b5de1781"
    sha256 cellar: :any,                 arm64_monterey: "ad93b371b212601c63db8c26d45c28ad5e7ff074302435a702625870b834e2b7"
    sha256 cellar: :any,                 sonoma:         "aa68c13e66fd97364b9048a90e1e355ea981dfc6f61d19afa9a6e34edad080d3"
    sha256 cellar: :any,                 ventura:        "9f121dc28983e73092c2690a01210e064f77e65e39b6939581179350b85fbd39"
    sha256 cellar: :any,                 monterey:       "30118e7cdd02c9bf0a00e5d18081b6401637b808f532c1b24e795dc04879f21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42007413b2193eb2073a0d38d97db805121891dad7ea71353d0f71d15c176267"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

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
    system "#{bin}/mise", "install", "terraform@1.5.7"
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
