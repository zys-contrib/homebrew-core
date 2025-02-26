class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.1.4.tar.gz"
  sha256 "ac6c86d7df3f938c12f5a3f6738a2d0140f888fe8e58771a134cfa5067ba9c3a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfdc97dd4717de8ff34f0669ba0281d7c077d6d833e471a15b8068d00c5625e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75012b57a249802d98d30c096c6bde4cbeb829a9328436987fb7c9d4af34e462"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49be4974bb47260e72fbade2fcc276a5e4dca0509eca9a0eb5949c787fc67ca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b213fd35f8f543edea4796c7e748344652239c91fc8b4eadf84f06329b4aebc"
    sha256 cellar: :any_skip_relocation, ventura:       "d6f79bf9f57f98662a549af812ae17604edeb3e4dff1caae8be6adca4c9c2a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cfb5587fa89557ec122849b4f22e1f380ad74571f159b4cc08a674c671c506e"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
