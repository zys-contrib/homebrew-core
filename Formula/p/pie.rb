class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.7.0/pie.phar"
  sha256 "17532528ed9ad2bf73443fb908f879fb62b5b467edabc8273924f44e631be4a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c715b1cea433a20cede42e047f884acb376e8f777bd64134d088dcf5ef8d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c715b1cea433a20cede42e047f884acb376e8f777bd64134d088dcf5ef8d43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6c715b1cea433a20cede42e047f884acb376e8f777bd64134d088dcf5ef8d43"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b1ae1be6c66a6706a944ff2d4884cce61c0c1f5bdd29261e72f4366450bf13"
    sha256 cellar: :any_skip_relocation, ventura:       "b0b1ae1be6c66a6706a944ff2d4884cce61c0c1f5bdd29261e72f4366450bf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f65bf4ca327366bc29025d7436940721ca46d350a20c644ebd5e7400b45f8067"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
