class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/dc/9b/9f254b434ed6af1e8566a398660c9f8ecada95ccf03ed799e09637a13b77/eg-1.2.3.tar.gz"
  sha256 "31f221b24701a9fc4b034d9593f081859d943b14bf26b2e98190509b64e2622b"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de4a06419ab8e14dd8fc0e0788db94e5ec3f81df50e29fb7cab28cb6ce90573d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de4a06419ab8e14dd8fc0e0788db94e5ec3f81df50e29fb7cab28cb6ce90573d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de4a06419ab8e14dd8fc0e0788db94e5ec3f81df50e29fb7cab28cb6ce90573d"
    sha256 cellar: :any_skip_relocation, sonoma:        "022bac6f1c7c991e7b1d147e2e0add5b7cd8f044816af299be4d348b79b6a6ee"
    sha256 cellar: :any_skip_relocation, ventura:       "022bac6f1c7c991e7b1d147e2e0add5b7cd8f044816af299be4d348b79b6a6ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4a06419ab8e14dd8fc0e0788db94e5ec3f81df50e29fb7cab28cb6ce90573d"
  end

  depends_on "python@3.13"

  conflicts_with "eg", because: "both install `eg` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
