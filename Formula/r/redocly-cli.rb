class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-1.28.5.tgz"
  sha256 "a7e2f3f62bc9bb6b5660ab875a411dda12667dbf5ac7cb65f6674a2205af8679"
  license "MIT"
  head "https://github.com/redocly/redocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76c16c653ef19feb778662fada5ec62786df173f43a3475e1f25aaf555451b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c16c653ef19feb778662fada5ec62786df173f43a3475e1f25aaf555451b80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76c16c653ef19feb778662fada5ec62786df173f43a3475e1f25aaf555451b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fa6a263fdfe4dbe86ec4c5e163c241925aa5545067b955571228f44c392fd07"
    sha256 cellar: :any_skip_relocation, ventura:       "3fa6a263fdfe4dbe86ec4c5e163c241925aa5545067b955571228f44c392fd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c16c653ef19feb778662fada5ec62786df173f43a3475e1f25aaf555451b80"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/redocly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redocly --version")

    test_file = testpath/"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https://opensource.org/licenses/MIT
      servers: #ServerList
        - url: http://petstore.swagger.io:{Port}/v1
          variables:
            Port:
              enum:
                - '8443'
                - '443'
              default: '8443'
      security: [] # SecurityRequirementList
      tags: # TagList
        - name: pets
          description: Test description
        - name: store
          description: Access to Petstore orders
      paths:
        /pets:
          get:
            summary: List all pets
            operationId: list_pets
            tags:
              - pets
            parameters:
              - name: Accept-Language
                in: header
                description: 'The language you prefer for messages. Supported values are en-AU, en-CA, en-GB, en-US'
                example: en-US
                required: false
                schema:
                  type: string
                  default: en-AU
            responses:
              '200':
                description: An paged array of pets
                headers:
                  x-next:
                    description: A link to the next page of responses
                    schema:
                      type: string
                content:
                  application/json:
                    encoding:
                      historyMetadata:
                        contentType: application/json; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}/redocly lint --extends=minimal #{test_file} 2>&1")
  end
end
