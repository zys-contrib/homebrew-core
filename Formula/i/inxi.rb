class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.38-1.tar.gz"
  sha256 "9601b5d6287a2508a2e3c2652ce44190636dfe48371dc658e48ffc74af500b1b"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0dc059e9f7ab886820bc7fb3a5c94d4fd60413a12ffbc057a0016f763c51efb"
    sha256 cellar: :any_skip_relocation, ventura:       "e0dc059e9f7ab886820bc7fb3a5c94d4fd60413a12ffbc057a0016f763c51efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190f696b65279d91a9ef502668e49eb5e702205245016888f2469a36b6a4534f"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output(bin/"inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
