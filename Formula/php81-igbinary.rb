require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php81Igbinary < AbstractPhp81Extension
  init
  desc "Igbinary is a replacement for the standard php serializer."
  homepage "https://pecl.php.net/package/igbinary"
  url "https://github.com/igbinary/igbinary/archive/3.2.6.tar.gz"
  sha256 "87cf65d8a003a3f972c0da08f9aec65b2bf3cb0dc8ac8b8cbd9524d581661250"
  head "https://github.com/igbinary/igbinary.git"
  version "3.2.6"
  revision 1

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95523596985263b2a91f3c9b5776e5428e71898e8895f87ced9df3f8dbd4ac77"
    sha256 cellar: :any_skip_relocation, sonoma:        "749b5160df8a978595c00b441b6781d639944c17f27df2e583d5ec2040e441f1"
    sha256 cellar: :any_skip_relocation, ventura:       "19c4d448890402d67d895e6eaae19ea07aad363857f77d8dc6f00b58e3459b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28232647866c4655706c0f14555dd3158b3e0e058de707055f5e80962caf2bd1"
  end


  depends_on "igbinary" => :build

  def install
    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/igbinary.so"
    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<~EOS
      ; Enable or disable compacting of duplicate strings
      ; The default is On.
      ;igbinary.compact_strings=On

      ; Use igbinary as session serializer
      ;session.serialize_handler=igbinary

      ; Use igbinary as APC serializer
      ;apc.serializer=igbinary
    EOS
  end
end
