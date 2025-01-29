class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.7.6.tar.gz"
  sha256 "1e06959e58d42b94c04260409a82ec29c56d25890d41ff8e95700fda0913f12c"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "09901a91078dc39a58a2b99241b9393108e98689d96209f4867432d64a5ac931"
    sha256 cellar: :any_skip_relocation, ventura:       "09901a91078dc39a58a2b99241b9393108e98689d96209f4867432d64a5ac931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b113afd8240357f276f559ab9eaef84f42277e763bb1b68c76472ad86f6821"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end
