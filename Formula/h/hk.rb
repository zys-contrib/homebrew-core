class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "6313818ca222aef08c537ba2ef4a132f1087d689fb8aa020bbeab121f5fcdf92"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b63b9540340295cda86ab10f1133da3f727a906b034f66e92ea0d1fdafbb381"
    sha256 cellar: :any,                 arm64_sonoma:  "1fe4b82b3547c3fc79b7a25a11facc2bcca83f6bae94670ada777aaa8ebe55d9"
    sha256 cellar: :any,                 arm64_ventura: "43e96ca67e818e00fb7421b8c5337ec326a894f4cbda7c18a8b07f9806ab004f"
    sha256 cellar: :any,                 sonoma:        "e8a73127f864c78057e02ede02930e223fe8bc68f677090b02f84c8a5f783347"
    sha256 cellar: :any,                 ventura:       "608a3112844642e3c3b5a0feb34dbb065ba374e082242f725fd8ecb6dba07e01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ba6d31433a67a2b5475115dd138380f2173f215d1da1f08aa22ea4004715b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226302aed91174074659597cc40870bc2ffbff827f9f550afc4e98821ae8de68"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"hk", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "package://github.com/jdx/hk/releases/download/v#{version}/hk@#{version}#/Config.pkl"
      import "package://github.com/jdx/hk/releases/download/v#{version}/hk@#{version}#/builtins/cargo_clippy.pkl"

      linters {
        ["cargo-clippy"] = new cargo_clippy.CargoClippy {}
      }

      hooks {
        ["pre-commit"] {
          ["fix"] = new Fix {}
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
