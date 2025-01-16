class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "41627aa17f2f7954f6ee684a0d688479d034bed03a46df6f977cb57e1f6bbfd8"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3865926b9358c87264ca3641afec20813c8b289db529f40a51fa3ba86ea66b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3865926b9358c87264ca3641afec20813c8b289db529f40a51fa3ba86ea66b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3865926b9358c87264ca3641afec20813c8b289db529f40a51fa3ba86ea66b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ebd3e493d36f718d560054d72f4c6e08533b671a7d641574ce9504cd00fd5a5"
    sha256 cellar: :any_skip_relocation, ventura:       "3ebd3e493d36f718d560054d72f4c6e08533b671a7d641574ce9504cd00fd5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d4a74709618af3614ee3c2d02f3c2c94b8c9c046845899180811fdea5fdd2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/styrainc/regal/pkg/version.Version=#{version}
      -X github.com/styrainc/regal/pkg/version.Commit=#{tap.user}
      -X github.com/styrainc/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/styrainc/regal/pkg/version.Hostname=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"regal", "completion")
  end

  test do
    (testpath/"test").mkdir

    (testpath/"test/example.rego").write <<~REGO
      package test

      import rego.v1

      default allow := false
    REGO

    output = shell_output("#{bin}/regal lint test/example.rego 2>&1")
    assert_equal "1 file linted. No violations found.", output.chomp

    assert_match version.to_s, shell_output("#{bin}/regal version")
  end
end
