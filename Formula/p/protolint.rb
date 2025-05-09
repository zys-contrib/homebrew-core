class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "625cbbad34107efe6a838975a8a48ebf054874d936d003578f7a3ff02e486545"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d59f3c8c369d991216962f617112b39596c81d32cf54b7a7bc022da38cfaf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d59f3c8c369d991216962f617112b39596c81d32cf54b7a7bc022da38cfaf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73d59f3c8c369d991216962f617112b39596c81d32cf54b7a7bc022da38cfaf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c9e280390caa5acac4cceb9c4d1c943bcdaffcc15683334a983dc36e2e5fbe9"
    sha256 cellar: :any_skip_relocation, ventura:       "8c9e280390caa5acac4cceb9c4d1c943bcdaffcc15683334a983dc36e2e5fbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dfaa46f3af600d8f67f307ddd41b867485a27b89aa0e197f787fed2d75dbbb8"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: protolint_ldflags), "./cmd/protolint"
    system "go", "build",
      *std_go_args(ldflags: protocgenprotolint_ldflags, output: bin/"protoc-gen-protolint"),
      "./cmd/protoc-gen-protolint"

    pkgshare.install Dir["_example/proto/*.proto"]
  end

  test do
    cp_r Dir[pkgshare/"*.proto"], testpath

    output = "[invalidFileName.proto:1:1] File name \"invalidFileName.proto\" " \
             "should be lower_snake_case.proto like \"invalid_file_name.proto\"."
    assert_equal output,
      shell_output("#{bin}/protolint lint #{testpath}/invalidFileName.proto 2>&1", 1).chomp

    output = "Quoted string should be \"other.proto\" but was 'other.proto'."
    assert_match output, shell_output("#{bin}/protolint lint #{testpath}/simple.proto 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/protolint version")
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-protolint version")
  end
end
