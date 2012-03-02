require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XmlHate::Document do
  
  describe "with a simple car xml block" do
    before do
      xml = <<DOC
<car>a car</car>
DOC
      @document = XmlHate::Document.new(xml)
    end
  
    it "should return an object for car" do
      @document.car.wont_be_nil  
    end

    it "should return il for anything else" do
      @document.blah.must_be_nil
      @document.something.must_be_nil
      @document.else.must_be_nil
    end
  end

  describe "with a simple truck xml block" do
    before do
      xml = <<DOC
<truck>a truck</truck>
DOC
      @document = XmlHate::Document.new(xml)
    end
  
    it "should return an object for car" do
      @document.truck.wont_be_nil  
    end

    it "should return il for anything else" do
      @document.car.must_be_nil
      @document.blah.must_be_nil
      @document.something.must_be_nil
      @document.else.must_be_nil
    end
  end
end
