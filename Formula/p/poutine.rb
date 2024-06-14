class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b74028a79b960cdd9765c4fded68b8734c27b6423e70ac31d37e8850fd6bc930"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c713feb6dd0b2e1ec3b9e08faa5311e2ae617e33cbcdf7c9603b0f3e0bd4292"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd43a9647275c7d9dcb9bc01b92dc36ad42ac0396b76c0bce91b0c4d9ef7ae97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c53f6c621f827801a0ae38f31699fe80421d535c2c5d1525c560ee493a60fa51"
    sha256 cellar: :any_skip_relocation, sonoma:         "93b7ab36efd7fc9f9be6600442bee9daa564298bde6d3cfbf5fdab6aeeff52b2"
    sha256 cellar: :any_skip_relocation, ventura:        "8afff2452c7cae88dd1d8490ca9109eef52b3785e59f4afaef650b0f358c9d05"
    sha256 cellar: :any_skip_relocation, monterey:       "33cdd6874af910daaf9d7cb8d0e1a31522023fa69f6355bfff038213dcc35ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f09e612a17c6a1657ef53b6415976a4b20e25406cec85c1024712fb8e88a9149"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"poutine", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/poutine version")

    # Creating local Git repo with vulnerable test file that the scanner can detect
    # This makes no outbound network call and does not read or write outside the of the temp directory
    (testpath/"repo/.github/workflows/").mkpath
    system "git", "-C", testpath/"repo", "init"
    system "git", "-C", testpath/"repo", "remote", "add", "origin", "git@github.com:actions/whatever.git"
    vulnerable_workflow = <<-HEREDOC
    on:
      pull_request_target:
    jobs:
      test:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@v3
          with:
            ref: ${{ github.event.pull_request.head.sha }}
        - run: make test
    HEREDOC
    (testpath/"repo/.github/workflows/build.yml").write(vulnerable_workflow)
    system "git", "-C", testpath/"repo", "add", ".github/workflows/build.yml"
    system "git", "-C", testpath/"repo", "commit", "-m", "message"
    assert_match "Detected usage of `make`", shell_output("#{bin}/poutine analyze_local #{testpath}/repo")
  end
end
