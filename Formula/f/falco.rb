class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "9b96e4c891a6715df11078c05e9624bc8ab29b63d7bb9e0c23c197b8ff0ae62a"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "074f310ae65ff6c421967a632bbc6d1f6a105b87c6cdcaf29b2732cc27db149b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "074f310ae65ff6c421967a632bbc6d1f6a105b87c6cdcaf29b2732cc27db149b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "074f310ae65ff6c421967a632bbc6d1f6a105b87c6cdcaf29b2732cc27db149b"
    sha256 cellar: :any_skip_relocation, sonoma:        "625511e9a67111b69cfdd3c8966aca7150c965b30a52c3610edca63f8cfdfea7"
    sha256 cellar: :any_skip_relocation, ventura:       "625511e9a67111b69cfdd3c8966aca7150c965b30a52c3610edca63f8cfdfea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7124576dcca057c23bad037f5bb5436aa7b00ecf2b4f96186de477843acdf3e"
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
