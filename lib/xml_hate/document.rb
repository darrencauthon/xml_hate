require 'hashie'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      begin 
        return_value = Hashie::Mash.new
        if @document[meth.to_s][0].class == String
          return @document[meth.to_s][0]
        end
        return_value[meth.to_s] = Hashie::Mash.new(@document[meth.to_s][0])
        return return_value[meth.to_s]
      rescue 
        ""
      end
    end
  end
end
