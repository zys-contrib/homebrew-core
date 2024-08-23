class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.15.3/phive-0.15.3.phar"
  sha256 "3f4ab8130e83bb62c2a51359e7004df95b60ad07bbd319f4b39d35a48a051e27"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bcf4e05e84f3efd3abbefe8b1fcf8a9978923a28cbd2322e0c9e1561e807417b"
  end

  depends_on "php"

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
