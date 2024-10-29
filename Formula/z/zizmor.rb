class Zizmor < Formula
  desc "CLI tool for finding security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d743533d553538b5392ea3bfc45b27d1b55606280babd9418f9cfe7af0273ec0"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/action.yaml")
    assert_match "does not set persist-credentials: false", output
  end
end
