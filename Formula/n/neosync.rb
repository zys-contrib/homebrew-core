class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.33.tar.gz"
  sha256 "87938bcbae301f7ae7f2d30ee5e05a869291e176da611e573b5b2070955192ac"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a413258c184b9f3162d5862458d5484c9ff06b671c87672b5fbaf963003c7399"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39aeeedb5075053f80df11f1b872041b5c5a5df2cb10dec78e1458f52e2be1e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7703e7c845e0e353e243337d87a45e22cecfa42d37659f327aa15703c571c27"
    sha256 cellar: :any_skip_relocation, sonoma:         "209d2684a1c0eb0417856930f6c91b9329c52a178a222644466326971637067a"
    sha256 cellar: :any_skip_relocation, ventura:        "bd9a6712084e9522c4e2fcc5c14422eea8f42c55b9541fcb07dea06c0f514a7c"
    sha256 cellar: :any_skip_relocation, monterey:       "8e2eac9bcdd31796c130f58cd03cde6cd19d8b4565e618fe5599a25e5dbd2d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0693fe63f75c01df45df737dbfec3ac580c04bd68121113f7348a802b28772"
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
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
