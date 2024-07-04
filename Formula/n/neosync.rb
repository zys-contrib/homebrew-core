class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.43.tar.gz"
  sha256 "b9feb900bdf79a5c542342f447f9a02b3d449a9fdace90f80cfb305568cc4cc7"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cabb3a8fd8d632f99bc5cf85eb5458c58e4d16c7fa4b11a65371b7b541e46db1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "538f0e6395d5eed9bb15900da7ae1b3c27821bf77d841699f0763ba2fa07054c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883778bda9bfdc66c325f90d8c7f0e7cc6517083ca9a39513f36e6fb0d282066"
    sha256 cellar: :any_skip_relocation, sonoma:         "1760b6e2992e55c5a2337c38d513aede49f7188d23447f5eca0c26d639a8e81a"
    sha256 cellar: :any_skip_relocation, ventura:        "d300aa2ec84b838766386d564f008545e77e8e0686b15cdcd19f603915b6db43"
    sha256 cellar: :any_skip_relocation, monterey:       "bf3a6b163af0039d1f0ce5963974606bba68f687888d76b046e8afab1e5ec11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c1ac7480065c7621ec7246a79215792eb1b764461c337f26b993dc6ac824834"
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
