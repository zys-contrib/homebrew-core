class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/0b/b3/52b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41/rpds_py-0.24.0.tar.gz"
  sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f0654c6182c426c12bbd57e0f7a55b662475737fbe32ee94de5b87631e5e278"
    sha256 cellar: :any,                 arm64_sonoma:  "a92eeec7bf2da5e2c6b1dfaf53b293a24748d9af54b38f07dbd442e28d56b0c1"
    sha256 cellar: :any,                 arm64_ventura: "d2d6de90d070bba87aafed5468b9ad06f9160710a1b80ad4cc0a74e003351fcc"
    sha256 cellar: :any,                 sonoma:        "189b36e2d6d884b1d53a92aff6961cd888be19c40aad2eb11f2c935c997a35e3"
    sha256 cellar: :any,                 ventura:       "7d08d1705551d2a9a38a1822511f2b6cb0f7028714410f46d83de66daa12ba83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16f4a509e5b4b3109d92d587b3e86376099a82e5d490e2a03a32b602e347d36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d865aeb961599cdcbf006e9c28154dc170883fee176b88b7d712d8f71a7313"
  end

  depends_on "maturin" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "rust" => :build

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/e0/0c/db5a68b4e95229db38a1793d58561870bd68b92b95fed183c6cd48910c9f/setuptools_rust-1.11.0.tar.gz"
    sha256 "f765d66f3def6fdc85e1e6d889c6a812aea1430c8dadcf1c7b6779b45f874fb2"
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

      deps = %w[setuptools setuptools-rust semantic-version]
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
      from rpds import HashTrieMap, HashTrieSet, List

      m = HashTrieMap({"foo": "bar", "baz": "quux"})
      assert m.insert("spam", 37) == HashTrieMap({"foo": "bar", "baz": "quux", "spam": 37})
      assert m.remove("foo") == HashTrieMap({"baz": "quux"})

      s = HashTrieSet({"foo", "bar", "baz", "quux"})
      assert s.insert("spam") == HashTrieSet({"foo", "bar", "baz", "quux", "spam"})
      assert s.remove("foo") == HashTrieSet({"bar", "baz", "quux"})

      L = List([1, 3, 5])
      assert L.push_front(-1) == List([-1, 1, 3, 5])
      assert L.rest == List([3, 5])
    EOS

    pythons.each do |python3|
      system python3, "test.py"
    end
  end
end
