require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "2f44a042ec5681e9da4a31d931c5e1826d4518d115758464bf77738f7b1eb9fe"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b6ba040ebb9240165fce3583415bc65b315004690bf8112cd29a1fdb79c1059"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64d33e34df6a875240ebbabc984140f89068bd3d2c23f1f1e2b7ab0c0dae5ef8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f69b2c684186231c6102a7eb56f80a3333c9b005e586df24fe41266b36cba6f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "21fde94a239cb0dc0e475799a359ae99089bb1ca0f63c7a15a6a86d755aec243"
    sha256 cellar: :any_skip_relocation, ventura:        "923efb26ecce849218625dce08010b1afc8e397512d77f9091b2777b95deca46"
    sha256 cellar: :any_skip_relocation, monterey:       "a796e088ee80839f142803a4239860478340f754c3eae816187f1246ad4b1f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca77c0cc664eb05fa67c2ba5964195f724d9ca3b850e84621ffbe12ef0e5014"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/openziti/zrok/build.Version=#{version}
      -X github.com/openziti/zrok/build.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~EOS
      v: 4
      maintenance:
        registration:
          expiration_timeout:           24h
          check_frequency:              1h
          batch_limit:                  500
        reset_password:
          expiration_timeout:           15m
          check_frequency:              15m
          batch_limit:                  500
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
