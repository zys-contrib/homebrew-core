class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/93/a7/1498799a2ea06148463a9a2c10ab2f6a921a74fb19e231b27dc412a748e2/cryptography-42.0.8.tar.gz"
  sha256 "8d09d05439ce7baa8e9e95b07ec5b6c886f548deb7e0f69ef25f64b3bce842f2"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa931de864cde4e129e723044c96964bea921e66696330240b24f125a05bcbd6"
    sha256 cellar: :any,                 arm64_ventura:  "9eba75615d69539a04370a4dbcb74a18e8d26a1e18a049fea3764c926a738544"
    sha256 cellar: :any,                 arm64_monterey: "f013612a4be0c9c6fa5be2869ea5195476446fa349b845e1c6416d531d81ff70"
    sha256 cellar: :any,                 sonoma:         "7f5eba4546a9e97d2d41148fb08a93677e35208979c7662cb58df6719ec2ed5b"
    sha256 cellar: :any,                 ventura:        "760c2638de6b28205fb163caa01da87ca857565d6d008bb996f0d911c820dc14"
    sha256 cellar: :any,                 monterey:       "09695143da9121fdb02ba0fc46c2de991e328357d1baddaa7503e3c0a261cb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae929ad754628360c1c1868018f8e55a3e5fd26f3cfb16f1367f053e27a1509d"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/9d/f1/2cb8887cad0726a5e429cc9c58e30767f58d22c34d55b075d2f845d4a2a5/setuptools-rust-1.9.0.tar.gz"
    sha256 "704df0948f2e4cc60c2596ad6e840ea679f4f43e58ed4ad0c1857807240eab96"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
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
