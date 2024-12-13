class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/39/c2/0fc369321be3500f8121253378e9c38b6ef8fcc259c56751bbf04c8b2895/translate_toolkit-3.14.2.tar.gz"
  sha256 "3105c14e54164f691e8d1de92094bc4d5c374248e0ed51f521547abd79059807"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae6d2cc2e897a02a78f54f79edd72e731f9c3749fb3f52106e6ac0f5e1b82c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c2a0cabbdbfbe74b43250fda9bb2092bdc1a309fd703c7daacc7560f90b376f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "867308913f6ccaf8f996da7f8867caeb766da397680b7f77b1877603ae16f76b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0235351a0dfcacc2922c175d87d4d48d4efdc29cea0124632a14abb9abf5c26"
    sha256 cellar: :any_skip_relocation, ventura:       "bcbd271c0b75bd0b16a06cac62ecd1de23eb26ec3a6729742a1cba57daa8cfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d80ff8da916c4c7a4255109bb18d23f313badb512b86bffa9fee7f51b566bce"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/95/e3/275e359662052888bbb262b947d3f157aaf685aaeef4efc8393e4f36d8aa/cwcwidth-0.1.9.tar.gz"
    sha256 "f19d11a0148d4a8cacd064c96e93bca8ce3415a186ae8204038f45e108db76b8"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
