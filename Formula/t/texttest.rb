class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/83/34/d32d805a55b80cbc9fa1b4892b52160126b5106c4aab6cb8c6e2cd82481c/texttest-4.4.3.tar.gz"
  sha256 "41b41f5f222764f2c915b388c43eac5aebcf45c6e6c4a59c83e6a4e5202b73bb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2317ca10830a367b205996aef21f1408dd67b55d5945ba5d72e54596f5045ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3747155b7a3932465db66ba9f67322902796698d063354160d07a209071ce077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f634b3d9be031e19c06d5ee25036be5fefa980a11fd38e809a0aeb5fa54af85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3025ecb8471e729b7ec64e3649ee91ca86511c4907112db5dccf251f8aafb6a1"
    sha256 cellar: :any_skip_relocation, ventura:       "943733a377d4931ac83f93c559679919d40f85fdae0fea80e4097b1002e207b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7529fb4baf4c2fbdcb059ffd8a8d6bb1658de15054b97b5422c021c708cc91ed"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
