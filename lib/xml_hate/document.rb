module XmlHate
  class Document
    def initialize(xml)
    end

    def car
      Object.new
    end

    def method_missing(meth, *args, &blk)
      nil
    end
  end
end
