class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/ba/dd/cc02bf66f342a4673867fdf6c1f9fce90ec1e91e651b21bc4af4890101da/bpython-0.25.tar.gz"
  sha256 "c246fc909ef6dcc26e9d8cb4615b0e6b1613f3543d12269b19ffd0782166c65b"
  license "MIT"
  revision 1
  head "https://github.com/bpython/bpython.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06bf6629f26910b0566487146288f2bfb1a22f2d4475fd8edfa40b846f999a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c859efd5a00b94aa9a44b5220ef48454b6f8ec2144334f56c04613bac6ad5471"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40ded59a27e86ff42fe70298d5c2599ac2a87fcfa9f816e1bcbad96371c2e91f"
    sha256 cellar: :any_skip_relocation, sonoma:        "688b211f53cd9632034f46c4337bc1840c15e38c14ea430027e80e53204e36e5"
    sha256 cellar: :any_skip_relocation, ventura:       "c9d34b976f66b6d5519f209703ac1248a16136db2a644f6ffca3485019784f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed3ce49336e167299dd2f293d67a290fc4054cca82bcc4f0dff25460e0416240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7632a46277b96ead7b36d94f1b19d43cd05d96c1e7e5c6f8230f126c436343e9"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/5e/3cada2f7514ee2a76bb8168c71f9b65d056840ebb711962e1ec08eeaa7b0/blessed-1.21.0.tar.gz"
    sha256 "ece8bbc4758ab9176452f4e3a719d70088eb5739798cd5582c9e05f2a28337ec"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/d1/18/5741cb42624089a815520d5b65c39c3e59673a77fd1fab6ad65bdebf2f91/curtsies-0.4.3.tar.gz"
    sha256 "102a0ffbf952124f1be222fd6989da4ec7cce04e49f613009e5f54ad37618825"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/c9/92/bb85bd6e80148a4d2e0c59f7c0c2891029f8fd510183afc7d8d2feeed9b6/greenlet-3.2.3.tar.gz"
    sha256 "8b0dd8ae4c0d6f5e54ee55ba935eeb3d735a9b58a8a1e5b5cbab64e01a39f365"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def python3
    which("python3.13")
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
