class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.2.0/pie.phar"
  sha256 "782284f528e3b729145581dcefe0cb542dca2664415f11ac7af4dc4d6e149d0d"
  license "BSD-3-Clause"

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
