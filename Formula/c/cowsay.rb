class Cowsay < Formula
  desc "Apjanke's fork of the classic cowsay project"
  homepage "https://cowsay.diamonds"
  url "https://github.com/cowsay-org/cowsay/archive/refs/tags/v3.8.3.tar.gz"
  sha256 "3bcb1f644a85792bc2ee8601971f16f8f1e7ca0013d6062cf35b4fd6d8fa29ea"
  license "GPL-3.0-only"
  head "https://github.com/cowsay-org/cowsay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "72e82e39c8e4323d209b71caaa253897347dba46a44881fc34c94d9ee36e93e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af3131f0ffe81fb5e0bdf5c512ad0dd90bed3c2ccbe581cd4b89e609cbed0893"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d35c9dfb46eea22b2b53c9c0deb00d7d95b6fe3fcfeb8d9404fd269d5739790"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d35c9dfb46eea22b2b53c9c0deb00d7d95b6fe3fcfeb8d9404fd269d5739790"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc3cb88861e89bb415d3b1be1b5314514174349bb44338551e80badc4da94542"
    sha256 cellar: :any_skip_relocation, sonoma:         "56323541bb1881aaa1bc8c79d917be6820e4109314ae284b38ab90bb93919ae4"
    sha256 cellar: :any_skip_relocation, ventura:        "23f11aa0196e2129ac8f293ac486dbc631de8a2f7786c1bb7c9d8642144f2856"
    sha256 cellar: :any_skip_relocation, monterey:       "23f11aa0196e2129ac8f293ac486dbc631de8a2f7786c1bb7c9d8642144f2856"
    sha256 cellar: :any_skip_relocation, big_sur:        "422c58f10fc2441a62a90864d01b83176ebda627f9a8c29b34f89f4f1f86618e"
    sha256 cellar: :any_skip_relocation, catalina:       "c1f4af994e038a18492c8afe0f6b97cfd1c475fe62eafe68762cf5d734dc214d"
    sha256 cellar: :any_skip_relocation, mojave:         "faebbfa7a9379fd4efddc43dc167fda055989d2936b0430e404c252a555439cc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4cdddb22ad76cf14527347e58317caf1495dc88fdf5d6c729ac72fa2fe19dd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d35c9dfb46eea22b2b53c9c0deb00d7d95b6fe3fcfeb8d9404fd269d5739790"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
