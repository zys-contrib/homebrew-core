class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "9cdafd1aa157dbc1fa14cbe62b9d5c0e94422172d48c9fc424131916ad10a7b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904d279970c6299905286e715bb500218893aec94a2fc1ce39da45ea2c266bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f716e429d99817ece6065bf898c17211053cd33247360fd986ac03609ce71750"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311f2c6871548f143436fe724c28587d89bde8f51db1ee3324306941eaf2b0f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8531f0a4e4e4aa70aa9940dc9ab785237baabb93a11c5920cb04bab49d49ded"
    sha256 cellar: :any_skip_relocation, ventura:       "baab0b7f85d1caf7a74c140b50d5cd73ff61556cc9ec71edff0faba53a4701eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb2343ae59d232ecf625a5ad23fec90aea9883066bae1a49ec9c1f3fdb4c768"
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
    url "https://files.pythonhosted.org/packages/c1/fe/3adf1035c1f9e9243516530beae67e197f2acc17562ec75f03a0ba77fc55/grpcio_tools-1.70.0.tar.gz"
    sha256 "e578fee7c1c213c8e471750d92631d00f178a15479fb2cb3b939a07fc125ccd3"
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
