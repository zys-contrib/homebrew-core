class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "86f8df1e4e76c6a4bcdb728fa74876bacf931641157d16f6e93ebeb5bac0151c"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50c511670ee40fa1da2d8b18029bad69223ee3d8e50a3009d4607ac94390fc48"
    sha256 cellar: :any,                 arm64_sonoma:  "5d6c168d37c55fdfcaaa4c95b3e380cc859296ef9d114ff5830ff8aa2291bbae"
    sha256 cellar: :any,                 arm64_ventura: "48f0c95193b1714f59799528db6ae6069148fdc21963dcf76c205f9b5b377579"
    sha256 cellar: :any,                 sonoma:        "33a01d5e4b4cd52ae2dcb1830288cbde9a9560f56c2205fb267140797ffa2d42"
    sha256 cellar: :any,                 ventura:       "62b3be14fd3c750708c27a70c1edea19c893a67cdd45154ea259583661459970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "439cd35809f8b0eb10150b5598be56d1afbfa9aa5a2c26aecbd1dcaad1414a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2140f62549e58a6938ee9d265d926223bdfca139485464958e89340279f3af47"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    require "utils/linkage"

    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
