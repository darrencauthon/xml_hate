require 'hashie'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      return_value = Hashie::Mash.new
      return_value[meth.to_s] = Hashie::Mash.new(@document[meth.to_s][0])
      return return_value[meth.to_s]
    end
  end
end
