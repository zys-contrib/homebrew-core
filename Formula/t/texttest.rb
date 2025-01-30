class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/0b/e0/4c6eb823436d221ccfeec099c228ee5c477483693fa167f0c70a3b55e5e4/texttest-4.4.2.tar.gz"
  sha256 "144c9ac050e836ef1aa7a5668519640cd449b8b7031513348d5fcbb9f6623952"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d812b136c436d44b688f9d0c30d6f1b3b9bfaff9fdf2875c14f7c381c4f6b23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b472aec384950ef9c8d127f58d0ad6c05162ed86dc6dcb1c40080d1a368873a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03498616b898f19e7b5e18c9350f71a963698462c52ad5545723e0958f210016"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b76d158ecb43d65c66aa426df46c3d61d9b17f59dc50df6b7404f5bf05f848"
    sha256 cellar: :any_skip_relocation, ventura:       "b712314e420fc6829411b822833794d5ac66221833df1560e5b7399eca899323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf8efe552a492c9e0dd0035787d7017c4335aabd82bfb36fdc94b6f9718a7cf"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1f/5a/07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cb/psutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
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
