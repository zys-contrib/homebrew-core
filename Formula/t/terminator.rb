class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "df46cb8fbf4bc80289cabbf59e22a03948a65278c637573db3bc5e7acfd1966b"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d823e29f9a03f186e2ff84443aca3348821632cab7a085068146bd0403383fe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241380e6ab7728c4cb1b46bf8a569a0a8527a4b4e97fbfab7fcd78a658c5bbe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5440ad3063e68abe0e0bf3796021dfbbd4bae5f07c1c013f0265c47e0dcdcace"
    sha256 cellar: :any_skip_relocation, sonoma:        "a18e427816b26610cec97cd87bf1915ee7aec6a86c2af90295a3bf0a5130ddd7"
    sha256 cellar: :any_skip_relocation, ventura:       "60f289ff7f318d749a0523fbcb094c694ec1db2700ad6ee6899774d61dfe3fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f308e8367d3813ca6b6ec3d46852877fb293163656b8b5b725ee042602b1480f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73119f14b2225e8557fb354ac8d53d1f58579893bbb69e1e74ddbfca62eede9e"
  end

  depends_on "pygobject3"
  depends_on "python@3.13"
  depends_on "vte3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    pid = Process.spawn bin/"terminator", "-d", [:out, :err] => "#{testpath}/output"
    sleep 30
    Process.kill "TERM", pid
    output = if OS.mac?
      "Window::create_layout: Making a child of type: Terminal"
    else
      "You need to run terminator in an X environment. Make sure $DISPLAY is properly set"
    end
    assert_match output, File.read("#{testpath}/output")
  ensure
    Process.kill "KILL", pid
  end
end
