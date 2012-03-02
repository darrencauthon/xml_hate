module XmlHate
  class Document
    def initialize(xml)
      @document = ::Nokogiri::Slop(xml)
    end

    def method_missing(meth, *args, &blk)
      begin
        return @document.send(meth, *args, &blk)
      rescue
        return nil 
      end
    end
  end
end
