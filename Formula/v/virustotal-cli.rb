class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.1.0.tar.gz"
  sha256 "b0e6c36218107e96b7f639f77a12ecd8950b2b4d199c1fc56404b88498904fd4"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0741c2b6fc67e72d0d5fcd17989e341b83134e9b4114ebe43d0d9dfa1e0c06b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0741c2b6fc67e72d0d5fcd17989e341b83134e9b4114ebe43d0d9dfa1e0c06b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0741c2b6fc67e72d0d5fcd17989e341b83134e9b4114ebe43d0d9dfa1e0c06b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "82646679faf59607bda0a2cc4f7fdee65e9f4fcf64909cc400b9e80b60ad0a90"
    sha256 cellar: :any_skip_relocation, ventura:       "82646679faf59607bda0a2cc4f7fdee65e9f4fcf64909cc400b9e80b60ad0a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fb3edf37296d94d134a6367cc7413b55b0c8357c6517c561c2a15284216d44e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cmd.Version=#{version}", output: bin/"vt"), "./vt"

    generate_completions_from_executable(bin/"vt", "completion")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
