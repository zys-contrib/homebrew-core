class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.18.17/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "6695245d3ff02d6a4de3f5b815614528cddfb92f11751bf5116a05685b5295f0"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4402d6e8ddeb04dd068355c883bc9d50f34743bb0d3bd62f2cc4afa7938e88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdf3c8d88940eeea466fcb6caa9a7a49550763782c0317404c8fa7f9cacc05eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6631c1a9dc4305467ab439d04cd4599228afab0463ae7232495c53e7d7823771"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ec0dde8e6fd8463f6d20c30edf7a1b4ad156975bfeec2bdecf325bddc6db13c"
    sha256 cellar: :any_skip_relocation, ventura:       "89a4a91cf1b42cb417258583ad28ca284a1ff416bfdee8ce18a22747432d6bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "572930dad60471434dae26c0b9b18d4419b0bf5371c66ecd015c6d382601f659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa6bd264ee7f064f017706384316424b81a544bd6ad6ec5d82795cd58e328d2"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https://github.com/Homebrew/brew/issues/14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"
    generate_completions_from_executable(bin/"oc", "completion")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    # Verify the built artifact matches the formula
    assert_match version_json["clientVersion"]["gitVersion"], "v#{version}"

    # Get remote release details
    release_raw = shell_output("#{bin}/oc adm release info #{version} --output=json")
    release_json = JSON.parse(release_raw)

    # Verify the formula matches the release data for the version
    assert_match version_json["clientVersion"]["gitCommit"],
      release_json["references"]["spec"]["tags"].find { |tag|
        tag["name"]=="cli"
      } ["annotations"]["io.openshift.build.commit.id"]

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
