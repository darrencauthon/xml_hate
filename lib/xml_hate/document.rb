module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      begin
        return @document[meth.to_s][0] || ""
      rescue
        return "" 
      end
    end
  end
end
