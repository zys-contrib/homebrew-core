class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.223.tar.gz"
  sha256 "e44fe1b905b0f095c4cbafacfa3a04ca2e364e394218dcb3581e99441360697a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f4c2440cf82a7c8042f821d27fbc98fdf82f6a4d6bbb69f8059eb98e8b40e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f4c2440cf82a7c8042f821d27fbc98fdf82f6a4d6bbb69f8059eb98e8b40e75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f4c2440cf82a7c8042f821d27fbc98fdf82f6a4d6bbb69f8059eb98e8b40e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef49517e20adfdef9706824bab5260bc3760a36d80d54591eeed2f2bd3ab153a"
    sha256 cellar: :any_skip_relocation, ventura:       "ef49517e20adfdef9706824bab5260bc3760a36d80d54591eeed2f2bd3ab153a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de9629196afdedc87d5f0e508ca9d6ace658e58d9b5c71eb72e83b446602ecec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
