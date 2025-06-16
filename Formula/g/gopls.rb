class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.19.0.tar.gz"
  sha256 "31fb294f11d5a939a347c4c62ff2b9a92d739a5feab73e7b795bb041367da0c4"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51103714879c3a9c45b9da97c4c489179e12292b992c5c5d5190c4f684862c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51103714879c3a9c45b9da97c4c489179e12292b992c5c5d5190c4f684862c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a51103714879c3a9c45b9da97c4c489179e12292b992c5c5d5190c4f684862c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e6bae6f127a45cbcece58178bb2a25867e6bc8c209e57ebe58bb815af628cb"
    sha256 cellar: :any_skip_relocation, ventura:       "f3e6bae6f127a45cbcece58178bb2a25867e6bc8c209e57ebe58bb815af628cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71942ac2fc52efc631a25de23fa00ad34ec720d30dbf4d037d5d062bce31ace0"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}/gopls version")
  end
end
