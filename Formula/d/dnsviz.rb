class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/30/26/57a692b8f913ae22450f5b1dde5c52fe9a262c3e678eb63a4bdc0e464781/dnsviz-0.11.0.tar.gz"
  sha256 "3e93055950fc7837a40058f06190b0d9d7392332ea1aa0da6f9ff00c3b076d3e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e74fc8bc1e0eabf08fe6b0fe49a032212ab4fa499de6c1a9dc0bb073fdfea8b3"
    sha256 cellar: :any,                 arm64_sonoma:   "010d753c953f5784dbdcabb3a0e178b37feebc15a8849ecc60da0e06e6b1a98d"
    sha256 cellar: :any,                 arm64_ventura:  "11074313d53d5f0e1bb3bb45e5f0d2cfd360890158bb0db237acfb5fdac8b4a6"
    sha256 cellar: :any,                 arm64_monterey: "4cb91ae29fff849510d2eab470bcfe4370158db481f9ce11101661a692ff1855"
    sha256 cellar: :any,                 sonoma:         "d16f6e37ee84a64ed3dd280965879b0d103dd67b1330842d61b5bb3502cd526e"
    sha256 cellar: :any,                 ventura:        "be79adbc4298d749b20aa5d3f223a80bab1ebb58cac17a5ee5bbb89d7449a1ea"
    sha256 cellar: :any,                 monterey:       "6ed049efc4d975a5eff8cdfb85e2f23274d73e9218e9b4bf4ce4822f04d96c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80fb24e908cb98fc30a35d3a4a882daa73eaa9c1b9678a4ec714f3118e42450c"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "cryptography"
  depends_on "graphviz"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/8c/41/7b9a22df38bb7884012b34f2986d765691dbe41bf5e7af881dfd09f8145f/pygraphviz-1.13.tar.gz"
    sha256 "6ad8aa2f26768830a5a1cfc8a14f022d13df170a8f6fdfd68fd1aa1267000964"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    resource "example-com-probe-auth" do
      url "https://raw.githubusercontent.com/dnsviz/dnsviz/refs/heads/master/tests/zones/unsigned/example.com-probe-auth.json"
      sha256 "6d75bf4e6289db41f8da6263aed2e0e8c910b8f303e4f065ec7d359997248997"
    end

    resource("example-com-probe-auth").stage do
      system bin/"dnsviz", "probe", "-d", "0",
        "-r", "example.com-probe-auth.json",
        "-o", "example.com.json"
      system bin/"dnsviz", "graph", "-r", "example.com.json", "-Thtml", "-o", "/dev/null"
      system bin/"dnsviz", "grok", "-r", "example.com.json", "-o", "/dev/null"
      system bin/"dnsviz", "print", "-r", "example.com.json", "-o", "/dev/null"
    end
  end
end
