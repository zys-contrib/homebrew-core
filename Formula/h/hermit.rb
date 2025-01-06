class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "fb03ba33da2c38bde1cff17dab66b84cdc49bec6b38860f7b662ad782ea64d98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b58196bdb896a83f7b2ee9ecc9fa3a6595d2e44add7d51961b6b802049d829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2678e186fc45eac1df9ae62106d8b7531ca56fa9486c654b3d73bd81a3493d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cce18ba51647e26e039192d296599a4fc1d832c407723a0053eba9d93c63e1f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4ad09a922c071184f7f989268087f997e80c969f43f0d86985c748992bb1bf7"
    sha256 cellar: :any_skip_relocation, ventura:       "4980ff0900535c34c42a4be5336af8531d922e570687808f98f7fe76eeafc38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d183ca6ddc7cb88bd9f2a2b6e9a4abd6d3a5aafb56b28c495c0484c77621fd79"
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
