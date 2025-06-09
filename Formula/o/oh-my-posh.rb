class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.6.0.tar.gz"
  sha256 "5d7ee8a1f20fc32bfad60f575e2b3d5713dd8e6e0f9812c4b61cdf2954858978"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "184353e058cc39ff5aaa9c26abdd345adbc3575273ba98dd81b29cd2f614ae84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f792cec7047923f1f660d03fff2ff4c0d2daf11bdcd8e8a9412802928a4c2156"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe02ab6da26647d73bb30cbeed9eec77ff26b072937a9c9d319ab2fe326456d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "97210418913e0bf5c1cf6ec081e051a8290111768c988bbac2203cd071c28c61"
    sha256 cellar: :any_skip_relocation, ventura:       "1ad14579c0911656d2634f6bd970e577ff9065ef4b7979f834fc8de3b5af95ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d302792e5c7956b58013810afe04b82fd00d955592a710b5cbc51d9fe289007"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
