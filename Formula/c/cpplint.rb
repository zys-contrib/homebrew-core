class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/e7/1d/6965acf4f85495956ebdb80ab2cafd803e39ba866b8370618a120d72938b/cpplint-2.0.0.tar.gz"
  sha256 "330daf6bf9a9006b9161af6693661df8f8373d54b2ea6527cd515a8e61d41abb"
  license "Apache-2.0"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a520db08cb75abe19ed23000c038712f423b26212d425b0a4495d18c36fd4dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1ebcdaadbf95e043eee26a5e61ef099d163f02b1024bfd6a48e25b43bb1e40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "160d2679081ce1941f4c026ae9808ad2b7611afb937b6a3536b00be8709796f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ae38619920a9e68a04561d58ddfdbdca7a214beaa4f2d7a0a53a37c1da3e4db"
    sha256 cellar: :any_skip_relocation, sonoma:         "491893d9094e7f1565ae342c8aceecde9f7ccbc011fe10546b2690507bd8fee1"
    sha256 cellar: :any_skip_relocation, ventura:        "4e6456089c2d047c90d1533bbe3ea2be9fe341ed595c990eeff4a4f44b31be6a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f433ee51e12a95f15dae3023877f3e84a6cb87ae27cc20f7052a5de39e9d7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f80a3e8068bebc91afb5c7cb391aaddc15bc098ae7f5698a4b5bfbd09439dc"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    test_file = pkgshare/"samples/v8-sample/src/interface-descriptors.h"
    output = shell_output("#{bin}/cpplint #{test_file} 2>&1", 1)
    assert_match "Total errors found: 2", output
  end
end
