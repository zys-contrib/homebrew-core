class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.11.2/sigsum-go-v0.11.2.tar.bz2"
  sha256 "70f448a4f4957fa2e5ceccbc3218f0fa59d00b9ea39f1541291f7d6bab3929df"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bd593429b56a8d070f3b29e7c277e304d24a2a38f8b529d81ccb0bb76c23f5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd593429b56a8d070f3b29e7c277e304d24a2a38f8b529d81ccb0bb76c23f5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bd593429b56a8d070f3b29e7c277e304d24a2a38f8b529d81ccb0bb76c23f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7cd72aeea9a62700f5027faf590582cb7e5b71449312470b38a7bfac58ef4f7"
    sha256 cellar: :any_skip_relocation, ventura:       "b7cd72aeea9a62700f5027faf590582cb7e5b71449312470b38a7bfac58ef4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc07ff5fd182004f2a608bc99133537fd0d5f91d84c806b5c42b88d3a1e1224"
  end

  depends_on "go" => :build

  def install
    %w[
      sigsum-key
      sigsum-monitor
      sigsum-submit
      sigsum-token
      sigsum-verify
      sigsum-witness
    ].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags: "-s -w"), "./cmd/#{cmd}"
    end
  end

  test do
    system bin/"sigsum-key", "gen", "-o", "key-file"
    pipe_output("#{bin}/sigsum-key sign -k key-file -o signature", (bin/"sigsum-key").read)
    pipe_output("#{bin}/sigsum-key verify -k key-file.pub -s signature", (bin/"sigsum-key").read)
  end
end
