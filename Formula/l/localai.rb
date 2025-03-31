class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "595ade8031a8f7d4fd23c4e3a5c24b37f542059f3585c9f15352da4fb79c06e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beefef3660c05f418321f60e7157d2ea8ebdecce71355e37754e823ae66fb787"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3d81153835ec2683a2853e482503fd9a3dfdf8f4c365266820dec596fca46e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad1d15a333d5f3906d8bb8e5afb9ff9dcf2ce563024328f5c371cdbc90e5a54c"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d02fc81cfa530869a0587449d376feaba752a58e912fb16e196643de6fac0b"
    sha256 cellar: :any_skip_relocation, ventura:       "fc70aea23b8e998d06ea8ab06e028ee0f95f9a0d16d9f53dec5a7a0427781e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f48ca2dff458a789804fec3c8a9068a7cd3f966352448028041f278c831011d"
  end

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "grpc" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build
  depends_on "python@3.13" => :build

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/05/d2/c0866a48c355a6a4daa1f7e27e210c7fa561b1f3b7c0bce2671e89cfa31e/grpcio_tools-1.71.0.tar.gz"
    sha256 "38dba8e0d5e0fb23a034e09644fdc6ed862be2371887eee54901999e8f6792a8"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
