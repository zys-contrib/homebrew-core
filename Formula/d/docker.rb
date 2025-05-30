class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.2.2",
      revision: "e6534b4eb700e592f25e7213568a02f3ce37460d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c19c34b5478047f288edddc9269788d1d754d87b92a3c72b256fefb3eea4bd7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c19c34b5478047f288edddc9269788d1d754d87b92a3c72b256fefb3eea4bd7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c19c34b5478047f288edddc9269788d1d754d87b92a3c72b256fefb3eea4bd7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f65caf3685f3f1a8278bde3c9974180bec591f117aedc0b35ffdd0c6e2d7e990"
    sha256 cellar: :any_skip_relocation, ventura:       "f65caf3685f3f1a8278bde3c9974180bec591f117aedc0b35ffdd0c6e2d7e990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89caf722f0bd199badd95dca7d231b7e433d319619a620071d667e4475a84134"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker"

  def install
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}
      -X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}
      -X github.com/docker/cli/cli/version.Version=#{version}
      -X "github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
