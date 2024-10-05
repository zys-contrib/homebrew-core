class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/43/d3/8fa476380d3b330a9284efd9b8f309cb239a90d7a86b0446f189d05692c0/git_up-2.3.0.tar.gz"
  sha256 "4a771b9cae8bc6c95e2916bfb120a6ffc76c80fc3f5c91af61f91c21e5980f2e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6a8eae527cd03ada9cef1d60403f749c5b857737a291e8c974c802b928412b88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c35855737998db174e1881211025f98056b88b317248d42a33357e5a1898139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0ecfc67c1a56c0bb8b55a838cfcc925423757b6313ea72a805db661dc899dd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a6160237c7def873073d438a0dc30e54783e00ec6aad65d234c810a43cb6aaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbe485e8436fbbc11e9511f13ceeec125f35ccad63847a6035127fbed0ddbbcc"
    sha256 cellar: :any_skip_relocation, ventura:        "a4a8bc36201c800b95a4c52eec4cc7ee6347a51370467b432670152b0f71a198"
    sha256 cellar: :any_skip_relocation, monterey:       "b756cd6c5d2e6719f9b099d320946574deff4a4679b6fbaf0a65a12765c7288d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d7b54ea93c598ebbf629b278b47f9405661dad87bc78f99024298c58ab8ec58"
  end

  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "git", "clone", "https://github.com/Homebrew/install.git"
    cd "install" do
      assert_match "Fetching origin", shell_output("#{bin}/git-up")
    end
  end
end
