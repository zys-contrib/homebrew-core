class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "3d70b0396afe5c7246d6a9a264a997a87ad24261546c857a7939e4f9592fe1f5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "750270c365baf190de542b6e9539bfca05922f15c15853e0f5e09212fdcb321d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da7f1a5c1d1726a4cd7fe22f7145380e46f67ed34dd9d6f2ba0d6c7897d8e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99c11c211528b9a594a3cbc1f1e6c6a092736d048b88f60481702c8efb48202b"
    sha256 cellar: :any_skip_relocation, sonoma:        "39d952db048b3baa7986df7626f523ec50b06486de8137186e2c70ad212d04a2"
    sha256 cellar: :any_skip_relocation, ventura:       "4600364d46417e162e7a8aecfcbb661bc614fdca2fe8378cd51d8101c326d8b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88137fc42272df68e7b3645bbade0d230e69113251a77e796c96529702042c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01642f64e77450379d5ea582cfea44b52573cc036730d3f25249514421283e08"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
