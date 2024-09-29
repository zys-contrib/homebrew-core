class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.lhan.me"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "741233cb5fa7bd10cab117713816a1771484db7149fbe87b294bc09072e15d33"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46419dd11546611d8646f10977d1a1513e7297db0d9adc3c078e86547dcb0d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46419dd11546611d8646f10977d1a1513e7297db0d9adc3c078e86547dcb0d96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46419dd11546611d8646f10977d1a1513e7297db0d9adc3c078e86547dcb0d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "089dc3c2d791053dfbe33aab8481888ea29191782c1bdfb87bba75c62a1c0d48"
    sha256 cellar: :any_skip_relocation, ventura:       "089dc3c2d791053dfbe33aab8481888ea29191782c1bdfb87bba75c62a1c0d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e37d27d16352e6eb428628bda761f99aef5de40a2e130663de6107c0effb12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output(bin/"vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
