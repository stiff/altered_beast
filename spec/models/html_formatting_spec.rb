require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include HtmlFormatting

describe HtmlFormatting do
  
  it "should workaround RedCloth bug caused by lines like 'word.. sentence'" do
    HtmlFormatting::clear_dot_dot("this. is ok").should eql "this. is ok"
    
    HtmlFormatting::clear_dot_dot("this... is ok").should eql "this... is ok"
    
    HtmlFormatting::clear_dot_dot("abc.. xyz\nnot this line\nyes.. this line").should eql "abc... xyz\nnot this line\nyes... this line"
  end


end
