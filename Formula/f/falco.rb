class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "0aa2f046ad1c10aedb0e81b46aabd354d22f161138eb231ee0a11e4b5156c932"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5d9b1048b3c98d62ae13fd4a8b4d29c58bf8ac162e26580c30652f322355f8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5d9b1048b3c98d62ae13fd4a8b4d29c58bf8ac162e26580c30652f322355f8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5d9b1048b3c98d62ae13fd4a8b4d29c58bf8ac162e26580c30652f322355f8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a775b202d45b380ca7e7ff8a223d9a54b40b6fcb68ece6729b85b8df166b765"
    sha256 cellar: :any_skip_relocation, ventura:       "8a775b202d45b380ca7e7ff8a223d9a54b40b6fcb68ece6729b85b8df166b765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "034ef7e2e56a3b828114fd921d3af7f04cd67a67382b825895bcec50e8669cfd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1", 1)

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
