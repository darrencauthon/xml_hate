require 'hashie'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def push_single_elements_up_to_attributes(value)
        value.each do |k, v|
          begin
            value[k] = v[0] if v.count == 1 
            if v.count > 1
              v.each do |i|
                push_single_elements_up_to_attributes i
              end
            end
          rescue
          end
        end
    end
    
    def method_missing(meth, *args, &blk)
      begin
        return_value = Hashie::Mash.new

        this_node = @document[meth.to_s][0]
        return this_node if this_node.class == String

        return_value[meth.to_s] = Hashie::Mash.new(this_node)

       push_single_elements_up_to_attributes(return_value[meth.to_s])
        return return_value[meth.to_s]
      rescue
      end
    end
  end
end
