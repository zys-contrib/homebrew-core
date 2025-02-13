class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "4ef1034d25a547380aecf491b43c3fc214b7940c19cb7d7cc763ac87dcbb6438"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf03e6781af299856d50f80b8a0a9e243a68aff75a26e9df6888483d1111558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdf03e6781af299856d50f80b8a0a9e243a68aff75a26e9df6888483d1111558"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdf03e6781af299856d50f80b8a0a9e243a68aff75a26e9df6888483d1111558"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b59053b1b0c3fcf54a849283d551543c179dc722e0a59f6da805c2a5f334e60"
    sha256 cellar: :any_skip_relocation, ventura:       "4b59053b1b0c3fcf54a849283d551543c179dc722e0a59f6da805c2a5f334e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c56c1c65f6a78fe034eec1036825cccfbc7a0f12c1f82d4b49d23ccd6df67e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
