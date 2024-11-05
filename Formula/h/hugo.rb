class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.137.1.tar.gz"
  sha256 "ca3bd3099f0268c43e6cb5a0f7ef1e49fe495d9f528981778047851ba1180c70"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a66f1d72cf13ed0e58089654a29547cd27fdbdb232a5f110c734cf15a5b83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daedcd4bf40138b8ce6315bc1cabf36d26bfeb7a83b1f729c322c564b9844c64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c9d24d643897f6864a613f21242faf494a763caa23d92fa515d61afdd475346"
    sha256 cellar: :any_skip_relocation, sonoma:        "eab942a61db314b3112e6f52250a0ddbf4367dfdd16bf62adde106804a6ec4e0"
    sha256 cellar: :any_skip_relocation, ventura:       "87d6069a7be0c9ff56c0743215d4434fbc74c425c9ed56923e59c2f60e80d568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1104c9643d00fb7753bb27f156a30a6dbe27f61e0ec392a4410257979706894d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

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
