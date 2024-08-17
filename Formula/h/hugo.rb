class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.133.0.tar.gz"
  sha256 "98685a1ac7cceef51f4f23a8fa5a86a32db18c21c3a3f380a5d8a211c420caba"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3f86923059b2bac56bd425a5674bdd364f550826de192272664eef1ee94a74f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f83fbb3fef62b8bbc8182162f6d51f1dbe56df9b4a91ded2488124e3057f7fdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6f86e60ef6622a523c59e56cb4ef01b2b96e8105b856392b1368d53536ea130"
    sha256 cellar: :any_skip_relocation, sonoma:         "8737d027205321615fd9482a15ac25c52f36a25195ba7dad94e70991f59e740a"
    sha256 cellar: :any_skip_relocation, ventura:        "3fe6889e8943b128a8942d1a702972657d88adb577e24c33cfa1ca6e41fb178c"
    sha256 cellar: :any_skip_relocation, monterey:       "78acfba8656704ace56d9e5b7966ce5b76c2b34e996d1e8cbe447f5981a4c98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e30e3967afd9a6ff3c06502b64d3c57bae95d96207372a26598c598848382d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
