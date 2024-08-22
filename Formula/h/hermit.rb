class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "b02675024c70e3eff17e617abaf039a81fa904b3766e8c088ff96e2aa5eb9adc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41ada97b022df81dae5eb0d721bab7ca6a0d5c3732ae4a0bed15e163d085a5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6efc531f5a68d2f8a87098f370a1e3713d8e48b76df8bd1ca185c2ee34785a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7bed88360f75ebacf3b4909728a312c55c960ee0158a0d672ad57bfe2e56e84"
    sha256 cellar: :any_skip_relocation, sonoma:         "d84d6c2b7ca33b0ba877176d0d9d3ff5af66d745f1ea5ba0771f04cd4ada829d"
    sha256 cellar: :any_skip_relocation, ventura:        "64382c62344c75ebaa30db00d9508af954bf640cbe10a8126b2737dcf0e82a04"
    sha256 cellar: :any_skip_relocation, monterey:       "cc628ea11015daf51ec6fa6f172068b437da8bcc983ab3954099fde54a35605d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b767c1fa52eb3b3215f8f63c08e83d9fdbd1c0b1ac95b7f38922b6ce162a5bd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_predicate testpath/"bin/hermit.hcl", :exist?
  end
end
