class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d8f2652587317c07dbb146654955774edd61b79abf9232b261ba0641d0da90d4"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end
