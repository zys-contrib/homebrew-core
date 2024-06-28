class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/refs/tags/2.8.7.tar.gz"
  sha256 "83d5767e363c3ed4b4271000b9ce63b6e11b6c4740df910e0074f844fb34258e"
  license "MIT"
  head "https://github.com/clibs/clib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6731e2dac2c1366e927a181c6f36a8550222d7af6ec2a5966330dd642315cb40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda0f0c819604faaf6b06cc0fa759fdf57be408126ccd253bcc8cbb1aa8bf8c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcd1e902b95d5a768583dcbabf27d47c2d5f5bc07f34f953e3c92eabc93e7525"
    sha256 cellar: :any_skip_relocation, sonoma:         "4357f7fb71fab00af4da6ecd69284c0935b94a88fa1546ee8137a942e705ae96"
    sha256 cellar: :any_skip_relocation, ventura:        "144626f6491b5ae931e442e72853583c22acfa2f36d1a366a1cbf10a3fcff582"
    sha256 cellar: :any_skip_relocation, monterey:       "3caa83703a1f806930e08d62311f2b0af95c6efefdf62e12ac90ce9ab7a7be15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1bafac64063408b040c9829ffc7cd32a26596c85abbbef6b045fbe2b27b6839"
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
