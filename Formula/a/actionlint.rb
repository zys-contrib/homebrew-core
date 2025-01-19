class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "237aec651a903bf4e9f9c8eb638da6aa4d89d07c484f45f11cfb89c2dbf277a5"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd6d76f6e07f1908754e770c907782702154fde31c66651b5296301c9f54947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bd6d76f6e07f1908754e770c907782702154fde31c66651b5296301c9f54947"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bd6d76f6e07f1908754e770c907782702154fde31c66651b5296301c9f54947"
    sha256 cellar: :any_skip_relocation, sonoma:        "b680789b47bba8b2a0438171315072575432c03845e88f083f89a7d31f6a93e2"
    sha256 cellar: :any_skip_relocation, ventura:       "b680789b47bba8b2a0438171315072575432c03845e88f083f89a7d31f6a93e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f300027c75eca3be9900adecb2065a5dcf2f6b349355421d2f258f4d1be5ac"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "shellcheck"

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionlint --version 2>&1")

    (testpath/"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end
