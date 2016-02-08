#!/usr/bin/env ruby

require 'openssl'
require 'xmlenc'
require 'saml'

if ARGV.length != 3
  puts "Usage ./decrypt_sample_response <key_location> <saml_response> <output_file>"
  exit 
else
  key_location = ARGV[0]
  saml_response = ARGV[1]
  output_file = ARGV[2]
end

encryption_key    = OpenSSL::PKey::RSA.new(File.read(key_location))
saml_file = File.read(saml_response)
encrypted_document = Xmlenc::EncryptedDocument.new(File.read(saml_response))
Saml::Elements::EncryptedID.parse(encrypted_document.decrypt(encryption_key, false))
File.write(output_file, encrypted_document.document.to_xml)