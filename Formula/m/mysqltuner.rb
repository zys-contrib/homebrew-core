class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "9ba57ecc616c1791907c1e7befe593fee23315bcff0121adc13dbd62b2553a3c"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "030ec7296fb4cd9f95fd85e2c1e33fdfedff8b7c80b3fce4596a0f322097438e"
    sha256 cellar: :any_skip_relocation, ventura:        "030ec7296fb4cd9f95fd85e2c1e33fdfedff8b7c80b3fce4596a0f322097438e"
    sha256 cellar: :any_skip_relocation, monterey:       "030ec7296fb4cd9f95fd85e2c1e33fdfedff8b7c80b3fce4596a0f322097438e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
  end

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system bin/"mysqltuner", "--help"
  end
end
