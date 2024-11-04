class Ranger < Formula
  include Language::Python::Virtualenv

  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://github.com/ranger/ranger/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "7ad75e0d1b29087335fbb1691b05a800f777f4ec9cba84faa19355075d7f0f89"
  license "GPL-3.0-or-later"
  head "https://github.com/ranger/ranger.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a0c957609a0dbc3c20f6bb0e420d1166bb65de6c205acca14ee85c880b68da"
    sha256 cellar: :any_skip_relocation, ventura:       "c4a0c957609a0dbc3c20f6bb0e420d1166bb65de6c205acca14ee85c880b68da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")

    code = "print('Hello World!')\n"
    (testpath/"test.py").write code
    assert_equal code, shell_output("#{bin}/rifle -w cat test.py")

    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"
    assert_equal "Hello World!\n", shell_output("#{bin}/rifle -p 2 test.py")
  end
end
