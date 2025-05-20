class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  revision 3
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969080e39441d8db18d446ebae92c9a95d1d4738d64ac3528d7be2787fcef349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a92d145e3bfd46ebca31454bef1d0089cc2eb3f34991e73ccdfe7e83eb38165"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c90e4d80be180455c9922bcca4c7d9da06c52fa5a229c84c287f1bd3e93b0d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "005a3b436ae67a59fb9c41e20117e9fb8236ab8c255db39e511a51c31d918958"
    sha256 cellar: :any_skip_relocation, ventura:       "4867e1eb46ec92e136a1500a70b5675bd26a37b374cf89a47adba12c64045bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6657c430639a92f1d6d4a73f0a85d58bfb080e2cdfa437a92f17ff2cee10a7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b914c93bc339131a9eafe74dd7b8ec2123a954934b29433aff5d6694644339e"
  end

  depends_on "neovim"
  depends_on "python@3.13"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/34/c1/a82edae11d46c0d83481aacaa1e578fea21d94a1ef400afd734d47ad95ad/greenlet-3.2.2.tar.gz"
    sha256 "ad053d34421a2debba45aa3cc39acf454acbcd025b3fc1a9f8a0dee237abd485"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/09/84/c77ec45e084907e128710e08f5d7926723d7a67ccbebf27089309118807d/pynvim-0.5.2.tar.gz"
    sha256 "734a2432db8683519f58572617528ecb4a2f321bc7b27f034b3f9b2322c15615"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    socket = testpath/"nvimsocket"
    file = testpath/"test.txt"
    ENV["NVIM_LISTEN_ADDRESS"] = socket

    nvim = spawn(
      { "NVIM_LISTEN_ADDRESS" => socket },
      Formula["neovim"].opt_bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", file,
      [:out, :err] => "/dev/null"
    )
    sleep 5

    str = "Hello from neovim-remote!"
    system bin/"nvr", "--remote-send", "i#{str}<esc>:write<cr>"
    assert_equal str, file.read.chomp
    assert_equal Process.kill(0, nvim), 1

    system bin/"nvr", "--remote-send", ":quit<cr>"

    # Test will be terminated by the timeout
    # if `:quit` was not sent correctly
    Process.wait nvim
  end
end
