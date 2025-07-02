class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.16.tar.gz"
  sha256 "e5d1fffc37feb9243c6d29fa2e9c9d910522c0d546d52204773cb27ee5d5115c"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f4b68715bda0101d061a07d0e68f926b6a9f4acbc1366cfb863faabe6add69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d6bab1ce5b0829d17a1854d3f9bda0af9d5af6ca7bce89a17ef665f0a0c9ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b6a6748dd091e113d1ff927eb5cc13011dd9ec3760abb2842676287fc70339f"
    sha256 cellar: :any_skip_relocation, sonoma:        "98a1c08c86fc2270c9d91be36379279d51db05b0c8f100fd062cadd387e79985"
    sha256 cellar: :any_skip_relocation, ventura:       "732f13d200a58506af27403cec3ee3357d5fcf31b58e477f94721e33f6bdda44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38e4b942a8648d1786a2df49256779f860d50268257140977fd2a761cd65a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "651287699bee5457dc2efdd044e8be39d9cca6045a4d1154d2ebbcfc78e49121"
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

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
