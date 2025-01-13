class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "251b3e2e84bd3574a9c628961066c8b41c403de6ecfb83b7aebd0dd5d7018290"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "20c4b5099aecbda1553b1efa9bf18a059d447d50fec0238c2ab8450f17da6418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "989b6afca91ab1d58ded187951e2873166306dbf62c3ea361dfa172202618c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "989b6afca91ab1d58ded187951e2873166306dbf62c3ea361dfa172202618c06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "989b6afca91ab1d58ded187951e2873166306dbf62c3ea361dfa172202618c06"
    sha256 cellar: :any_skip_relocation, sonoma:         "384249fd7765b9fc63ed94b468c0f37034e9ac41b084ca2d1fc817b04f5237c9"
    sha256 cellar: :any_skip_relocation, ventura:        "384249fd7765b9fc63ed94b468c0f37034e9ac41b084ca2d1fc817b04f5237c9"
    sha256 cellar: :any_skip_relocation, monterey:       "384249fd7765b9fc63ed94b468c0f37034e9ac41b084ca2d1fc817b04f5237c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26ee325d2507901c3d597f65eda36b0c431d75f14deba1244f679595ce920f22"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ldflags = "-s -w -X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end
