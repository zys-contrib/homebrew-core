class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://www.uvicorn.org/"
  url "https://files.pythonhosted.org/packages/5a/01/5e637e7aa9dd031be5376b9fb749ec20b86f5a5b6a49b87fabd374d5fa9f/uvicorn-0.30.6.tar.gz"
  sha256 "4b15decdda1e72be08209e860a1e10e92439ad5b97cf44cc945fcbee66fc5788"
  license "BSD-3-Clause"
  head "https://github.com/encode/uvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3bd8a0f4e4db6cda44202ae7afbe668a2f4cec0b43881fed41b31a64f7e9bf55"
    sha256 cellar: :any,                 arm64_ventura:  "b2b368b204f9d9b363b3fb358ec982873c17a72363f2e0ff01eff8bd590d8f1e"
    sha256 cellar: :any,                 arm64_monterey: "1a3b3996cd5eb73c2391e049ac8df6c0ee141e5e0aed57e35c17737ac357e8f2"
    sha256 cellar: :any,                 sonoma:         "764f25325ab5818c7ec426a052b8a60fc566d73400aa4da20a257ca88724eab6"
    sha256 cellar: :any,                 ventura:        "595b1845301e2172f783ba12581ad7f30e978c27bde0dfd36926135e2f728424"
    sha256 cellar: :any,                 monterey:       "394d3dbd07fe79b39e77d0e301ac9e26211b5d2062ffd260ae4130805c90bbd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3254424dd8c73b4019edbb2a20045811b3539abe8f7d7d9309640fe1a953f92e"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/e6/e3/c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2/anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/67/1d/d77686502fced061b3ead1c35a2d70f6b281b5f723c4eff7a2277c04e4a2/httptools-0.6.1.tar.gz"
    sha256 "c6e26c30455600b95d94b1b836085138e82f177351454ee841c148f93a9bad5a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/9c/16/728cc5dde368e6eddb299c5aec4d10eaf25335a5af04e8c0abd68e2e9d32/uvloop-0.19.0.tar.gz"
    sha256 "0246f4fd1bf2bf702e06b0d45ee91677ee5c31242f39aab4ea6fe0c51aedd0fd"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/9e/1a/b06613ef620d7f5ca712a3d4928ec1c07182159a64277fcdf7738edb0b32/watchfiles-0.23.0.tar.gz"
    sha256 "9338ade39ff24f8086bb005d16c29f8e9f19e55b18dcb04dfa26fcbc09da497b"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"uvicorn", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"example.py").write <<~EOS
      async def app(scope, receive, send):
          assert scope['type'] == 'http'

          await send({
              'type': 'http.response.start',
              'status': 200,
              'headers': [
                  (b'content-type', b'text/plain'),
              ],
          })
          await send({
              'type': 'http.response.body',
              'body': b'Hello, Homebrew!',
          })
    EOS

    port = free_port
    pid = fork do
      exec bin/"uvicorn", "--port=#{port}", "example:app"
    end

    assert_match "Hello, Homebrew!", shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
