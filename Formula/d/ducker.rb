class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "dc63b9755f40a68dbca9137f1feffe4750da7571cee1c3e3b646baada1569cc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487da8aecf1084d1e3a42e44fe7ed902f91a41c4063f8f4313ae9c88d034c87c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "031db5dc4417080c9f39329ae0b16defbc399035f78a47873b178667dfb28ded"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9b41a2dfbc3cfb1669738b6d0c0bd322cf213f5381675596ec96e24a45a422e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8648905f40407409ead10a3509eae50472de3f4667070dcac28cadafd474cb5a"
    sha256 cellar: :any_skip_relocation, ventura:       "92019cbfb6bae785a8e6c330348d07806ec0fa9e5147a91c844c8da8ee39c596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "196f64e26af168f7808baeddd15c30edb1ed09f69f39ac9d2a27c234574f1757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe52aa9c83edf3fb2576d07241bf3e074c31ddaef85d0883afbfb992605d75e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
