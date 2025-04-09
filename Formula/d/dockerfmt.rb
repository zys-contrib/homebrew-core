class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/0.2.6.tar.gz"
  sha256 "6965c27d38203d56a7e68ef32213e8eefdaed1cf704196fcb09d9f2ea6db1675"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb49ccf3024d401f72de8357489af21fa1e7f74b8c7ef6a8540c6baba3f87854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb49ccf3024d401f72de8357489af21fa1e7f74b8c7ef6a8540c6baba3f87854"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb49ccf3024d401f72de8357489af21fa1e7f74b8c7ef6a8540c6baba3f87854"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b126040a72e805e74095fefa5d0d16c983eba6c6d62cb8f90eb3a05e0314268"
    sha256 cellar: :any_skip_relocation, ventura:       "9b126040a72e805e74095fefa5d0d16c983eba6c6d62cb8f90eb3a05e0314268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157874321f5a2790dc67d204c74d49ef288ce43110862a1029572218a7ee163a"
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
    assert_match "File Dockerfile is not formatted", output
  end
end
