class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "7ed3113aea2b057223bb1d224548ce83f16ed0934691af5981ae6dfa6166795b"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0237acd1d33c2721678ad1ab94ead46a3902e2379227d1b0436adbddd22a462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0237acd1d33c2721678ad1ab94ead46a3902e2379227d1b0436adbddd22a462"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0237acd1d33c2721678ad1ab94ead46a3902e2379227d1b0436adbddd22a462"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e7fa9c20e89bbb037e538ec32b91b411076be70dded157b2bd894ff6cc58fd"
    sha256 cellar: :any_skip_relocation, ventura:       "17e7fa9c20e89bbb037e538ec32b91b411076be70dded157b2bd894ff6cc58fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52b708e3e23b258626cff394da6eb1f95255309420ebcb234d26169932a5779"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
