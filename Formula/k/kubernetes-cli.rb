class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.4",
      revision: "59526cd4867447956156ae3a602fcbac10a2c335"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ecec94a86bf2747a20a97e2bd8db4b20e54cac3aa4d762e33f60646d4d97300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed676e3f9e2664c536d3ff8d9694abd1316c8941e9dc19475977b7bc2b48f74e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50b2f779cbf75369b220d2157348565ecac14fa683896d6e5431343a80ba2724"
    sha256 cellar: :any_skip_relocation, sonoma:        "100eed4c7f30b03f3d52cb55515bd189fbee3ab528528a1425a0783bc890e0ba"
    sha256 cellar: :any_skip_relocation, ventura:       "cf9dcf1ccc545847016e36430f47aa92b67eb21f65322bb06c2f250210da8d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae2dfce9560b7533c5220679182a23354fca9378eb56caa71c35f416b4335d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a922d49359951a683a6b84826b2052c5fca4e52627a8fd133213929c41616b2c"
  end

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end
