class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "e388d32e3a3e22618e420dff605f393726dcc17efbd4b84c8ebac8a1681743b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "897e5b90a1bf2f423f49f0644975aaf4f1afbe88800af3726339d732d6465953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ee4a3092d9d033ff94720d573eb42ec77ac4c11222694d1c0b10d78a7e6a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a3ec7b2730c01c32aad01d616ce884a5ec822f2c906be14bc280380c52e47f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a5d2b448b95d96eb6216b159927faae8be74ce49d56c01ed1232ab3d768412b"
    sha256 cellar: :any_skip_relocation, ventura:       "0e8a16a3c85205f967fc4ba95c4f496c72805f7814306f16f41bd3b0d090f377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a2cea38823c77413da67369d1d2722396952839edbd9c99fe65567e1f82952"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
