class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "db65c42757922c74c1ad34eea6c13bec970b92e7202f06eac7fa4ba5ba8ebbe1"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f2be6468a0add926d51852f82df5483c79476f050c6f4270f6503bb04324cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f2be6468a0add926d51852f82df5483c79476f050c6f4270f6503bb04324cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f2be6468a0add926d51852f82df5483c79476f050c6f4270f6503bb04324cd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "54d66ecf8cefb33b6275559b7e31c20443e5090a4ba98ee507583def4f43cac5"
    sha256 cellar: :any_skip_relocation, ventura:       "54d66ecf8cefb33b6275559b7e31c20443e5090a4ba98ee507583def4f43cac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b58f16a83e8d5679fb261235410321cfbc555b86b89e7fda2ca854879211bf8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1")

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
