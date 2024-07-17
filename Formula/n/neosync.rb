class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.45.tar.gz"
  sha256 "6a8f9fe0bd4e7be6874ec1104e7c6f3dfa2932fd1a90bb769ba5a09d815845ec"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c1763decea86781f19dbb090fa286279bbc8d9c84cce5e60917f71cd8f32999"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3feda3bcd6e56c1bfa9ddd024c538e060838e9612705cc25875f732e9e5f957d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451ac2522ae75b5b1ddf18400ba0848b7b106412f7bd1aafd530c57dd62309bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f214aecb9f1d165be923bb630656e837ee2f9ab49b2981a5813fbe2fc95fb952"
    sha256 cellar: :any_skip_relocation, ventura:        "6224e74eeafe706855feddc454e67d9e2a69813bbe02947471d9bda24bfa4782"
    sha256 cellar: :any_skip_relocation, monterey:       "b3f2430e5bbf77b85421ef3e4b659d288d5df4033f717401c29922a4d8f6a2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef64d2d57876c490559c47bd49f42f921198024ad4bdcdd5c91c8c3bce3ed8d4"
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
