class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/d7/08/264d5c0b1a2618c95f3a391e038830c18bcccce5f202b293acdb14b7ac63/awsume-4.5.4.tar.gz"
  sha256 "4c1f6336e1f9e36b2144761345967f50f43128363892cc62325577201e133b1b"
  license "MIT"
  revision 1
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "84aa955718f42b2fb6684efcdf9d73c00aae0d97704c9fa955bec671b15299b5"
    sha256 cellar: :any,                 arm64_ventura:  "57ec3efa9a742eaaf5d8a910aa24cc18e10c2531cdb384e36596c0eab890c992"
    sha256 cellar: :any,                 arm64_monterey: "43b0e1e0b8e913876d422619787cfcd02fd8697d9a367dd7be0d496721152310"
    sha256 cellar: :any,                 sonoma:         "0553ae46a87165c714f0906e3877ac637ecd7f58f56238fec080c9d22b0e227f"
    sha256 cellar: :any,                 ventura:        "7f8d4cb7f2ce640a009bef0e982384cae9ef033cbecac23763c21671f9b70f3a"
    sha256 cellar: :any,                 monterey:       "39f9b6599717ad85d77be2777ebc19da1af4c0fbe20f4ed48ba7bfc3c3cf7d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb0ef6c8d3a7e7aa9c477dd723d10102ca3f5b942a17bb7cd821ff8e1d1f233"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/81/f5/0c7d1b745462d9fe0c2b4709dc6a4b1cbe399c02ad60b26ae2837714d455/boto3-1.34.128.tar.gz"
    sha256 "43a6e99f53a8d34b3b4dbe424dbcc6b894350dc41a85b0af7c7bc24a7ec2cead"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9e/c9/844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484/botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  PARTITION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
