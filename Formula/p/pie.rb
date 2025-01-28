class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.6.0/pie.phar"
  sha256 "ebe8240389a46c12aae5af7497ba4c1a20803f968c3dfc8a857d04bb17a58e8c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "124dc6dc9ba434054d7e35f97aeb5c10d9da7d61702dae46f9696952b1efedb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "124dc6dc9ba434054d7e35f97aeb5c10d9da7d61702dae46f9696952b1efedb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "124dc6dc9ba434054d7e35f97aeb5c10d9da7d61702dae46f9696952b1efedb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e51adaac7a258be59d484be0a366a9a32fbd428666de09aa95ad6ab8b724229"
    sha256 cellar: :any_skip_relocation, ventura:       "6e51adaac7a258be59d484be0a366a9a32fbd428666de09aa95ad6ab8b724229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b67b5b6db7175474cdd3a20aa1db903a563cfb98ee40fac4f434cec4b4aceb"
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
