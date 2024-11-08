class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.10.1.tar.gz"
  sha256 "20ee481f7ed9b3355cbdee5f590819b491e9c08992f3f7da0d96ca4495bc68db"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3126c55c04f00ba119676fe2fd2a7d9c5d06b0adbe2d40e1cd824e05c7fbd008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3126c55c04f00ba119676fe2fd2a7d9c5d06b0adbe2d40e1cd824e05c7fbd008"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3126c55c04f00ba119676fe2fd2a7d9c5d06b0adbe2d40e1cd824e05c7fbd008"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bc2e594deede859deb2c315b913cf3fa7bd2c922f81873d179edb31d50923ab"
    sha256 cellar: :any_skip_relocation, ventura:       "4bc2e594deede859deb2c315b913cf3fa7bd2c922f81873d179edb31d50923ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3126c55c04f00ba119676fe2fd2a7d9c5d06b0adbe2d40e1cd824e05c7fbd008"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/d3/36/3dae1ccf058414ee9cc1d39722216db0e0430002ce5008c0b0244f1886fd/rpm-0.3.1.tar.gz"
    sha256 "d75c5dcb581f1e9c4f89cb6667e938e944c6e7c17dd96829e1553c39f3a4c961"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
