class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.17.tar.gz"
  sha256 "5459d053cd626f9202cad5aee98c48a7c2eb61487d544e6a64a4af9a276b3199"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43af0658995f79b3f5bd0cd363f1e92597c03cd78109607fc0c20eba08724365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43af0658995f79b3f5bd0cd363f1e92597c03cd78109607fc0c20eba08724365"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43af0658995f79b3f5bd0cd363f1e92597c03cd78109607fc0c20eba08724365"
    sha256 cellar: :any_skip_relocation, sonoma:        "6437912a0932d8e3f54b8eec445e6638a5033d001e03abcf7a94f0bcfae4dfb8"
    sha256 cellar: :any_skip_relocation, ventura:       "6437912a0932d8e3f54b8eec445e6638a5033d001e03abcf7a94f0bcfae4dfb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e7702b75e557ea30f0b2f1daf73e9e19ad914bcd0f7652b71b500a93bd6400"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
