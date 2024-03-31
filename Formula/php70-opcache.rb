require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Opcache < AbstractPhp70Extension
  init
  desc "OPcache improves PHP performance"
  homepage "https://php.net/manual/en/book.opcache.php"
  revision PHP_REVISION

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "864c9b11261ffc6210bde114164968bc92959e5fe9dfe4589db2a06ecf82d155"
    sha256 cellar: :any_skip_relocation, sonoma:       "571ab387d9efe9d837b3a9c9392ba944169606641f22118536a6a995f5d96c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ba9f25945b7d6c8a618a2994fa2342d43fe4329ae85881faff719ca4c969c743"
  end

  depends_on "pcre"

  def extension_type
    "zend_extension"
  end

  def install
    Dir.chdir "ext/opcache"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/opcache.so"
    write_config_file if build.with? "config-file"
  end
end
