class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "5255c1fb4e21889cedaa718ae68be5a6ace759fc4d1782f03f01535b627bc941"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8aa38fa91cc82753e12abfc40ba7f924230ed4bd8706ba9be5cf958080a947b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb6cd2dbf7b67bfadb4c5fbc3e1954b82428d2c5affa123df8c5855af258630"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d6526105667c11963fe675db2725228d2c87493a538e84882ff73a58b395529"
    sha256 cellar: :any_skip_relocation, sonoma:        "37ee4f86eb999464da84d316fc41ead96aa3c6ff19e9dbe67c1848f912e2e62f"
    sha256 cellar: :any_skip_relocation, ventura:       "26fdd4cbf5e6e922ef6768fa42237846606ca4a41b1ae636e186588b5c59e5eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47ccae1b791a9e2e93291d597d649da334646abad0bb3640c10f4f139d476264"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
