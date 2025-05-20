class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "https://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/93/75/414f33186846444da53b4e834d5ccfb0577d0e09b997819c183fa509f70a/coconut-3.1.2.tar.gz"
  sha256 "ef0656ee2df4594007f998f4a9c2a1b9bfbc40541a400cbaa00ccbbac50e5414"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25a6f46e119a250f8d10b8dd2df6a214823c1068b28fb5c332867e7b8ab8d2fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b8cf2ffa687f0c101bdc413edf820eb96c6642b31f94fba3142499e0f507e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19088d74ca2b35b02d63aec0edd71d0e38c6ec3054879b542f029f65f25a22e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "edeff6b15686362384e4fa5334bca7d95393e27e47f9ca5a1401d4f6d1e596b8"
    sha256 cellar: :any_skip_relocation, ventura:       "5ea59853688e12fa9585572ecbfed6d46633eb9ac63aae0b4a22f7cef6babe0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0143d784e8e81c960cb5cf4b7aa2ecc52ae8e0fe539c1fabeb6224df88d43112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54bd43552fdf9f556039fdba27670f50e5fd699df7b967ff9648c05b3bd26059"
  end

  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/d6/f8/76a0f8c9b16d7d4ac21a409a2d0e532095ff17217d4876d70f3be3f1297f/cpyparsing-2.4.7.2.4.1.tar.gz"
    sha256 "d917f01a74b3fc614f939eb99fc328a08c9b1de58095660c0f29597744bf1d30"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
