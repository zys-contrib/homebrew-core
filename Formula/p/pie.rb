class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.11.0/pie.phar"
  sha256 "5c37e6b4c244f1c6fec6ee066f2b5cba54d3c4d89a8df9ea97d3bf9708a5aee1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd9167ccf9227949d1289ed0a5d6c781dc0623facedfb3c795dbe57a46b8e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd9167ccf9227949d1289ed0a5d6c781dc0623facedfb3c795dbe57a46b8e4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcd9167ccf9227949d1289ed0a5d6c781dc0623facedfb3c795dbe57a46b8e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee61b13abb26574ec7385dde6ab76ee8b03e1e06674542b2441aa35493fdd366"
    sha256 cellar: :any_skip_relocation, ventura:       "ee61b13abb26574ec7385dde6ab76ee8b03e1e06674542b2441aa35493fdd366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4845da91b6b6c3c45a13e67b6751339326aae80c869ee40fb677c11694cb09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4845da91b6b6c3c45a13e67b6751339326aae80c869ee40fb677c11694cb09e"
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
