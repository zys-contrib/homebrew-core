class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "a4d961f20b58092de3b6cb4c948c0b3a18b3e9b20d3aaad1b4957f743b278b2e"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b32d295031a8cb1770b47c1c6b3e8f42f0eb4c75142bebaa81fbada4356eb25f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a9df8f51f1dece9aeedcb54921813fc2c202b6efe7528a7bcaaeb45e3f1904"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a363a3af71fc71842900613e439410c93e67147a8787e7d14117ad95462dcc30"
    sha256 cellar: :any_skip_relocation, sonoma:         "11c954e32b747be494e1b615263a5637479f49b0b7b6239ad9e33409be9263c5"
    sha256 cellar: :any_skip_relocation, ventura:        "e0dd02d57e63029fc651306461c138c390dab4831f4070b829dc19f50138085c"
    sha256 cellar: :any_skip_relocation, monterey:       "782232fd8db54b65ab800b41cf18aa68661d274c238313905007cbcd556520d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1ba552fb8ee5d368a6535169f8cd30a0490cd7bdad6a4f1b158b160a6ec936"
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
