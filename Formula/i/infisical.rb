class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.87.tar.gz"
  sha256 "be1c32f42b9e6f91bd465a1173e65a0552be858dbdd25332810dfb7809964435"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e47c53023c782eb86bce8cd9fa88f8daafee6a783800f607db0e9cfed757e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e47c53023c782eb86bce8cd9fa88f8daafee6a783800f607db0e9cfed757e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e47c53023c782eb86bce8cd9fa88f8daafee6a783800f607db0e9cfed757e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7c39532c50a12718a7563862bd64cd61065509eebde2208719ac9164cee5ec"
    sha256 cellar: :any_skip_relocation, ventura:       "5f7c39532c50a12718a7563862bd64cd61065509eebde2208719ac9164cee5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d14ac04f0b78a830fff75b6060473cbf72c566cb11ba76afbd5b7d752190aa7"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
