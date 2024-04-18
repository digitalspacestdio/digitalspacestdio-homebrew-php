require File.expand_path("../../Abstract/abstract-php-common", __FILE__)

class Php81Common < AbstractPhpCommon
  include AbstractPhpVersion::Php81Defs
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php81-common"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7103a1050dd5fc0affd167ffe157fe4fc121daea2d08d3f765d35675deea0186"
    sha256 cellar: :any_skip_relocation, monterey:      "0219a192f2912e58dee85a02716ee5fbad22462956ccffc1bc076df7729acf7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5229fd3a367fae83d7cde16b3ef6e4e4670247138af71e4fc16e006bcff59111"
  end

  init PHP_VERSION_MAJOR, PHP_VERSION, PHP_BRANCH_NUM
end
