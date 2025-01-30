class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.3.0.tar.gz"
  sha256 "0255b811b09ddbfb4afdffe639b5eb91406a67134def5230d2c53ac80f8f4dd0"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2445031d931e07242d297ff8b35a53b7d263ea93f96185699c48398301b2c35b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9b6a37c6ffc5a4584ea53481cfebedfbb1b043e72baef6c68fc82386a0cb57a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a3efd04dd81a28b433a2d39beb98ff0d3f235b1ba6b7d4557ce6be7477882cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fabebae494ce94f86ed080185a1926e0cc16b50a3982bc98c680591018374f9d"
    sha256 cellar: :any_skip_relocation, ventura:       "51f84d81b12c2ef3ea1e5b55633e1474f76550e0320d91b551e153c31204671e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89628635847d3cb3a0373f7566d4f60d459bed18cb8f9fd4558649f4678255a2"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
