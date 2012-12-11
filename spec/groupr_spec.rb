require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Groupr" do

  before do
    @group = Groupr.new
  end

  it "Checks for network connectivity"
  it "Should allow you to specify a custom Service API" do
    @group.respond_to?(:api_url).should eq true
  end
  it "Should allow you to specify your X509 certificate" do
    @group.respond_to?(:certificate).should eq true
  end
  it "Should Allow you to specify your RSA key" do
    @group.respond_to?(:key).should eq true
  end
  context "group operations" do
    context "#group_exists?" do
      it "Should tell you that the uw_employees group exists" do
        @group.should_receive(:make_get_request).and_return(nil)
        @group.should_receive(:get_response_code).and_return(200)
        @group.group_exists?("u_nikky_git").should be_true
      end
      it "Should tell you that the a_team group does not exist" do
        @group.should_receive(:make_get_request).and_return(nil)
        @group.should_receive(:get_response_code).and_return(404)
        @group.group_exists?("a_team").should be_false
      end
    end

    context "#view_group" do
      before do
        @group.should_receive(:make_get_request).and_return(File.open('spec/sample_responses/view_group.html'))
        @results = @group.view_group("u_nikky_git")
      end
      it "Should tell you the group name" do
        @results[:name].should eq "u_nikky_git"
      end
      it "Should tell you the group description" do
        @results[:description].should_not == ""
      end
      it "Should tell you the group contact" do
        @results[:contact].should eq "nikky"
      end
      it "Should tell you the group title" do
        @results[:title].should eq "nikky git"
      end
    end
    context "#create_group" do
      before do
        @group.should_receive(:make_put_request).and_return(nil)
      end
      it "Should create a new group" do
        @group.should_receive(:get_response_code).and_return(200)
        @group.create_group("u_test_hi").should eq true
      end
      it "Should fail to create a new group if the response code is non-200" do
        @group.should_receive(:get_response_code).and_return(419)
        @group.create_group("u_test_hi").should eq false
      end
    end

    context "#delete_group" do
      before do
        @group.should_receive(:make_delete_request).and_return(nil)
      end
      it "Should delete a currently existing group" do
        @group.should_receive(:get_response_code).and_return(200)
        @group.delete_group("u_test-group").should eq true
        @group.status.should eq "Group deleted or not found"
      end
      it "Should return false upon fail" do
        @group.should_receive(:get_response_code).and_return(412)
        @group.delete_group("u_test_group").should eq false
        @group.status.should eq "No authorization"
      end
    end
    context "#update_group" do
      it "Should let you edit the attributes of an already existing group"
    end
  end
  context "member operations" do

    context "#get_membership" do
      before do
        @group.should_receive(:make_get_request).and_return(File.open("spec/sample_responses/get_membership.html"))
      end
      it "Should get the members of a group" do
        @group.get_membership("u_nikky_awesome").should eq ["blogs", "blogsdev", "hiigara.cac.washington.edu", "nikky", "nikky.cac.washington.edu", "solanum.cac.washington.edu", "sqltest", "u_nikky_git", "webtest"]
      end

    end
    context "#get_effective_members" do
      it "Should list the effective membership of a group"
    end
    context "#add_members" do
      it "Should add member(s) to a group"
    end

    context "#delete_members" do
      it "Removes member(s) from a group"
    end
  end
end
