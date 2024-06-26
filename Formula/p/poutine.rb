class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d36f1e5849599d5b56a8838818a1dc41e30e113a5f1a098607cf40b32e5639fb"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8420dc470cb1f80a0c6384a63f38da038281ea5711b69cc93e9855245750b58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c595fa80e0ad7c6ccba3b909c712f61398102682628f1c83cc4462d15245e0d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4583a9f23046bbba334edbccc3d3402178e65d7eb4b9d996e8d26a0f6ff1b37a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a61698fe6cb335baee4f1439e2d0e0e636529805e2e55aed1c969bc9b982160a"
    sha256 cellar: :any_skip_relocation, ventura:        "69186fc5b93384bc5848ec7ba37a1e23e849e71936cac3394b5da7f3c4f146fc"
    sha256 cellar: :any_skip_relocation, monterey:       "ab0b3d6b89922063b32ee2bc09959a508fa31a34c11588e67dad22c6b83b7f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03490f11616b8bcc3dda3cd40549c3b3ea6bddb1207e6f73c4cc4c888c098635"
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
    mkdir testpath/".poutine"
    (testpath/".poutine.yml").write <<~EOS
      include:
      - path: .poutine
      ignoreForks: true
    EOS

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
