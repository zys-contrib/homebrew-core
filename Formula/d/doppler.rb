class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.74.0.tar.gz"
  sha256 "7174cf7c963e939180cd07e325a163e2712ad1346b2aef09a267f0328fd9ee1a"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35670aacb361f976a2ad44ff2259cd9f65944fdfd73e19bc2c38a188a629781f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35670aacb361f976a2ad44ff2259cd9f65944fdfd73e19bc2c38a188a629781f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35670aacb361f976a2ad44ff2259cd9f65944fdfd73e19bc2c38a188a629781f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d6e32e4bfbc7dfdc20df51f519d191c60acf4f2f473e769e9b6ed0c5eb0d176"
    sha256 cellar: :any_skip_relocation, ventura:       "7d6e32e4bfbc7dfdc20df51f519d191c60acf4f2f473e769e9b6ed0c5eb0d176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae6ba10a9a861404f2345fc99bfab05b0471f1e434f8fe53ad30d2ec77e31eb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
