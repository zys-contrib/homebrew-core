class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "4940eca5e52f1256f352b7958166456bf0e80c0d044a2b3eca63f2fd3cc3309b"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2022193b52c7b8a9176e0cc575b214a16cf8236070278e6184d485a4c8b1d5d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2022193b52c7b8a9176e0cc575b214a16cf8236070278e6184d485a4c8b1d5d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2022193b52c7b8a9176e0cc575b214a16cf8236070278e6184d485a4c8b1d5d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b00ebfda3dab63aeddaf916aff12d31365ed836b867fc85c4d174bd72ff5e59"
    sha256 cellar: :any_skip_relocation, ventura:       "1b00ebfda3dab63aeddaf916aff12d31365ed836b867fc85c4d174bd72ff5e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995b209cd742541ad9f6fd0f0484232bfcd6c1509b1423ca14dc6b00f5a9121f"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
