class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.39.3.tar.gz"
  sha256 "21e6db1df48021f48a48c4e81e2fea9c17fbb00a8205658524cfe98d13155d88"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9065eab0c638adf28e4549a32b2e2c27e177010a4ac2677dce4225ac583ded04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a7f165286606d506bc41c163fcf293772066a512b2bc39f28b0b949b0a3b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0500764f7218b2306d9a1375deb39c7d784ab003d9211b5d3e4a9c31d6686947"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab9e7b7e96b7ac9373db0f36e1168513c7a07958bcfceddadea6ec0cd3b26a9b"
    sha256 cellar: :any_skip_relocation, ventura:       "30a9377983189e573db75b4fe31b579b9573cbfe8fd118b3534373bb4af71dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620313a95b8538d9705df6862e2b820754815e0ca9c8d1e17093632ec446b440"
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
