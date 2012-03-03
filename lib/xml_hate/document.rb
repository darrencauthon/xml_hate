require 'hashie'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      begin 
        return_value = Hashie::Mash.new

        this_node = @document[meth.to_s][0]
        return this_node if this_node.class == String

        return_value[meth.to_s] = Hashie::Mash.new(this_node)
        return return_value[meth.to_s]
      rescue 
        ""
      end
    end
  end
end
