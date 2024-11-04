class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.4.3",
      revision: "9a68c54d53d6bca9f1d2ef8ab981fda11a3ef4b5"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb000cab1a73706a917994b8d1e3c9d509c85369ef373a0c016d5764ece6c16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb000cab1a73706a917994b8d1e3c9d509c85369ef373a0c016d5764ece6c16d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb000cab1a73706a917994b8d1e3c9d509c85369ef373a0c016d5764ece6c16d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b611436e744703f6cfdf01622f5751b166da0ac0447455ddb7a3277ab9e1e518"
    sha256 cellar: :any_skip_relocation, ventura:       "b611436e744703f6cfdf01622f5751b166da0ac0447455ddb7a3277ab9e1e518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0981b85a0d1b216d2d17473f3ac6ed28e86999de3a6520b6bd0312ce5ba14fea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
