require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XmlHate::Document do
  
  describe "with a simple car xml block" do
    before do
      xml = <<DOC
<root>
<car>a car</car>
</root>
DOC
      @document = XmlHate::Document.new(xml)
    end
  
    it "should return a car for car" do
      @document.car.must_equal "a car"  
    end

    it "should return an empty string for anything else" do
      @document.blah.must_equal ""
      @document.something.must_equal ""
      @document.else.must_equal ""
    end
  end

  describe "with a simple truck xml block" do
    before do
      xml = <<DOC
<root>
<truck>a truck</truck>
</root>
DOC
      @document = XmlHate::Document.new(xml)
    end
  
    it "should return a truck for truck" do
      @document.truck.must_equal "a truck"  
    end

    it "should return an empty string for anything else" do
      @document.car.must_equal ""
      @document.blah.must_equal ""
      @document.something.must_equal ""
      @document.else.must_equal ""
    end
  end
end
