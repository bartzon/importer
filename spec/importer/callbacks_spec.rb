require File.dirname(__FILE__) + '/../spec_helper'

describe 'Importer::Callbacks' do
  class MyImporter < Importer::Base
    def assign_d; end
    def assign_b; end
    def assign_c; end
    def assign_a; end
  end
    
  before(:each) do
    MyImporter.clear_ordered_assigns!
  end
  
  it "should clear assigns" do
    MyImporter.assign(:b, :before => :d).should == [:b, :d]
    MyImporter.clear_ordered_assigns!.should == []
  end
  
  describe ":before" do
    it "should assign values in the correct order" do
      MyImporter.assign(:b, :before => :d).should == [:b, :d]
      MyImporter.assign(:c, :before => :d).should == [:b, :c, :d]
      MyImporter.assign(:a, :before => :b).should == [:a, :b, :c, :d]
    end
  end
  
  describe ":after" do
    it "should assign values in the correct order" do
      MyImporter.assign(:c, :after => :a).should == [:a, :c]
      MyImporter.assign(:b, :after => :a).should == [:a, :b, :c]
      MyImporter.assign(:d, :after => :c).should == [:a, :b, :c, :d]
    end
  end
  
  describe ":between" do
    it "should assign values in the correct order" do
      MyImporter.assign(:c, :between => [:a, :d]).should == [:a, :c, :d]
      MyImporter.assign(:b, :between => [:a, :c]).should == [:a, :b, :c, :d]
    end
  end
  
  it "should raise an error if an incorrect action is given" do
    lambda { MyImporter.assign(:c, :foo => :bar) }.should raise_error(ArgumentError, "Please specify :before, :after or :between")
  end
end

