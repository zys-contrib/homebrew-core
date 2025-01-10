class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "f9d7a8ceae6987a7ad3ac3a67bc604bea2f539275015fc88203e2762ec5fc697"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cbba8cd0121fc2130aac0a2a2bf139faee570bf56d82f5ef03122bdbb25f556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a507a8f3dfcb311bdb40c07ca3313196e5bb566dee51b829d315961e677d0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8645fa2b753e7737c594c67b2a18ab510baf311cdd6c626b43db9417eae341ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad2e277808b710eda5d98e0c1e984c721f4e426b04c3d0e0a60a34bcb6897ea4"
    sha256 cellar: :any_skip_relocation, ventura:       "5a6f4d946f11b75a4164eb21c106a697b3b3e16efb93c9ca7fb236aa5e01f9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad9706f203403ba6384e7afac7e9b73fc185a66e7e9e8bacf51a56d3c5ae2153"
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
    url "https://files.pythonhosted.org/packages/64/ec/1c25136ca1697eaa09a02effe3e74959fd9fb6aba9960d7340dd6341c5ce/grpcio_tools-1.69.0.tar.gz"
    sha256 "3e1a98f4d9decb84979e1ddd3deb09c0a33a84b6e3c0776d5bde4097e3ab66dd"
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
