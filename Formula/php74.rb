require File.expand_path("../../Abstract/abstract-php", __FILE__)

class Php74 < AbstractPhp
  init
  desc "PHP Version 7.4"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "krb5"

  include AbstractPhpVersion::Php74Defs

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  head PHP_GITHUB_URL, :branch => PHP_BRANCH

  def php_version
    "7.4"
  end

  def php_version_path
    "74"
  end

#   def install
#     ENV.append "PKG_CONFIG", "#{Formula["pkgconfig"].opt_prefix}"
#     super
#   end
end
