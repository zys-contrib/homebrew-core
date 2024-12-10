class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "792f763c24a961f154dded8236f0cefc29dbd62534a6c167ceb9056384b1e021"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6461ceb7783eff4a0a02c18f658b10d8f879cc2caf1c43819fd434a6fc956ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1fdef434e79c6a52689a68b3637a57944ce957502f4d73c90f435a63d721b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20b70988c29c160ac6493554c90a9cc1ec6b6b384aac02d46e5cf959e17d383c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac9ce3bf4fce8989515957b800bd72220d79c579f0518c90068da52c1423ed4b"
    sha256 cellar: :any_skip_relocation, ventura:       "5e0df82641074afc4e8838725d4d25134da71e36c95ea86aeadf632f88082c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710549e983b3dda5d3eb380be29b63cc411acd9d2488eba1e58da8e4b99fa650"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
