class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "20c3ed4d4a026205670be98a996a456bc059421f18c15667150d5fdf6fbaa1aa"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72911e8793849975b151804f48c7266e6e0de1178bea59dc277234b1bf817356"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73c95a0d7c20332c5702d92c25732805668141fce97bc3fa89c606dcb1463c8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7966916633425ce38843235654b9639b3172a16851e318b9d0ce5277759eb02b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a56f6a99cc7d77ee67db9368ca48fa87cfe958c1fedc3c9e59c873445f189127"
    sha256 cellar: :any_skip_relocation, ventura:        "814a56aca8ec1a68f25067023770fc1ed0b553ad88874a96f7a3b5c4d057cb59"
    sha256 cellar: :any_skip_relocation, monterey:       "387525a375c85d7cc757ebef63ecc439645d943a592c742aebf5529c78674bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d56a0bed9e530d0ba5b83a1f3a92f80aa58c630cf45a44c87ef023aee96d04c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
