class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.0.9.tar.gz"
  sha256 "b668c9270a6a42a634544e413f87c6fb5411960f9af050d0d3761cd00314fa1e"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "652eb3919ebcbecdfc9b46e269db2ac2a96941bc65048792302e5ca41922c8e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652eb3919ebcbecdfc9b46e269db2ac2a96941bc65048792302e5ca41922c8e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "652eb3919ebcbecdfc9b46e269db2ac2a96941bc65048792302e5ca41922c8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd85bae5823a3a8364a162e39083e0148f5e807e8994bc451abcf1f4a07e773c"
    sha256 cellar: :any_skip_relocation, ventura:       "bd85bae5823a3a8364a162e39083e0148f5e807e8994bc451abcf1f4a07e773c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f879f38b842813bc79f8488898b0491262ec70616465d8d765ed783351af9ef"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "ERROR 009 (User Error): no authenticated workspaces", output
  end
end
