class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.43.0.tar.gz"
  sha256 "68ddddc46d3c71e014f32df2c7c14b357dee2065afc86fec7a76a1e1645217a4"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1d913ea33c427dc6235d27116dae57bf979a49aac82bb9ea746b613a1d831e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1d913ea33c427dc6235d27116dae57bf979a49aac82bb9ea746b613a1d831e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc1d913ea33c427dc6235d27116dae57bf979a49aac82bb9ea746b613a1d831e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c79be3a7f7a1928a6785e2b7fc59a51ec91de54142ba8ade059088c43c477a5"
    sha256 cellar: :any_skip_relocation, ventura:       "8c79be3a7f7a1928a6785e2b7fc59a51ec91de54142ba8ade059088c43c477a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbea15871ce606f75353b5d788c691abdf31afe5999fea701bcaa32e2399795d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
