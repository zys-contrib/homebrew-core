class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/98/37/ca672c427d128e127587d8addc21343b09e242482a5bf475349f2aff4369/texttest-4.4.1.tar.gz"
  sha256 "1719d9c7e00b138f0c40a1582399c4300c2b7d1609d374341a77cfea76978fb8"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391bf3cb3b1c414c96e37c5bcc5741dbb1ae059cbe1251224194fd7840a6f661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4865496f4043e96bddef882094a7e08d3056a151990a1a83305500a500bd0092"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf6c82b4a760c1f02612c560b6ab04b8bbc4a0d1dc2c193730607a7fe10bdd79"
    sha256 cellar: :any_skip_relocation, sonoma:        "55ab51362a999050f962fe162c66e18f7237816b36d8ac38bb59fa117f580f6e"
    sha256 cellar: :any_skip_relocation, ventura:       "a3ddf9f6dd0b68726f98e3e3f888359ed46c8739bd82ad90662533814e3e5e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d792f108c5f2b916e3f2dfd4e45d5bd29df80fa5b58ad6fe347db24fe37fec61"
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
