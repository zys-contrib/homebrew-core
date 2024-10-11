class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/7b/be/e0afb37ba09060368e3858c8248328faf187d814f9cb9da00e5611d150d0/arxiv_latex_cleaner-1.0.8.tar.gz"
  sha256 "e40215f486770a90aaec3d4d5c666a5695ce282b4bf57cdd39c2f4623866e3f4"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "08a84cb867183fd4be38d7f65dab02fdb523f17e1a538f2cdac8683eb221d3c2"
    sha256 cellar: :any,                 arm64_sonoma:   "5a37569df6a66eef2a53b02bbb13a782ba83f4e894022645480204fc24992602"
    sha256 cellar: :any,                 arm64_ventura:  "313087287b015b42b510f91bd9c6c7d19b8364c9bf41b8ef3aa9a8a047afce11"
    sha256 cellar: :any,                 arm64_monterey: "68cc793418d3ab532bf37f3f6e40583818eb5116520ce2ec53640ae997dadc7c"
    sha256 cellar: :any,                 sonoma:         "0213afa6a370cfb86fd1186795d2fb81ab550a5a5094575a50209d23707b41bc"
    sha256 cellar: :any,                 ventura:        "d0d00917ffe829b1974b4520480cfaecf5670022590028fa90900c13feaee46c"
    sha256 cellar: :any,                 monterey:       "7ae2853822bc7fbaa35854e0bcb77ed7269ba01ed4b3eb9c36755547eb788dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84700ec1a08e5bcf4bd094f277893e89858b93ca394db5b580c188d562b6aa7"
  end

  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
    sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
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
