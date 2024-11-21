class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.38.1.tar.gz"
  sha256 "3ab3039e66b571a7217408fb5f2e58a1c3c92782e061cd5423147b080ce2d663"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0056058d3b205764e235531c6ed7406275a48b2f6655918236fa7f69059f171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db88f8f1dca124aa504fba294401602c9e5fef67c9f5f109ad2c4e10796581e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f9c5c7e4a81cf52e067cde1588eace836ebfa41e5e08df57a84bd29379ec8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f22d7d4c4bbc37e7253979a71c993bee4757819980e547f4ce5a47c5a770151"
    sha256 cellar: :any_skip_relocation, ventura:       "841b0bd4fb9e592fcfcfeed151a5681eb3cd6ba1e6a6f6f64aeb07122e5acd4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b68fcc131ffa794c28cf7089113ac5cdd9e2a3bebcf85821d8a29c4eefe9522"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "crates/sui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end
