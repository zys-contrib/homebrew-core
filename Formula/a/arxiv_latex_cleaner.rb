class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/b9/4c/d7fd953c8d95361ab9d2cf44256613d9cc6d9ef3f271704c1444e639b5fa/arxiv_latex_cleaner-1.0.6.tar.gz"
  sha256 "c15732e2287a298a509fab65848a175cd3bc32a89af6cc5c6bd1f8f6d3764d98"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f6de1b22e5d020534388d22df0529276f389ffb72c301eaad34213cf08c7463"
    sha256 cellar: :any,                 arm64_ventura:  "bb9a986fdceafbda0c25fb0d337a3b561bf3a95e013af7979456575dc262b007"
    sha256 cellar: :any,                 arm64_monterey: "1f80f53f410141b7c91b2d4cf0e6dfd7a4082eff2157ec32a28a38b73f16df01"
    sha256 cellar: :any,                 sonoma:         "bc5e11edf6af1baeba52a6708d9ab93159b83761c3394fde90f06b14099cff26"
    sha256 cellar: :any,                 ventura:        "fa192de0424d068bb53d31bb48d74795a663de071373ec61d2bacbd61ca30766"
    sha256 cellar: :any,                 monterey:       "f3c8cd3cd991d2bc09a3883f9fd553a0bba24b474ace696ccf4eda4114d8cb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e314c116276dcf202f358e0d7abc8a4c062c44e22b87c5becd4dbae4d6df3bb"
  end

  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
    sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
