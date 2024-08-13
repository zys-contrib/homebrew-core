class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.41.5.tar.gz"
  sha256 "bf9c3c095b8986181b615f6464092ca4c1e151efb16e7e70a13c736764905341"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81133c484da2fb5f863e4c26ea07a9528f2e175124e01e672562f50526e742ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6f4eae4fc1e7c65d5a04cc21cf132da2abf58936cdd9b645f6ba9330fc702c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3324217799ba0701f2227a35515f16d547af105867c83d8c6f48bd6e52528e00"
    sha256 cellar: :any_skip_relocation, sonoma:         "69331f4343ee473bd5e012f5b3b6096ba536ec56de98cd352c5dabc1961089ba"
    sha256 cellar: :any_skip_relocation, ventura:        "5276390c2bc08df7f85633bda4306725810be78b1433d666b29cc0d07d9c85fc"
    sha256 cellar: :any_skip_relocation, monterey:       "820bcfb0674fbdf9954b8e133ac2077724775c8e6150cb3e2ecea9209bbe2bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4f953586a8bf5a4fa7d3c193ee1344a4469aa827f00410a618913370964702"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
