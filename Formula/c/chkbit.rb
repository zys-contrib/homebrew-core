class Chkbit < Formula
  include Language::Python::Virtualenv

  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit-py"
  url "https://files.pythonhosted.org/packages/ce/c3/83700e8a9c188638403e5eb897c59e8940af0fac3a37678c22b996c8c9f8/chkbit-4.2.1.tar.gz"
  sha256 "6dbcb17c43667fcd63189e0c4682c83bcf0a6d0663e043fe08e4cda565cb1c3e"
  license "MIT"
  head "https://github.com/laktak/chkbit-py.git", branch: "master"

  depends_on "rust" => :build
  depends_on "python@3.12"

  uses_from_macos "zlib"

  resource "blake3" do
    url "https://files.pythonhosted.org/packages/b0/8d/43eafa8a785547c33b611068ffd6d914f5c5f96637d5b453abc556f095a0/blake3-0.4.1.tar.gz"
    sha256 "0625c8679203d5a1d30f859696a3fd75b2f50587984690adab839ef112f4c043"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/chkbit --version").chomp

    (testpath/"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin/"chkbit", "-u", testpath
    assert_predicate testpath/".chkbit", :exist?
  end
end
