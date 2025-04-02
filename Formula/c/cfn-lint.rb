class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/8e/37/581cd6a9e4068f908d5ae6133e5ebbbf617adc482b173023c6b58851ca89/cfn_lint-1.32.2.tar.gz"
  sha256 "c6b51e0ac8956a0f9bcb74f225bf2b7ab86e3c59ffd82476da3d3d5668ed9476"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6104d6212dfc852119efdb55fed1e78adf592078b36f2c626d9396c6d14ae8a8"
    sha256 cellar: :any,                 arm64_sonoma:  "42ce3c214eb93fe5c3702bded5e260a7ed96940593b310f254f4ad6619c6005f"
    sha256 cellar: :any,                 arm64_ventura: "55e98920e03f6002ec9986e6de5558335f4246cb832f4120b5ae70adf5675fbb"
    sha256 cellar: :any,                 sonoma:        "4965f40e7457bd7ef879f37829fcedccebd11e811aa98e4a25c9a953a0b8014e"
    sha256 cellar: :any,                 ventura:       "110ca8ee45d8748f0c5ecf48e33c6e373acd2dc67f2cbd686b099678d894b4ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec7748e8d3ad4bbe84a50b9770d5969601ea35d0e5defc32c1081f5bdbf64a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2027707dc29f8f25a36e14470e072d5e5e48c18c034a97749e4c8172935cadb"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/61/8c/4ea1c5fafdec02f2b3a91d60889219a42c18f5c3dd93ec13ef985e4249f6/aws_sam_translator-1.95.0.tar.gz"
    sha256 "fd2b891fc4cbdde1e06130eaf2710de5cc74442a656b7859b3840691144494cf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c5/67/624011e0bf632818e786fcaa457e0a9421befede9ea7afe8dbe91ad4c8a3/boto3-1.37.25.tar.gz"
    sha256 "23e9cbad028ef3723567f4556411ee8d0f732594316b4c78c174a03ba3ca3159"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0a/32/9854fb2a59f306d90cff889b1fe794b34f3681f0fafc574b2a7fa4cfc753/botocore-1.37.25.tar.gz"
    sha256 "6f8cefd769df170809816d66bde2e12c43f557ca6cf18c807922003319b52991"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/93/a3/698b87a4d4d303d7c5f62ea5fbf7a79cab236ccfbd0a17847b7f77f8163e/pydantic-2.11.1.tar.gz"
    sha256 "442557d2910e75c991c39f4b4ab18963d57b9b55122c8b2a9cd176d8c29ce968"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/b9/05/91ce14dfd5a3a99555fce436318cc0fd1f08c4daa32b3248ad63669ea8b4/pydantic_core-2.33.0.tar.gz"
    sha256 "40eb8af662ba409c3cbf4a8150ad32ae73514cd7cb1f1a2113af39763dd616b3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/0b/b3/52b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41/rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/0f/ec/aa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938/s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/11/8a/5a7fd6284fa8caac23a26c9ddf9c30485a48169344b4bd3b0f02fef1890f/sympy-1.13.3.tar.gz"
    sha256 "b27fd2c6530e0ab39e275fc9b683895367e51d5da91baa8d3d64db2565fec4d9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0e/3e/b00a62db91a83fff600de219b6ea9908e6918664899a2d85db222f4fbf19/typing_extensions-4.13.0.tar.gz"
    sha256 "0a4ac55a5820789d87e297727d229866c9650f6521b64206413c4fbada24d95b"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfn-lint --version")

    (testpath/"test.yml").write <<~YAML
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    YAML
    system bin/"cfn-lint", "test.yml"
  end
end
