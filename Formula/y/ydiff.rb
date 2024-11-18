class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://files.pythonhosted.org/packages/63/d4/578eb2bf5ba1ce874a854d0f926fdce8c413ba29c973e53ea60b48fdced6/ydiff-1.4.2.tar.gz"
  sha256 "369be623dcde7954d98973fb9db1780d64f0353982bf3ac85818f3d62ff452b0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a18c9c49c4a25b326deca039b8a23a1d27926cbca568a56bfc6840a685f5f73"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
