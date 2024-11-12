class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "626cc531b5682b7f08513736df76a060c9272066f87156bf94194d6c1887d018"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adcac8fef947c7328f92f04c88f6f6a03f7850ff6eda76e8c61641b801aa30e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adcac8fef947c7328f92f04c88f6f6a03f7850ff6eda76e8c61641b801aa30e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adcac8fef947c7328f92f04c88f6f6a03f7850ff6eda76e8c61641b801aa30e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "341ad9e33312dde036869e78abdee6e39c13d4e48c5fd574031b0421e4386949"
    sha256 cellar: :any_skip_relocation, ventura:       "341ad9e33312dde036869e78abdee6e39c13d4e48c5fd574031b0421e4386949"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    YAML
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}/awsdac test.yaml").strip
  end
end
