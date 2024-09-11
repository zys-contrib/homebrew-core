class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.37.0.tar.gz"
  sha256 "4b8ef28d17db3f83ee5db70737b4157ab19310f09369248c11b4f80b0c39a7c6"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce389a59cf0d0ed2e0e84105e0d174666f18641cfb95896074d1e217d265dcd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a8cd97814d893303bace229e5ea3e410d1aeea5b1df3915fec9e5b932d3d456"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8cd97814d893303bace229e5ea3e410d1aeea5b1df3915fec9e5b932d3d456"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8cd97814d893303bace229e5ea3e410d1aeea5b1df3915fec9e5b932d3d456"
    sha256 cellar: :any_skip_relocation, sonoma:         "46253fc9f80d1b496a1abe1ba38ed56e26406dd90ac0886a014d7fd3c3b72979"
    sha256 cellar: :any_skip_relocation, ventura:        "46253fc9f80d1b496a1abe1ba38ed56e26406dd90ac0886a014d7fd3c3b72979"
    sha256 cellar: :any_skip_relocation, monterey:       "46253fc9f80d1b496a1abe1ba38ed56e26406dd90ac0886a014d7fd3c3b72979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead1f12c6885fe77262cb26145b7eb1cf0b9e9d42a38b36c3cf1c49fd6a98768"
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
