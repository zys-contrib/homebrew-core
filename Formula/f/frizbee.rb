class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "f3e7e5b111588347b968179c03de94bfe1b1137696fc3d01987868ac5f08bc97"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d493d35fc33fb6a7ab95909fea881860fb489997e8955412f9be3f65c94b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d493d35fc33fb6a7ab95909fea881860fb489997e8955412f9be3f65c94b72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55d493d35fc33fb6a7ab95909fea881860fb489997e8955412f9be3f65c94b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa37e13bd2999e782103080a746b4bd8658aae65302b65a69c995de01ebe1de"
    sha256 cellar: :any_skip_relocation, ventura:       "ffa37e13bd2999e782103080a746b4bd8658aae65302b65a69c995de01ebe1de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18114600f41cd2d5b8f1a3457a8a0a0b6776cfeed30187008935d1670df0a63"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"frizbee version 2>&1")

    output = shell_output(bin/"frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
