class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.40.2.tar.gz"
  sha256 "691911a2b8a177a511378866d5e3e7e705f1f4da6dac624980fe3ab1701e87e8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e21876af96148be64caea60a2f5c14c6c7d210f9b3ee00f82e1117b01e9fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37bec3f2bf089f649e6f7969a4e14adad60223053a7afd4ecfd13d1d2be9e096"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70f20a3e1e9d931ed7259e0ec479ce39c68d9caffb34220496d2c04c0097a921"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9156bb7888c4507d5fb28ac42f67aa8a5923c139428acbbc6dc5c3684869473"
    sha256 cellar: :any_skip_relocation, ventura:       "7527c63d4aaa6799f9bb19277471126187bcfee3501d15a883e86b7dd17181b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "034c010b384e52b64d6e78a7a9c5d567046878863898d7f729a3f983e25d74ae"
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
