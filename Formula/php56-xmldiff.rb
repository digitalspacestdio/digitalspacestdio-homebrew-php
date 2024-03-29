require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php56Xmldiff < AbstractPhp56Extension
  init
  desc "XML diff and merge"
  homepage "https://pecl.php.net/package/xmldiff"
  url "https://pecl.php.net/get/xmldiff-0.9.2.tgz"
  sha256 "60d7d7fde2ebb695ae2cb26803153ad07a6146e0d70c102b3403131c86177550"
  revision PHP_REVISION

  def install
    Dir.chdir "xmldiff-#{version}"

    # ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}", phpconfig
    system "make"
    prefix.install "modules/xmldiff.so"
    write_config_file if build.with? "config-file"
  end
end
