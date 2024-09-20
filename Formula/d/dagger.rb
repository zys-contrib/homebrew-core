class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.13.2",
      revision: "576d437da1cacd2ea15d502590878bb00795b8e4"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620ecb46485ac5ae80c9c87b17a8d8bbaa5b673b47ff9e108b4618c479181a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620ecb46485ac5ae80c9c87b17a8d8bbaa5b673b47ff9e108b4618c479181a62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620ecb46485ac5ae80c9c87b17a8d8bbaa5b673b47ff9e108b4618c479181a62"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ceeb780158bc489d507563fb544d1fea785ebab53dc59db959fe09c0821c694"
    sha256 cellar: :any_skip_relocation, ventura:       "8ceeb780158bc489d507563fb544d1fea785ebab53dc59db959fe09c0821c694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f86815129eeb6e958f7d168d5713d3b14e9c3aee74998ed94e173dadc633f744"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
