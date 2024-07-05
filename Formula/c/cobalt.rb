class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "10e5453835f87892d8a41e9209c136a9464892b5c4edcedea9267db9dd3832f1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baffd28842c1e7c0f25870a1b73077981035eeaa96dd4ded0e675a0e2ba647ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77bcf76daabef23be4a574e03d6c01e3f9a745a4c57e3f1be5604317e0f848d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e23ea9e2cf165b9bf10c7990929e383391b2252e126daf4b30f39e81944e5c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "15f025a0a52e07790b600595b83507c6bc81f348a94a9f5d03b377888e9891f8"
    sha256 cellar: :any_skip_relocation, ventura:        "e11e16e00497640e6036cbc313309a9191bf2b97be7583bbbbca218843b5c855"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed5a49253a2d11dd80a1c7b8535fc1c9840c8e80d21e0c307f33c2913e6415b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc05eada084d0a925711d6adefe5a2acf525b1194da3ab6281c0999ab72120f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
