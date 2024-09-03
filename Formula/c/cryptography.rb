class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/de/ba/0664727028b37e249e73879348cc46d45c5c1a2a2e81e8166462953c5755/cryptography-43.0.1.tar.gz"
  sha256 "203e92a75716d8cfb491dc47c79e17d0d9207ccffcbcb35f598fbe463ae3444d"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f63358344349cb2cbe451b3e268f30062fef70549f90fa59b00cef233f9177a9"
    sha256 cellar: :any,                 arm64_ventura:  "2bace84ec8a8756ebb3d6827193d906c0f774e60c3ae256a2db48688d166c328"
    sha256 cellar: :any,                 arm64_monterey: "69c35ff5a5f9655e3803231bf0e93730f6622a86357fda453fb7ac0512fc0e61"
    sha256 cellar: :any,                 sonoma:         "55ad8089aa466bde1e15753953738fe0644c46a22f00334ef46e1f8629fc8cba"
    sha256 cellar: :any,                 ventura:        "0f2b5d6e6d27f3741b56a4773f3a62daf06c16c9926ae10fe65677d38d2bb2aa"
    sha256 cellar: :any,                 monterey:       "b657b927d664c836db4f6701884b8f12879284f370508f972ae1e55ddffc516a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a098109ae8af3903feb995d819859407f5580156e5cf5b68b7666e1ae8f6903e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/1d/ec/1f688d6ad82a568fd7c239f1c7a130d3fc2634977df4ef662ee0ac58a153/maturin-1.7.1.tar.gz"
    sha256 "147754cb3d81177ee12d9baf575d93549e76121dacd3544ad6a50ab718de2b9c"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/cb/e754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96b/setuptools-74.1.1.tar.gz"
    sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/b8/86/4f34594f21f529623b8650fe729548e3a2ad6c9ad81583391f03f74dd11a/setuptools_rust-1.10.1.tar.gz"
    sha256 "d79035fc54cdf9342e9edf4b009491ecab06c3a652b37c3c137c7ba85547d3e6"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV.append_path "PATH", buildpath/"bin"
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      deps = %w[setuptools setuptools-rust semantic-version maturin]
      deps.each do |r|
        resource(r).stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end
