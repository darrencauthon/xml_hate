require 'hashie'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      begin
        this_node = @document[meth.to_s][0]
        return this_node if this_node.class == String

        return_value = Hashie::Mash.new(this_node)

        push_single_elements_up_to_attributes(return_value)
        return return_value
      rescue
        ""
      end
    end

    private

    def push_single_elements_up_to_attributes(node)
      node.each do |key, value|
        begin
          node[key] = value[0] if value.count == 1 
          if value.count > 1
            value.each do |i|
              push_single_elements_up_to_attributes i
            end
          end
        rescue
        end
      end
    end
  end
end
