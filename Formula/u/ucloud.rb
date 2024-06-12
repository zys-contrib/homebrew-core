class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a67d31b7ab9ad8845698936cdee1c6f9980c07b5018bcb741026f147c56c121"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a93d50a16e9b628fe6c42871ab1d6ae988a221a15b93c345ce833d2bb23e237d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cae3626927613c5bd734740d45241bced4cb81e75b39a2f5493d2511616a6c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f61b797fcf86656430a97971a22e84546083c75ac24c02e8e6abe75f4d94304"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9df871f2a44fa2f3259e7792129aedf1fb00e5fe66144eb5400128fd7a4af80"
    sha256 cellar: :any_skip_relocation, ventura:        "d25e50e82701c5c3b0d0559d2644e45a48304a6281b7d8d3c9b8fc6a8e471d87"
    sha256 cellar: :any_skip_relocation, monterey:       "404b374cd12f920b6d4c433ebfcecaaf651abee5684c198555bd577d31aa5b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d921267da7214008c80f12b942d0f0cc306618e65eceaeed7c6dfc89015aa6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
  end

  test do
    system bin/"ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
