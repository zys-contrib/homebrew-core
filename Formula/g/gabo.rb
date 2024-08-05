class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2aba8f85f9d241217a56847c372f7d7a001218073f76f8e791bc161edd525611"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    system bin/"gabo", "--help"
    system bin/"gabo", "--version"
    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_predicate gabo_test/".github/workflows/lint-yaml.yaml", :exist?
  end
end
