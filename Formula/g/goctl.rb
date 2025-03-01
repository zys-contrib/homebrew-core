class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.8.1.tar.gz"
  sha256 "16e7e90c95e702da6d9e102a95a07dcca7c5e7bd08351c8e56b6fe40fea9a27d"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd528fbec2987dfe0384bd171e5bc32bd4efb785ee57491cf14d898c3a84eec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd528fbec2987dfe0384bd171e5bc32bd4efb785ee57491cf14d898c3a84eec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cd528fbec2987dfe0384bd171e5bc32bd4efb785ee57491cf14d898c3a84eec"
    sha256 cellar: :any_skip_relocation, sonoma:        "197af2fddbd9088b9ddaef8e9a862cb8fb6aa8666026a0a50022e7b9dabdda87"
    sha256 cellar: :any_skip_relocation, ventura:       "197af2fddbd9088b9ddaef8e9a862cb8fb6aa8666026a0a50022e7b9dabdda87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6619bbc538401203a780d4694be262b4e541479cc0fcff949fcdce80546ed17a"
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
    assert_path_exists testpath/"api/main.tpl", "goctl install fail"
  end
end
