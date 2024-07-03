class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "48b97161f3a852985963782686b597ba1692fa46bfc50449d12cbe75defb9043"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a97c22ae40def022d0823f51304daa498bd0d6f40e5ef2f28832f64816136046"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d899313a663f6407983f25562f66353a75b7895df96070461c650563950b0f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90374fc254103ef62fffbe2aedcecaf144f92b1dc01284d0f6a45ff13b2fff24"
    sha256 cellar: :any_skip_relocation, sonoma:         "519fa54668483568bd69988b4f531eb16ae55a1c2a706ce5df9e82057327518c"
    sha256 cellar: :any_skip_relocation, ventura:        "9961f1d7784e85b9d9396a10271019847a43ccb8a860f7facd10a7f7f15841d0"
    sha256 cellar: :any_skip_relocation, monterey:       "08ca70c67dcfd396cb83d781d5ce6e3b2b9eb937783016e17e0212a2c608364b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c787ef8ab9a55fa1b08fea170a41fe2e8cd74f139b030fb26c52d3ecefe384f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}/gittuf rsl remote check brewtest 2>&1", 1)
    assert_match "Error: unable to identify GIT_DIR", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
