class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "7ea7e46a3d04618d229333ebddfc4786ce9dfe4bdf6f1c1dc82cf3deb9612b14"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abc4a8b01ec1aa7184f18519328a66323798bf2bfaaedab7e93779d70b0240f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abc4a8b01ec1aa7184f18519328a66323798bf2bfaaedab7e93779d70b0240f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abc4a8b01ec1aa7184f18519328a66323798bf2bfaaedab7e93779d70b0240f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "474dcee2aa0f1d14f4d7625e21d466fc83e3189896b921e2ae82bf1a2b63fc5c"
    sha256 cellar: :any_skip_relocation, ventura:       "474dcee2aa0f1d14f4d7625e21d466fc83e3189896b921e2ae82bf1a2b63fc5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a25fc5bca929319e034c927fa20246284c266e1e74ab3adc7ead9521a565a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}/dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "Dockerfile is not formatted", output
  end
end
