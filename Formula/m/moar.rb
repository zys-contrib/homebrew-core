class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "66157f547cffbcbf3cede581f4e232ed991213055157a3a075dc789ea1f7475a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c67b9bd10e90c58b03b4593399076d9e3d9e9dd7438b55855722e264995d354e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c67b9bd10e90c58b03b4593399076d9e3d9e9dd7438b55855722e264995d354e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67b9bd10e90c58b03b4593399076d9e3d9e9dd7438b55855722e264995d354e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e50396e6542dbe099ad107c4775f56cda3ff52be72546a8ac9b9b6eee2b4ad57"
    sha256 cellar: :any_skip_relocation, ventura:        "e50396e6542dbe099ad107c4775f56cda3ff52be72546a8ac9b9b6eee2b4ad57"
    sha256 cellar: :any_skip_relocation, monterey:       "e50396e6542dbe099ad107c4775f56cda3ff52be72546a8ac9b9b6eee2b4ad57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d754de910909aefd9fa2e777208eb519fd2ae6266e108390fa3cbc70dca3a4fa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
