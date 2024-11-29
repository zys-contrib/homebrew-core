class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.42.0.tar.gz"
  sha256 "66c76065668a3ade672504a82d2ca5ff070610396909170874f4ad24eb6763a1"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88e9d3462ecae61106c0e42750a3c14e02cc892afdc208559a67c4a2b8c21dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e9d3462ecae61106c0e42750a3c14e02cc892afdc208559a67c4a2b8c21dd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88e9d3462ecae61106c0e42750a3c14e02cc892afdc208559a67c4a2b8c21dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d75a4f1c32ffe7c8a5f65a3c62dbee292a7a57873adf904aaec064843bd6ab"
    sha256 cellar: :any_skip_relocation, ventura:       "f6d75a4f1c32ffe7c8a5f65a3c62dbee292a7a57873adf904aaec064843bd6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5f7d3e261549ab84bc71f80b776f95888a1b68e62aad01511b343a288161a3"
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
