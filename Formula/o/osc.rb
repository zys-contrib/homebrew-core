class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.9.2.tar.gz"
  sha256 "c32bcf47c8a0f23a722fca781959ef2b1f865d0d4ed32be237f3e4444e671864"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2d1b50281a139b89e0f13e3a76d282c4b14bdda9e8a7085867586ef2e9c4248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b440ae8843b0300dfd814393075b27463847bc66a699338134b3fe81b365dd4c"
    sha256 cellar: :any_skip_relocation, ventura:        "b440ae8843b0300dfd814393075b27463847bc66a699338134b3fe81b365dd4c"
    sha256 cellar: :any_skip_relocation, monterey:       "b440ae8843b0300dfd814393075b27463847bc66a699338134b3fe81b365dd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/44/1b/ef44b5e2fae8e398bfc58f38c25a6f0a10ea147e3e4970b7e66154017d1d/rpm-0.2.0.tar.gz"
    sha256 "b92285f65c9ddf77678cb3e51aa67827426408fac34cdd8d537d8c14e3eaffbf"
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
