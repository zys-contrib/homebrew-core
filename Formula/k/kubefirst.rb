class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.5.9.tar.gz"
  sha256 "b2bb593bb968e1dafc7056d9f7e490d94398d5e78c0a96b0afcc3e89b7287de6"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dafb37cd08c7e452e43f0a2ff6698e6b73ac0b513a5122f2138c079475641a59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44650a2a9383d4100a784486addaefed0aada4dbea85fa296aeae1f17154b24a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad84001d437133413cb789dc77601e8526754331a931ee658e7a2f3bf751424b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8d7581ee5acf16494986c8ccdb05d19358e6b22dbe6cda75a734a2c9599252a"
    sha256 cellar: :any_skip_relocation, ventura:        "baa3d7bbc89814c89ee0eca322bc6dc50c51ae9ef9f1c30b6823748a7938e493"
    sha256 cellar: :any_skip_relocation, monterey:       "8d93b5446730413106e032e0149ba7e1220249bd0b2bd76c8568461bcdb0a378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f2d6e5b7fb886b5cacefe26b4f50b16f813921353adb156446b1e7220e878ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
