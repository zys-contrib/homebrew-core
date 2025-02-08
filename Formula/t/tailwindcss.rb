class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.0.4.tgz"
  sha256 "b75edc09ae4e5b4e9b3d6817f31c083346a23089a80591b62e4ff9de2cb9e300"
  license "MIT"
  head "https://github.com/tailwindlabs/tailwindcss.git", branch: "next"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256                               arm64_sequoia: "6ddcb14591250bac2b506d8cc3d161f3952bf4646a6c4993ce69d0b4d7c0cccc"
    sha256                               arm64_sonoma:  "b2abd59f889f631763abaf580cdb77a3cd48062052a81cc5f11db1bf23b04625"
    sha256                               arm64_ventura: "27f32f13c1337f9f9d5a181ea736e30d9f14fa18fdda0aa5d3d728a532127e61"
    sha256                               sonoma:        "e40dff6e0235180c0fb521094240ba1e7f00e42a5e110ef734354232e3b550c4"
    sha256                               ventura:       "7d74640a9d98207da0f65a0457f772238710e549e4969974f2cfe8655299debe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3133d07f96695bc8115105f5033c85ba809063535603d2603c380ad5c053cfd1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", NODE_PATH: libexec/"lib/node_modules/@tailwindcss/cli/node_modules"
  end

  test do
    (testpath/"input.css").write <<~CSS
      @tailwind base;
      @import "tailwindcss";
    CSS
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath/"output.css"
  end
end
