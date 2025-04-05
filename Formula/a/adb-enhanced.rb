class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/c4/a5/9066bb8c0dd47025aafbb3388b87f68df02f2cf64a83933feee0b3c7c259/adb_enhanced-2.6.0.tar.gz"
  sha256 "ead467df4e0e4fc964007c62b0b55801a5f158793bd551ec4b25154801fc3f5a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf9d90b43874da9f96f287e01eff19306019042c9dbc1641d40e0d7eb950612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c6ffd4ecea05981249f50b94d12fb602c2915858c837b9d61dbfc0d467c2be1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdcc36321c5778c81bb587694d04608f9c1e1617c781b0818339c23f9cf78cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ef1a0c31c3dd44a7bd2c72abd676c7b1c2af29f5a16bcd9b3827d0854e304e2"
    sha256 cellar: :any_skip_relocation, ventura:       "22a91ffb280d4b143607d9d4d3040b926e9761ef43772f329f2f8d1fb55b9cb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1edfaedf9c999a4b316cd95896b499351bca6741e152ea47bda70294af008d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0d9eb3a03003615e28a362234771ee2c200d732c82a8a155cf99d800ae27af"
  end

  depends_on "python@3.13"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
