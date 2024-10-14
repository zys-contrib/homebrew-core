class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.39.0.tar.gz"
  sha256 "a8c79c5fa98a48f133b1100927c02c5c10f0410a618ec96336ea95e73d306c7b"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d7eed311ddc033c297672f380f3c706778160cc92a0b85c3a67890b94844c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d7eed311ddc033c297672f380f3c706778160cc92a0b85c3a67890b94844c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70d7eed311ddc033c297672f380f3c706778160cc92a0b85c3a67890b94844c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "130c7bfe92e7c0d2048c6eeeca4a23bf981e648d84d57f3dcc671f3eba0af339"
    sha256 cellar: :any_skip_relocation, ventura:       "130c7bfe92e7c0d2048c6eeeca4a23bf981e648d84d57f3dcc671f3eba0af339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc56d65c99f0fa90d48f50de12b8e226950cff15b43f3f9f3b05fb766251866a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
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
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
